import {LogsPage} from '../../pages/logs/logs.page';

import {Then, When} from 'cucumber';
// this import looks like its not used but is by expect().to.be.closeToTime()
import * as chaiDateTime from 'chai-datetime';
import {expect} from 'chai';
import {browser} from 'protractor';
import {DateAndTimeUtils} from '../../pages/common/utilities/DateAndTimeUtils';
import * as fs from 'fs';
import {TokenUtils} from '../../pages/common/utilities/TokenUtils';
import extract = require('extract-zip');
import {DelayUtils} from '../../utils/delayUtils';

const readline = require('readline');

const logsPage: LogsPage = new LogsPage();

When(/^I navigate to the (Timetable|Movement|Signalling) log tab$/, async (tabId: string) => {
  await logsPage.openTab(tabId);
});

When(/^I search for (Timetable|Berth|Signalling) logs for (trainDescription|date|planningUid|fromBerthId|toBerthId|trainDescriber|fromToBerthId|signallingId) '(.*)'$/,
  async (tab: string, field: string, val: string) => {
    if ((val === 'generated') && (field === 'trainDescription' || field === 'planningUid')) {
      if (field === 'trainDescription') {
        val = browser.referenceTrainDescription;
      }
      if (field === 'planningUid') {
        val = browser.referenceTrainUid;
      }
    }
    await logsPage.searchSingleField(tab, field, val);
  });

When(/^I search for (Timetable|Berth|Signalling) logs with$/,
  async (tab: string, table: any) => {
    const criteria = table.hashes()[0];
    if (criteria.trainDescription === 'generated') {
      criteria.trainDescription = browser.referenceTrainDescription;
    }
    if (criteria.planningUid === 'generated') {
      criteria.planningUid = browser.referenceTrainUid;
    }
    await logsPage.searchMultipleFields(tab, criteria);
  });

When(/^I set the Timeframe checkbox for (Timetable|Berth|Signalling) as (checked|unchecked)$/, async (tab: string, value: string) => {
  await logsPage.setTimeCheckbox(tab, value);
});

When(/^I export for (Timetable|Berth|Signalling) logs with$/,
  async (tab: string, table: any) => {
    const criteria = table.hashes()[0];
    if (criteria.trainDescription === 'generated') {
      criteria.trainDescription = browser.referenceTrainDescription;
    }
    if (criteria.planningUid === 'generated') {
      criteria.planningUid = browser.referenceTrainUid;
    }
    await logsPage.exportMultipleFields(tab, criteria);
  });

Then(/the (Timetable|Movement|Signalling) tab is highlighted/, async (tab: string) => {
  const isLogTabHighlighted = await logsPage.isLogTabHighlighted(tab);
  expect(isLogTabHighlighted, `Expected ${tab} tab to be highlighted but was ${isLogTabHighlighted}`).to.equal(true);
});

Then(/the (Timetable|Movement|Signalling) view is visible/, async (tab: string) => {
  const isLogViewVisible = await logsPage.isLogViewVisible(tab);
  expect(isLogViewVisible, `Expected ${tab} view to be visible but was ${isLogViewVisible}`).to.equal(true);
});

Then('the log results table has columns in the following order', async (tabNameDataTable: any) => {
  const expectedColumnNames: any[] = tabNameDataTable.hashes();
  let actualColumnName: string;
  let i = 0;
  for (const expectedColumnName of expectedColumnNames) {
    actualColumnName = await logsPage.getLogResultsTableColumnName(i);
    expect(actualColumnName, `Expected ${expectedColumnName.colName} but was ${actualColumnName}`).to.equal(expectedColumnName.colName);
    i++;
  }
});

Then(/^the first (berth|timetable|signalling) log results are$/, async (tab: string, table: any) => {
  await compareLogResults(tab, 1, table);
});

Then(/^the (berth|timetable|signalling) log results from row (\d+) are$/, async (tab: string, start: number, table: any) => {
  await compareLogResults(tab, start, table);
});

Then(/^the movement logs (berth|timetable|signalling) tab search error message is shown (.*)$/, async (tab: string, expected: string) => {
  const actual = await logsPage.getSearchError(tab);
  expect(actual, `Expected ${expected} but was ${actual}`).to.equal(expected);

});

Then(/^the downloads folder is empty$/, async () => {
  if (!fs.existsSync(browser.params.downloads_path)) {
    fs.mkdirSync(browser.params.downloads_path, {recursive: true});
  }

  for (const filePath of fs.readdirSync(browser.params.downloads_path)) {
    fs.unlinkSync(browser.params.downloads_path + '/' + filePath);
  }
});


Then(/^allow (.*) milliseconds to pass$/, async (milliseconds: number) => {
  await DelayUtils.waitFor(milliseconds);

});

Then(/^the zip, with the name of '(.*)' and a filename of '(.*)', contains the following csv logs$/,
  async (rawZipFilename: string, rawCsvFileName: string, dataTable: any) => {
    const zipFilename: string = TokenUtils.process(rawZipFilename);
    const zipFilePAth = browser.params.downloads_path + '/' + zipFilename;

    const csvFilename = TokenUtils.process(rawCsvFileName);
    const csvFilePath = browser.params.downloads_path + '/' + csvFilename;

    expect(fs.existsSync(zipFilePAth), `File does not exist: ${zipFilePAth}`).to.equal(true);

    await extract(zipFilePAth, {dir: browser.params.downloads_path});

    const expectedCsvRows = [];
    const actualCsvRows = [];

    dataTable.rawTable.forEach(dataTableRow => {
      expectedCsvRows.push(TokenUtils.process(dataTableRow.join(',')));
    });

    const readLines = readline.createInterface({
      input: fs.createReadStream(csvFilePath),
      crlfDelay: Infinity
    });

    for await (const line of readLines) {
      actualCsvRows.push(line);
    }

    expect(actualCsvRows).to.have.length(expectedCsvRows.length);
    expect(actualCsvRows).to.have.members(expectedCsvRows);
  });

Then(/^the log results for row '(\d+)' displays '(.*)' and punctuality '(.*)'$/,
  async (row: number, trainNum: string, expectedPunctuality: string) => {
    const actualValues = await logsPage.getMovementLogResultsValuesForRow('berth', row);
    if (trainNum.includes('generated')) {
      trainNum = browser.referenceTrainDescription;
    }
    compareLogResultField(actualValues[0], trainNum);
    if (expectedPunctuality === 'null') {
      compareLogResultField(actualValues[5], '');
    }

    if (expectedPunctuality === '0') {
      const expectedTime: Date = await DateAndTimeUtils.formulateTime('00:00:00');
      const actualTime = await DateAndTimeUtils.formulateTime(actualValues[5].replace('-', ''));
      return expect(actualTime, `replay playback speed is not as expected`)
        .to.be.closeToTime(expectedTime, 60);
    }

    if (expectedPunctuality === '+' || expectedPunctuality === '-') {
      const colon = /:/gi;
      const actualPunctuality = actualValues[5].replace('+', '')
        .replace('-', '')
        .replace(colon, '');
      expect(actualValues[5], `Expected ${expectedPunctuality} but was ${actualValues[5]}`).to.contain(expectedPunctuality);
      expect(parseInt(actualPunctuality, 10), `Expected ${expectedPunctuality} but was ${actualValues[5]}`).to.greaterThan(1);
    }
  });

Then(/^there (?:is|are) (\d+) rows? returned in the log results$/, async (expectedRowCount: number) => {
  const numRows = await logsPage.getLogRowCount();
  expect(numRows, `Expected ${expectedRowCount} rows but was ${numRows}`).to.equal(expectedRowCount);
});

When('I primary click for the record for {string} schedule uid {string} from the timetable results',
  async (trainDescription: string, scheduleId: string) => {
    if (scheduleId.includes('generated')) {
      scheduleId = browser.referenceTrainUid;
    }
    await logsPage.leftClickLogResultItem(scheduleId);
  });

When(/^I open the date picker for (Timetable|Berth|Signalling) logs$/, async (tab: string) => {
    await logsPage.leftClickDatePicker();
  });

Then(/^the (.*) field for (Timetable|Berth|Signalling) is displayed$/, async (field: string, tab: string) => {
  const isDisplayed = await logsPage.isFieldPresent(tab, field);
  expect(isDisplayed, `${field} field was not displayed`).to.equal(true);
});

Then(/^the date picker for (Timetable|Berth|Signalling) is displayed$/, async (tab: string) => {
  const isDisplayed = await logsPage.isDatePickerPresent();
  expect(isDisplayed, `Date picker was not displayed`).to.equal(true);
});

Then(/^the value of the (.*) field for (Timetable|Berth|Signalling) is (.*)$/, async (field: string, tab: string, val: string) => {
  const displayedValue = await logsPage.getDisplayedValue(tab, field);
  let expectedValue = val;
  if (val === 'today') {
    expectedValue = DateAndTimeUtils.getCurrentDateTimeString('dd/MM/yyyy');
  }
  else if (val.includes('now')) {
    expectedValue = DateAndTimeUtils.parseTimeEquation(val, 'HH:mm:ss');
  }
  if (field.includes('Time')) {
    const expectedTime = await DateAndTimeUtils.formulateTime(expectedValue);
    const actualTime = await DateAndTimeUtils.formulateTime(displayedValue);
    expect(actualTime, `${displayedValue} was not close enough to ${val}`)
      .to.be.closeToTime(expectedTime, 60);
  }
  else {
    expect(displayedValue, `Expected ${expectedValue} but was ${displayedValue}`).to.equal(expectedValue);
  }
});

Then(/^the value of the date picker for (Timetable|Berth|Signalling) is (.*)$/, async (tab: string, val: string) => {
  const displayedValue = await logsPage.getDatePickerDateSelected();
  const displayedDate = Date.parse(displayedValue);
  const expectedValue = DateAndTimeUtils.convertToDesiredDateAndFormat(val, 'yyyy-MM-dd');
  const expectedDate = Date.parse(expectedValue);
  const dateDiff = expectedDate - displayedDate;
  expect(dateDiff, `Expected ${displayedValue} to be ${expectedValue}`).to.equal(0);
});

Then(/^it (is|isn't) possible to set the (Timetable|Berth|Signalling) date field to (.*) with the picker$/,
  async (option: string, tab: string, value: string) => {
    const canSetDate = await logsPage.setDateWithDropdown(value);
    if (option === 'is') {
      expect(canSetDate, `Could not set date when it should have been possible`).to.equal(true);
    } else {
      expect(canSetDate, `Could set date when it should not have been possible`).to.equal(false);
    }
  }
);

Then(/^it (is|isn't) possible to set the (Timetable|Berth|Signalling) date field to (.*) with the keyboard$/,
  async (option: string, tab: string, value: string) => {
    await logsPage.setVisibleDateField(value);
    const errorText = await logsPage.getVisibleValidationError();
    if (option === 'is') {
      expect(errorText, `Validation error was not displayed`).to.equal('');
    } else {
      expect(errorText, `Validation error was not displayed`).to.equal('* Date must be within 90 days of today');
    }
  }
);

Then(/^it (is|isn't) possible to set the (Timetable|Berth|Signalling) startTime to (.*) and endTime to (.*) with the (keyboard|spinners)$/,
  async (option: string, tab: string, startValue: string, endValue: string, inputMethod) => {
    const now = DateAndTimeUtils.getCurrentDateTime();
    const startTime = await DateAndTimeUtils.getTimeStringWithEstablishedNow(startValue, now, 'HH:mm:ss');
    const endTime = await DateAndTimeUtils.getTimeStringWithEstablishedNow(endValue, now, 'HH:mm:ss');
    if (inputMethod === 'keyboard') {
      await logsPage.setVisibleTimeField(tab, 'startTime', startTime);
      await logsPage.setVisibleTimeField(tab, 'endTime', endTime);
    }
    else {
      await logsPage.setTimeWithSpinners('startTime', startTime);
      await logsPage.setTimeWithSpinners('endTime', endTime);
    }
    const errorText = await logsPage.getVisibleValidationError();
    if (option === 'is') {
      expect(errorText, `Validation error was displayed for start ${startTime} end ${endTime}`)
        .to.equal('');
    } else {
      expect(errorText, `Validation error was not displayed for start ${startTime} end ${endTime}`)
        .to.equal('* Start date time must be before end date time');
    }
  }
);

function compareLogResultField(actual: string, expected: string): void {
  expect(actual, `Expected ${expected} but was ${actual}`).to.equal(expected);
}

async function compareLogResults(tab: string, start: number, table: any): Promise<void> {
  const expectedValueTable = table.hashes();
  let i = start;
  for (const row of expectedValueTable) {
    const actualValues = await logsPage.getMovementLogResultsValuesForRow(tab, i);
    if (tab === 'berth') {
      compareMovementLogBerthResultRow(actualValues, row);
    } else if (tab === 'timetable') {
      compareMovementLogTimetableResultRow(actualValues, row);
    } else if (tab === 'signalling') {
      compareMovementLogSignallingResultRow(actualValues, row);
    }
    i++;
  }
}

function compareMovementLogBerthResultRow(actual: string[], expected: any): void {
  compareMovementLogResultField(actual[0], expected, 'trainId');
  compareMovementLogResultField(actual[1], expected, 'fromBerth');
  compareMovementLogResultField(actual[2], expected, 'toBerth');
  compareMovementLogResultField(actual[3], expected, 'previousTrainId');
  compareMovementLogResultField(actual[6], expected, 'planningUid');
}

function compareMovementLogTimetableResultRow(actual: string[], expected: any): void {
  compareMovementLogResultField(actual[0], expected, 'trainId');
  compareMovementLogResultField(actual[1], expected, 'scheduleType');
  compareMovementLogResultField(actual[2], expected, 'planningUid');
}

function compareMovementLogSignallingResultRow(actual: string[], expected: any): void {
  compareMovementLogResultField(actual[0], expected, 'trainDescriber');
  compareMovementLogResultField(actual[1], expected, 'signallingFunctionName');
  compareMovementLogResultField(actual[2], expected, 'type');
  compareMovementLogResultField(actual[3], expected, 'signallingId');
  compareMovementLogResultField(actual[4], expected, 'state');
  compareMovementLogResultField(actual[5], expected, 'dateTime');
}

function compareMovementLogResultField(actual: string, expected: any, property: string): void {
  if (expected.hasOwnProperty(property)) {
    let expectedValue = expected[property];
    if (expectedValue === 'generated') {
      if (property === 'trainId') {
        expectedValue = browser.referenceTrainDescription;
      }
      if (property === 'planningUid') {
        expectedValue = browser.referenceTrainUid;
      }
    }
    if (property === 'dateTime') {
      const today = DateAndTimeUtils.convertToDesiredDateAndFormat('today', 'dd/MM/yyyy');
      expectedValue = expectedValue.replace('today', today);
    }
    expect(actual, `Expected ${expectedValue} but was ${actual}`).to.equal(expectedValue);
  }
}
