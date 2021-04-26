import { create, fragment } from 'xmlbuilder2';
import {LocalDateTime} from '@js-joda/core';
import {TrainActivationMessageHeader} from './message-header';
import {AdminContactInfo} from './admin-contact-info';
import {TrainActivationPathInformationBuilder} from './path-information';
import {Identifiers} from "./identifiers";

export class TrainActivationMessageBuilder {
  public runDateTime = LocalDateTime.now();

  public messageStatus = (messageStatus: string = '1') => {
    const messageStat = fragment().ele('ns0:MessageStatus').txt(messageStatus).doc();
    return messageStat.end({prettyPrint: true});
  }

  public typeOfRequest = (typeOfRequest: string = '3') => {
    const TypeOfReq = fragment().ele('ns0:TypeOfRequest').txt(typeOfRequest).doc();
    return TypeOfReq.end({prettyPrint: true});
  }

  public typeOfInformation = (typeOfInformation: string = '50') => {
    const TypeOfInfo = fragment().ele('ns0:TypeOfInformation').txt(typeOfInformation).doc();
    return TypeOfInfo.end({prettyPrint: true});
  }

  public buildMessage = (locationPrimaryCode: string, locationSubsidiaryCode: string,
                         time: string, operationalTrainNumber: string, trainUID: string, departureDate: string,
                         actualDepartureHour: string) => {
    const hourOfDeparture = parseInt(time.split(':')[0], 2);
    return create().ele('ns0:PathDetailsMessage')
      .att('xmlns:ns0', 'http://www.era.europa.eu/schemes/TAFTSI/5.3')
      .att('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance')
      .att('xsi:schemaLocation', 'http://www.era.europa.eu/schemes/TAFTSI/5.3 taf_cat_complete.xsd')
      .ele(TrainActivationMessageHeader.messageHeader(operationalTrainNumber, trainUID, hourOfDeparture)).root()
      .ele(AdminContactInfo.adminContactInfo()).root()
      .ele(Identifiers.identifiers(operationalTrainNumber, trainUID, departureDate, actualDepartureHour)).root()
      .ele(this.messageStatus()).root()
      .ele(this.typeOfRequest()).root()
      .ele(this.typeOfInformation()).root()
      .ele(TrainActivationPathInformationBuilder.pathInformation(locationPrimaryCode, locationSubsidiaryCode,
      time, operationalTrainNumber, trainUID)).root()
      .doc();
  }

}
