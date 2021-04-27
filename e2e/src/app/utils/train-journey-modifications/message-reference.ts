import {DateTimeFormatter, LocalDateTime} from '@js-joda/core';

export class MessageReference {
  public MessageType?: string;
  public MessageTypeVersion?: string;
  public MessageIdentifier?: string;
  public MessageDateTime?: string;
}

export class MessageReferenceBuilder {
  private MessageType?: string;
  private MessageTypeVersion?: string;
  private MessageIdentifier?: string;
  private MessageDateTime?: string;
  constructor() {
    this.MessageType = '9004';
    this.MessageTypeVersion = '5.3.1.GB';
    this.MessageIdentifier = '414d51204e52504230303920202020205e504839247ce8d0';
    this.MessageDateTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern('yyyy-MM-dd\'T\'HH:mm:ss')) + '-00:00';
  }
  withMessageType(value: string): MessageReferenceBuilder {
    this.MessageType = value;
    return this;
  }
  withMessageTypeVersion(value: string): MessageReferenceBuilder {
    this.MessageTypeVersion = value;
    return this;
  }
  withMessageIdentifier(value: string): MessageReferenceBuilder {
    this.MessageIdentifier = value;
    return this;
  }
  withMessageDateTime(value: string): MessageReferenceBuilder {
    this.MessageDateTime = value;
    return this;
  }
  build(): MessageReference {
    const messageReference = new MessageReference();
    messageReference.MessageType = this.MessageType;
    messageReference.MessageTypeVersion = this.MessageTypeVersion;
    messageReference.MessageIdentifier = this.MessageIdentifier;
    messageReference.MessageDateTime = this.MessageDateTime;
    return messageReference;
  }
}
