import {Then, When} from 'cucumber';
import {TrainsListPageObject} from '../../pages/trains-list/trains-list.page';
import { expect } from 'chai';
import {protractor} from 'protractor';

const trainsListPage: TrainsListPageObject = new TrainsListPageObject();


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

Then('the service is displayed in the trains list with the following indication', async (trainsListRowsDataTable: any) => {
  const trainsListRowValues: any[] = trainsListRowsDataTable.hashes();

  for (const expectedTrainsListRow of trainsListRowValues) {
    const actualRowColFill: string = await trainsListPage.getTrainsListRowColFill(expectedTrainsListRow.rowId);
    const actualTrainDescriptionFill: string = await trainsListPage.getTrainsListTrainDescriptionEntryColFill(expectedTrainsListRow.rowId);

    expect(actualRowColFill).to.equal(expectedTrainsListRow.rowColFill);
    expect(actualTrainDescriptionFill).to.equal(expectedTrainsListRow.trainDescriptionFill);
  }
});
