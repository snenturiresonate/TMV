import {When} from 'cucumber';
import {TrainRunningInformationMessageBuilder} from '../../utils/train-running-information/train-running-information-message';
import {LinxRestClient} from '../../api/linx/linx-rest-client';

const linxRestClient: LinxRestClient = new LinxRestClient();

/**
 * Step to be used when train running information does not have any delay
 * Message Type to be used:
 * Not Specified, Arrival at termination, Departure from Origin, Arrival at station, Departure from station, Passing Location
 * Input: trainUID,trainNumber,scheduledStartDate(per timetable- accepts today),LocationPrimaryCode,LocationSubsidiaryCode,messageType
 */
// tslint:disable-next-line:max-line-length
When(/^the following train running information? (?:message|messages)? (?:is|are) sent from LINX$/, {timeout: 2 * 20000}, async (trainRunningInfoMessageTable: any) => {
  const trainRunningInfoMessages = trainRunningInfoMessageTable.hashes();
  for (let i = 0; i < trainRunningInfoMessages.length; i++){
    const trainRunningInformationMessageBuilder: TrainRunningInformationMessageBuilder = new TrainRunningInformationMessageBuilder();
    const trainUID = trainRunningInfoMessages[i].trainUID;
    const operationalTrainNumber = trainRunningInfoMessages[i].trainNumber;
    const scheduledStartDate = trainRunningInfoMessages[i].scheduledStartDate;
    const locationPrimaryCode = trainRunningInfoMessages[i].locationPrimaryCode;
    const locationSubsidiaryCode = trainRunningInfoMessages[i].locationSubsidiaryCode;
    const messageType = trainRunningInfoMessages[i].messageType;
    const trainRunningInfo = trainRunningInformationMessageBuilder.buildMessageWithoutDelay(locationPrimaryCode, locationSubsidiaryCode,
      operationalTrainNumber, trainUID,
      scheduledStartDate, messageType);
    console.log('XML: ' + trainRunningInfo.toString({prettyPrint: true}));
    await linxRestClient.postTrainActivation(trainRunningInfo.toString({prettyPrint: true}));

    await linxRestClient.waitMaxTransmissionTime();
  }
});

When(/^the following train running information? (?:message|messages) with delay? (?:is|are) sent from LINX$/,
  async (trainRunningInfoMessageTable: any) => {
  const trainRunningInfoMessages = trainRunningInfoMessageTable.hashes();
  for (let i = 0; i < trainRunningInfoMessages.length; i++){
    const trainRunningInformationMessageBuilder: TrainRunningInformationMessageBuilder = new TrainRunningInformationMessageBuilder();
    const trainUID = trainRunningInfoMessages[i].trainUID;
    const operationalTrainNumber = trainRunningInfoMessages[i].trainNumber;
    const scheduledStartDate = trainRunningInfoMessages[i].scheduledStartDate;
    const locationPrimaryCode = trainRunningInfoMessages[i].locationPrimaryCode;
    const locationSubsidiaryCode = trainRunningInfoMessages[i].locationSubsidiaryCode;
    const messageType = trainRunningInfoMessages[i].messageType;
    const delay = trainRunningInfoMessages[i].delay;
    const delayHoursOrMins = trainRunningInfoMessages[i].delayHoursOrMins;
    // tslint:disable-next-line:max-line-length
    const trainRunningInfo = trainRunningInformationMessageBuilder.buildMessageWithDelayAgainstBookedTime(locationPrimaryCode, locationSubsidiaryCode,
      operationalTrainNumber, trainUID,
      scheduledStartDate, messageType, delay, delayHoursOrMins);
    await linxRestClient.postTrainActivation(trainRunningInfo.toString({prettyPrint: true}));

    await linxRestClient.waitMaxTransmissionTime();
  }
});
