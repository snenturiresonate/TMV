import {browser} from 'protractor';
import {expect} from 'chai';
import * as fs from 'fs';
import * as path from 'path';
import {ProjectDirectoryUtil} from '../utils/project-directory.util';
import {DateAndTimeUtils} from '../pages/common/utilities/DateAndTimeUtils';
import {ChronoField, ChronoUnit, DateTimeFormatter, ZonedDateTime} from '@js-joda/core';
import {CucumberLog} from '../logging/cucumber-log';
import {LinxRestClient} from '../api/linx/linx-rest-client';

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

export class AccessPlanService {
  public static async processCifInputsAndSubmit(newTrainProps, plusMins = 0, minusMins = 0): Promise<any> {
    let linxRestClient: LinxRestClient;
    linxRestClient = new LinxRestClient();
    let refTrainUid;
    let refTrainDescription = newTrainProps.newTrainDescription;
    if (newTrainProps.newPlanningUid.includes('generated')) {
      refTrainUid = browser.referenceTrainUid;
    }
    else {
      expect(newTrainProps.newPlanningUid.length, 'Train UID (aka schedule ID) should be length 6').to.equal(6);
      refTrainUid = newTrainProps.newPlanningUid;
    }
    if (refTrainDescription.includes('generated')) {
      refTrainDescription = browser.referenceTrainDescription;
    }
    expect(refTrainDescription.length, 'Train Description should be of form nCnn').to.equal(4);
    const rawData: Buffer = fs.readFileSync(path.join(ProjectDirectoryUtil.testDataFolderPath(), newTrainProps.filePath));
    const initialString = rawData.toString();
    const cifLines: string[] = initialString.split(/\r?\n/, 1000);
    for (const cifLine of cifLines) {
      const rowType = cifLine.substr(0, 2);
      const thisLoc = cifLine.substr(2, 7);
      if (thisLoc.trim() === newTrainProps.refLocation) {
        const nowInCifFormat: string =
          DateAndTimeUtils.getCurrentTime().plusMinutes(plusMins).minusMinutes(minusMins).format(DateTimeFormatter.ofPattern('HHmm'));
        browser.timeAdjustMs = this.calculateTimeAdjustToNearestMinInMs
          (cifLine, nowInCifFormat, rowType + '_' + newTrainProps.refTimingType);
        break;
      }
    }
    for (let j = 0; j < cifLines.length; j++) {
      const rowType = cifLines[j].substr(0, 2);
      if ((rowType === 'BS') || (rowType === 'CR')) {
        cifLines[j] = this.adjustCIFTrainIds(cifLines[j], rowType, refTrainDescription, refTrainUid);
      }
      else {
        cifLines[j] = this.adjustCIFTimes(cifLines[j], rowType, browser.timeAdjustMs);
      }
    }
    // put it all back together and load
    const newData = cifLines.join('');
    await CucumberLog.addText(`Access Plan: ${newData}`);
    await linxRestClient.addAccessPlan('', newData);
    await linxRestClient.waitMaxTransmissionTime();
  }

  public static dealWithHDRecord(cifLine: string, dateOfExtract: string, timeOfExtract: string, extractEndDate: string): string {
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

  public static dealWithLOOrLTRecord(cifLine: string, trainStartHours, hoursVal: number): string {
    // replace positions 11-12 and 16-17
    const padToEighty = ' '.repeat(80 - cifLine.length);
    const LO1 = cifLine.substr(0, 10);
    const LO2DepWTTHours = cifLine.substr(10, 2);
    const LO2 = this.pickCorrectHoursString(LO2DepWTTHours, trainStartHours, hoursVal);
    const LO3 = cifLine.substr(12, 3);
    const LO4DepPTHours = cifLine.substr(15, 2);
    let LO4 = '00';
    const pubTime = cifLine.substr(15, 4);
    if (pubTime !== '0000') {
      LO4 = this.pickCorrectHoursString(LO4DepPTHours, trainStartHours, hoursVal);
    }
    const LO5 = cifLine.substr(17, 63);
    const LO6 = '\r\n';
    return LO1 + LO2 + LO3 + LO4 + LO5 + padToEighty + LO6;
  }

  public static dealWithLIRecord(cifLine: string, trainStartHours, hoursVal: number): string {
    // replace positions (11-12 and 16-17 and 26-27 and 30-31) or 21-22
    const LI1 = cifLine.substr(0, 10);
    const padToEighty = ' '.repeat(80 - cifLine.length);

    // case of a pass
    if (cifLine.substr(10, 2) === '  ') {
      const LI2 = cifLine.substr(10, 10);
      const LI3PassPTHours = cifLine.substr(20, 2);
      const LI3 = this.pickCorrectHoursString(LI3PassPTHours, trainStartHours, hoursVal);
      const LI4 = cifLine.substr(22, 58);
      const LI5 = '\r\n';
      return LI1 + LI2 + LI3 + LI4 + padToEighty + LI5;
    }

    // case of a stop
    else {
      const LI2ArrWTTHours = cifLine.substr(10, 2);
      const LI2 = this.pickCorrectHoursString(LI2ArrWTTHours, trainStartHours, hoursVal);
      const LI3 = cifLine.substr(12, 3);
      const LI4DepWTTHours = cifLine.substr(15, 2);
      const LI4 = this.pickCorrectHoursString(LI4DepWTTHours, trainStartHours, hoursVal);
      const LI5 = cifLine.substr(17, 8);
      const LI6ArrPTHours = cifLine.substr(25, 2);
      let LI6 = '00';
      const pubArrTime = cifLine.substr(25, 4);
      if (pubArrTime !== '0000') {
        LI6 = this.pickCorrectHoursString(LI6ArrPTHours, trainStartHours, hoursVal);
      }
      const LI7 = cifLine.substr(27, 2);
      const LI8DepPTHours = cifLine.substr(29, 2);
      let LI8 = '00';
      const pubDepTime = cifLine.substr(29, 4);
      if (pubDepTime !== '0000') {
        LI8 = this.pickCorrectHoursString(LI8DepPTHours, trainStartHours, hoursVal);
      }
      const LI9 = cifLine.substr(31, 49);
      const LI10 = '\r\n';
      return LI1 + LI2 + LI3 + LI4 + LI5 + LI6 + LI7 + LI8 + LI9 + padToEighty + LI10;
    }
  }

  private static pickCorrectHoursString(initialString: string, trainStartHours, hoursVal: number): string {
    const hoursDiff = Number(initialString) - trainStartHours;
    return String(hoursVal + hoursDiff).padStart(2, '0');
  }

  private static calculateTimeAdjustToNearestMinInMs(cifLine: string, refTimeInCifFormat: string, refRowAndTimingType: string): number {
    let timeStringLength = 4;
    if (refRowAndTimingType.includes('wtt')) {
      timeStringLength = 5;
    }
    const cifLineTimeString = cifLine.substr(cifStartChars[refRowAndTimingType], timeStringLength);
    const diffMs = this.toDateTime(cifLineTimeString).until(this.toDateTime(refTimeInCifFormat), ChronoUnit.MILLIS);
    // round ms to nearest minute
    return Math.round(diffMs / (60 * 1000)) * (60 * 1000);
  }

  private static toDateTime(cifTime: string): ZonedDateTime {
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

  public static toCIFTime(inputTime: ZonedDateTime, cifTimingType: string): string {
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

  private static adjustCIFTrainIds(cifLine: string, rowType: string, trainDesc: string, planningUid: number): string {
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

  public static adjustCIFTrainUId(cifLine: string, rowType: string, planningUid: string): string {
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


  private static adjustCIFTimes(cifLine: string, rowType: string, timeAdjustMs: number): string {
    const padToEighty = ' '.repeat(80 - cifLine.length);
    if (rowType === 'LO') {
      return cifLine.substr(0, 10)
        + this.adjustCIFTime(cifLine.substr(cifStartChars.LO_WTT_dep, 5), timeAdjustMs)
        + this.adjustCIFTime(cifLine.substr(cifStartChars.LO_GBTT_dep, 4), timeAdjustMs)
        + cifLine.substr(19, 63)
        + padToEighty + '\r\n';
    }
    else if (rowType === 'LI') {
      return cifLine.substr(0, 10)
        + this.adjustCIFTime(cifLine.substr(cifStartChars.LI_WTT_arr, 5), timeAdjustMs)
        + this.adjustCIFTime(cifLine.substr(cifStartChars.LI_WTT_dep, 5), timeAdjustMs)
        + this.adjustCIFTime(cifLine.substr(cifStartChars.LI_WTT_pass, 5), timeAdjustMs)
        + this.adjustCIFTime(cifLine.substr(cifStartChars.LI_GBTT_arr, 4), timeAdjustMs)
        + this.adjustCIFTime(cifLine.substr(cifStartChars.LI_GBTT_dep, 4), timeAdjustMs)
        + cifLine.substr(33, 49)
        + padToEighty + '\r\n';
    }
    else if (rowType === 'LT') {
      return cifLine.substr(0, 10)
        + this.adjustCIFTime(cifLine.substr(cifStartChars.LT_WTT_arr, 5), timeAdjustMs)
        + this.adjustCIFTime(cifLine.substr(cifStartChars.LT_GBTT_arr, 4), timeAdjustMs)
        + cifLine.substr(19, 63)
        + padToEighty + '\r\n';
    }
    else {
      return cifLine + padToEighty + '\r\n';
    }
  }

  private static adjustCIFTime(timeString: string, timeAdjustMs: number): string {
    // don't adjust if the timeString is essentially blank
    if ((timeString === '     ') || (timeString === '    ') || (timeString === '0000')) {
      return timeString;
    }
    else {
      const newTime = this.toDateTime(timeString).plusNanos(timeAdjustMs * 1000000);
      if (timeString.length === 5) {
        return this.toCIFTime(newTime, 'wtt');
      }
      else {
        return this.toCIFTime(newTime, 'gbtt');
      }
    }
  }

}
