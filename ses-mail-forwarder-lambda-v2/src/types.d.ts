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
