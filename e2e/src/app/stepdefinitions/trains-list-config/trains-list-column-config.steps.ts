import {Then, When} from 'cucumber';
import { expect } from 'chai';
import {TrainsListColumnConfigTabPageObject} from '../../pages/trains-list-config/trains.list.column.config.tab.page';
import {protractor} from 'protractor';

const trainsListColumnConfigPage: TrainsListColumnConfigTabPageObject = new TrainsListColumnConfigTabPageObject();

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

Then('the following can be seen in the selected column config in the given order', {timeout: 6 * 5000}, async (selectedEntriesDataTable: any) => {
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
