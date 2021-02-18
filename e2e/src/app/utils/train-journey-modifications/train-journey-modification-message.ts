import {LocalDateTime} from '@js-joda/core';
import {MessageHeader, MessageHeaderBuilder} from './message-header';
import {OperationalTrainNumberIdentifier} from './operational-train-number-identifier';
import {TrainOperationalIdentification, TrainOperationalIdentificationBuilder} from './train-operational-identification';
import {ReferenceOTN} from './reference-otn';
import {TrainJourneyModification} from './train-journey-modification';
import {TransportOperationalIdentifiersBuilder} from './train-operational-identifiers';

export class TrainJourneyModificationMessage {
  public MessageHeader?: MessageHeader;
  public MessageStatus?: string;
  public TrainOperationalIdentification?: TrainOperationalIdentification;
  public OperationalTrainNumberIdentifier?: OperationalTrainNumberIdentifier;
  public ReferenceOTN?: ReferenceOTN;
  public TrainJourneyModification?: TrainJourneyModification;
  public ModificationReason?: string;
  public TrainJourneyModificationTime?: string;

  toXML(): string {
    const convert = require('xml-js');
    const options = {compact: true, ignoreComment: true, spaces: 4};
    const xml = '<?xml version="1.0" encoding="UTF-8"?><TrainJourneyModificationMessage>'
    + convert.json2xml(JSON.stringify(this), options)
    + '</TrainJourneyModificationMessage>';
    console.log(xml);
    return xml;
  }
}

export class TrainJourneyModificationMessageBuilder {
  private MessageHeader: MessageHeader;
  private MessageStatus: string;
  private TrainOperationalIdentification: TrainOperationalIdentification;
  private OperationalTrainNumberIdentifier?: OperationalTrainNumberIdentifier;
  private ReferenceOTN?: ReferenceOTN;
  private TrainJourneyModification?: TrainJourneyModification;
  private ModificationReason?: string;
  private TrainJourneyModificationTime?: string;

  constructor() {
    this.MessageHeader = new MessageHeaderBuilder().build();
    this.TrainJourneyModificationTime = LocalDateTime.now().toString();
    this.TrainOperationalIdentification = new TrainOperationalIdentificationBuilder()
      .withTransportOperationalIdentifiers(new TransportOperationalIdentifiersBuilder().build())
      .build();
  }
  create(): TrainJourneyModificationMessageBuilder {
    this.withMessageStatus('1');
    return this;
  }
  modify(): TrainJourneyModificationMessageBuilder {
    this.withMessageStatus('2');
    return this;
  }
  delete(): TrainJourneyModificationMessageBuilder {
    this.withMessageStatus('3');
    return this;
  }
  withMessageHeader(value: MessageHeader): TrainJourneyModificationMessageBuilder {
    this.MessageHeader = value;
    return this;
  }
  withMessageStatus(value: string): TrainJourneyModificationMessageBuilder {
    this.MessageStatus = value;
    return this;
  }
  withTrainOperationalIdentification(value: TrainOperationalIdentification): TrainJourneyModificationMessageBuilder {
    this.TrainOperationalIdentification = value;
    return this;
  }
  withOperationalTrainNumberIdentifier(value: OperationalTrainNumberIdentifier): TrainJourneyModificationMessageBuilder {
    this.OperationalTrainNumberIdentifier = value;
    return this;
  }
  withReferenceOTN(value: ReferenceOTN): TrainJourneyModificationMessageBuilder {
    this.ReferenceOTN = value;
    return this;
  }
  withTrainJourneyModification(value: TrainJourneyModification): TrainJourneyModificationMessageBuilder {
    this.TrainJourneyModification = value;
    return this;
  }
  withModificationReason(value: string): TrainJourneyModificationMessageBuilder {
    this.ModificationReason = value;
    return this;
  }
  withTrainJourneyModificationTime(value: string): TrainJourneyModificationMessageBuilder {
    this.TrainJourneyModificationTime = value;
    return this;
  }
  build(): TrainJourneyModificationMessage {
    const trainJourneyModificationMessage = new TrainJourneyModificationMessage();
    trainJourneyModificationMessage.MessageHeader = this.MessageHeader;
    trainJourneyModificationMessage.MessageStatus = this.MessageStatus;
    trainJourneyModificationMessage.TrainOperationalIdentification = this.TrainOperationalIdentification;
    trainJourneyModificationMessage.OperationalTrainNumberIdentifier = this.OperationalTrainNumberIdentifier;
    trainJourneyModificationMessage.ReferenceOTN = this.ReferenceOTN;
    trainJourneyModificationMessage.TrainJourneyModification = this.TrainJourneyModification;
    trainJourneyModificationMessage.ModificationReason = this.ModificationReason;
    trainJourneyModificationMessage.TrainJourneyModificationTime = this.TrainJourneyModificationTime;
    return trainJourneyModificationMessage;
  }
}
