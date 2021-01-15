import {Then, When} from 'cucumber';
import { expect } from 'chai';
import {TrainsListRailwayUndertakingConfigTabPageObject} from '../../pages/trains-list-config/trains.list.railway.undertaking.config.tab.page';
import {browser} from 'protractor';

const trainsListRailwayUndertakingConfigPage: TrainsListRailwayUndertakingConfigTabPageObject
  = new TrainsListRailwayUndertakingConfigTabPageObject();

Then('the following header can be seen on the railway undertaking columns', async (configColumnNameDataTable: any) => {
  const expectedConfigColumnNames = configColumnNameDataTable.hashes();
  const actualConfigColumnNames = await trainsListRailwayUndertakingConfigPage.getTrainListConfigColumn();

  expectedConfigColumnNames.forEach((expectedConfigColumnName: any) => {
    expect(actualConfigColumnNames).to.contain(expectedConfigColumnName.configColumnName);
  });
});

Then('the following can be seen on the unselected railway undertaking config', async (unSelectedEntryDataTable: any) => {
  const expectedUnselectedEntries = unSelectedEntryDataTable.hashes();
  const actualUnselectedEntries = await trainsListRailwayUndertakingConfigPage.getTrainConfigUnselected();
  const actualUnselectedArrow = await trainsListRailwayUndertakingConfigPage.getConfigUnselectedArrow();
  expectedUnselectedEntries.forEach((expectedUnselectedEntry: any) => {
    expect(actualUnselectedEntries).to.contain(expectedUnselectedEntry.unSelectedColumn);
  });
  expectedUnselectedEntries.forEach((expectedUnselectedEntry: any) => {
    expect(actualUnselectedArrow).to.contain(expectedUnselectedEntry.arrowType);
  });
});

Then('the following appear in the selected railway undertaking config', async (selectedEntriesDataTable: any) => {
  const expectedSelectedEntries = selectedEntriesDataTable.hashes();
  const actualSelectedEntries = await trainsListRailwayUndertakingConfigPage.getSecondElementsInSelectedGrid();

  expectedSelectedEntries.forEach((expectedSelectedEntry: any) => {
    expect(actualSelectedEntries).to.contain(expectedSelectedEntry.selectedColumn);
  });
});

Then('I click on all the unselected railway undertaking entries', async () => {
  await trainsListRailwayUndertakingConfigPage.trainListConfigUnselected.click();
});

Then('I click on all the selected railway undertaking entries', async () => {
  await trainsListRailwayUndertakingConfigPage.trainListConfigSelectedSecondElements.click();
});

When('I set toc filters to be {string}', async (wantedColumns: string) => {
  await trainsListRailwayUndertakingConfigPage.trainListConfigSelectedSecondElements.click();
  const userTLOperators = wantedColumns.split(',', 16).map(item => item.trim());
  for (const item of userTLOperators) {
    await trainsListRailwayUndertakingConfigPage.moveToSelectedList(item, -1);
  }
  browser.userTLOperators = wantedColumns.split(',', 16).map(item => item.substr(item.length - 3, 2));
});
