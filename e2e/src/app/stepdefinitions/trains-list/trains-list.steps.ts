import {Then, When} from 'cucumber';
import {TrainsListPageObject} from '../../pages/trains-list/trains-list.page';
import { expect } from 'chai';

const trainsListPage: TrainsListPageObject = new TrainsListPageObject();

enum DefaultTrainsListColumnIndexes {
  schedule,
  service,
  time,
  report,
  punctuality,
  originLoc,
  originTimeCurrentPlan,
  originTimePredicted,
  destLoc,
  destTimeCurrentPlan,
  destTimePredicted,
  nextLoc,
  tocFoc
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

When('I increase the trains list pagination page number', async () => {
  await trainsListPage.increaseTrainsListPageNumber();
});

When('I decrease the trains list pagination page number', async () => {
  await trainsListPage.decreaseTrainsListPageNumber();
});

Then('The active page is page {int}', async (pageNumber: number) => {
  const isVisible = await trainsListPage.isPaginationControlActive(pageNumber);

  expect(isVisible).to.equal(true);
});

When('the service {string} is not active', async (serviceId: string) => {
  const isScheduleVisible: boolean = await trainsListPage.isScheduleVisible(serviceId);
  expect(isScheduleVisible).to.equal(false);
});

When('the service {string} is active', async (serviceId: string) => {
  const isScheduleVisible: boolean = await trainsListPage.isScheduleVisible(serviceId);
  expect(isScheduleVisible).to.equal(true);
});

Then('The trains list columns and values for train {string} are displayed in the following order',
  async (serviceId: string, trainsListColumnsAndValues: any) => {
    const expectedTrainsListColsAndValues: any[] = trainsListColumnsAndValues.hashes();
    const actualTrainsListCols: string[] = await trainsListPage.getTrainsListCols();
    const actualTrainsListEntryColValues: string[] = await trainsListPage.getTrainsListEntryColValues(serviceId);
    for (const test of expectedTrainsListColsAndValues) {
      const actualColName: string = actualTrainsListCols[test.colOrder - 1]
        .replace('arrow_downward', '')
        .replace('arrow_upward', '');
      expect(actualColName).to.equal(test.colName.toUpperCase());
      expect(actualTrainsListEntryColValues[test.colOrder - 1]).to.equal(test.specificValue);
    }
  });

Then('the trains list context menu is displayed', async () => {
  const isTrainsListContextMenuVisible: boolean = await trainsListPage.isContextMenuVisible();
  expect(isTrainsListContextMenuVisible).to.equal(true);
});

Then('the trains list context menu is not displayed', async () => {
  const isTrainsListContextMenuVisible: boolean = await trainsListPage.isContextMenuVisible();
  expect(isTrainsListContextMenuVisible).to.equal(false);
});

Then('the context menu contains {string} on line {int}', async (expectedText: string, rowNum: number) => {
  const actualContextMenuItem: string = await trainsListPage.getTrainsListContextMenuItem(rowNum);
  expect(actualContextMenuItem).to.contain(expectedText);
});

Then('the context menu contains the {word} of train {int} on line {int}', async (colName: string, trainRow: number, menuRow: number) => {
  const actualTrainsListEntryRowValues: string[] = await trainsListPage.getScheduleValuesForRow(trainRow);
  const testColIndex: DefaultTrainsListColumnIndexes = DefaultTrainsListColumnIndexes[colName];
  let expectedValue: string = actualTrainsListEntryRowValues[testColIndex];
  if (colName === 'tocFoc') {
    expectedValue = '(' + expectedValue + ')';
  }
  const actualContextMenuItem = await trainsListPage.getTrainsListContextMenuItem(menuRow);

  expect(actualContextMenuItem).to.contain(expectedValue);
});

Then('the number of predicted times for train {int} tallies', async (trainRow: number) => {
  const numberPredictedTimesInTrainRow: number = await trainsListPage.getCountOfPredictedTimesForRow(trainRow);
  const numberPredictedTimesInContextMenu: number = await trainsListPage.getCountOfPredictedTimesForContext();

  expect(numberPredictedTimesInContextMenu).to.equal(numberPredictedTimesInTrainRow);
});

Then('I can click away to clear the menu', async () => {
  await trainsListPage.trainsListItems.click();
});

Then('Filters section is displayed as {string}', async (expectedFilter: string) => {
  const actualFilter: string = await trainsListPage.getFilterValue();
  expect(actualFilter).to.equal(expectedFilter);
});

Then('the Train List criteria is hidden', async () => {
  const isDisplayed: boolean = await trainsListPage.isTrainListCriteriaDisplayed();
  const isHidden: boolean = !isDisplayed;
  expect(isHidden).to.equal(true);
});

Then('the Train List criteria is displayed', async () => {
  const isDisplayed: boolean = await trainsListPage.isTrainListCriteriaDisplayed();
  expect(isDisplayed).to.equal(true);
});

Then('The Misc Selection Criteria {string} field is displayed as {string}',
  async (miscCssFieldName: string, expectedFieldValue: string) => {
    const fieldValue: string = await trainsListPage.getMiscSelectionCriteriaFieldText(miscCssFieldName);
    expect(fieldValue).to.equal(expectedFieldValue);
  });

When('the Filters Applied is clicked', async () => {
  await trainsListPage.clickFilterIcon();
});

Then('Train List User Preference is displayed as {string}', async (expectedTrainPrefValue: string) => {
  const actualTrainPrefValue: string = await trainsListPage.getTrainUserPrefValue();
  expect(actualTrainPrefValue).to.equal(expectedTrainPrefValue);
});

Then('Train List Service filter is displayed as {string}', async (expectedTrainServiceValue: string) => {
  const actualTrainServiceValue: string = await trainsListPage.getTrainServiceValue();
  expect(actualTrainServiceValue).to.equal(expectedTrainServiceValue);
});

Then('Train List Location filter is displayed as {string}', async (expectedTrainLocationValue: string) => {
  const actualTrainLocationValue: string = await trainsListPage.getTrainLocationValue();
  expect(actualTrainLocationValue).to.equal(expectedTrainLocationValue);
});

Then('the following details can be seen for the location', async (locationEntryDataTable: any) => {
  const expectedLocationEntries = locationEntryDataTable.hashes();
  const actualLocationNames = await trainsListPage.getTrainLocationName();
  const actualStopTypes = await trainsListPage.getTrainLocationStops();

  expectedLocationEntries.forEach((expectedLocationEntry: any) => {
    expect(actualLocationNames).to.contain(expectedLocationEntry.locationName);
  });

  expectedLocationEntries.forEach((expectedLocationEntry: any) => {
    expect(actualStopTypes).to.contain(expectedLocationEntry.stopType);
  });
});

Then('the service entry values are displayed as {string}', async (expectedTrainServiceValue: string) => {
  const actualTrainServiceValue: string = await trainsListPage.getServiceEntity();
  expect(actualTrainServiceValue).to.contain(expectedTrainServiceValue);
});

Then('the first reference entity is displayed as {string}', async (expectedTrainPrefContentValue: string) => {
  const actualTrainPrefContentValue: string = await trainsListPage.getFirstReferenceEntity();
  expect(actualTrainPrefContentValue).to.contain(expectedTrainPrefContentValue);
});

Then('the second reference entity is displayed as {string}', async (expectedTrainNextPrefValue: string) => {
  const actualTrainNextPrefValue: string = await trainsListPage.getSecondReferenceEntity();
  expect(actualTrainNextPrefValue).to.contain(expectedTrainNextPrefValue);
});

Then('the third reference entity is displayed as {string}', async (expectedTrainLastPrefValue: string) => {
  const actualTrainLastPrefValue: string = await trainsListPage.getThirdReferenceEntity();
  expect(actualTrainLastPrefValue).to.contain(expectedTrainLastPrefValue);
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

