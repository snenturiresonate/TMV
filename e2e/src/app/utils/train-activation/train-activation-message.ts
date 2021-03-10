import { create, fragment } from 'xmlbuilder2';
import {LocalDateTime} from '@js-joda/core';
import {TrainActivationMessageHeader} from './message-header';
import {AdminContactInfo} from './admin-contact-info';

export class TrainActivationMessageBuilder {
  public runDateTime = LocalDateTime.now();

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
    const hourOfDeparture = parseInt(time.split(':')[0], 2);
    const message =  create().ele('PathDetailsMessage')
      .ele(TrainActivationMessageHeader.messageHeader(operationalTrainNumber, trainUID, hourOfDeparture)).root()
      .ele(AdminContactInfo.adminContactInfo()).root()
      .ele(this.messageStatus()).root()
      .ele(this.typeOfRequest()).root()
      .ele(this.typeOfInformation()).root()
      .ele(this.pathInformation(locationPrimaryCode, locationSubsidiaryCode,
      time, operationalTrainNumber, trainUID)).root()
      .doc();
    console.log('XML: ' + message.end({prettyPrint: true}));
    return message;
  }

}
