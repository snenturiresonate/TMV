import { When, Then} from 'cucumber';
import {expect} from 'chai';
import {TrainsListPageObject} from '../../pages/trainslist/trainslist.page';

const trainsListPage: TrainsListPageObject = new TrainsListPageObject();


Then('The trains list table is visible', async () => {
  const isTrainsListPageVisible: boolean = await trainsListPage.isTrainsListTableVisible();
  expect(isTrainsListPageVisible).to.equal(true);
});

Then('the trains list context menu is not displayed', async () => {
  const isTrainsListContextMenuVisible: boolean = await trainsListPage.isContextMenuVisible();
  expect(isTrainsListContextMenuVisible).to.equal(false);
});

When('I invoke the context menu from train {int} on the trains list', async (itemNum: number) => {
  await trainsListPage.rightClickTrainListItem(itemNum);
});

When('I wait for the context menu to display', async () => {
  await trainsListPage.waitForContextMenu();
});

Then('I open timetable from the context menu', async () => {
  await trainsListPage.timeTableLink.click();
});
