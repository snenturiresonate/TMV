import { create, fragment } from 'xmlbuilder2';
import {LocalDateTime} from '@js-joda/core';
import {TrainActivationMessageHeader} from './message-header';
import {AdminContactInfo} from './admin-contact-info';
import {TrainActivationPathInformationBuilder} from './path-information';

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
      .ele(TrainActivationPathInformationBuilder.pathInformation(locationPrimaryCode, locationSubsidiaryCode,
      time, operationalTrainNumber, trainUID)).root()
      .doc();
    console.log('XML: ' + message.end({prettyPrint: true}));
    return message;
  }

}
