import {When} from 'cucumber';
import {TrainRunningInformationMessageBuilder} from '../../utils/train-running-information/train-running-information-message';
import {LinxRestClient} from '../../api/linx/linx-rest-client';
import {CucumberLog} from '../../logging/cucumber-log';
import {browser} from 'protractor';

const linxRestClient: LinxRestClient = new LinxRestClient();

/**
 * Step to be used when train running information does not have any delay
 * Message Type to be used:
 * Not Specified, Arrival at termination, Departure from Origin, Arrival at station, Departure from station, Passing Location
 * Input: trainUID,trainNumber,scheduledStartDate(accepts today),LocationPrimaryCode,LocationSubsidiaryCode,messageType
 */

// tslint:disable-next-line:max-line-length
When(/^the following train running information? (?:message|messages)? (?:is|are) sent from LINX$/, {timeout: 2 * 20000}, async (trainRunningInfoMessageTable: any) => {
  const trainRunningInfoMessages = trainRunningInfoMessageTable.hashes();
  // tslint:disable-next-line:prefer-for-of
  for (let i = 0; i < trainRunningInfoMessages.length; i++) {
    const trainRunningInformationMessageBuilder: TrainRunningInformationMessageBuilder = new TrainRunningInformationMessageBuilder();
    const trainUID = trainRunningInfoMessages[i].trainUID;
    const operationalTrainNumber = trainRunningInfoMessages[i].trainNumber;
    const scheduledStartDate = trainRunningInfoMessages[i].scheduledStartDate;
    const locationPrimaryCode = trainRunningInfoMessages[i].locationPrimaryCode;
    const locationSubsidiaryCode = trainRunningInfoMessages[i].locationSubsidiaryCode;
    const messageType = trainRunningInfoMessages[i].messageType;
    const hourDepartFromOrigin = trainRunningInfoMessages[i].hourDepartFromOrigin;
    const trainRunningInfo = trainRunningInformationMessageBuilder.buildMessageWithoutDelay(locationPrimaryCode, locationSubsidiaryCode,
      operationalTrainNumber, trainUID,
      scheduledStartDate, messageType, hourDepartFromOrigin);
    const triMessage: string = trainRunningInfo.toString({prettyPrint: true});
    await CucumberLog.addText(triMessage);
    await linxRestClient.postTrainRunningInformation(triMessage);
    await linxRestClient.waitMaxTransmissionTime();
  }
});

/**
 * Step to be used when train running information has delay on the location timing
 * Message Type to be used:
 * Not Specified, Arrival at termination, Departure from Origin, Arrival at station, Departure from station, Passing Location
 * Input: trainUID,trainNumber,scheduledStartDate(accepts today),LocationPrimaryCode,LocationSubsidiaryCode,messageType and delay(hh:mm)
 */
When(/^the following train running information? (?:message|messages) with delay against booked time? (?:is|are) sent from LINX$/,
  async (trainRunningInfoMessageTable: any) => {
    const trainRunningInfoMessages = trainRunningInfoMessageTable.hashes();
    // tslint:disable-next-line:prefer-for-of
    for (let i = 0; i < trainRunningInfoMessages.length; i++) {
      const trainRunningInformationMessageBuilder: TrainRunningInformationMessageBuilder = new TrainRunningInformationMessageBuilder();
      const trainUID = trainRunningInfoMessages[i].trainUID;
      const operationalTrainNumber = trainRunningInfoMessages[i].trainNumber;
      const scheduledStartDate = trainRunningInfoMessages[i].scheduledStartDate;
      const locationPrimaryCode = trainRunningInfoMessages[i].locationPrimaryCode;
      const locationSubsidiaryCode = trainRunningInfoMessages[i].locationSubsidiaryCode;
      const messageType = trainRunningInfoMessages[i].messageType;
      const delay = trainRunningInfoMessages[i].delay;
      const hourDepartFromOrigin = trainRunningInfoMessages[i].hourDepartFromOrigin;
      // tslint:disable-next-line:max-line-length
      const trainRunningInfo = trainRunningInformationMessageBuilder.buildMessageWithDelayAgainstBookedTime(locationPrimaryCode, locationSubsidiaryCode,
        operationalTrainNumber, trainUID,
        scheduledStartDate, messageType, delay, hourDepartFromOrigin);
      const triMessage: string = trainRunningInfo.toString({prettyPrint: true});
      await CucumberLog.addText(triMessage);
      await linxRestClient.postTrainRunningInformation(triMessage);
      await linxRestClient.waitMaxTransmissionTime();
    }
  });

When(/^the following train running info? (?:message|messages) with time? (?:is|are) sent from LINX$/,
  async (trainRunningInfoMessageTable: any) => {
    const trainRunningInfoMessages = trainRunningInfoMessageTable.hashes();
    // tslint:disable-next-line:prefer-for-of
    for (let i = 0; i < trainRunningInfoMessages.length; i++) {
      const trainRunningInformationMessageBuilder: TrainRunningInformationMessageBuilder = new TrainRunningInformationMessageBuilder();
      const trainUID = trainRunningInfoMessages[i].trainUID;
      const operationalTrainNumber = trainRunningInfoMessages[i].trainNumber;
      const scheduledStartDate = trainRunningInfoMessages[i].scheduledStartDate;
      const locationPrimaryCode = trainRunningInfoMessages[i].locationPrimaryCode;
      const locationSubsidiaryCode = trainRunningInfoMessages[i].locationSubsidiaryCode;
      const messageType = trainRunningInfoMessages[i].messageType;
      const timestamp = trainRunningInfoMessages[i].timestamp;
      const hourDepartFromOrigin = trainRunningInfoMessages[i].hourDepartFromOrigin;
      // tslint:disable-next-line:max-line-length
      const trainRunningInfo = trainRunningInformationMessageBuilder.buildMessageWithTime(locationPrimaryCode, locationSubsidiaryCode,
        operationalTrainNumber, trainUID,
        scheduledStartDate, messageType, timestamp, hourDepartFromOrigin);
      const triMessage: string = trainRunningInfo.toString({prettyPrint: true});
      await CucumberLog.addText(triMessage);
      await linxRestClient.postTrainRunningInformation(triMessage);
      await linxRestClient.waitMaxTransmissionTime();
    }
  });
