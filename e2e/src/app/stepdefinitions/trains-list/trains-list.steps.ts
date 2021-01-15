import {Then, When} from 'cucumber';
import {TrainsListPageObject} from '../../pages/trains-list/trains-list.page';
import { expect } from 'chai';
import {browser, protractor} from 'protractor';
import {CssColorConverterService} from '../../services/css-color-converter.service';

const trainsListPage: TrainsListPageObject = new TrainsListPageObject();
const defaultClasses = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
const defaultOperators = ['HW', 'HY', 'HZ', 'HV', 'HU', 'HT', 'HS', 'HR', 'HQ'];
const defaultScheduleTypes = ['LTP', 'STP', 'VSTP', 'VAR', 'CAN', 'VSTP VAR', 'VSTP CAN', ''];
const defaultScheduleTypesNoCancelled = ['LTP', 'STP', 'VSTP', 'VSTP VAR', ''];
const defaultColumns = ['Sched.', 'Service', 'time', 'Report', 'Punct.', 'Origin',
  'Planned', 'Actual / Predict', 'Dest.', 'Planned', 'Actual / Predict', 'Nextloc.', 'TOC/FOC'];

// tests also assuming the following - but not actively used at the moment
// const defaultShowCancelled = 'on';
// const defaultShowUnmatched = 'on';
// const defaultShowUncalled = 'off';

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

When('I wait for the context menu to display', async () => {
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

When('the service {string} is active', async (serviceId: string) => {
  const isScheduleVisible: boolean = await trainsListPage.isScheduleVisible(serviceId);
  expect(isScheduleVisible).to.equal(true);
});

Then('I open timetable from the context menu', async () => {
  await trainsListPage.timeTableLink.click();
});

Then('the trains list context menu is displayed', async () => {
  const isTrainsContextMenuVisible: boolean = await trainsListPage.isTrainsListContextMenuDisplayed();
  expect(isTrainsContextMenuVisible).to.equal(true);
});

Then('I can click away to clear the menu', async () => {
  await trainsListPage.trainsListItems.click();
});

Then('the service is displayed in the trains list with the following indication', async (trainsListRowsDataTable: any) => {
  const trainsListRowValues: any[] = trainsListRowsDataTable.hashes();

  for (const expectedTrainsListRow of trainsListRowValues) {
    const actualRowColFill: string = await trainsListPage.getTrainsListRowColFill(expectedTrainsListRow.rowId);
    const actualTrainDescriptionFill: string = await trainsListPage.getTrainsListTrainDescriptionEntryColFill(expectedTrainsListRow.rowId);

    expect(actualRowColFill).to.equal(expectedTrainsListRow.rowColFill);
    expect(actualTrainDescriptionFill).to.equal(expectedTrainsListRow.trainDescriptionFill);
  }
});

Then('I should see the trains list columns as', async (table: any) => {
  const expectedColHeaders = table.hashes();
  const expectedNoOfCols = table.hashes().length;
  const actualColHeader = await trainsListPage.getTrainsListColHeaders();
  const actualNoOfCols = await trainsListPage.getTrainsListColHeaderCount();
  expectedColHeaders.forEach((expectedColHeaderName: any) => {
    expect(actualColHeader).to.contain(expectedColHeaderName.header);
  });
  expect(actualNoOfCols).to.equal(expectedNoOfCols);
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

When('I navigate to train list configuration', async () => {
  await trainsListPage.clickTrainListSettingsBtn();
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
    // for (let i = 0; i < expectedTLServiceValues.length; i++) {
    //   expect(actualTLServiceValues).not.contains(expectedTLServiceValues[i]);
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
