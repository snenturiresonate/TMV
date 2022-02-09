import {LogsPage} from '../../pages/logs/logs.page';

import {Then, When} from 'cucumber';
// this import looks like its not used but is by expect().to.be.closeToTime()
import * as chaiDateTime from 'chai-datetime';
import {expect} from 'chai';
import {browser} from 'protractor';
import {DateAndTimeUtils} from '../../pages/common/utilities/DateAndTimeUtils';

const logsPage: LogsPage = new LogsPage();

When(/^I navigate to the (Timetable|Movement|Signalling) log tab$/, async (tabId: string) => {
  await logsPage.openTab(tabId);
});

When(/^I search for (Timetable|Berth|Signalling) logs for (trainDescription|planningUid|fromBerthId|toBerthId|trainDescriber|fromToBerthId|signallingId) '(.*)'$/,
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

Then(/^the movement logs (berth|timetable) tab search error message is shown (.*)$/, async (tab: string, expected: string) => {
  const actual = await logsPage.getSearchError(tab);
  expect(actual, `Expected ${expected} but was ${actual}`).to.equal(expected);

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

  if (expectedPunctuality === '+' || expectedPunctuality === '-'){
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
