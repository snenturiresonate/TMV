import {MessageReference, MessageReferenceBuilder} from './message-reference';
import {SenderReferenceCalculator} from '../sender-reference-calculator';

export class MessageHeader {
  public MessageReference?: MessageReference;
  public SenderReference?: string;
  public Sender?: string;
  public Recipient?: string;

  calculateSenderReference(trainNumber: string, trainUid: string, hourDepartFromOrigin: number): void {
    this.SenderReference = trainNumber + SenderReferenceCalculator.encodeToSenderReference(trainUid, hourDepartFromOrigin);
  }
}

export class MessageHeaderBuilder {
  private MessageReference?: MessageReference;
  private SenderReference?: string;
  private Sender?: string;
  private Recipient?: string;
  constructor() {
    this.MessageReference = new MessageReferenceBuilder().build();
    this.SenderReference = '1X07c91IB35K';
    this.Sender = '0070';
    this.Recipient = '9999';
  }
  withMessageReference(value: MessageReference): MessageHeaderBuilder {
    this.MessageReference = value;
    return this;
  }
  withSenderReference(value: string): MessageHeaderBuilder {
    this.SenderReference = value;
    return this;
  }
  withSender(value: string): MessageHeaderBuilder {
    this.Sender = value;
    return this;
  }
  withRecipient(value: string): MessageHeaderBuilder {
    this.Recipient = value;
    return this;
  }
  build(): MessageHeader {
    const messageHeader = new MessageHeader();
    messageHeader.MessageReference = this.MessageReference;
    messageHeader.SenderReference = this.SenderReference;
    messageHeader.Sender = this.Sender;
    messageHeader.Recipient = this.Recipient;
    return messageHeader;
  }
}
