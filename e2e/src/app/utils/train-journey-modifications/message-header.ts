import {MessageReference, MessageReferenceBuilder} from './message-reference';

export class MessageHeader {
  public MessageReference?: MessageReference;
  public SenderReference?: string;
  public Sender?: string;
  public Recipient?: string;
}

export class MessageHeaderBuilder {
  private MessageReference?: MessageReference;
  private SenderReference?: string;
  private Sender?: string;
  private Recipient?: string;
  constructor() {
    this.MessageReference = new MessageReferenceBuilder().build();
    this.SenderReference = '5A416EUB-N3J';
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
