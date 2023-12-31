import {Then, When} from 'cucumber';
import {expect} from 'chai';
import {TrainsListRailwayUndertakingConfigTabPageObject} from '../../pages/trains-list-config/trains.list.railway.undertaking.config.tab.page';
import {browser} from 'protractor';
import {TrainsListTableColumnsPage} from '../../pages/trains-list/trains-list.tablecolumns.page';
import {CommonActions} from '../../pages/common/ui-event-handlers/actionsAndWaits';

const trainsListRailwayUndertakingConfigPage: TrainsListRailwayUndertakingConfigTabPageObject =
  new TrainsListRailwayUndertakingConfigTabPageObject();
const trainsListTable: TrainsListTableColumnsPage = new TrainsListTableColumnsPage();

Then('the following header can be seen on the railway undertaking columns', async (configColumnNameDataTable: any) => {
  const expectedConfigColumnNames = configColumnNameDataTable.hashes();
  const actualConfigColumnNames = await trainsListRailwayUndertakingConfigPage.getTrainListConfigColumn();

  expectedConfigColumnNames.forEach((expectedConfigColumnName: any) => {
    expect(actualConfigColumnNames, `${expectedConfigColumnName.configColumnName} not found in config column names`)
      .to.contain(expectedConfigColumnName.configColumnName);
  });
});

// tslint:disable-next-line:max-line-length
Then('the following can be seen on the unselected railway undertaking config', {timeout: 2 * 20000}, async (unSelectedEntryDataTable: any) => {
  const expectedUnselectedEntries = unSelectedEntryDataTable.hashes();
  const actualUnselectedEntries = await trainsListRailwayUndertakingConfigPage.getTrainConfigUnselected();
  const actualUnselectedArrow = await trainsListRailwayUndertakingConfigPage.getConfigUnselectedArrow();
  expectedUnselectedEntries.forEach((expectedUnselectedEntry: any) => {
    expect(actualUnselectedEntries, `${expectedUnselectedEntry.unSelectedColumn} not found in unselected entries`)
      .to.contain(expectedUnselectedEntry.unSelectedColumn);
  });
  expectedUnselectedEntries.forEach((expectedUnselectedEntry: any) => {
    expect(actualUnselectedArrow, `unselected arrow was not ${expectedUnselectedEntry.arrowType}`)
      .to.contain(expectedUnselectedEntry.arrowType);
  });
});

Then('the following appear in the selected railway undertaking config', {timeout: 2 * 20000}, async (selectedEntriesDataTable: any) => {
  const expectedSelectedEntries = selectedEntriesDataTable.hashes();
  if (expectedSelectedEntries[0].selectedColumn !== '') {
    const actualSelectedEntries = await trainsListRailwayUndertakingConfigPage.getSecondElementsInSelectedGrid();
    expectedSelectedEntries.forEach((expectedSelectedEntry: any) => {
      expect(actualSelectedEntries, `${expectedSelectedEntry.selectedColumn} not found in selected entries`)
        .to.contain(expectedSelectedEntry.selectedColumn);
    });
  } else {
    const actualSelectedElementsDisplayed = await trainsListRailwayUndertakingConfigPage.selectedGridElementsDisplay();
    expect(actualSelectedElementsDisplayed, `Selected elements are displayed when shouldn't`)
      .to.equal(false);
  }
});

Then('I click on all the unselected railway undertaking entries', async () => {
  await CommonActions.waitForElementInteraction(trainsListRailwayUndertakingConfigPage.trainListConfigUnselected.last());
  await trainsListRailwayUndertakingConfigPage.trainListConfigUnselected.click();
});

Then('I click on all the selected railway undertaking entries', async () => {
  await trainsListRailwayUndertakingConfigPage.trainListConfigSelectedSecondElements.click();
});

When('I select only the following railway undertaking entries', async (table: any) => {
  const tableItems = table.hashes();
  await trainsListRailwayUndertakingConfigPage.trainListConfigSelectedSecondElements.click();
  // tslint:disable-next-line:prefer-for-of
  for (let i = 0; i < tableItems.length; i++) {
    await trainsListRailwayUndertakingConfigPage.selectTrainConfigUnselectedItem(tableItems[i].items);
  }
});

Then('I should see the trains list column TOC/FOC has only the below values', async (table: any) => {
  const tableValues = table.hashes();
  const expectedValues: any[] = [];
  // Using for-loop as Foreach seems to be populating an array of objects while a string array is required.
  // tslint:disable-next-line:prefer-for-of
  for (let i = 0; i < tableValues.length; i++) {
    expectedValues.push(tableValues[i].expectedValues);
  }
  const tocFocColumnValues: string[] = await trainsListTable.getTocValues();
  expect(tocFocColumnValues, `Expected values not found in TOC/FOC column`)
    .to.have.members(expectedValues);
});

Then('the railway undertaking tab header is displayed as {string}', async (expectedTitle: string) => {
  const actualTabTitle: string = await trainsListRailwayUndertakingConfigPage.getTocFocTabTitle();
  expect(actualTabTitle, `Tab header is not ${expectedTitle}`)
    .to.equal(expectedTitle);
});

When('I set toc filters to be {string}', async (wantedColumns: string) => {
  await trainsListRailwayUndertakingConfigPage.trainListConfigSelectedSecondElements.click();
  const userTLOperators = wantedColumns.split(',', 16).map(item => item.trim());
  for (const item of userTLOperators) {
    await trainsListRailwayUndertakingConfigPage.moveToSelectedList(item, -1);
  }
  browser.userTLOperators = wantedColumns.split(',', 16).map(item => item.substr(item.length - 3, 2));
});
