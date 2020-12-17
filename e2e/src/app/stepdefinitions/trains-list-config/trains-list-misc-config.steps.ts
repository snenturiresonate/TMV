import {Then, When} from 'cucumber';
import { expect } from 'chai';
import {TrainsListMiscConfigTab} from '../../pages/trains-list-config/trains.list.misc.config.tab';

const trainsListMisc: TrainsListMiscConfigTab = new TrainsListMiscConfigTab();

Then('the misc class header is displayed as {string}', async (expectedHeader: string) => {
  const actualHeader: string = await trainsListMisc.getTrainMiscClassHeader();
  expect(actualHeader).to.equal(expectedHeader);
});

Then('the following can be seen on the class table', async (miscEntryDataTable: any) => {
  const expectedMiscEntries = miscEntryDataTable.hashes();

  let index = 0;
  for (const expectedMiscEntry of expectedMiscEntries) {
    const actualMiscClass = await trainsListMisc.getTrainMiscClassName(index);
    const actualMiscToggle = await trainsListMisc.getTrainMiscClassToggle(index);
    expect(actualMiscClass).to.contain(expectedMiscEntry.classValue);
    expect(actualMiscToggle).to.contain(expectedMiscEntry.toggleValue);
    index++;
  }
});

Then('the following can be seen on the right class table', async (miscRightEntryDataTable: any) => {
  const expectedMiscRightEntries = miscRightEntryDataTable.hashes();
  const actualMiscRightClass = await trainsListMisc.getTrainMiscClassNameRight();
  expectedMiscRightEntries.forEach((expectedMiscRightEntry: any) => {
    expect(actualMiscRightClass).to.contain(expectedMiscRightEntry.classValue);
  });
});

When('I click on the Select All button', async () => {
  await trainsListMisc.selectAllButton();
});

When('I click on the Clear All button', async () => {
  await trainsListMisc.clearAllButton();
});

When('I toggle on the Ignore PD cancels switch', async () => {
  await trainsListMisc.clickIgnoreToggle();
});

Then('the toggle state of Ignore PD cancels is {string}', async (expectedHeader: string) => {
  const actualHeader: string = await trainsListMisc.getIgnoreToggleState();
  expect(actualHeader).to.equal(expectedHeader);
});

Then('the time to remain on list displayed as {string}', async (expectedHeader: string) => {
  const actualHeader: string = await trainsListMisc.getTimeToRemain();
  expect(actualHeader).to.equal(expectedHeader);
});
When('I click on the time to remain', async () => {
  await trainsListMisc.clickTimeToRemain();
});
