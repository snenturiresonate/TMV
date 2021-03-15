import {create, fragment} from 'xmlbuilder2';
import {TrainRunningInformationMessageHeader} from './message-header';
import { TRIOperationalTrainNumberIdentifier } from './operational-train-number-identifier';
import {TRITrainOperationalIdentification} from './train-operational-identification';
import {TRITrainLocationReport} from './train-location-report';
import {DateAndTimeUtils} from '../../pages/common/utilities/DateAndTimeUtils';

export class TrainRunningInformationMessageBuilder {
  private currentTimeHour(): number {
    return parseInt(DateAndTimeUtils.getHourFromTimeStamp(DateAndTimeUtils.getCurrentDateTime())[Symbol.toStringTag], 2);
  }
  public buildMessageWithoutDelay = (locationPrimaryCode: string, locationSubsidiaryCode: string,
                                     operationalTrainNumber: string, trainUID: string,
                                     scheduledStartDate: string, messageType: string) => {
    const currentTimeHour = this.currentTimeHour();
    return create().ele('TrainRunningInformationMessage')
      .ele(TrainRunningInformationMessageHeader.messageHeader(operationalTrainNumber, trainUID, currentTimeHour)).root()
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
                                                   delay: number, delayHoursOrMins: string) => {
    const currentTimeHour = this.currentTimeHour();
    return create().ele('TrainRunningInformationMessage')
      .ele(TrainRunningInformationMessageHeader.messageHeader(operationalTrainNumber, trainUID, currentTimeHour)).root()
      .ele(this.messageStatus()).root()
      .ele(TRIOperationalTrainNumberIdentifier.operationalTrainNumberIdentifier(operationalTrainNumber)).root()
      .ele(TRITrainOperationalIdentification.trainOperationalIdentification(trainUID, operationalTrainNumber, scheduledStartDate)).root()
      .ele(TRITrainLocationReport.trainLocationReportWithDelayAgainstBookedTime(locationPrimaryCode, locationSubsidiaryCode,
        this.deriveRunningStatusFromMessageType(messageType), delay, delayHoursOrMins)).root()
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
