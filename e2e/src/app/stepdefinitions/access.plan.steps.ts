import {Given, Before, When} from 'cucumber';
import {LinxRestClient} from '../api/linx/linx-rest-client';
import {AppPage} from '../pages/app.po';
import * as fs from 'fs';
import {AccessPlanRequest} from '../../../../src/app/api/linx/models/access-plan-request';
import {ProjectDirectoryUtil} from '../utils/project-directory.util';
import * as path from 'path';
import {browser} from 'protractor';
import {DateAndTimeUtils} from '../pages/common/utilities/DateAndTimeUtils';
import {CucumberLog} from '../logging/cucumber-log';
import {DateTimeFormatter} from '@js-joda/core';
import {AccessPlanService} from '../services/access-plan.service';
import {TrainUIDUtils} from '../pages/common/utilities/trainUIDUtils';
import {BerthStep} from '../../../../src/app/api/linx/models/berth-step';
import {BerthInterpose} from '../../../../src/app/api/linx/models/berth-interpose';
import {BackEndChecksService} from '../services/back-end-checks.service';

let page: AppPage;
let linxRestClient: LinxRestClient;

Before(() => {
  page = new AppPage();
  linxRestClient = new LinxRestClient();
});

When('the access plan located in CIF file {string} is amended so that all services start within the next hour and then received from LINX',
  async (cifFilePath: string) => {
    const rawData: Buffer = fs.readFileSync(path.join(ProjectDirectoryUtil.testDataFolderPath(), cifFilePath));
    const initialString = rawData.toString();
    const cifLines: string[] = initialString.split(/\r?\n/, 1000);
    const now = DateAndTimeUtils.getCurrentTime();
    const startHours = now.hour();
    const startMins = now.minute();
    const timeOfExtract = now.format(DateTimeFormatter.ofPattern('HHmm'));
    const dateOfExtract = DateAndTimeUtils.convertToDesiredDateAndFormat('today', 'ddMMyy');
    const endDateOfExtract = DateAndTimeUtils.convertToDesiredDateAndFormat('tomorrow', 'ddMMyy');
    let setHours = startHours;
    let trainWTTStartHours = 0;
    let trainWTTStartMins = 0;
    for (let i = 0; i < cifLines.length; i++) {
      // Header record setup to current date
      if (i === 0) {
        cifLines[i] = AccessPlanService.dealWithHDRecord(cifLines[i], dateOfExtract, timeOfExtract, endDateOfExtract);
      }
      if (cifLines[i].indexOf('LO') === 0) {
        // for each LO record, set up the trainWTTStartHours, setHours values which are then used for subsequest LI and LT records
        trainWTTStartHours = Number(cifLines[i].substr(10, 2));
        trainWTTStartMins = Number(cifLines[i].substr(12, 2));
        if (trainWTTStartMins < startMins) {
          setHours = startHours + 1;
        }
        else {
          setHours = startHours;
        }
        cifLines[i] = AccessPlanService.dealWithLOOrLTRecord(cifLines[i], trainWTTStartHours, setHours);
      }
      else if (cifLines[i].indexOf('LI') === 0) {
        cifLines[i] = AccessPlanService.dealWithLIRecord(cifLines[i], trainWTTStartHours, setHours);
      }
      else if (cifLines[i].indexOf('LT') === 0) {
        cifLines[i] = AccessPlanService.dealWithLOOrLTRecord(cifLines[i], trainWTTStartHours, setHours);
      }
      else {
        cifLines[i] = cifLines[i] + ' '.repeat(80 - cifLines[i].length) + '\r\n';
      }
    }
    // put it all back together and load
    const newData = cifLines.join('');
    await CucumberLog.addText(`Access Plan: ${newData}`);
    await linxRestClient.addAccessPlan('', newData);
});

When ('I remove all CIFs from the LINX FTP server', async () => {
    await linxRestClient.clearCIFs();
});

When ('the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX',
  async (inputs: any) => {
    const cifInputs: any = inputs.hashes()[0];
    await AccessPlanService.processCifInputsAndSubmit(cifInputs);
});

When (/^the train in CIF file below is updated accordingly so time at the reference point is now (.) '?(.*)'? minutes?, and then received from LINX$/,
  async (operator: string, mins: string, inputs: any) => {
    const cifInputs: any = inputs.hashes()[0];
    if (operator === '+') {
      await AccessPlanService.processCifInputsAndSubmit(cifInputs, parseInt(mins, 10));
    }
    else {
      await AccessPlanService.processCifInputsAndSubmit(cifInputs, 0, parseInt(mins, 10));
    }
  });


When (/^I load a CIF file leaving (.*) now using (.*) which (.*) running today$/,
  async (refLoc: string, templateTrain: string, isRunningToday: string) => {
    let runDays = '1111111';
    if (isRunningToday !== 'is') {
      const dayPos = DateAndTimeUtils.dayOfWeekOrdinal();
      runDays =  runDays.substring(0, dayPos) + '0' + runDays.substring(dayPos + 1);
    }
    const inputs = {
      filePath: templateTrain,
      refLocation: refLoc,
      refTimingType: 'WTT_dep',
      newTrainDescription: 'generated',
      newPlanningUid: 'generated',
      newRunDays: runDays
    };
    browser.referenceTrainDescription = await TrainUIDUtils.generateTrainDescription();
    browser.referenceTrainUid = await TrainUIDUtils.generateUniqueTrainUid();
    await AccessPlanService.processCifInputsAndSubmit(inputs);
  });

Given (/^I set up a train that is (.*) late at (.*) using (.*) TD (.*) interpose into (.*) step to (.*)$/,
  async (lateness, refLoc, templateTrain, td, fromBerth, toBerth) => {
  const inputs = {
    filePath: templateTrain,
    refLocation: refLoc,
    refTimingType: 'WTT_dep',
    newTrainDescription: 'generated',
    newPlanningUid: 'generated'
  };
  browser.referenceTrainDescription = await TrainUIDUtils.generateTrainDescription();
  browser.referenceTrainUid = await TrainUIDUtils.generateUniqueTrainUid();
  const msg = `Generated train description: ${browser.referenceTrainDescription} ${browser.referenceTrainUid}`;
  console.log(msg);
  await CucumberLog.addText(msg);
  const operator = lateness.substr(0, 1);
  const mins = lateness.substr(1);
  // if we want late ( i.e. data table operator is +), we need to time the train back the number of mins and v.v.
  if (operator === '+') {
    await AccessPlanService.processCifInputsAndSubmit(inputs, 0, parseInt(mins, 10));
  }
  else {
    await AccessPlanService.processCifInputsAndSubmit(inputs, parseInt(mins, 10));
  }
  const date: string = await DateAndTimeUtils.getCurrentDateTimeString('yyyy-MM-dd');
  await BackEndChecksService.waitForTrainUid(browser.referenceTrainUid, date);
  const now = DateAndTimeUtils.getCurrentTimeString();
  const berthInterpose: BerthInterpose = new BerthInterpose(now, fromBerth, td, browser.referenceTrainDescription);
  await CucumberLog.addJson(berthInterpose);
  await linxRestClient.postBerthInterpose(berthInterpose);
  await linxRestClient.waitMaxTransmissionTime();
  await linxRestClient.waitMaxTransmissionTime();
  const now2 = DateAndTimeUtils.getCurrentTimeString();
  const berthStep: BerthStep = new BerthStep(fromBerth, now2, toBerth, td, browser.referenceTrainDescription);
  await CucumberLog.addJson(berthStep);
  await linxRestClient.postBerthStep(berthStep);
  await linxRestClient.waitMaxTransmissionTime();
  await linxRestClient.waitMaxTransmissionTime();
});

When('the access plan located in JSON file {string} is received from LINX', async (jsonFilePath: string) => {
  const rawData: Buffer = fs.readFileSync(path.join(ProjectDirectoryUtil.testDataFolderPath(), jsonFilePath));
  const accessPlanRequest: AccessPlanRequest = JSON.parse(rawData.toString());
  await linxRestClient.writeAccessPlan(accessPlanRequest);
});

When('the access plan located in CIF file {string} is received from LINX with name {string}',
  async (cifFilePath: string, cifName: string) => {
  const rawData: Buffer = fs.readFileSync(path.join(ProjectDirectoryUtil.testDataFolderPath(), cifFilePath));
  await linxRestClient.addAccessPlan(cifName, rawData.toString());
});

When('the access plan located in CIF file {string} is received from LINX',
  async (cifFilePath: string) => {
    const rawData: Buffer = fs.readFileSync(path.join(ProjectDirectoryUtil.testDataFolderPath(), cifFilePath));
    await linxRestClient.addAccessPlan('', rawData.toString());
  });

When('the access plan located in CIF file {string} is received from LINX with the new uid',
  async (cifFilePath: string) => {
    const rawData: Buffer = fs.readFileSync(path.join(ProjectDirectoryUtil.testDataFolderPath(), cifFilePath));
    const initialString = rawData.toString();
    const cifLines: string[] = initialString.split(/\r?\n/, 1000);
    for (let i = 0; i < cifLines.length; i++) {
      const rowType = cifLines[i].substr(0, 2);
      cifLines[i] = AccessPlanService.adjustCIFTrainUId(cifLines[i], rowType, browser.referenceTrainUid);
    }
    const newData = cifLines.join('');
    await CucumberLog.addText(`Access Plan: ${newData}`);
    await linxRestClient.addAccessPlan('', newData);
    await linxRestClient.waitMaxTransmissionTime();
  });

When(/^the access (?:plan is|plans are) received from LINX$/, async (cifFilePaths: any) => {
    const cifFiles: any = cifFilePaths.hashes();
    for (const cifFile of cifFiles) {
      const rawData: Buffer = fs.readFileSync(path.join(ProjectDirectoryUtil.testDataFolderPath(), cifFile.path));
      await linxRestClient.addAccessPlan('', rawData.toString());
    }
  });
