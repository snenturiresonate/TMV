import {Then, When} from 'cucumber';
import {TrainsListPageObject} from '../../pages/trains-list/trains-list.page';
import { expect } from 'chai';
import {browser, protractor} from 'protractor';
import {CssColorConverterService} from '../../services/css-color-converter.service';
import {DateAndTimeUtils} from '../../pages/common/utilities/DateAndTimeUtils';
import {AppPage} from '../../pages/app.po';
import {CommonActions} from '../../pages/common/ui-event-handlers/actionsAndWaits';

const page: AppPage = new AppPage();
const trainsListPage: TrainsListPageObject = new TrainsListPageObject();
const defaultClasses = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
const defaultOperators = ['HW', 'HY', 'HZ', 'HV', 'HU', 'HT', 'HS', 'HR', 'HQ'];
const defaultScheduleTypes = ['LTP', 'STP', 'VSTP', 'VAR', 'CAN', 'VSTP VAR', 'VSTP CAN', ''];
const defaultScheduleTypesNoCancelled = ['LTP', 'STP', 'VSTP', 'VSTP VAR', ''];
const defaultColumns = ['SCHED.', 'SERVICE', 'TIME', 'REPORT', 'PUNCT.', 'ORIGIN',
  'PLANNED', 'ACTUAL / PREDICT', 'DEST.', 'PLANNED', 'ACTUAL / PREDICT', 'NEXT LOC.', 'OPERATOR'];

// tests also assuming the following - but not actively used at the moment
// const defaultShowCancelled = 'on';
// const defaultShowUnmatched = 'on';
// const defaultShowUncalled = 'off';

const colTextColourHex = {
  green: '#28a745',
  orange: '#ffc107'
};

const mapTLColIds = new Map([
  ['SCHED.', 'schedule-type'],
  ['SERVICE', 'train-description'],
  ['TIME', 'time'],
  ['REPORT', 'report'],
  ['PUNCT.', 'punctuality'],
  ['ORIGIN', 'origin-location-id'],
  ['ORIGIN>PLANNED', 'origin-current-time'],
  ['ORIGIN>ACTUAL / PREDICT', 'origin-actual-predicted-time'],
  ['DEST.', 'destination-location-id'],
  ['DEST.>PLANNED', 'destination-current-time'],
  ['DEST.>ACTUAL / PREDICT', 'destination-actual-predicted-time'],
  ['NEXT LOC.', 'next-location'],
  ['OPERATOR', 'operator'],
  ['TRUST ID', 'trust-uid'],
  ['SCHED. UID', 'schedule-uid'],
  ['REASON', 'modification-reason'],
  ['CANCEL', 'modification-type'],
  ['PUB. ARR.', 'working-destination-arrival-time'],
  ['PUB. DEPT.', 'working-origin-departure-time'],
  ['NEXT TIME', 'next-time'],
  ['LINE', 'last-reported-line'],
  ['PLT.', 'last-reported-platform'],
  ['CATEGORY', 'train-category'],
  ['SERVICE CODE', 'train-service-code']
]);

enum DefaultTrainsListIndicationColours {
  changeOfOrigin = '#cccc00',
  changeOfIdentity = '#ccff66',
  cancellation = '#00ff00',
  reinstatement = '#00ffff',
  offRoute = '#cc6600',
  nextReportOverdue = '#ffff00',
  originCalled = '#9999ff',
  originDepartureOverdue = '#339966',
  noIndicationBlack = '#000000',
  noIndicationGrey = '#2c2c2c',
  someOtherBlack = '#140e2b'
}

When('I invoke the context menu from train {int} on the trains list', async (itemNum: number) => {
  await trainsListPage.rightClickTrainListItem(itemNum);
});

When('I invoke the context menu from train {string} on the trains list', async (scheduleNum: string) => {
  const itemNum = await trainsListPage.getRowForSchedule(scheduleNum) + 1;
  expect(itemNum, `Train ${scheduleNum} does not appear on the trains list`).to.not.equal(0);
  await trainsListPage.rightClickTrainListItem(itemNum);
});

Then('Train description {string} is visible on the trains list', async (scheduleNum: string) => {
  const itemNum = await trainsListPage.getRowForSchedule(scheduleNum) + 1;
  expect(itemNum, `Train ${scheduleNum} does not appear on the trains list`).to.not.equal(0);
});

Then('train description {string} is visible on the trains list with schedule type {string}',
  async (trainDescription: string, scheduleType: string) => {
    const scheduleFound: boolean = await trainsListPage.trainDescriptionHasScheduleType(trainDescription, scheduleType);
    expect(scheduleFound, `${scheduleType} train ${trainDescription} does not appear on the trains list`).to.equal(true);
});

Then('train {string} with schedule id {string} for today is visible on the trains list',
  async (serviceId: string, scheduleId: string) => {
    const todaysScheduleString = scheduleId + ':' + DateAndTimeUtils.convertToDesiredDateAndFormat('today', 'yyyy-MM-dd');
    const isScheduleVisible: boolean = await trainsListPage.isTrainVisible(serviceId, todaysScheduleString);
    expect(isScheduleVisible).to.equal(true);
  });

Then('train description {string} disappears from the trains list', async (trainDescription: string) => {
  const hasDisappeared: boolean = await trainsListPage.trainDescriptionHasDisappeared(trainDescription);
  expect(hasDisappeared).to.equal(true);
});

Then('train description {string} with schedule type {string} disappears from the trains list',
  async (trainDescription: string, scheduleType: string) => {
    const hasDisappeared: boolean = await trainsListPage.trainDescriptionWithScheduleTypeHasDisappeared(trainDescription, scheduleType);
    expect(hasDisappeared).to.equal(true);
});

When('I wait for the trains list context menu to display', async () => {
  await trainsListPage.waitForContextMenu();
});

Then('The trains list table is visible', async () => {
  const isTrainsListPageVisible: boolean = await trainsListPage.isTrainsListTableVisible();
  expect(isTrainsListPageVisible).to.equal(true);
});

When('the service {string} is not active', async (serviceId: string) => {
  const isScheduleVisible: boolean = await trainsListPage.isScheduleVisible(serviceId);
  expect(isScheduleVisible).to.equal(false);
});

When('the following service is not displayed on the trains list', async (table: any) => {
  const tableValues = table.hashes()[0];
  const serviceId = tableValues.trainId;
  const trainUID = tableValues.trainUId;
  await page.navigateTo('/tmv/trains-list');
  const isTrainVisible: boolean = await trainsListPage.isTrainVisible(serviceId, trainUID);
  expect(isTrainVisible, `Service ${serviceId} with trainUId ${trainUID} is displayed`).to.equal(false);
});

When('the following service is displayed on the trains list', async (table: any) => {
  const tableValues = table.hashes()[0];
  const serviceId = tableValues.trainId;
  const trainUID = tableValues.trainUId;
  await page.navigateTo('/tmv/trains-list');
  const isTrainVisible: boolean = await trainsListPage.isTrainVisible(serviceId, trainUID);
  expect(isTrainVisible, `Service ${serviceId} with trainUId ${trainUID} is not displayed`).to.equal(true);
});

When('the service {string} is active', async (serviceId: string) => {
  const isScheduleVisible: boolean = await trainsListPage.isScheduleVisible(serviceId);
  expect(isScheduleVisible).to.equal(true);
});

When(/^I click on (?:Unmatch|Match) in the context menu$/, async () => {
  await trainsListPage.openManualMatch();
});

Then('I open timetable from the context menu', async () => {
  await trainsListPage.timeTableLink.click();
});

Then('the open timetable option is present on the context menu', async () => {
  await trainsListPage.timeTableLink.isPresent();
});

Then('the trains list context menu is displayed', async () => {
  const isTrainsContextMenuVisible: boolean = await trainsListPage.isTrainsListContextMenuDisplayed();
  expect(isTrainsContextMenuVisible, 'Trains list menu is not visible').to.equal(true);
});

Then('the trains list context menu contains {string} on line {int}', async (expectedText: string, rowNum: number) => {
  const actualContextMenuItem: string = await trainsListPage.getTrainsListContextMenuItem(rowNum);
  expect(actualContextMenuItem, 'Trains list menu item is not as expected').to.contain(expectedText);
});

Then('the trains list context menu has {string} on line {int}', async (expectedText: string, rowNum: number) => {
  const actualContextMenuItem: string = await trainsListPage.getTrainsListContextMenuItem(rowNum);
  expect(actualContextMenuItem, 'Trains list menu item is not as expected').to.equal(expectedText);
});

Then('the trains list context menu contains the {word} {string} of train {int} on line {int}',
  async (occurence: string, colName: string, trainRow: number, menuRow: number) => {
  const actualTrainsListEntryRowValues: string[] = await trainsListPage.getTrainsListValuesForRow(trainRow);
  const cols = await trainsListPage.getTrainsListCols();
  const colsNoArrows = cols.map(item => item.replace('arrow_downward', '')
    .replace('arrow_upward', ''));
  let testColIndex = colsNoArrows.indexOf(colName);
  if (occurence === 'second') {
    testColIndex = cols.indexOf(colName, testColIndex + 1);
  }
  let expectedValue: string = actualTrainsListEntryRowValues[testColIndex];
  if (colName === 'TOC/FOC') {
    expectedValue = '(' + expectedValue + ')';
  }
  if (expectedValue === '+0m') {
    expectedValue = 'On time';
  }
  const actualContextMenuItem = await trainsListPage.getTrainsListContextMenuItem(menuRow);

  expect(actualContextMenuItem).to.contain(expectedValue);
});

Then(/^the (Matched|Unmatched) version of the trains list context menu is displayed$/, async (matchType: string) => {
  let expected1;
  let expected2;
  if (matchType === 'Matched') {
    expected1 = 'Open timetable';
    expected2 = 'Find train';

  } else {
    expected1 = 'No timetable';
    expected2 = 'Match';
  }
  const contextMenuItem1: string = await trainsListPage.getTrainsListContextMenuItem(2);
  const contextMenuItem2: string = await trainsListPage.getTrainsListContextMenuItem(3);
  expect(contextMenuItem1, `Context menu does not imply ${matchType} state - does not contain ${expected1}`)
    .to.contain(expected1);
  expect(contextMenuItem2, `Context menu does not imply ${matchType} state - does not contain ${expected2}`)
    .to.contain(expected2);
});


Then('the number of predicted times for train {int} tallies', async (trainRow: number) => {
  const numberPredictedTimesInTrainRow: number = await trainsListPage.getCountOfPredictedTimesForRow(trainRow);
  const numberPredictedTimesInContextMenu: number = await trainsListPage.getCountOfPredictedTimesForContext();

  expect(numberPredictedTimesInContextMenu).to.equal(numberPredictedTimesInTrainRow);
});

Then('I can click away to clear the menu', async () => {
  await trainsListPage.trainsListItems.click();
});

Then('the service is displayed in the trains list with the following indication', async (trainsListRowsDataTable: any) => {
  const trainsListRowValues: any[] = trainsListRowsDataTable.hashes();
  let actualRowColFill: string;
  let actualTrainDescriptionFill: string;

  for (const expectedTrainsListRow of trainsListRowValues) {
    if (expectedTrainsListRow.rowType === 'unmatched step' || expectedTrainsListRow.rowType === 'unmatched interpose') {
      const rowNum = await trainsListPage.getRowForSchedule(expectedTrainsListRow.rowId);
      actualRowColFill = await CommonActions.waitForFunctionalStringResult(
        trainsListPage.getTrainsListRowFillForRow, rowNum, expectedTrainsListRow.rowColFill);
      actualTrainDescriptionFill = await trainsListPage.getTrainsListTrainDescriptionEntryColFillForRow(rowNum);
    }
    else {
      const rowIdentifier = expectedTrainsListRow.trainUID + ':' + DateAndTimeUtils.convertToDesiredDateAndFormat('today', 'yyyy-MM-dd');
      actualRowColFill = await CommonActions.waitForFunctionalStringResult(
        trainsListPage.getTrainsListRowFillForSchedule, rowIdentifier, expectedTrainsListRow.rowColFill);
      actualTrainDescriptionFill = await trainsListPage.getTrainsListTrainDescriptionEntryColFillForSchedule(rowIdentifier);
    }

    expect(actualRowColFill, 'Row colour is not as expected').to.equal(expectedTrainsListRow.rowColFill);
    expect(actualTrainDescriptionFill, 'Train Description colour is not as expected').to.equal(expectedTrainsListRow.trainDescriptionFill);
  }
});

Then('the service is displayed in the trains list with the following row colour', async (trainsListRowsDataTable: any) => {
  const trainsListRowValues: any[] = trainsListRowsDataTable.hashes();
  let actualRowColFill: string;

  for (const expectedTrainsListRow of trainsListRowValues) {
    let rowIdentifier = '';
    if (expectedTrainsListRow.rowType === 'unmatched step' || expectedTrainsListRow.rowType === 'unmatched interpose') {
      rowIdentifier = expectedTrainsListRow.rowId;
      const rowNum = await trainsListPage.getRowForSchedule(expectedTrainsListRow.rowId);
      actualRowColFill = await CommonActions.waitForFunctionalStringResult(
        trainsListPage.getTrainsListRowFillForRow, rowNum, expectedTrainsListRow.rowColour);
    }
    else {
      rowIdentifier = expectedTrainsListRow.trainUID + ':' + DateAndTimeUtils.convertToDesiredDateAndFormat('today', 'yyyy-MM-dd');
      actualRowColFill = await CommonActions.waitForFunctionalStringResult(
        trainsListPage.getTrainsListRowFillForSchedule, rowIdentifier, expectedTrainsListRow.rowColour);
    }

    expect(actualRowColFill, 'Row colour is not as expected').to.equal(expectedTrainsListRow.rowColour);
  }
});

Then('I should see the trains list columns as', {timeout: 2 * 20000}, async (table: any) => {
  const expectedColHeaders: string[] = table.hashes().map((Value: any) => {
    return Value.header;
  });
  const columnsAsExpected = await trainsListPage.columnsAre(expectedColHeaders);
  expect(columnsAsExpected, 'Columns are not as expected').to.equal(true);
});

When('I see all the available trains list columns with defaults first', {timeout: 2 * 20000}, async () => {
  const allCols = ['SCHED.', 'SERVICE', 'TIME', 'REPORT', 'PUNCT.', 'ORIGIN', 'PLANNED', 'ACTUAL / PREDICT',
    'DEST.', 'PLANNED', 'ACTUAL / PREDICT', 'NEXT LOC.', 'OPERATOR', 'TRUST ID', 'SCHED. UID', 'REASON', 'CANCEL', 'PUB. ARR.',
     'PUB. DEPT.', 'NEXT TIME', 'LINE', 'PLT.', 'CATEGORY', 'SERVICE CODE'];

  const columnsAsExpected = await trainsListPage.columnsAre(allCols);

  expect(columnsAsExpected, 'Columns are not as expected').to.equal(true);
});

Then('I should see the trains list columns as in the below order', async (table: any) => {
  const results: any[] = [];
  const expectedColHeaders = table.hashes();
  const expectedNoOfCols = table.hashes().length;
  const actualNoOfCols = await trainsListPage.getTrainsListColHeaderCount();
  for (let i = 0; i < table.hashes.length; i++) {
    const actualColHeader = await trainsListPage.getTrainsListColHeaderByIndex(i);
    results.push(expect(actualColHeader).to.contain(expectedColHeaders[i].header));
  }
  results.push(expect(actualNoOfCols).to.equal(expectedNoOfCols));
  return protractor.promise.all(results);
});

Then(/^the columns have a sort \(primary and secondary\)$/, async () => {
  const primColText = await trainsListPage.getPrimarySortColumnNameAndArrow();
  const secColText = await trainsListPage.getSecondarySortColumnNameAndArrow();
  expect(primColText.length).greaterThan(0);
  expect(secColText.length).greaterThan(0);
});

When(/^I select (.*) text$/, async (colName: string) => {
  await trainsListPage.clickHeaderText(colName);
});

When(/^I select (.*) arrow$/, async (colName: string) => {
  await trainsListPage.clickHeaderArrow(colName);
});

Then(/^(.*) is the (primary|secondary) sort column with (green|orange) text and an? (downward|upward) arrow$/,
  async (expectedColText: string, primOrSec: string, expectedTextColour: string, expectedArrowDirection: string) => {
    let expectedColName: string;
    let actualColText: string;
    const colStructure = expectedColText.split('>', 2).map(item => item.trim());
    if (colStructure.length === 1) {
      expectedColName = colStructure[0];
    }
    else {
      expectedColName = colStructure[1];
    }
    let actualColTextRgbColour: string;
    if (primOrSec === 'primary') {
      actualColText = await trainsListPage.getPrimarySortColumnNameAndArrow();
      actualColTextRgbColour = await trainsListPage.primarySortCol.getCssValue('color');

    }
    else if (primOrSec === 'secondary') {
      actualColText = await trainsListPage.getSecondarySortColumnNameAndArrow();
      actualColTextRgbColour = await trainsListPage.secondarySortCol.getCssValue('color');
    }

    const actualColTextHexColour = CssColorConverterService.rgb2Hex(actualColTextRgbColour);
    const actualColArrowDirection = actualColText.substring(actualColText.indexOf('arrow')).replace('arrow_', '');
    const actualColName = actualColText.replace('arrow_' + actualColArrowDirection, '');
    expect(actualColName).to.equal(expectedColName);
    expect(actualColArrowDirection).to.equal(expectedArrowDirection);
    expect(actualColTextHexColour).to.equal(colTextColourHex[expectedTextColour]);
  });

Then(/^the entries in (.*) column are in (ascending|descending) order$/, async (colName: string, sortDirection: string) => {
  const colIdentifier = mapTLColIds.get(colName);
  const colValues = await trainsListPage.getTrainsListValuesForColumn(colIdentifier);
  for (let i = 0; i < colValues.length; i++) {
    checkOrdering(colValues[i], colValues[i + 1], colName, sortDirection);
  }
});

Then(/^the entries in (.*) column are in (ascending|descending) order within each value in (.*) column$/,
  async (secColName: string, sortDirection: string, primColName: string) => {
    const colIdentifierPrim = mapTLColIds.get(primColName);
    const colIdentifierSec = mapTLColIds.get(secColName);
    const colValuesPrim = await trainsListPage.getTrainsListValuesForColumn(colIdentifierPrim);
    const colValuesSec = await trainsListPage.getTrainsListValuesForColumn(colIdentifierSec);
    for (let i = 0; i < colValuesPrim.length; i++) {
      if (colValuesPrim[i] === colValuesPrim[i + 1]) {
        checkOrdering(colValuesSec[i], colValuesSec[i + 1], secColName, sortDirection);
      }
    }
  });

Then(/^all grid entries for (.*) train (.*) are blank except for (.*)$/, async (sCase: string, trainIdentifier: string, cols: string) => {
  const expectedColsWithValues = cols.split(',', 10).map(item => item.trim());
  const visibleColumns = await trainsListPage.getTrainsListCols();
  const visibleColsNoArrows = visibleColumns.map(item => item.replace('arrow_downward', '')
    .replace('arrow_upward', ''));

  let rowIdentifier: string;
  let actualValsForSchedule: string[];

  if ((sCase === 'unmatched step') || (sCase === 'unmatched interpose')) {
    actualValsForSchedule = await trainsListPage.getTrainsListValuesForFirstScheduleWithDescription(trainIdentifier);
  }
  else {
    rowIdentifier = trainIdentifier + ':' + DateAndTimeUtils.convertToDesiredDateAndFormat('today', 'yyyy-MM-dd');
    actualValsForSchedule = await trainsListPage.getTrainsListValuesForSchedule(rowIdentifier);
  }
  for (let colNum = 0; colNum < visibleColsNoArrows.length; colNum++) {
    const col = visibleColsNoArrows[colNum];
    if (expectedColsWithValues.indexOf(col) === -1) {
      expect(actualValsForSchedule[colNum].length, `Entry for column ${col} for train ${rowIdentifier} is not empty`).equals(0);
    }
    else {
      expect(actualValsForSchedule[colNum].length, `Entry for column ${col} for train ${rowIdentifier} is empty`).not.equals(0);
    }
  }
});

Then(/^the (.*) entry for (.*) train (.*) is (.*)$/, async (column: string, sCase: string, trainId: string, expectedVal: string) => {
  let rowIdentifier: string;
  let actualValForSchedule: string;
  const colIdentifier = mapTLColIds.get(column);
  if ((sCase === 'unmatched step') || (sCase === 'unmatched interpose')) {
    actualValForSchedule = await trainsListPage.getTrainsListValueForColumnAndUnmatchedTrain(colIdentifier, trainId);
  }
  else {
    rowIdentifier = trainId + ':' + DateAndTimeUtils.convertToDesiredDateAndFormat('today', 'yyyy-MM-dd');
    actualValForSchedule = await trainsListPage.getTrainsListValueForColumnAndSchedule(colIdentifier, rowIdentifier);
  }
  expect(actualValForSchedule, `Entry for column ${column} for train ${rowIdentifier} is incorrect`).to.equal(expectedVal);
});

When('I navigate to train list configuration', async () => {
  await trainsListPage.clickTrainListSettingsBtn();
});

When('I perform a secondary click on a random service using the mouse', async () => {
  const tableRowCount = await trainsListPage.trainsListItems.count();
  const randomIndex = Math.floor(Math.random() * tableRowCount);
  await trainsListPage.rightClickTrainListItem(randomIndex);
});

Then('The {word} trains list columns are displayed in order', async (filterType: string) => {
  let expectedTrainsListColumns = defaultColumns;
  if (filterType === 'configured') {
    expectedTrainsListColumns = browser.userTLColumns;
  }
  const numColumns = expectedTrainsListColumns.length;
  const actualTrainsListCols: string[] = await trainsListPage.getTrainsListCols();
  for (let col = 0; col < numColumns; col++) {
    const actualColName: string = actualTrainsListCols[col]
      .replace('arrow_downward', '')
      .replace('arrow_upward', '');
    expect(actualColName).to.equal(expectedTrainsListColumns[col].toUpperCase());
  }
});

Then('there are train entries present on the trains list', async () => {
  const actualTrainsListRows = await trainsListPage.trainsListItems;
  expect(actualTrainsListRows.length).greaterThan(0);
});

Then('A selection of services are shown which match the {word} filters and settings', async (filterType: string) => {
  // get what actual data is being displayed on page 1
  const actualTLScheduleTypeValues: string[] = await trainsListPage.getTrainsListValuesForColumn('schedule-type');
  const uniqueActualTLScheduleTypeValues = [...new Set(actualTLScheduleTypeValues)];
  const actualTLOperatorValues: string[] = await trainsListPage.getTrainsListValuesForColumn('operator');
  const uniqueActualTLOperatorValues = [...new Set(actualTLOperatorValues)];
  const actualTLServiceValues: string[] = await trainsListPage.getTrainsListValuesForColumn('train-description');
  const actualTLClassValues: string[] = actualTLServiceValues.map((value: string) => value.charAt(0));
  const uniqueActualTLClassValues = [...new Set(actualTLClassValues)];
  const actualTLIndicationColoursRGB: string[] = await trainsListPage.getTrainsListIndicationColoursRgb();
  const actualTLIndicationColoursHex: string[] = actualTLIndicationColoursRGB.map((val) => CssColorConverterService.rgb2Hex(val));
  const uniqueActualTLIndicationColoursHex = [...new Set(actualTLIndicationColoursHex)];
  let expectedScheduleTypes = defaultScheduleTypes;
  let expectedOperators = defaultOperators;
  let expectedClasses = defaultClasses;

  if (filterType === 'configured') {
    expectedOperators = browser.userTLOperators;
    expectedClasses = browser.userTLClasses;
  }

  if (browser.userTLShowCancelled === 'off') {
    expectedScheduleTypes = defaultScheduleTypesNoCancelled;
  }
  // check the set of observed values falls within those expected given the filters and settings
  expect(actualTLServiceValues.length).greaterThan(1);
  expect(uniqueActualTLScheduleTypeValues.every(val => expectedScheduleTypes.includes(val))).to.equal(true);
  expect(uniqueActualTLOperatorValues.every(val => expectedOperators.includes(val))).to.equal(true);
  expect(uniqueActualTLClassValues.every(val => expectedClasses.includes(val))).to.equal(true);
  expect(uniqueActualTLIndicationColoursHex.every(val =>
    Object.values(DefaultTrainsListIndicationColours).includes(val as DefaultTrainsListIndicationColours))).to.equal(true);
});

Then('{string} are {word} displayed', async (expectedTrainDescriptions: string, isDisplayed: string) => {
  const actualTLServiceValues: string[] = await trainsListPage.getTrainsListValuesForColumn('train-description');
  const expectedTLServiceValues = expectedTrainDescriptions.split(',', 10).map(item => item.trim());

  if (isDisplayed === 'not') {
      for (const item of expectedTLServiceValues) {
        expect(actualTLServiceValues).not.contains(item);
    }
  }
  else {
    for (const item of expectedTLServiceValues) {
      expect(actualTLServiceValues).contains(item);
    }

  }
});

Then('I should see the trains list table to only display train description {string}', async (expectedTrainDescription: string) => {
  const actualTrainDescriptionsArray: string[] = await trainsListPage.getTrainsListValuesForColumn('train-description');
  actualTrainDescriptionsArray.forEach(trainDescriber => {
    expect(trainDescriber, `Unexpected train describer ${trainDescriber} seen`).to.equal(expectedTrainDescription);
  });
});

Then('I should see the trains list table to only display the following trains', async (expectedTrainDescriptionTable: any) => {
  const expectedTrainDescriptionValues = expectedTrainDescriptionTable.hashes();
  const expectedTrainDescriptionArray: string[] = [];
  for (const i in expectedTrainDescriptionValues) {
    expectedTrainDescriptionArray.push(expectedTrainDescriptionValues[i].trainDescription);
  }
  const actualTrainDescriptionsArray: string[] = await trainsListPage.getTrainsListValuesForColumn('train-description');
  expect(actualTrainDescriptionsArray).to.include.all.members(expectedTrainDescriptionArray);

});

Then('I should see the trains list table to display the following trains', async (expectedTrainDescriptionTable: any) => {
  const expectedTrainDescriptionValues = expectedTrainDescriptionTable.hashes();
  const expectedTrainDescriptionArray: string[] = [];
  for (const i in expectedTrainDescriptionValues) {
    expectedTrainDescriptionArray.push(expectedTrainDescriptionValues[i].trainDescription);
  }
  const actualTrainDescriptionsArray: string[] = await trainsListPage.getTrainsListValuesForColumn('train-description');
  expect(actualTrainDescriptionsArray).to.include.members(expectedTrainDescriptionArray);

});

Then('I should see the trains list table to not display the following trains', async (expectedTrainDescriptionTable: any) => {
  const expectedTrainDescriptionValues = expectedTrainDescriptionTable.hashes();
  const expectedTrainDescriptionArray: string[] = [];
  for (const i in expectedTrainDescriptionValues) {
    expectedTrainDescriptionArray.push(expectedTrainDescriptionValues[i].trainDescription);
  }
  const actualTrainDescriptionsArray: string[] = await trainsListPage.getTrainsListValuesForColumn('train-description');
  expect(actualTrainDescriptionsArray).to.not.include(expectedTrainDescriptionArray);

});

When('I remove all trains from the trains list', async () => {
  await trainsListPage.removeAllTrainsFromTrainsList();
});

function checkOrdering(thisString: string, nextString: string, colName: string, direction: string): void {

  let orderCheck = thisString.localeCompare(nextString);
  if (colName.endsWith('PREDICT')) {
    const thisStringTrimmed = thisString.replace('(', '').replace(')', '');
    const nextStringTrimmed = nextString.replace('(', '').replace(')', '');
    orderCheck = thisStringTrimmed.localeCompare(nextStringTrimmed);
  }
  else if (colName === 'PUNCT.') {
    const thisVal = convertPunctTextToSec(thisString);
    const nextVal = convertPunctTextToSec(nextString);
    orderCheck = thisVal - nextVal;
  }
  if (direction === 'descending') {
    expect(orderCheck).to.be.greaterThan(-1, 'expected ' + thisString + ' to be greater than or equal to ' + nextString);
  }
  else  {
    expect(orderCheck).to.be.lessThan(1, 'expected ' + thisString + ' to be less than or equal to ' + nextString);
  }
}

function convertPunctTextToSec(punctualityString: string): number {
  let punctualityStringMinutes = '0';
  let punctualityStringSeconds = '0';
  if (punctualityString.includes('m')) {
    punctualityStringMinutes = punctualityString.substr(1, punctualityString.indexOf('m'));
    if (punctualityString.includes('s')) {
      punctualityStringSeconds = punctualityString.substr(punctualityString.indexOf('m') + 2,
        punctualityString.length - punctualityString.indexOf('m') - 3);
    }
  }
  else if (punctualityString.includes('s')) {
    punctualityStringSeconds = punctualityString.substr(1, punctualityString.length - 2);
  }
  const punctualitySeconds = (60 * parseFloat(punctualityStringMinutes)) + parseFloat(punctualityStringSeconds);
  if (punctualityString[0] === '+') {
    return punctualitySeconds;
  }
  else {
    return 0 - punctualitySeconds;
  }
}


