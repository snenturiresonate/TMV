import {LogsPage} from '../../pages/logs/logs.page';
import {Then, When} from 'cucumber';
import {expect} from 'chai';
import {browser} from 'protractor';

const logsPage: LogsPage = new LogsPage();

When(/^I navigate to the (Timetable|Berth|S-Class|Latch|Signal) log tab$/, async (tabId: string) => {
  await logsPage.openTab(tabId);
});

When(/^I search for (Timetable|Berth|S-Class|Latch|Signal) logs for (trainDescription|planningUid|fromBerthId|toBerthId|trainDescriber|fromToBerthId|displayCode|latchSignalId) '(.*)'$/,
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

When(/^I search for (Timetable|Berth|S-Class|Latch|Signal) logs with$/,
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

Then(/^the first movement log (berth|timetable) results are$/, async (tab: string, table: any) => {
  const expectedValueTable = table.hashes();
  let i = 1;
  for (const row of expectedValueTable) {
    const actualValues = await logsPage.getMovementLogResultsValuesForRow(tab, i);
    if (tab === 'berth') {
      compareMovementLogBerthResultRow(actualValues, row);
    } else if (tab === 'timetable') {
      compareMovementLogTimetableResultRow(actualValues, row);
    }
    i++;
  }
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
    compareLogResultField(actualValues[6], '');
  }

  if (expectedPunctuality === '0') {
    compareLogResultField(actualValues[6], '00:00:00');
  }

  if (expectedPunctuality === '+' || expectedPunctuality === '-'){
    const colon = /:/gi;
    const actualPunctuality = actualValues[6].replace('+', '')
      .replace('-', '')
      .replace(colon, '');
    expect(actualValues[6], `Expected ${expectedPunctuality} but was ${actualValues[6]}`).to.contain(expectedPunctuality);
    expect(parseInt(actualPunctuality, 10), `Expected ${expectedPunctuality} but was ${actualValues[6]}`).to.greaterThan(1);
  }
});

function compareLogResultField(actual: string, expected: string): void {
  expect(actual, `Expected ${expected} but was ${actual}`).to.equal(expected);
}

function compareMovementLogBerthResultRow(actual: string[], expected: any): void {
  compareMovementLogResultField(actual[0], expected, 'trainId');
  compareMovementLogResultField(actual[1], expected, 'fromBerth');
  compareMovementLogResultField(actual[2], expected, 'toBerth');
  compareMovementLogResultField(actual[3], expected, 'previousTrainId');
  compareMovementLogResultField(actual[7], expected, 'planningUid');
}

function compareMovementLogTimetableResultRow(actual: string[], expected: any): void {
  compareMovementLogResultField(actual[0], expected, 'trainId');
  compareMovementLogResultField(actual[1], expected, 'scheduleType');
  compareMovementLogResultField(actual[2], expected, 'planningUid');
}

function compareMovementLogResultField(actual: any, expected: any, property: string): void {
  if (expected.hasOwnProperty(property)) {
    const expectedValue = expected[property];
    expect(actual, `Expected ${expectedValue} but was ${actual}`).to.equal(expectedValue);
  }
}
