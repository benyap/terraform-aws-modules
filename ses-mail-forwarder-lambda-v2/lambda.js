"use strict";

const AWS = require("aws-sdk");

console.log("AWS Lambda SES Forwarder // @arithmetric // Version 4.2.0");

// Configure the S3 bucket and key prefix for stored raw emails, and the
// mapping of email addresses to forward from and to.
//
// Expected keys/values:
//
// - fromEmail: Forwarded emails will come from this verified address
//
// - emailBucket: S3 bucket name where SES stores emails.
//
// - emailKeyPrefix: S3 key name prefix where SES stores email. Include the
//   trailing slash.
//
// - prefixMapping: A mapping of intended recipient address to email subject prefix.
//
// - forwardMapping: mapping of intended recipient address to forward destination address.
//
//   To match all email addresses on a domain, use a key without the name part
//   of an email address before the "at" symbol (i.e. `@example.com`).
//
//   To match a mailbox name on all domains, use a key without the "at" symbol
//   and domain part of an email address (i.e. `info`).
const defaultConfig = {
  fromEmail: process.env.fromEmail,
  emailBucket: process.env.emailBucket,
  emailKeyPrefix: process.env.emailKeyPrefix,
  previxMapping: JSON.parse(process.env.prefixMapping),
  forwardMapping: JSON.parse(process.env.forwardMapping)
};

/**
 * Parses the SES event record provided for the `mail` and `receipients` data.
 *
 * @param {object} data - Data bundle with context, email, etc.
 *
 * @return {object} - Promise resolved with data.
 */
exports.parseEvent = function(data) {
  // Validate characteristics of a SES event record.
  if (
    !data.event ||
    !data.event.hasOwnProperty("Records") ||
    data.event.Records.length !== 1 ||
    !data.event.Records[0].hasOwnProperty("eventSource") ||
    data.event.Records[0].eventSource !== "aws:ses" ||
    data.event.Records[0].eventVersion !== "1.0"
  ) {
    data.log({
      message: "parseEvent() received invalid SES message:",
      level: "error",
      event: JSON.stringify(data.event)
    });
    return Promise.reject(new Error("Error: Received invalid SES message."));
  }

  data.email = data.event.Records[0].ses.mail;
  data.recipients = data.event.Records[0].ses.receipt.recipients;
  return Promise.resolve(data);
};

/**
 * Transforms the original recipients to the desired forwarded destinations.
 *
 * @param {object} data - Data bundle with context, email, etc.
 *
 * @return {object} - Promise resolved with data.
 */
exports.transformRecipients = function(data) {
  let newRecipients = [];

  data.originalRecipients = data.recipients;

  data.recipients.forEach(email => {
    const emailKey = email.toLowerCase();

    // Check if the forward mapping has the original recipient
    if (data.config.forwardMapping.hasOwnProperty(emailKey)) {
      // If it exists, add it to the list of new recipients
      newRecipients = newRecipients.concat(
        data.config.forwardMapping[emailKey]
      );
      data.originalRecipient = email;
    } else {
      let domain, user;
      const pos = emailKey.lastIndexOf("@");

      // If there is no '@' in the email, use the email as the 'user'
      if (pos === -1) {
        user = emailKey;
      }
      // Otherwise, split the email into user and domain parts
      else {
        user = emailKey.slice(0, pos);
        domain = emailKey.slice(pos);
      }

      // If there was a domain, see if we can find a mapping
      // for the domain of the user's email.
      if (domain && data.config.forwardMapping.hasOwnProperty(domain)) {
        newRecipients = newRecipients.concat(
          data.config.forwardMapping[domain]
        );
        data.originalRecipient = email;
      }
      // If there was only a username, see if we can find a
      // mapping for that user's identifier.
      else if (user && data.config.forwardMapping.hasOwnProperty(user)) {
        newRecipients = newRecipients.concat(data.config.forwardMapping[user]);
        data.originalRecipient = email;
      }
    }
  });

  if (!newRecipients.length) {
    data.log({
      message:
        "Finishing process. No new recipients found for " +
        "original destinations: " +
        data.originalRecipients.join(", "),
      level: "info"
    });
    return data.callback();
  }

  data.recipients = newRecipients;
  return Promise.resolve(data);
};

/**
 * Fetches the message data from S3.
 *
 * @param {object} data - Data bundle with context, email, etc.
 *
 * @return {object} - Promise resolved with data.
 */
exports.fetchMessage = function(data) {
  // Copying email object to ensure read permission
  const { config, email } = data;
  const { emailBucket, emailKeyPrefix } = config;
  const key = `${emailKeyPrefix}${email.messageId}`;
  const source = `${emailBucket}/${key}`;
  data.log({
    level: "info",
    message: `Fetching email at s3://${source}`
  });
  return new Promise(function(resolve, reject) {
    data.s3.copyObject(
      {
        Bucket: data.config.emailBucket,
        CopySource: source,
        Key: key,
        ACL: "private",
        ContentType: "text/plain",
        StorageClass: "STANDARD"
      },
      function(err) {
        if (err) {
          data.log({
            level: "error",
            message: "copyObject() returned error:",
            error: err,
            stack: err.stack
          });
          return reject(
            new Error("Error: Could not make readable copy of email.")
          );
        }

        // Load the raw email from S3
        data.s3.getObject(
          {
            Bucket: emailBucket,
            Key: key
          },
          function(err, result) {
            if (err) {
              data.log({
                level: "error",
                message: "getObject() returned error:",
                error: err,
                stack: err.stack
              });
              return reject(
                new Error("Error: Failed to load message body from S3.")
              );
            }
            data.emailData = result.Body.toString();
            return resolve(data);
          }
        );
      }
    );
  });
};

/**
 * Processes the message data, making updates to recipients and other headers
 * before forwarding message.
 *
 * @param {object} data - Data bundle with context, email, etc.
 *
 * @return {object} - Promise resolved with data.
 */
exports.processMessage = function(data) {
  let match = data.emailData.match(/^((?:.+\r?\n)*)(\r?\n(?:.*\s+)*)/m);
  let header = match && match[1] ? match[1] : data.emailData;
  const body = match && match[2] ? match[2] : "";

  const { config, originalRecipient } = data;

  // Add "Reply-To:" with the "From" address if it doesn't already exists
  if (!/^Reply-To: /im.test(header)) {
    match = header.match(/^From: (.*(?:\r?\n\s+.*)*\r?\n)/m);
    var from = match && match[1] ? match[1] : "";
    if (from) {
      header = header + "Reply-To: " + from;
      data.log({
        level: "info",
        message: "Added Reply-To address of: " + from
      });
    } else {
      data.log({
        level: "info",
        message:
          "Reply-To address not added because " +
          "From address was not properly extracted."
      });
    }
  }

  // SES does not allow sending messages from an unverified address,
  // so replace the message's "From:" header with the original
  // recipient (which is a verified domain)
  header = header.replace(/^From: (.*(?:\r?\n\s+.*)*)/gm, (match, from) => {
    let fromText;
    if (config.fromEmail) {
      fromText = `From: ${from.replace(/<(.*)>/, "").trim()} <${
        config.fromEmail
      }>`;
    } else {
      fromText = `From: ${from
        .replace("<", "at ")
        .replace(">", "")} <${originalRecipient}>`;
    }
    return fromText;
  });

  // Add a prefix to the Subject
  if (
    config.prefixMapping &&
    config.prefixMapping[originalRecipient.toLowerCase()]
  ) {
    header = header.replace(
      /^Subject: (.*)/gm,
      (match, subject) =>
        `Subject: ${
          config.prefixMapping[originalRecipient.toLowerCase()]
        }${subject}`
    );
  }

  // Replace original 'To' header with a manually defined one
  if (config.toEmail) {
    header = header.replace(/^To: (.*)/gm, () => "To: " + config.toEmail);
  }

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

  data.emailData = header + body;
  return Promise.resolve(data);
};

/**
 * Send email using the SES sendRawEmail command.
 *
 * @param {object} data - Data bundle with context, email, etc.
 *
 * @return {object} - Promise resolved with data.
 */
exports.sendMessage = function(data) {
  var params = {
    Destinations: data.recipients,
    Source: data.originalRecipient,
    RawMessage: {
      Data: data.emailData
    }
  };
  data.log({
    level: "info",
    message:
      "sendMessage: Sending email via SES. " +
      `Original recipients: [${data.originalRecipients.join(", ")}]. ` +
      `Transformed recipients: [${data.recipients.join(", ")}].`
  });
  return new Promise(function(resolve, reject) {
    data.ses.sendRawEmail(params, function(err, result) {
      if (err) {
        data.log({
          level: "error",
          message: "sendRawEmail() returned error.",
          error: err,
          stack: err.stack
        });
        return reject(new Error("Error: Email sending failed."));
      }
      data.log({
        level: "info",
        message: "sendRawEmail() successful.",
        result: result
      });
      resolve(data);
    });
  });
};

/**
 * Handler function to be invoked by AWS Lambda with an inbound SES email as
 * the event.
 *
 * @param {object} event - Lambda event from inbound email received by AWS SES.
 * @param {object} context - Lambda context object.
 * @param {object} callback - Lambda callback object.
 * @param {object} overrides - Overrides for the default data, including the
 * configuration, SES object, and S3 object.
 */
exports.handler = function(event, context, callback, overrides) {
  var steps =
    overrides && overrides.steps
      ? overrides.steps
      : [
          exports.parseEvent,
          exports.transformRecipients,
          exports.fetchMessage,
          exports.processMessage,
          exports.sendMessage
        ];
  var data = {
    event: event,
    callback: callback,
    context: context,
    config: overrides && overrides.config ? overrides.config : defaultConfig,
    log: overrides && overrides.log ? overrides.log : console.log,
    ses: overrides && overrides.ses ? overrides.ses : new AWS.SES(),
    s3:
      overrides && overrides.s3
        ? overrides.s3
        : new AWS.S3({ signatureVersion: "v4" })
  };
  Promise.series(steps, data)
    .then(function(data) {
      data.log({ level: "info", message: "Process finished successfully." });
      return data.callback();
    })
    .catch(function(err) {
      data.log({
        level: "error",
        message: "Step returned error: " + err.message,
        error: err,
        stack: err.stack
      });
      return data.callback(new Error("Error: Step returned error."));
    });
};

Promise.series = function(promises, initValue) {
  return promises.reduce(function(chain, promise) {
    if (typeof promise !== "function") {
      return Promise.reject(
        new Error("Error: Invalid promise item: " + promise)
      );
    }
    return chain.then(promise);
  }, Promise.resolve(initValue));
};
