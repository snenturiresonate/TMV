import {create, fragment} from 'xmlbuilder2';
import {TrainRunningInformationMessageHeader} from './message-header';
import { TRIOperationalTrainNumberIdentifier } from './operational-train-number-identifier';
import {TRITrainOperationalIdentification} from './train-operational-identification';
import {TRITrainLocationReport} from './train-location-report';

export class TrainRunningInformationMessageBuilder {
  public buildMessageWithoutDelay = (locationPrimaryCode: string, locationSubsidiaryCode: string,
                                     operationalTrainNumber: string, trainUID: string,
                                     scheduledStartDate: string, messageType: string, hourDepartFromOrigin: string) => {
    return create().ele('TrainRunningInformationMessage')
      .att('xmlns', 'http://www.era.europa.eu/schemes/TAFTSI/5.3')
      .att('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance')
      .att('xmlns:ns0', 'http://www.era.europa.eu/schemes/TAFTSI/5.3')
      .att('xsi:schemaLocation', 'http://www.era.europa.eu/schemes/TAFTSI/5.3 taf_cat_complete.xsd')
      .ele(TrainRunningInformationMessageHeader.messageHeader(
        operationalTrainNumber, trainUID, Number(hourDepartFromOrigin), scheduledStartDate)).root()
      .ele(this.messageStatus()).root()
      .ele(TRIOperationalTrainNumberIdentifier.operationalTrainNumberIdentifier(operationalTrainNumber)).root()
      .ele(TRITrainOperationalIdentification.trainOperationalIdentification(trainUID, operationalTrainNumber, scheduledStartDate)).root()
      .ele(TRITrainLocationReport.trainLocationReportWithoutDelay(locationPrimaryCode, locationSubsidiaryCode,
        this.deriveRunningStatusFromMessageType(messageType))).root()
      .doc();
  }


  public buildMessageWithTimestamp = (locationPrimaryCode: string, locationSubsidiaryCode: string,
                                      operationalTrainNumber: string, trainUID: string,
                                      scheduledStartDate: string, messageType: string, timestamp: string,
                                      hourDepartFromOrigin: string) => {
    return create().ele('TrainRunningInformationMessage')
      .att('xmlns', 'http://www.era.europa.eu/schemes/TAFTSI/5.3')
      .att('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance')
      .att('xmlns:ns0', 'http://www.era.europa.eu/schemes/TAFTSI/5.3')
      .att('xsi:schemaLocation', 'http://www.era.europa.eu/schemes/TAFTSI/5.3 taf_cat_complete.xsd')
      .ele(TrainRunningInformationMessageHeader.messageHeader(operationalTrainNumber, trainUID, Number(hourDepartFromOrigin))).root()
      .ele(this.messageStatus()).root()
      .ele(TRIOperationalTrainNumberIdentifier.operationalTrainNumberIdentifier(operationalTrainNumber)).root()
      .ele(TRITrainOperationalIdentification.trainOperationalIdentification(trainUID, operationalTrainNumber, scheduledStartDate)).root()
      .ele(TRITrainLocationReport.trainLocationReportWithoutDelay(locationPrimaryCode, locationSubsidiaryCode,
        this.deriveRunningStatusFromMessageType(messageType))).root()
      .doc();
  }


  public buildMessageWithDelayAgainstBookedTime = (locationPrimaryCode: string, locationSubsidiaryCode: string,
                                                   operationalTrainNumber: string, trainUID: string,
                                                   scheduledStartDate: string, messageType: string,
                                                   delay: string, hourDepartFromOrigin: string) => {
    return create().ele('TrainRunningInformationMessage')
      .att('xmlns', 'http://www.era.europa.eu/schemes/TAFTSI/5.3')
      .att('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance')
      .att('xmlns:ns0', 'http://www.era.europa.eu/schemes/TAFTSI/5.3')
      .att('xsi:schemaLocation', 'http://www.era.europa.eu/schemes/TAFTSI/5.3 taf_cat_complete.xsd')
      .ele(TrainRunningInformationMessageHeader.messageHeader(operationalTrainNumber, trainUID, Number(hourDepartFromOrigin))).root()
      .ele(this.messageStatus()).root()
      .ele(TRIOperationalTrainNumberIdentifier.operationalTrainNumberIdentifier(operationalTrainNumber)).root()
      .ele(TRITrainOperationalIdentification.trainOperationalIdentification(trainUID, operationalTrainNumber, scheduledStartDate)).root()
      .ele(TRITrainLocationReport.trainLocationReportWithDelayAgainstBookedTime(locationPrimaryCode, locationSubsidiaryCode,
        this.deriveRunningStatusFromMessageType(messageType), delay)).root()
      .doc();
  }

  public buildMessageWithTime = (locationPrimaryCode: string, locationSubsidiaryCode: string,
                                 operationalTrainNumber: string, trainUID: string,
                                 scheduledStartDate: string, messageType: string, timestamp: string,
                                 hourDepartFromOrigin: string) => {
    return create().ele('TrainRunningInformationMessage')
      .att('xmlns', 'http://www.era.europa.eu/schemes/TAFTSI/5.3')
      .att('xmlns:ns0', 'http://www.era.europa.eu/schemes/TAFTSI/5.3')
      .att('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance')
      .att('xsi:schemaLocation', 'http://www.era.europa.eu/schemes/TAFTSI/5.3 taf_cat_complete.xsd')
      .ele(TrainRunningInformationMessageHeader.messageHeader(operationalTrainNumber, trainUID, Number(hourDepartFromOrigin))).root()
      .ele(this.messageStatus()).root()
      .ele(TRIOperationalTrainNumberIdentifier.operationalTrainNumberIdentifier(operationalTrainNumber)).root()
      .ele(TRITrainOperationalIdentification.trainOperationalIdentification(trainUID, operationalTrainNumber, scheduledStartDate)).root()
      .ele(TRITrainLocationReport.trainLocationReportAtTime(locationPrimaryCode, locationSubsidiaryCode,
        this.deriveRunningStatusFromMessageType(messageType), timestamp)).root()
      .doc();
  }

  public buildMessageWithTimeAgainstBooked = (locationPrimaryCode: string, locationSubsidiaryCode: string,
                                              operationalTrainNumber: string, trainUID: string,
                                              scheduledStartDate: string, messageType: string, bookedTimestamp: string, timestamp: string,
                                              hourDepartFromOrigin: string) => {
    return create().ele('TrainRunningInformationMessage')
      .att('xmlns', 'http://www.era.europa.eu/schemes/TAFTSI/5.3')
      .att('xmlns:ns0', 'http://www.era.europa.eu/schemes/TAFTSI/5.3')
      .att('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance')
      .att('xsi:schemaLocation', 'http://www.era.europa.eu/schemes/TAFTSI/5.3 taf_cat_complete.xsd')
      .ele(TrainRunningInformationMessageHeader.messageHeader(operationalTrainNumber, trainUID, Number(hourDepartFromOrigin))).root()
      .ele(this.messageStatus()).root()
      .ele(TRIOperationalTrainNumberIdentifier.operationalTrainNumberIdentifier(operationalTrainNumber)).root()
      .ele(TRITrainOperationalIdentification.trainOperationalIdentification(trainUID, operationalTrainNumber, scheduledStartDate)).root()
      .ele(TRITrainLocationReport.trainLocationReportAtTimeAgainstBooked(locationPrimaryCode, locationSubsidiaryCode,
        this.deriveRunningStatusFromMessageType(messageType), bookedTimestamp, timestamp)).root()
      .doc();
  }

  public messageStatus = (messageStatus: string = '1') => {
    const messageStat = fragment().ele('MessageStatus').txt(messageStatus).doc();
    return messageStat.end({prettyPrint: true});
  }

  private deriveRunningStatusFromMessageType(messageType: string): string {
    let runningStatus;
    const type = messageType.replace(/\s/g, '').toLowerCase();
    switch (type){
      case ('notspecified'):
        runningStatus = '00';
        break;
      case('arrivalattermination'):
        runningStatus = '01';
        break;
      case('departurefromorigin'):
        runningStatus = '02';
        break;
      case('arrivalatstation'):
        runningStatus = '03';
        break;
      case('departurefromstation'):
        runningStatus = '04';
        break;
      case('passinglocation'):
        runningStatus = '05';
        break;
      default:
        throw new Error('Please verify the TRI message Type');
    }
    return runningStatus;
  }
}
