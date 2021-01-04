import {Then, When} from 'cucumber';
import {TrainsListPageObject} from '../../pages/trains-list/trains-list.page';
import { expect } from 'chai';

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

Then('I open timetable from the context menu', async () => {
  await trainsListPage.timeTableLink.click();
});
