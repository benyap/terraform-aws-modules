import * as AWS from "aws-sdk";
import { Context, Callback } from "aws-lambda";

import { Config, SESEvent, Data, EmailToForward } from "./types";

/**
 * Handler function to be invoked by AWS Lambda with an inbound SES email as the event.
 * @param event the Lambda event from inbound email received by AWS SES.
 * @param context the Lambda context object.
 * @param callback the Lambda callback object.
 */
export const handler = (
  event: SESEvent,
  context: Context,
  callback: Callback
) => {
  // Extract configuration settings
  const config: Config = {
    fromEmail: process.env.fromEmail || "",
    emailBucket: process.env.emailBucket || "",
    emailKeyPrefix: process.env.emailKeyPrefix || "",
    prefixMapping: JSON.parse(process.env.prefixMapping || "{}"),
    forwardMapping: JSON.parse(process.env.forwardMapping || "{}")
  };

  // Set up data to be passed to each step
  let data: Data = {
    event,
    context,
    callback,
    config,
    log: console.log,
    ses: new AWS.SES(),
    s3: new AWS.S3({ signatureVersion: "v4" })
  };

  // Run steps
  [parseEvent, transformRecipients, fetchMessage, processMessage, sendMessage]
    // Chain promises together!
    .reduce(async (chain, promise) => {
      if (typeof promise !== "function") {
        return Promise.reject(new Error(`Error: invalid promise: ${promise}`));
      }
      return chain.then(promise);
    }, Promise.resolve(data))
    .then(data => {
      data.log({ level: "info", message: "Process finished successfully." });
      return data.callback();
    })
    .catch(error => {
      data.log({
        level: "error",
        message: error.message,
        error: error,
        stack: error.stack
      });
      return data.callback(new Error("Error: step returned error."));
    });
};

/**
 * Parse the SES event record
 *
 * Populates the `email` and `recipients` fields in `data`.
 */
export const parseEvent = async (data: Data) => {
  const { event, log } = data;

  // Validate characteristics of a SES event record.
  if (
    !event ||
    !event.hasOwnProperty("Records") ||
    event.Records.length !== 1 ||
    !event.Records[0].hasOwnProperty("eventSource") ||
    event.Records[0].eventSource !== "aws:ses" ||
    event.Records[0].eventVersion !== "1.0"
  ) {
    log({
      message: "parseEvent() received invalid SES message:",
      level: "error",
      event: JSON.stringify(data.event)
    });
    return Promise.reject(new Error("Error: Received invalid SES message."));
  }

  data.email = data.event.Records[0].ses.mail;
  data.recipients = data.event.Records[0].ses.receipt.recipients;

  return data;
};

/**
 * Map the original recipients to the desired forwarding destinations.
 *
 * Populates the `emailsToForward` field in `data`.
 */
export const transformRecipients = async (data: Data) => {
  const { recipients = [] } = data;

  // Map each recipient to a new email.
  data.emailsToForward = recipients
    .map(email => {
      const { forwardMapping, prefixMapping } = data.config;
      const emailKey = email.toLowerCase();

      // Create an email to forward
      let forward: EmailToForward = {
        originalRecipient: emailKey,
        recipients: []
      };

      /**
       * Use a given key to get an email's mapped destination.
       * @param key a key that is known to have a match in `forwardMapping`
       */
      const addEmailWithKey = (key: string) => {
        // Use key to get mapping
        forward.recipients.concat(forwardMapping[key]);
        // Check for a matching prefix
        if (prefixMapping[key]) {
          forward.prefix = prefixMapping[key];
        }
      };

      // Check if the email has a direct match
      if (forwardMapping[emailKey]) {
        addEmailWithKey(emailKey);
      }

      // Check if there are domain or user matches
      else {
        let token: string = "";
        const index = emailKey.lastIndexOf("@");

        // If there is no '@' in the email, use the key as the 'user'
        if (index === -1) token = emailKey;
        // Otherwise, use it as a domain
        else token = emailKey.slice(index);

        // Add destination if there is a match
        if (forwardMapping[token]) {
          addEmailWithKey(token);
        }
      }

      return forward;
    })
    // Filter out any emails that have no recipients
    .filter(email => email.recipients.length);

  return data;
};

/**
 * Fetch message data from S3.
 *
 * Populates the `emailData` field in `data`.
 */
export const fetchMessage = async (data: Data) => {
  const {
    config: { emailBucket, emailKeyPrefix },
    email,
    log,
    s3
  } = data;

  const key = `${emailKeyPrefix}${email!.messageId}`;
  const source = `${emailBucket}/${key}`;

  log({
    level: "info",
    message: `Fetching email at s3://${source}`
  });

  return new Promise<Data>((resolve, reject) => {
    // Copying email object to ensure read permission
    s3.copyObject(
      {
        Bucket: emailBucket,
        CopySource: source,
        Key: key,
        ACL: "private",
        ContentType: "text/plain",
        StorageClass: "STANDARD"
      },
      error => {
        // Reject promise if there was an error
        if (error) {
          log({
            level: "error",
            message: `copyObject() returned error for ${source}`,
            error,
            stack: error.stack
          });
          return reject(
            new Error(
              `Error: could not make readable copy of email at ${source}.`
            )
          );
        }

        // Load the raw email from S3
        s3.getObject({ Bucket: emailBucket, Key: key }, (error, result) => {
          if (error) {
            log({
              level: "error",
              message: `getObject() returned error for ${source}`,
              error,
              stack: error.stack
            });
            return reject(
              new Error(
                `Error: failed to load message body from S3 of email at ${source}.`
              )
            );
          }

          // Pass on email data.
          data.emailData = result.Body!.toString();
          return resolve(data);
        });
      }
    );
  });
};

/**
 * Process message data. Maps recipients to appropriate forwarding addresses
 * and updates headers appropriately for forwarding.
 */
export const processMessage = async (data: Data) => {
  const {
    emailData = "",
    config: { fromEmail },
    log
  } = data;

  let match = emailData.match(/^((?:.+\r?\n)*)(\r?\n(?:.*\s+)*)/m);
  let header = match && match[1] ? match[1] : data.emailData!;
  const body = match && match[2] ? match[2] : "";

  // Add "Reply-To:" with the "From" address if it doesn't already exists
  if (!/^Reply-To: /im.test(header)) {
    match = header.match(/^From: (.*(?:\r?\n\s+.*)*\r?\n)/m);
    const from = match && match[1] ? match[1] : "";
    if (from) {
      header = header + "Reply-To: " + from;
      log({
        level: "info",
        message: "Added Reply-To address of: " + from
      });
    } else {
      log({
        level: "info",
        message:
          "Reply-To address not added because 'From' address was not properly extracted."
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
  data.emailsToForward = data.emailsToForward!.map(email => {
    let finalHeader = header;

    // Check if we need to customise the prefix
    if (email.prefix) {
      finalHeader = finalHeader.replace(
        /^Subject: (.*)/gm,
        (match, subject) => `Subject: ${email.prefix} ${subject}`
      );
    }

    // Put data into email object
    email.data = finalHeader + body;

    return email;
  });

  return data;
};

export const sendMessage = async (data: Data) => {
  const {
    log,
    emailsToForward = [],
    ses,
    config: { fromEmail }
  } = data;

  log({
    level: "info",
    message: `sendMessage: Sending ${emailsToForward.length} email${
      emailsToForward.length === 1 ? "" : "s"
    } via SES.`
  });

  await Promise.all(
    emailsToForward.map(
      // Send each email that needs to be forwarded
      email =>
        new Promise((resolve, reject) => {
          ses.sendRawEmail(
            {
              Destinations: email.recipients,
              Source: fromEmail,
              RawMessage: {
                Data: email.data || ""
              }
            },
            (error, result) => {
              // Check for error
              if (error) {
                log({
                  level: "error",
                  message: `Failed to forward email from ${
                    email.originalRecipient
                  } to [${email.recipients.join(", ")}].`,
                  error: error,
                  stack: error.stack
                });
                return reject(
                  new Error(
                    `Failed to forward email from ${
                      email.originalRecipient
                    } to [${email.recipients.join(", ")}].`
                  )
                );
              }

              // Log successful message
              log({
                level: "info",
                message: `Email to ${
                  email.originalRecipient
                } forwarded to [${email.recipients.join(", ")}].`,
                result: result
              });
              resolve();
            }
          );
        })
    )
  );

  return data;
};
