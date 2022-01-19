import {LogsPage} from '../../pages/logs/logs.page';
import {Then, When} from 'cucumber';
import {expect} from 'chai';
import {browser} from 'protractor';

const logsPage: LogsPage = new LogsPage();

When(/^I navigate to the (Timetable|Berth|S-Class|Latch|Signal) log tab$/, async (tabId: string) => {
  await logsPage.openTab(tabId);
});

When(/^I search for (Timetable|Berth|S-Class|Latch|Signal) logs for (trainDescription|planningUid|fromBerthId|toBerthId|trainDescriber|berthId|displayCode|latchSignalId) '(.*)'$/,
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

Then(/^the log results for row '(\d+)' are$/, async (row: number, table: any) => {
  const expectedValues = table.hashes()[0];
  const actualValues = await logsPage.getLogResultsValuesForRow(row);

  compareLogResultField(actualValues[0], expectedValues.trainId);
  compareLogResultField(actualValues[1], expectedValues.fromBerth);
  compareLogResultField(actualValues[2], expectedValues.toBerth);
  compareLogResultField(actualValues[3], expectedValues.previousTrainId);
});

Then(/^the log results for row '(\d+)' displays '(.*)' and punctuality '(.*)'$/,  async (row: number, trainNum: string, expectedPunctuality: string) => {
  const actualValues = await logsPage.getLogResultsValuesForRow(row);
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
    const colon = /\:/gi;
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
