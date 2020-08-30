import * as AWS from "aws-sdk";
import { Context, Callback } from "aws-lambda";

import { SESEvent, EmailToForward } from "./types";

/**
 * Handler function to be invoked by AWS Lambda with an inbound SES email as the event.
 */
export const handler = async (
  event: SESEvent,
  context: Context,
  callback: Callback
) => {
  // Extract configuration settings
  const {
    bucket = "",
    objectKeyPrefix = "",
    fromEmail = "",
    defaultRecipient = "",
    prefixMapping: rawPrefixMapping = "{}",
    forwardMapping: rawForwardMapping = "{}",
  } = process.env;

  const prefixMapping: Record<string, string> = JSON.parse(rawPrefixMapping);
  const forwardMapping: Record<string, string> = JSON.parse(rawForwardMapping);

  //
  // Parse SES event
  //

  // Validate characteristics of a SES event record.
  if (
    !event ||
    !event.hasOwnProperty("Records") ||
    event.Records.length !== 1 ||
    !event.Records[0].hasOwnProperty("eventSource") ||
    event.Records[0].eventSource !== "aws:ses" ||
    event.Records[0].eventVersion !== "1.0"
  ) {
    const message = `Received invalid SES message.`;
    console.log({
      level: "error",
      message,
      event: JSON.stringify(event),
    });
    return callback(new Error(message));
  }

  const emailData = event.Records[0].ses.mail;
  const recipients = event.Records[0].ses.receipt.recipients;

  //
  // Fetch message data from S3.
  //

  if (!emailData) {
    const message = `Received empty mail data object.`;
    console.log({
      level: "error",
      message,
      event: JSON.stringify(event),
    });
    return callback(new Error(message));
  }

  const s3 = new AWS.S3({ signatureVersion: "v4" });

  const key = `${objectKeyPrefix}${emailData.messageId}`;
  const source = `${bucket}/${key}`;

  console.log({
    level: "info",
    message: `Fetching email ${emailData.messageId} body at s3://${source}`,
  });

  let emailBodyData: string | undefined = undefined;

  try {
    const result = await s3
      .getObject({
        Bucket: bucket,
        Key: key,
      })
      .promise();
    emailBodyData = result.Body?.toString();
  } catch (error) {
    const message = `getObject() returned error for ${source}`;
    console.log({
      level: "error",
      message,
      error,
      stack: error.stack,
    });
    return callback(new Error(message));
  }

  if (!emailBodyData) {
    const message = `Email ${emailData.messageId} body contains no data.`;
    console.log({
      level: "error",
      message,
    });
    return callback(new Error(message));
  }

  //
  // Map original recipients to desired forwarding destinations.
  //

  const emailsToForward: EmailToForward[] = recipients
    .map((rawEmail) => {
      const email = rawEmail.toLowerCase();
      let recipients: string[] = [];
      let prefix = "[FWD]";

      // Get mapping if it exists
      const mappedRecipient = forwardMapping[email];
      if (typeof mappedRecipient !== "undefined")
        recipients = recipients.concat(mappedRecipient);
      else if (defaultRecipient) recipients.push(defaultRecipient);

      // Get prefix if it exists
      const mappedPrefix = prefixMapping[email];
      if (typeof mappedPrefix !== "undefined") prefix = mappedPrefix;

      console.log({
        level: "info",
        message: `Forwarding email from ${email} to [${recipients.join(", ")}]`,
      });

      return {
        originalRecipient: email,
        prefix,
        recipients,
      };
    })
    // Filter out any emails that have no recipients
    .filter((email) => email.recipients.length > 0);

  if (emailsToForward.length === 0) {
    const message = `No valid recipients for forward email ${emailData.messageId} to.`;
    console.log({
      level: "info",
      message,
    });
    return callback(new Error(message));
  }

  //
  // Process message data.
  // Maps recipients to appropriate forwarding addresses and updates headers appropriately for forwarding.
  //

  // Separate the email body's headers from its content
  let match = emailBodyData.match(/^((?:.+\r?\n)*)(\r?\n(?:.*\s+)*)/m);
  let header = match && match[1] ? match[1] : emailBodyData;
  const content = match && match[2] ? match[2] : "";

  // Add "Reply-To:" with the "From" address if it doesn't already exists
  if (!/^Reply-To: /im.test(header)) {
    match = header.match(/^From: (.*(?:\r?\n\s+.*)*\r?\n)/m);
    const from = match && match[1] ? match[1] : "";
    if (from) {
      header = header + "Reply-To: " + from;
      console.log({
        level: "info",
        message: "Added Reply-To address of " + from,
      });
    } else {
      console.log({
        level: "info",
        message:
          "Reply-To address not added because 'From' address was not properly extracted.",
      });
    }
  }

  // SES does not allow sending messages from an unverified
  // address, so replace the message's "From:" with a verified
  // address provided in the config.
  header = header.replace(
    /^From: (.*(?:\r?\n\s+.*)*)/gm,
    (match, from) => `From: ${from.replace(/<(.*)>/, "").trim()} <${fromEmail}>`
  );

  // Remove the Return-Path header.
  header = header.replace(/^Return-Path: (.*)\r?\n/gm, "");

  // Remove Sender header.
  header = header.replace(/^Sender: (.*)\r?\n/gm, "");

  // Remove Message-ID header.
  header = header.replace(/^Message-ID: (.*)\r?\n/gim, "");

  // Remove all DKIM-Signature headers to prevent triggering an
  // "InvalidParameterValue: Duplicate header 'DKIM-Signature'" error.
  // These signatures will likely be invalid anyways, since the From
  // header was modified.
  header = header.replace(/^DKIM-Signature: .*\r?\n(\s+.*\r?\n)*/gm, "");

  // Customise data for each email that needs to be forwarded.
  emailsToForward.forEach((email) => {
    let finalHeader = header;

    // Check if we need to customise the prefix
    if (email.prefix) {
      finalHeader = finalHeader.replace(
        /^Subject: (.*)/gm,
        (match, subject) => `Subject: ${email.prefix} ${subject}`
      );
    }

    // Put data into email object
    email.data = finalHeader + content;
  });

  //
  // Send message using AWS SMS.
  //

  console.log({
    level: "info",
    message: `Sending ${emailsToForward.length} email${
      emailsToForward.length === 1 ? "" : "s"
    } via SES.`,
  });

  const ses = new AWS.SES();

  await Promise.all(
    // Send each email that needs to be forwarded
    emailsToForward.map(async (email) => {
      try {
        const result = await ses
          .sendRawEmail({
            Destinations: email.recipients,
            Source: fromEmail,
            RawMessage: {
              Data: email.data || "",
            },
          })
          .promise();
        console.log({
          level: "info",
          step: "sendMessage",
          message: `Email to ${
            email.originalRecipient
          } forwarded to [${email.recipients.join(", ")}].`,
          result: result,
        });
      } catch (error) {
        const message = `Failed to forward email from ${
          email.originalRecipient
        } to [${email.recipients.join(", ")}].`;
        console.log({
          level: "error",
          message,
          error: error,
          stack: error.stack,
        });
        return callback(new Error(message));
      }
    })
  );

  return callback();
};
