import {Before, When} from 'cucumber';
import {LinxRestClient} from '../api/linx/linx-rest-client';
import {AppPage} from '../pages/app.po';
import * as fs from 'fs';
import {AccessPlanRequest} from '../../../../src/app/api/linx/models/access-plan-request';
import {ProjectDirectoryUtil} from '../utils/project-directory.util';
import * as path from 'path';
import {browser} from 'protractor';
import {expect} from 'chai';
import {DateAndTimeUtils} from '../pages/common/utilities/DateAndTimeUtils';
import {CucumberLog} from '../logging/cucumber-log';
import {ChronoField, ChronoUnit, DateTimeFormatter, ZonedDateTime} from '@js-joda/core';

let page: AppPage;
let linxRestClient: LinxRestClient;

const cifStartChars = {
  LO_WTT_dep: 10,
  LO_GBTT_dep: 15,
  LI_WTT_arr: 10,
  LI_WTT_dep: 15,
  LI_WTT_pass: 20,
  LI_GBTT_arr: 25,
  LI_GBTT_dep: 29,
  LT_WTT_arr: 10,
  LT_GBTT_arr: 15
};

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
        cifLines[i] = dealWithHDRecord(cifLines[i], dateOfExtract, timeOfExtract, endDateOfExtract);
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
        cifLines[i] = dealWithLOOrLTRecord(cifLines[i], trainWTTStartHours, setHours);
      }
      else if (cifLines[i].indexOf('LI') === 0) {
        cifLines[i] = dealWithLIRecord(cifLines[i], trainWTTStartHours, setHours);
      }
      else if (cifLines[i].indexOf('LT') === 0) {
        cifLines[i] = dealWithLOOrLTRecord(cifLines[i], trainWTTStartHours, setHours);
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
    await processCifInputs(inputs);
});

When (/^the train in CIF file below is updated accordingly so time at the reference point is now \+ '?(.*)'? minutes?, and then received from LINX$/,
  async (plusMins: string, inputs: any) => {
    await processCifInputs(inputs, parseInt(plusMins, 10));
  });

When ('the train in CIF file below is updated accordingly so time at the reference point is now - {string} minutes, and then received from LINX',
  async (minusMins: string, inputs: any) => {
    await processCifInputs(inputs, 0, parseInt(minusMins, 10));
  });

async function processCifInputs(cifInputs, plusMins = 0, minusMins = 0): Promise<any> {
  const newTrainProps: any = cifInputs.hashes()[0];
  let refTrainUid;
  expect(newTrainProps.newTrainDescription.length, 'Train Description should be of form nCnn').to.equal(4);
  if (newTrainProps.newPlanningUid === 'generated') {
    refTrainUid = browser.referenceTrainUid;
  }
  else {
    expect(newTrainProps.newPlanningUid.length, 'Train UID (aka schedule ID) should be length 6').to.equal(6);
    refTrainUid = newTrainProps.newPlanningUid;
  }
  const rawData: Buffer = fs.readFileSync(path.join(ProjectDirectoryUtil.testDataFolderPath(), newTrainProps.filePath));
  const initialString = rawData.toString();
  const cifLines: string[] = initialString.split(/\r?\n/, 1000);
  for (const cifLine of cifLines) {
    const rowType = cifLine.substr(0, 2);
    const thisLoc = cifLine.substr(2, 7);
    if (thisLoc.trim() === newTrainProps.refLocation) {
      const nowInCifFormat: string =
        DateAndTimeUtils.getCurrentTime().plusMinutes(plusMins).minusMinutes(minusMins).format(DateTimeFormatter.ofPattern('HHmm'));
      browser.timeAdjustMs = calculateTimeAdjustToNearestMinInMs(cifLine, nowInCifFormat, rowType + '_' + newTrainProps.refTimingType);
      break;
    }
  }
  for (let j = 0; j < cifLines.length; j++) {
    const rowType = cifLines[j].substr(0, 2);
    if ((rowType === 'BS') || (rowType === 'CR')) {
      cifLines[j] = adjustCIFTrainIds(cifLines[j], rowType, newTrainProps.newTrainDescription, refTrainUid);
    }
    else {
      cifLines[j] = adjustCIFTimes(cifLines[j], rowType, browser.timeAdjustMs);
    }
  }
  // put it all back together and load
  const newData = cifLines.join('');
  await CucumberLog.addText(`Access Plan: ${newData}`);
  await linxRestClient.addAccessPlan('', newData);
  await linxRestClient.waitMaxTransmissionTime();
}

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
      cifLines[i] = adjustCIFTrainUId(cifLines[i], rowType, browser.referenceTrainUid);
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

function dealWithHDRecord(cifLine: string, dateOfExtract: string, timeOfExtract: string, extractEndDate: string): string {
  // replace positions 22-28 for date of extract in ddmmyy
  // replace positions 28-32 for time of extract in hhmm
  const padToEighty = ' '.repeat(80 - cifLine.length);
  const HD = cifLine.substr(0, 2);
  const fileMainframeId = cifLine.substr(2, 20);
  const DOE = cifLine.substr(22, 6);
  const newDOE = cifLine.replace(DOE, dateOfExtract).substr(22, 6);
  const TOE = cifLine.substr(28, 4);
  const newTOE = cifLine.replace(TOE, timeOfExtract).substr(28, 4);
  const fileRefs = cifLine.substr(32, 16);
  const userExtractStartDate = cifLine.substr(48, 6);
  const newUserExtractStartDate = cifLine.replace(userExtractStartDate, dateOfExtract).substr(48, 6);
  const userExtractEndDate = cifLine.substr(54, 6);
  const newUserExtractEndDate = cifLine.replace(userExtractEndDate, extractEndDate).substr(54, 6);
  // tslint:disable-next-line:max-line-length
  return HD + fileMainframeId + newDOE + newTOE + fileRefs + newUserExtractStartDate + newUserExtractEndDate + padToEighty;
}

function dealWithLOOrLTRecord(cifLine: string, trainStartHours, hoursVal: number): string {
  // replace positions 11-12 and 16-17
  const padToEighty = ' '.repeat(80 - cifLine.length);
  const LO1 = cifLine.substr(0, 10);
  const LO2DepWTTHours = cifLine.substr(10, 2);
  const LO2 = pickCorrectHoursString(LO2DepWTTHours, trainStartHours, hoursVal);
  const LO3 = cifLine.substr(12, 3);
  const LO4DepPTHours = cifLine.substr(15, 2);
  let LO4 = '00';
  const pubTime = cifLine.substr(15, 4);
  if (pubTime !== '0000') {
    LO4 = pickCorrectHoursString(LO4DepPTHours, trainStartHours, hoursVal);
  }
  const LO5 = cifLine.substr(17, 63);
  const LO6 = '\r\n';
  return LO1 + LO2 + LO3 + LO4 + LO5 + padToEighty + LO6;
}

function dealWithLIRecord(cifLine: string, trainStartHours, hoursVal: number): string {
  // replace positions (11-12 and 16-17 and 26-27 and 30-31) or 21-22
  const LI1 = cifLine.substr(0, 10);
  const padToEighty = ' '.repeat(80 - cifLine.length);

  // case of a pass
  if (cifLine.substr(10, 2) === '  ') {
    const LI2 = cifLine.substr(10, 10);
    const LI3PassPTHours = cifLine.substr(20, 2);
    const LI3 = pickCorrectHoursString(LI3PassPTHours, trainStartHours, hoursVal);
    const LI4 = cifLine.substr(22, 58);
    const LI5 = '\r\n';
    return LI1 + LI2 + LI3 + LI4 + padToEighty + LI5;
    }

  // case of a stop
  else {
    const LI2ArrWTTHours = cifLine.substr(10, 2);
    const LI2 = pickCorrectHoursString(LI2ArrWTTHours, trainStartHours, hoursVal);
    const LI3 = cifLine.substr(12, 3);
    const LI4DepWTTHours = cifLine.substr(15, 2);
    const LI4 = pickCorrectHoursString(LI4DepWTTHours, trainStartHours, hoursVal);
    const LI5 = cifLine.substr(17, 8);
    const LI6ArrPTHours = cifLine.substr(25, 2);
    let LI6 = '00';
    const pubArrTime = cifLine.substr(25, 4);
    if (pubArrTime !== '0000') {
      LI6 = pickCorrectHoursString(LI6ArrPTHours, trainStartHours, hoursVal);
    }
    const LI7 = cifLine.substr(27, 2);
    const LI8DepPTHours = cifLine.substr(29, 2);
    let LI8 = '00';
    const pubDepTime = cifLine.substr(29, 4);
    if (pubDepTime !== '0000') {
      LI8 = pickCorrectHoursString(LI8DepPTHours, trainStartHours, hoursVal);
    }
    const LI9 = cifLine.substr(31, 49);
    const LI10 = '\r\n';
    return LI1 + LI2 + LI3 + LI4 + LI5 + LI6 + LI7 + LI8 + LI9 + padToEighty + LI10;
  }
}

function pickCorrectHoursString(initialString: string, trainStartHours, hoursVal: number): string {
  const hoursDiff = Number(initialString) - trainStartHours;
  return String(hoursVal + hoursDiff).padStart(2, '0');
}

function calculateTimeAdjustToNearestMinInMs(cifLine: string, refTimeInCifFormat: string, refRowAndTimingType: string): number {
  let timeStringLength = 4;
  if (refRowAndTimingType.includes('wtt')) {
    timeStringLength = 5;
  }
  const cifLineTimeString = cifLine.substr(cifStartChars[refRowAndTimingType], timeStringLength);
  const diffMs = toDateTime(cifLineTimeString).until(toDateTime(refTimeInCifFormat), ChronoUnit.MILLIS);
  // round ms to nearest minute
  return Math.round(diffMs / (60 * 1000)) * (60 * 1000);
}

function toDateTime(cifTime: string): ZonedDateTime {
  const thisDateTime = DateAndTimeUtils.getCurrentTime();
  let cifHourStr = cifTime.substr(0, 2);
  let cifMinsStr = cifTime.substr(2, 2);
  let cifSecs = 0;
  if (cifHourStr.substr(0, 1) === '0') {
    cifHourStr = cifHourStr.substr(1, 1);
  }
  if (cifMinsStr.substr(0, 1) === '0') {
    cifMinsStr = cifMinsStr.substr(1, 1);
  }
  if (cifTime.length === 5 && cifTime.substr(4, 1) === 'H') {
    cifSecs = 30;
  }
  return thisDateTime.withHour(cifHourStr).withMinute(cifMinsStr).withSecond(cifSecs);
}

function toCIFTime(inputTime: ZonedDateTime, cifTimingType: string): string {
  let secString = '';
  if (cifTimingType === 'wtt') {
    if (inputTime.get(ChronoField.SECOND_OF_MINUTE) >= 30) {
      secString = 'H';
    }
    else {
      secString = ' ';
    }
  }
  return inputTime.get(ChronoField.HOUR_OF_DAY).toString().padStart(2, '0') +
    inputTime.get(ChronoField.MINUTE_OF_HOUR).toString().padStart(2, '0') + secString;
}

function adjustCIFTrainIds(cifLine: string, rowType: string, trainDesc: string, planningUid: number): string {
  const padToEighty = ' '.repeat(80 - cifLine.length);
  if (rowType === 'BS') {
    return cifLine.substr(0, 3)
      + planningUid
      + cifLine.substr(9, 23)
      + trainDesc
      + cifLine.substr(36, 46)
      + padToEighty + '\r\n';
  } else if (rowType === 'CR') {
    return cifLine.substr(0, 12)
      + trainDesc
      + cifLine.substr(16, 66)
      + padToEighty + '\r\n';
  }
}

function adjustCIFTrainUId(cifLine: string, rowType: string, planningUid: string): string {
  const padToEighty = ' '.repeat(80 - cifLine.length);
  if (rowType === 'BS') {
    return cifLine.substr(0, 3)
      + planningUid
      + cifLine.substr(9, 73)
      + padToEighty + '\r\n';
  }
  else {
    return cifLine + padToEighty + '\r\n';
  }
}


function adjustCIFTimes(cifLine: string, rowType: string, timeAdjustMs: number): string {
  const padToEighty = ' '.repeat(80 - cifLine.length);
  if (rowType === 'LO') {
    return cifLine.substr(0, 10)
      + adjustCIFTime(cifLine.substr(cifStartChars.LO_WTT_dep, 5), timeAdjustMs)
      + adjustCIFTime(cifLine.substr(cifStartChars.LO_GBTT_dep, 4), timeAdjustMs)
      + cifLine.substr(19, 63)
      + padToEighty + '\r\n';
  }
  else if (rowType === 'LI') {
    return cifLine.substr(0, 10)
      + adjustCIFTime(cifLine.substr(cifStartChars.LI_WTT_arr, 5), timeAdjustMs)
      + adjustCIFTime(cifLine.substr(cifStartChars.LI_WTT_dep, 5), timeAdjustMs)
      + adjustCIFTime(cifLine.substr(cifStartChars.LI_WTT_pass, 5), timeAdjustMs)
      + adjustCIFTime(cifLine.substr(cifStartChars.LI_GBTT_arr, 4), timeAdjustMs)
      + adjustCIFTime(cifLine.substr(cifStartChars.LI_GBTT_dep, 4), timeAdjustMs)
      + cifLine.substr(33, 49)
      + padToEighty + '\r\n';
  }
  else if (rowType === 'LT') {
    return cifLine.substr(0, 10)
      + adjustCIFTime(cifLine.substr(cifStartChars.LT_WTT_arr, 5), timeAdjustMs)
      + adjustCIFTime(cifLine.substr(cifStartChars.LT_GBTT_arr, 4), timeAdjustMs)
      + cifLine.substr(19, 63)
      + padToEighty + '\r\n';
  }
  else {
    return cifLine + padToEighty + '\r\n';
  }
}

function adjustCIFTime(timeString: string, timeAdjustMs: number): string {
  // don't adjust if the timeString is essentially blank
  if ((timeString === '     ') || (timeString === '    ') || (timeString === '0000')) {
    return timeString;
  }
  else {
    const newTime = toDateTime(timeString).plusNanos(timeAdjustMs * 1000000);
    if (timeString.length === 5) {
      return toCIFTime(newTime, 'wtt');
    }
    else {
      return toCIFTime(newTime, 'gbtt');
    }
  }
}
