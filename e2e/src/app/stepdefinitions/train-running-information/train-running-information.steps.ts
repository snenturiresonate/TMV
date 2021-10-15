import {When} from 'cucumber';
import {TrainRunningInformationMessageBuilder} from '../../utils/train-running-information/train-running-information-message';
import {LinxRestClient} from '../../api/linx/linx-rest-client';
import {CucumberLog} from '../../logging/cucumber-log';
import {DateAndTimeUtils} from '../../pages/common/utilities/DateAndTimeUtils';

const linxRestClient: LinxRestClient = new LinxRestClient();

/**
 * Step to be used when train running information does not have any delay
 * Message Type to be used:
 * Not Specified, Arrival at termination, Departure from Origin, Arrival at station, Departure from station, Passing Location
 * Input: trainUID,trainNumber,scheduledStartDate(accepts today),LocationPrimaryCode,LocationSubsidiaryCode,messageType
 */

When(/^the following train running information? (?:message|messages)? (?:is|are) sent from LINX$/,
  {timeout: 2 * 20000}, async (trainRunningInfoMessageTable: any) => {
  const trainRunningInfoMessages = trainRunningInfoMessageTable.hashes();
  for (const tri of trainRunningInfoMessages) {
    const trainRunningInformationMessageBuilder: TrainRunningInformationMessageBuilder = new TrainRunningInformationMessageBuilder();
    const trainUID = tri.trainUID;
    const operationalTrainNumber = tri.trainNumber;
    const scheduledStartDate = tri.scheduledStartDate;
    const locationPrimaryCode = tri.locationPrimaryCode;
    const locationSubsidiaryCode = tri.locationSubsidiaryCode;
    const messageType = tri.messageType;
    const hourDepartFromOrigin = tri.hourDepartFromOrigin;
    const trainRunningInfo = trainRunningInformationMessageBuilder.buildMessageWithoutDelay(locationPrimaryCode, locationSubsidiaryCode,
      operationalTrainNumber, trainUID,
      scheduledStartDate, messageType, hourDepartFromOrigin);
    const triMessage: string = trainRunningInfo.toString({prettyPrint: true});
    await CucumberLog.addText(`"${triMessage}"`);
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
    for (const tri of trainRunningInfoMessages) {
      const trainRunningInformationMessageBuilder: TrainRunningInformationMessageBuilder = new TrainRunningInformationMessageBuilder();
      const trainUID = tri.trainUID;
      const operationalTrainNumber = tri.trainNumber;
      const scheduledStartDate = tri.scheduledStartDate;
      const locationPrimaryCode = tri.locationPrimaryCode;
      const locationSubsidiaryCode = tri.locationSubsidiaryCode;
      const messageType = tri.messageType;
      const delay = tri.delay;
      const hourDepartFromOrigin = tri.hourDepartFromOrigin;
      const trainRunningInfo = trainRunningInformationMessageBuilder.buildMessageWithDelayAgainstBookedTime(
        locationPrimaryCode, locationSubsidiaryCode, operationalTrainNumber, trainUID,
        scheduledStartDate, messageType, delay, hourDepartFromOrigin);
      const triMessage: string = trainRunningInfo.toString({prettyPrint: true});
      await CucumberLog.addText(`"${triMessage}"`);
      await linxRestClient.postTrainRunningInformation(triMessage);
      await linxRestClient.waitMaxTransmissionTime();
    }
  });

When(/^the following train running info? (?:message|messages) with time? (?:is|are) sent from LINX$/,
  async (trainRunningInfoMessageTable: any) => {
    const trainRunningInfoMessages = trainRunningInfoMessageTable.hashes();
    for (const tri of trainRunningInfoMessages) {
      const trainRunningInformationMessageBuilder: TrainRunningInformationMessageBuilder = new TrainRunningInformationMessageBuilder();
      const trainUID = tri.trainUID;
      const operationalTrainNumber = tri.trainNumber;
      const scheduledStartDate = tri.scheduledStartDate;
      const locationPrimaryCode = tri.locationPrimaryCode;
      const locationSubsidiaryCode = tri.locationSubsidiaryCode;
      const messageType = tri.messageType;
      const timestamp = DateAndTimeUtils.parseTimeEquation(tri.timestamp, 'HH:mm:ss');
      const hourDepartFromOrigin = tri.hourDepartFromOrigin;
      const trainRunningInfo = trainRunningInformationMessageBuilder.buildMessageWithTime(locationPrimaryCode, locationSubsidiaryCode,
        operationalTrainNumber, trainUID, scheduledStartDate, messageType, timestamp, hourDepartFromOrigin);
      const triMessage: string = trainRunningInfo.toString({prettyPrint: true});
      await CucumberLog.addText(`"${triMessage}"`);
      await linxRestClient.postTrainRunningInformation(triMessage);
      await linxRestClient.waitMaxTransmissionTime();
    }
  });


When(/^the following train running info? (?:message|messages) with time? and delay (?:is|are) sent from LINX$/,
  async (trainRunningInfoMessageTable: any) => {
    const trainRunningInfoMessages = trainRunningInfoMessageTable.hashes();
    for (const tri of trainRunningInfoMessages) {
      const trainRunningInformationMessageBuilder: TrainRunningInformationMessageBuilder = new TrainRunningInformationMessageBuilder();
      const trainUID = tri.trainUID;
      const operationalTrainNumber = tri.trainNumber;
      const scheduledStartDate = tri.scheduledStartDate;
      const locationPrimaryCode = tri.locationPrimaryCode;
      const locationSubsidiaryCode = tri.locationSubsidiaryCode;
      const messageType = tri.messageType;
      const bookedTime = DateAndTimeUtils.parseTimeEquation(tri.bookedTime, 'HH:mm:ss');
      const timestamp = DateAndTimeUtils.parseTimeEquation(tri.timestamp, 'HH:mm:ss');
      const hourDepartFromOrigin = tri.hourDepartFromOrigin;
      const trainRunningInfo = trainRunningInformationMessageBuilder.buildMessageWithTimeAgainstBooked(
        locationPrimaryCode, locationSubsidiaryCode, operationalTrainNumber, trainUID, scheduledStartDate,
        messageType, bookedTime, timestamp, hourDepartFromOrigin);
      const triMessage: string = trainRunningInfo.toString({prettyPrint: true});
      await CucumberLog.addText(`"${triMessage}"`);
      await linxRestClient.postTrainRunningInformation(triMessage);
      await linxRestClient.waitMaxTransmissionTime();
    }
  });
