import { create, fragment, convert, builder } from 'xmlbuilder2';
import {LocalDateTime} from '@js-joda/core';
import {SenderReferenceCalculator} from '../sender-reference-calculator';

export class TrainActivationMessageBuilder {
  private runDateTime = LocalDateTime.now();
  // private senderReference = SenderReferenceCalculator.encodeToSenderReference()
  /*calculateSenderReference(trainNumber: string, trainUid: string, hourDepartFromOrigin: number): void {
    this.SenderReference = trainNumber + SenderReferenceCalculator.encodeToSenderReference(trainUid, hourDepartFromOrigin);
  }*/
  public messageReference = (messageDateTime: any = this.runDateTime) => {
      const messageReferenceObj = fragment().ele('MessageReference')
        .ele('MessageType').txt('2003').up()
        .ele('MessageTypeVersion').txt('5.3.1.GB').up()
        .ele('MessageIdentifier').txt('414d51204e52504230303920202020205e504839249a2a40').up()
        .ele('MessageDateTime').txt(messageDateTime)
        .doc();
      return messageReferenceObj.end({prettyPrint: true});

  }
  public messageHeader = () => {
    const messageHeaderObj = fragment().ele('MessageHeader')
       .ele(this.messageReference()).up()
       .ele('SenderReference').txt('5J09M2hi6N3J').up()
       .ele('Sender', {'n1:CI_InstanceNumber': '01'}).txt('0070').up()
      .ele('Recipient', {'n1:CI_InstanceNumber': '99'}).txt('0070').up()
      .doc();
    console.log('messageHeader: ' + messageHeaderObj.end({prettyPrint: true}));
    return messageHeaderObj.end({prettyPrint: true});
  }

  public adminContactInfo = (adminContactName: string = 'Network Rail') => {
    const adminContactInfo = fragment().ele('AdministrativeContactInformation')
      .ele('Name').txt(adminContactName)
      .doc();
    console.log('adminContactInfo: ' + adminContactInfo.end({prettyPrint: true}));
    return adminContactInfo.end({prettyPrint: true});
  }

  public messageStatus = (messageStatus: string = '1') => {
    const messageStat = fragment().ele('MessageStatus').txt(messageStatus).doc();
    console.log('messageStatus: ' + messageStat.end({prettyPrint: true}));
    return messageStat.end({prettyPrint: true});
  }

  public typeOfRequest = (typeOfRequest: string = '3') => {
    const TypeOfReq = fragment().ele('TypeOfRequest').txt(typeOfRequest).doc();
    console.log('TypeOfRequest: ' + TypeOfReq.end({prettyPrint: true}));
    return TypeOfReq.end({prettyPrint: true});
  }

  public typeOfInformation = (typeOfInformation: string = '50') => {
    const TypeOfInfo = fragment().ele('TypeOfInformation').txt(typeOfInformation).doc();
    console.log('TypeOfInformation: ' + TypeOfInfo.end({prettyPrint: true}));
    return TypeOfInfo.end({prettyPrint: true});
  }

  public locationSubsidiaryIdentification = (locationSubsidiaryCode: string, allocationCompany: string = '0070') => {
    const locationSubsidiaryIdentification = fragment().ele('LocationSubsidiaryIdentification')
      .ele('LocationSubsidiaryCode').att('n1:LocationSubsidiaryTypeCode', '0').txt(locationSubsidiaryCode).up()
      .ele('AllocationCompany').txt(allocationCompany)
      .doc();
    console.log('LocationSubsidiaryIdentification: ' + locationSubsidiaryIdentification.end({prettyPrint: true}));
    return locationSubsidiaryIdentification.end({prettyPrint: true});
  }

  public timingAtLocation = (time: string, offset: string = '0') => {
    const timingAtLocation = fragment().ele('TimingAtLocation')
      .ele('Timing').att('TimingQualifierCode', 'ALD')
      .ele('Time').txt(time).up()
      .ele('Offset').txt(offset).up()
      .doc();
    console.log('timingAtLocation: ' + timingAtLocation.end({prettyPrint: true}));
    return timingAtLocation.end({prettyPrint: true});
  }

  public trainActivity = (trainActivityType: string = 'GBTB') => {
    const trainActivity = fragment().ele('TrainActivity')
      .ele('TrainActivityType').txt(trainActivityType).up()
      .doc();
    console.log('trainActivity: ' + trainActivity.end({prettyPrint: true}));
    return trainActivity.end({prettyPrint: true});
  }

  public networkSpecificParameter = (name: string = 'UID', value: string) => {
    const networkSpecificParameter = fragment().ele('NetworkSpecificParameter')
      .ele('Name').txt(name).up()
      .ele('Value').txt(value)
      .doc();
    console.log('networkSpecificParameter: ' + networkSpecificParameter.end({prettyPrint: true}));
    return networkSpecificParameter.end({prettyPrint: true});
  }

  public plannedJourneyLocation = (locationPrimaryCode: string, locationSubsidiaryCode: string,
                                   time: string, operationalTrainNumber: string, trainUID: string) => {
    const plannedJourneyLocation = fragment().ele('PlannedJourneyLocation').att('JourneyLocationTypeCode', '01')
      .ele(this.locationSubsidiaryIdentification(locationSubsidiaryCode))
      .ele(this.timingAtLocation(time))
      .ele(this.trainActivity())
      .ele(this.networkSpecificParameter('UID', trainUID))
      .ele('CountryCodeISO').txt('GB').up()
      .ele('LocationPrimaryCode').txt(locationPrimaryCode).up()
      .ele('ResponsibleRU').txt('9984').up()
      .ele('ResponsibleIM').txt('0070').up()
      .ele('OperationalTrainNumber').txt(operationalTrainNumber).up()
      .doc();
    console.log('plannedJourneyLocation: ' + plannedJourneyLocation.end({prettyPrint: true}));
    return plannedJourneyLocation.end({prettyPrint: true});
  }

  public pathInformation = (locationPrimaryCode: string, locationSubsidiaryCode: string,
                            time: string, operationalTrainNumber: string, trainUID: string) => {
    const pathInformation = fragment().ele('PathInformation')
      .ele(this.plannedJourneyLocation(locationPrimaryCode, locationSubsidiaryCode,
      time, operationalTrainNumber, trainUID)).up()
      .ele(this.plannedCalendar())
      .doc();
    console.log('pathInformation: ' + pathInformation.end({prettyPrint: true}));
    return pathInformation.end({prettyPrint: true});
  }

  public validityPeriod = (startDateTime: any = this.runDateTime) => {
    const validityPeriod = fragment().ele('ValidityPeriod')
      .ele('StartDateTime').txt(startDateTime)
      .doc();
    console.log('validityPeriod: ' + validityPeriod.end({prettyPrint: true}));
    return validityPeriod.end({prettyPrint: true});
  }

  public plannedCalendar = (bitmapDays: string = '1') => {
    const plannedCalendar = fragment().ele('PlannedCalendar')
      .ele('BitmapDays').txt(bitmapDays).up()
      .ele(this.validityPeriod())
      .doc();
    console.log('plannedCalendar: ' + plannedCalendar.end({prettyPrint: true}));
    return plannedCalendar.end({prettyPrint: true});
  }

  public buildMessage = (locationPrimaryCode: string, locationSubsidiaryCode: string,
                         time: string, operationalTrainNumber: string, trainUID: string) => {
    console.log('Build Message: ');
    const message =  create().ele('PathDetailsMessage')
      .ele(this.messageHeader()).root()
      .ele(this.adminContactInfo()).root()
      .ele(this.messageStatus()).root()
      .ele(this.typeOfRequest()).root()
      .ele(this.typeOfInformation()).root()
      .ele(this.pathInformation(locationPrimaryCode, locationSubsidiaryCode,
      time, operationalTrainNumber, trainUID)).root()
      .doc();
    console.log('XML: ' + message.end({prettyPrint: true}));
    return message;
  }

/*  public buildMessage(rawXML: string, senderRef: string): any {
    return this.replaceSenderReference(rawXML, senderRef);
  }*/

  public serializeXML(rawXML: string): object {
    return create(rawXML).end({format: 'object'});
  }

  public replaceSenderReference(rawXML: string, senderReference: string): any {
    const serializedXML = this.serializeXML(rawXML);
    console.log('serializedXML: ' + serializedXML);
  }

  /*{
    MessageType: 2003,
    MessageTypeVersion: 5.3.1.GB,
    MessageIdentifier: 414d51204e52504230303920202020205e504839249a2a40,
    MessageDateTime: 2020-02-24T05:59:35-00:00
};*/

}
