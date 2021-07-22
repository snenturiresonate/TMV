import {Before, Given, When} from 'cucumber';
import {DateAndTimeUtils} from '../pages/common/utilities/DateAndTimeUtils';
import {CucumberLog} from '../logging/cucumber-log';
import {LinxRestClient} from '../api/linx/linx-rest-client';
import {VstpUpdates} from '../utils/vstp/vstp-updates';
import {browser} from 'protractor';
import { TrainUIDUtils } from '../pages/common/utilities/trainUIDUtils';
import {ChronoUnit, DateTimeFormatter, ZonedDateTime} from '@js-joda/core';

let linxRestClient: LinxRestClient;
let vstpUpdates: VstpUpdates;
let stpIndicatorArr;
const vstpUpdateValuesMap = new Map();

Before(() => {
  linxRestClient = new LinxRestClient();
  vstpUpdates = new VstpUpdates();
});

Given(/^the vstp schedule has a schedule before current time period$/, async () => {
  const timePeriodStart = DateAndTimeUtils.getCurrentDateTime().minusDays(3);
  const timePeriodEnd = DateAndTimeUtils.getCurrentDateTime().minusDays(2);
  browser.referenceTrainUid = await TrainUIDUtils.generateUniqueTrainUid();
  vstpUpdateValuesMap.set('<schedule_start_date>', timePeriodStart.format(DateTimeFormatter.ofPattern('yyyyMMdd')));
  vstpUpdateValuesMap.set('<schedule_end_date>', timePeriodEnd.format(DateTimeFormatter.ofPattern('yyyyMMdd')));
  vstpUpdateValuesMap.set('<train_uid>', browser.referenceTrainUid);
});

Given(/^the vstp schedule has a schedule after current time period$/, async () => {
  const timePeriod = DateAndTimeUtils.getCurrentDateTime().plusDays(2);
  browser.referenceTrainUid = await TrainUIDUtils.generateUniqueTrainUid();
  vstpUpdateValuesMap.set('<schedule_start_date>', timePeriod.format(DateTimeFormatter.ofPattern('yyyyMMdd')));
  vstpUpdateValuesMap.set('<train_uid>', browser.referenceTrainUid);
});

Given(/^the vstp schedule has a schedule days to run not in current time period$/, async () => {
  const currentDate = DateAndTimeUtils.getCurrentDateTimeString('yyyyMMdd');
  const scheduleDay = DateAndTimeUtils.getCurrentDateTime().plusDays(2).dayOfWeek();
  const runDays = vstpUpdates.runOneDay(scheduleDay.toString()).toString();
  browser.referenceTrainUid = await TrainUIDUtils.generateUniqueTrainUid();
  vstpUpdateValuesMap.set('<schedule_start_date>', currentDate);
  vstpUpdateValuesMap.set('<schedule_days_runs>', runDays);
  vstpUpdateValuesMap.set('<train_uid>', browser.referenceTrainUid);
});

Given(/^the vstp schedule has a schedule in the current time period with (.*) uid$/, async (uidSource: string) => {
  const currentDate = DateAndTimeUtils.getCurrentDateTimeString('yyyyMMdd');
  vstpUpdateValuesMap.set('<schedule_start_date>', currentDate);
  if (uidSource === 'new') {
    browser.referenceTrainUid = await TrainUIDUtils.generateUniqueTrainUid();
    vstpUpdateValuesMap.set('<train_uid>', browser.referenceTrainUid);
  }
  else if (uidSource === 'existing') {
    vstpUpdateValuesMap.set('<train_uid>', browser.referenceTrainUid);
  }
  else {
    vstpUpdateValuesMap.set('<train_uid>', uidSource);
  }
});

Given(/^the vstp schedule has a STP indicator '(.*)'$/, async (STPindicator: string) => {
  stpIndicatorArr = STPindicator.split( ',');
});

When(/^the following VSTP update messages? (?:is|are) sent from LINX starting (.*)$/,
  async (startTime: string, vstpMessageTable: any) => {
  const vstpMessages: any = vstpMessageTable.hashes();
  let updatedVstpMessage;

  vstpMessages.forEach((vstpMessage: any) => {
    if ( vstpUpdateValuesMap.size === 0 ){
      linxRestClient.postVstp(vstpMessage.asXml);
    }
    // To handle VSTP message updates
    else{
      if (startTime === 'now') {
        const templateVstpMessage = vstpMessage.asXml.toString();
        const origDepTimeCharStart = templateVstpMessage.indexOf('scheduled_departure_time') + 26;
        const origDepTimeString = templateVstpMessage.substr(origDepTimeCharStart, 6);
        const nowInVSTPFormat = DateAndTimeUtils.getCurrentTime().format(DateTimeFormatter.ofPattern('HHmmss'));
        const diffSecs = toDateTime(origDepTimeString).until(toDateTime(nowInVSTPFormat), ChronoUnit.SECONDS);
        updatedVstpMessage = adjustVSTPTimings(templateVstpMessage, diffSecs);
      }
      else {
        updatedVstpMessage = vstpMessage.asXml.toString();
      }

      vstpUpdateValuesMap.forEach((value, key) => {
        updatedVstpMessage = vstpUpdates.updateVSTPXML(key, value, updatedVstpMessage);
      });

      // To handle multiple STP indicators
      if (stpIndicatorArr !== undefined) {
        for (const stpIndicator of stpIndicatorArr){
          const replacementValue = ' CIF_stp_indicator=" ' + stpIndicator + '"';
          updatedVstpMessage = vstpUpdates.updateVSTPXMLRegEx(/CIF_stp_indicator=".*"/g, replacementValue , updatedVstpMessage);
          linxRestClient.postVstp(updatedVstpMessage);
          CucumberLog.addText(updatedVstpMessage);
        }
      } else {
        linxRestClient.postVstp(updatedVstpMessage);
        CucumberLog.addText(updatedVstpMessage);
      }
    }
  });
  await linxRestClient.waitMaxTransmissionTime();
});

function adjustVSTPTimings(vstpXMLString: string, timeAdjustSecs: number): string {
  let newTime = DateAndTimeUtils.getCurrentTime();
  let nextTimeStringStart = 0;
  let nextTime = '000000';
  let val = '000000';
  while (vstpXMLString.indexOf('_time=', nextTimeStringStart + 1) !== -1) {
    nextTimeStringStart = vstpXMLString.indexOf('_time=', nextTimeStringStart + 1) + 7;
    nextTime = vstpXMLString.substr(nextTimeStringStart, 6);
    if (nextTime.indexOf(' ') === -1) {
      newTime = toDateTime(nextTime).plusSeconds(timeAdjustSecs);
      val = newTime.format(DateTimeFormatter.ofPattern('HHmmss'));
      vstpXMLString = vstpXMLString.replace(nextTime, val);
    }
  }
  return vstpXMLString;
}

function toDateTime(vstpTime: string): ZonedDateTime {
  const thisDateTime = DateAndTimeUtils.getCurrentTime();
  let vstpHourStr = vstpTime.substr(0, 2);
  let vstpMinsStr = vstpTime.substr(2, 2);
  let vstpSecsStr = vstpTime.substr(4, 2);
  if (vstpHourStr.substr(0, 1) === '0') {
    vstpHourStr = vstpHourStr.substr(1, 1);
  }
  if (vstpMinsStr.substr(0, 1) === '0') {
    vstpMinsStr = vstpMinsStr.substr(1, 1);
  }
  if (vstpSecsStr.substr(0, 1) === '0') {
    vstpSecsStr = vstpSecsStr.substr(1, 1);
  }
  return thisDateTime.withHour(vstpHourStr).withMinute(vstpMinsStr).withSecond(vstpSecsStr);
}
