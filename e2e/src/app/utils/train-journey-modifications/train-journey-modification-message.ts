import {DateTimeFormatter, LocalDateTime} from '@js-joda/core';
import {MessageHeader, MessageHeaderBuilder} from './message-header';
import {OperationalTrainNumberIdentifier} from './operational-train-number-identifier';
import {TrainOperationalIdentification, TrainOperationalIdentificationBuilder} from './train-operational-identification';
import {ReferenceOTN} from './reference-otn';
import {TrainJourneyModification} from './train-journey-modification';
import {TransportOperationalIdentifiersBuilder} from './train-operational-identifiers';
import {jsonIgnore, jsonIgnoreReplacer} from 'json-ignore';
import {CucumberLog} from '../../logging/cucumber-log';

export class TrainJourneyModificationMessage {
  public MessageHeader?: MessageHeader;
  public MessageStatus?: string;
  public TrainOperationalIdentification?: TrainOperationalIdentification;
  public OperationalTrainNumberIdentifier?: OperationalTrainNumberIdentifier;
  public ReferenceOTN?: ReferenceOTN;
  public TrainJourneyModification?: TrainJourneyModification;
  public ModificationReason?: string;
  public TrainJourneyModificationTime?: string;
  @jsonIgnore()
  private nationalDelayCode: string;

  setNationalDelayCode(value: string): void {
    this.nationalDelayCode = value;
  }

  toXML(): string {
    const convert = require('xml-js');
    const options = {compact: true, ignoreComment: true, spaces: 4};
    const xml = '<?xml version="1.0" encoding="UTF-8"?>' +
      '<TrainJourneyModificationMessage xmlns="http://www.era.europa.eu/schemes/TAFTSI/5.3"' +
      ' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' +
      ' xmlns:n1="http://www.era.europa.eu/schemes/TAFTSI/5.3"' +
      ' xsi:schemaLocation="http://www.era.europa.eu/schemes/TAFTSI/5.3 taf_cat_complete.xsd">' +
      convert.json2xml(JSON.stringify(this, jsonIgnoreReplacer), options)
        .replace('<Sender>', '<Sender n1:CI_InstanceNumber="01">')
        .replace('<Recipient>', '<Recipient n1:CI_InstanceNumber="99">')
        .replace('<LocationSubsidiaryCode>', '<LocationSubsidiaryCode n1:LocationSubsidiaryTypeCode="0">')
        .replace('<Timing>', '<Timing TimingQualifierCode="ALA">')
        .replace('<ModificationReason>', `<ModificationReason NationalDelayCode="${this.nationalDelayCode}">`) +
      '</TrainJourneyModificationMessage>';
    CucumberLog.addText(xml);
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
  private departureHour: number;
  private trainUid: string;
  private nationalDelayCode: string;

  constructor() {
    this.MessageHeader = new MessageHeaderBuilder().build();
    this.TrainJourneyModificationTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern('yyyy-MM-dd\'T\'HH:mm:ss')) + '-00:00';
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

  withNationalDelayCode(value: any): TrainJourneyModificationMessageBuilder  {
    this.nationalDelayCode = value;
    return this;
  }

  withTrainJourneyModificationTime(value: string): TrainJourneyModificationMessageBuilder {
    const valueArray = value.split(':');
    this.TrainJourneyModificationTime = LocalDateTime.now()
      .withHour(Number(valueArray[0]))
      .withMinute(Number(valueArray[1]))
      .withSecond(Number(valueArray[2]))
      .format(DateTimeFormatter.ofPattern('yyyy-MM-dd\'T\'HH:mm:ss')) + '-00:00';;
    return this;
  }

  calculateSenderReferenceWith(trainUid: string, departureHour: number): TrainJourneyModificationMessageBuilder {
    this.trainUid = trainUid;
    this.departureHour = departureHour;
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
    trainJourneyModificationMessage.MessageHeader.calculateSenderReference(
      this.OperationalTrainNumberIdentifier.OperationalTrainNumber,
      this.trainUid,
      this.departureHour);
    if (this.nationalDelayCode != null) {
      trainJourneyModificationMessage.setNationalDelayCode(this.nationalDelayCode);
    }
    return trainJourneyModificationMessage;
  }
}
