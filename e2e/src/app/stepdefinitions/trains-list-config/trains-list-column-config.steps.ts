import {Then, When} from 'cucumber';
import { expect } from 'chai';
import {TrainsListColumnConfigTabPageObject} from '../../pages/trains-list-config/trains.list.column.config.tab.page';
import {browser, protractor} from 'protractor';

const trainsListColumnConfigPage: TrainsListColumnConfigTabPageObject = new TrainsListColumnConfigTabPageObject();

const mapTLColumns = new Map([
  ['Schedule', ['SCHED.']],
  ['Service', ['SERVICE']],
  ['Time', ['TIME']],
  ['Report', ['REPORT']],
  ['Punctuality', ['PUNCT.']],
  ['Origin', ['ORIGIN.', 'PLANNED', 'ACTUAL / PREDICTED']],
  ['Destination', ['DEST.', 'PLANNED', 'ACTUAL / PREDICTED']],
  ['Next location', ['NEXTLOC.']],
  ['TOC/FOC', ['TOC/FOC.']],
  ['TRUST UID', ['TRUST UID']],
  ['Schedule UID', ['SCHEDULE UID']],
  ['Cancellation Reason Code', ['CANCELLATION REASON CODE']],
  ['Cancellation Type', ['CANCELLATION TYPE']],
  ['Last Reported', ['LAST REPORTED', 'LAST REPORTED LINE', 'LAST REPORTED PLATFORM']],
  ['Train Category', ['TRAIN CATEGORY']],
  ['Train Service Code', ['TRAIN SERVICE CODE']]
]);


When('I have navigated to the {string} configuration tab', async (tabId: string) => {
  await trainsListColumnConfigPage.openTab(tabId);
});

Then('the following tabs can be seen on the configuration', async (configTabNameDataTable: any) => {
  const expectedConfigTabNames = configTabNameDataTable.hashes();
  const actualConfigTabNames = await trainsListColumnConfigPage.getTrainListConfigTab();

  expectedConfigTabNames.forEach((expectedConfigTabName: any) => {
    expect(actualConfigTabNames).to.contain(expectedConfigTabName.tabName);
  });
});

Then('the following header can be seen on the columns', async (configColumnNameDataTable: any) => {
  const expectedConfigColumnNames = configColumnNameDataTable.hashes();
  const actualConfigColumnNames = await trainsListColumnConfigPage.getTrainListConfigColumn();

  expectedConfigColumnNames.forEach((expectedConfigColumnName: any) => {
    expect(actualConfigColumnNames).to.contain(expectedConfigColumnName.configColumnName);
  });
});

Then('the following can be seen on the unselected column config', async (unSelectedEntryDataTable: any) => {
  const expectedUnselectedEntries = unSelectedEntryDataTable.hashes();
  const actualUnselectedEntries = await trainsListColumnConfigPage.getTrainConfigUnselected();
  const actualUnselectedArrow = await trainsListColumnConfigPage.getConfigUnselectedArrow();
  expectedUnselectedEntries.forEach((expectedUnselectedEntry: any) => {
    expect(actualUnselectedEntries).to.contain(expectedUnselectedEntry.unSelectedColumn);
  });
  expectedUnselectedEntries.forEach((expectedUnselectedEntry: any) => {
    expect(actualUnselectedArrow).to.contain(expectedUnselectedEntry.arrowType);
  });
});

Then('the following appear second in the selected column config', async (selectedEntriesDataTable: any) => {
  const expectedSelectedEntries = selectedEntriesDataTable.hashes();
  const actualSelectedEntries = await trainsListColumnConfigPage.getSecondElementsInSelectedGrid();

  expectedSelectedEntries.forEach((expectedSelectedEntry: any) => {
    expect(actualSelectedEntries).to.contain(expectedSelectedEntry.selectedColumn);
  });
});

Then('the following appear first in the selected column config', async (selectedEntriesDataTable: any) => {
  const expectedSelectedEntries = selectedEntriesDataTable.hashes();
  const actualSelectedEntries = await trainsListColumnConfigPage.getFirstElementsInSelectedGrid();

  expectedSelectedEntries.forEach((expectedSelectedEntry: any) => {
    expect(actualSelectedEntries).to.contain(expectedSelectedEntry.selectedColumn);
  });
});

Then('the following can be seen in the selected column config', async (selectedEntriesDataTable: any) => {
  const expectedSelectedEntries = selectedEntriesDataTable.hashes();
  const actualSelectedEntriesFirstCol = await trainsListColumnConfigPage.getFirstElementsInSelectedGrid();
  const actualSelectedEntriesSecondCol = await trainsListColumnConfigPage.getSecondElementsInSelectedGrid();
  expectedSelectedEntries.forEach((expectedSelectedEntry: any) => {
    if (expectedSelectedEntry.arrowType !== '') {
      expect(actualSelectedEntriesFirstCol).to.contain(expectedSelectedEntry.arrowType);
      expect(actualSelectedEntriesSecondCol).to.contain(expectedSelectedEntry.ColumnName);
    } else {
      expect(actualSelectedEntriesFirstCol).to.contain(expectedSelectedEntry.ColumnName);
    }
  });
});

Then('the following can be seen in the selected column config in the given order',
  {timeout: 6 * 5000}, async (selectedEntriesDataTable: any) => {
  const results: any[] = [];
  const expectedSelectedEntries = selectedEntriesDataTable.hashes();
  for (let i = 0; i < selectedEntriesDataTable.hashes().length; i++) {
    if (expectedSelectedEntries[i].arrowType !== '') {
      const actualSelectedEntriesFirstCol = await trainsListColumnConfigPage.getFirstElementInSelectedGridByIndex(i);
      const actualSelectedEntriesSecondCol = await trainsListColumnConfigPage.getSecondElementInSelectedByIndex(i);
      results.push(expect(actualSelectedEntriesFirstCol).to.contain(expectedSelectedEntries[i].arrowType));
      results.push(expect(actualSelectedEntriesSecondCol).to.contain(expectedSelectedEntries[i].ColumnName));
    } else {
      const actualSelectedEntriesFirstCol = await trainsListColumnConfigPage.getFirstElementInSelectedGridByIndex(i);
      results.push(expect(actualSelectedEntriesFirstCol).to.contain(expectedSelectedEntries[i].ColumnName));
    }
  }
  return protractor.promise.all(results);
});

Then('the unselected column entries should be empty', async () => {
  const unselectedColEntries: boolean = await trainsListColumnConfigPage.trainListConfigUnselected.isPresent();
  expect(unselectedColEntries).to.equal(false);
});

Then('I click on all the unselected column entries', async () => {
  await trainsListColumnConfigPage.trainListConfigUnselected.click();
});

Then('I click on all the selected column entries', async () => {
  await trainsListColumnConfigPage.trainListConfigSelectedSecondElements.click();
});

When('I set trains list columns to be {string}', {timeout: 15 * 1000}, async (wantedColumns: string) => {
  await trainsListColumnConfigPage.trainListConfigSelectedSecondElements.click();
  const userTLColumns = wantedColumns.split(',', 16).map(item => item.trim());
  for (let i = 0; i < userTLColumns.length; i++) {
    await trainsListColumnConfigPage.moveToSelectedList(userTLColumns[i], i);
  }
  // Store the selections, saving the actual column names that will appear in the TL using the relevant mappings from mapTLColumns
  // This includes the sub-columns for origin, destination, and last reported
  // need to flatten the array
  // used an alternative to flatMap https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/flatMap
  browser.userTLColumns = userTLColumns.reduce((acc: string[], item) => acc.concat(mapTLColumns.get(item)), []);
});

When('I select the arrow up down at position {int}', async (position: number) => {
  await trainsListColumnConfigPage.clickArrowUpDown(position);
});

When('I move {string} the selected column item {string}', async (arrowDir: string, itemName: string) => {
    await trainsListColumnConfigPage.clickArrow(arrowDir, itemName);
});

When('I select the left arrow position {int}', async (position: number) => {
  await trainsListColumnConfigPage.clickArrowLeft(position);
});

When('I select the right arrow position {int}', async (position: number) => {
  await trainsListColumnConfigPage.clickArrowRight(position);
});
