import {CucumberLog} from '../logging/cucumber-log';
import {LinxRestClient} from '../api/linx/linx-rest-client';
import {browser} from 'protractor';
import {DateAndTimeUtils} from '../pages/common/utilities/DateAndTimeUtils';
import {DateTimeFormatter} from '@js-joda/core';
import '@js-joda/timezone';
import {TrainActivationMessageBuilder} from '../utils/train-activation/train-activation-message';


export class TrainActivationService {
  public static async processTrainActivationMessagesAndSubmit(trainActivationMessages): Promise<any> {
    for (const activation of trainActivationMessages) {
      let linxRestClient: LinxRestClient;
      linxRestClient = new LinxRestClient();
      if (activation.sendMessage === 'false') {
        await CucumberLog.addText(`Train Activation message was not sent`);
      } else {
        const trainActivationMessageBuilder: TrainActivationMessageBuilder = new TrainActivationMessageBuilder();
        let trainUID = activation.trainUID;
        if (trainUID === 'generatedTrainUId' || trainUID === 'generated') {
          trainUID = browser.referenceTrainUid;
        }
        let trainNumber = activation.trainNumber;
        if (trainNumber.includes('generated')) {
          trainNumber = browser.referenceTrainDescription;
        }
        const schedDepString = (activation.scheduledDepartureTime).toLowerCase();
        const scheduledDepartureTime = () => {
          if (schedDepString === 'now') {
            return DateAndTimeUtils.getCurrentTimeString();
          } else if (schedDepString.includes('now + ')) {
            const offset = parseInt(schedDepString.substr(6, schedDepString.length - 6), 10);
            return DateAndTimeUtils.getCurrentTime().plusMinutes(offset).format(DateTimeFormatter.ofPattern('HH:mm:ss'));
          } else if (schedDepString.includes('now - ')) {
            const offset = parseInt(schedDepString.substr(6, schedDepString.length - 6), 10);
            return DateAndTimeUtils.getCurrentTime().minusMinutes(offset).format(DateTimeFormatter.ofPattern('HH:mm:ss'));
          } else {
            return activation.scheduledDepartureTime;
          }
        };
        const departureDate = () => {
          if ((activation.departureDate).toLowerCase() === 'today' ||
            (activation.departureDate).toLowerCase() === 'yesterday' ||
            (activation.departureDate).toLowerCase() === 'tomorrow') {
            return DateAndTimeUtils.convertToDesiredDateAndFormat((activation.departureDate).toLowerCase(), 'yyyy-MM-dd');
          } else if (activation.departureDate === undefined) {
            return DateAndTimeUtils.convertToDesiredDateAndFormat('today', 'yyyy-MM-dd');
          } else {
            return activation.scheduledDepartureTime;
          }
        };
        const actualDepartureHour = () => {
          let aDH = activation.actualDepartureHour;
          if (aDH === undefined) {
            aDH = 'now';
          }
          if (aDH.toLowerCase() === 'now' || activation.departureDate === undefined) {
            return DateAndTimeUtils.getCurrentTimeString('HH');
          }
          return activation.actualDepartureHour;
        };
        const locationPrimaryCode = activation.locationPrimaryCode;
        const locationSubsidiaryCode = activation.locationSubsidiaryCode;
        const asmVal = activation.asm ? activation.asm : 1;
        const trainActMss = trainActivationMessageBuilder.buildMessage(locationPrimaryCode, locationSubsidiaryCode,
          scheduledDepartureTime().toString(), trainNumber, trainUID, departureDate().toString(), actualDepartureHour().toString(), asmVal);
        await linxRestClient.postTrainActivation(trainActMss.toString({prettyPrint: true}));
        await CucumberLog.addText(`Train Activation message: ${trainActMss.toString({prettyPrint: true})}`);
      }
    }
  }
}
