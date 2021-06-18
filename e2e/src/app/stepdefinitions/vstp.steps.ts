import {Before, Given, When} from 'cucumber';
import {DateAndTimeUtils} from '../pages/common/utilities/DateAndTimeUtils';
import {CucumberLog} from '../logging/cucumber-log';
import {LinxRestClient} from '../api/linx/linx-rest-client';
import {VstpUpdates} from '../utils/vstp/vstp-updates';
import {LocalDate} from '@js-joda/core';
import {browser} from 'protractor';
import { TrainUIDUtils } from '../pages/common/utilities/trainUIDUtils';

let linxRestClient: LinxRestClient;
let vstpUpdates: VstpUpdates;
let stpIndicatorArr;
const vstpUpdateValuesMap = new Map();

Before(() => {
  linxRestClient = new LinxRestClient();
  vstpUpdates = new VstpUpdates();
});

Given(/^the vstp schedule has a schedule before current time period$/, async () => {
  const timePeriodStart = LocalDate.now().minusDays(3);
  const timePeriodEnd = LocalDate.now().minusDays(2);
  browser.referenceTrainUid = await TrainUIDUtils.generateUniqueTrainUid();
  vstpUpdateValuesMap.set('<schedule_start_date>', DateAndTimeUtils.convertToDesiredDateAndFormat(timePeriodStart.toString() , 'yyyyMMdd'));
  vstpUpdateValuesMap.set('<schedule_end_date>', DateAndTimeUtils.convertToDesiredDateAndFormat(timePeriodEnd.toString() , 'yyyyMMdd'));
  vstpUpdateValuesMap.set('<train_uid>', browser.referenceTrainUid);
});

Given(/^the vstp schedule has a schedule after current time period$/, async () => {
  const timePeriod = LocalDate.now().plusDays(2);
  browser.referenceTrainUid = await TrainUIDUtils.generateUniqueTrainUid();
  vstpUpdateValuesMap.set('<schedule_start_date>', DateAndTimeUtils.convertToDesiredDateAndFormat(timePeriod.toString() , 'yyyyMMdd'));
  vstpUpdateValuesMap.set('<train_uid>', browser.referenceTrainUid);
});

Given(/^the vstp schedule has a schedule days to run not in current time period$/, async () => {
  const currentDate = LocalDate.now();
  const scheduleDay = LocalDate.now().plusDays(2).dayOfWeek();
  const runDays = vstpUpdates.runOneDay(scheduleDay.toString()).toString();
  browser.referenceTrainUid = await TrainUIDUtils.generateUniqueTrainUid();
  vstpUpdateValuesMap.set('<schedule_start_date>', DateAndTimeUtils.convertToDesiredDateAndFormat(currentDate.toString() , 'yyyyMMdd'));
  vstpUpdateValuesMap.set('<schedule_days_runs>', runDays);
  vstpUpdateValuesMap.set('<train_uid>', browser.referenceTrainUid);
});

Given(/^the vstp schedule has a schedule in the current time period with (.*) uid$/, async (uidSource: string) => {
  const currentDate = LocalDate.now();
  vstpUpdateValuesMap.set('<schedule_start_date>', DateAndTimeUtils.convertToDesiredDateAndFormat(currentDate.toString() , 'yyyyMMdd'));
  if (uidSource === 'new') {
    browser.referenceTrainUid = await TrainUIDUtils.generateUniqueTrainUid();
    vstpUpdateValuesMap.set('<train_uid>', browser.referenceTrainUid);
  }
  if (uidSource === 'existing') {
    vstpUpdateValuesMap.set('<train_uid>', browser.referenceTrainUid);
  }
});

Given(/^the vstp schedule has a STP indicator '(.*)'$/, async (STPindicator: string) => {
  stpIndicatorArr = STPindicator.split( ',');
});

When(/^the following VSTP update messages? (?:is|are) sent from LINX$/, async (vstpMessageTable: any) => {
  const vstpMessages: any = vstpMessageTable.hashes();

  vstpMessages.forEach((vstpMessage: any) => {
    if ( vstpUpdateValuesMap.size === 0 ){
      linxRestClient.postVstp(vstpMessage.asXml);
    }
    // To handle VSTP message updates
    else{
      let updatedVstpMessage = vstpMessage.asXml.toString();
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
