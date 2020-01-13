import * as AWS from "aws-sdk";
import { Context, Callback } from "aws-lambda";

/**
 * Configuration passed in from environment variables.
 */
export interface Config {
  /**
   * Email to use as the `from` address for forwwarded emails.
   */
  fromEmail: string;

  /**
   * The S3 bucket name where SES stores emails.
   */
  emailBucket: string;

  /**
   * The S3 key name prefix where SES stores emails (should
   * include trailing slash).
   */
  emailKeyPrefix: string;

  /**
   * A mapping of intended recipient addresses to email subject prefixes.
   *
   * To match all email addresses on a domain, use a value that starts
   * with a `@` symbol. To match a mailbox name on ANY domain, use a
   * key without the `@` symbol.
   */
  prefixMapping: { [key: string]: string };

  /**
   * A mapping of intended recipient addresses to forward destinations.
   *
   * To match all email addresses on a domain, use a value that starts
   * with a `@` symbol. To match a mailbox name on ANY domain, use a
   * key without the `@` symbol.
   */
  forwardMapping: { [key: string]: string | string[] };
}

/**
 * Data passed to each step of the function.
 */
export interface Data {
  /**
   * The event that triggered the Lambda.
   */
  event: SESEvent;
  /**
   * The context that triggered the Lambda.
   */
  context: Context;
  /**
   * The Lambda callback function.
   */
  callback: Callback;
  /**
   * The AWS SES client to use.
   */
  ses: AWS.SES;
  /**
   * The AWS S3 client to use.
   */
  s3: AWS.S3;
  /**
   * Log function. Default is `console.log`.
   */
  log: (...args: any[]) => void;
  /**
   * Configuration passed through environment variables.
   */
  config: Config;
  /**
   * The email from the lambda action event.
   */
  email?: SESMail;
  /**
   * The receipients from the lambda action event.
   */
  recipients?: string[];
  /**
   * The email data retrieved from S3.
   */
  emailData?: string;
  /**
   * The transformed emails with their recipient data.
   */
  emailsToForward?: EmailToForward[];
}

export interface EmailToForward {
  /**
   * The original recipient of the email.
   */
  originalRecipient: string;
  /**
   * A list of recipients to forward the email to.
   */
  recipients: string[];
  /**
   * A prefix to use in the subject if required.
   */
  prefix?: string;
  /**
   * The customised email data for forwarding.
   */
  data?: string;
}

/**
 * Expected email action Lambda event from AWS SES.
 * Based on https://docs.aws.amazon.com/ses/latest/DeveloperGuide/receiving-email-action-lambda-event.html.
 */
export interface SESEvent {
  Records: SESEventRecord[];
}

export interface SESEventRecord {
  eventSource: "aws:ses";
  eventVersion: string;
  ses: {
    mail: SESMail;
    receipt: SESReceipt;
  };
}

export interface SESMail {
  timestamp: string;
  source: string;
  messageId: string;
  destination: string[];
  headersTruncated: boolean;
  headers: SESHeader[];
  commonHeaders: {
    returnPath: string;
    from: string[];
    date: string;
    to: string[];
    messageId: string;
    subject: string;
  };
}

export interface SESHeader {
  name: string;
  value: string;
}

export interface SESReceipt {
  timestamp: string;
  processingTimeMillis: number;
  recipients: string[];
  spamVerdict: {
    status: string;
  };
  virusVerdict: {
    status: string;
  };
  spfVerdict: {
    status: string;
  };
  dkimVerdict: {
    status: string;
  };
  dmarcVerdict: {
    status: string;
  };
  action: {
    type: string;
    functionArn: string;
    invocationType: string;
  };
}
