import {Given, Then, When} from 'cucumber';
import { expect } from 'chai';
import {TrainsListMiscConfigTab} from '../../pages/trains-list-config/trains.list.misc.config.tab';
import {browser} from 'protractor';

const trainsListMisc: TrainsListMiscConfigTab = new TrainsListMiscConfigTab();

Given('I set class filters to be {string}', {timeout: 15 * 1000}, async (wantedColumns: string) => {
  await trainsListMisc.clearAllButton();
  const userTLClasses = wantedColumns.split(',', 10).map(item => item.trim());
  for (const item of userTLClasses) {
    await trainsListMisc.toggleClassOn(item);
  }
  browser.userTLClasses = wantedColumns.split(',', 10).map(item => item.trim()).map(item => item.replace('Class ', ''));
});

Given('I set {string} to be {string}', async (flag: string, setting: string) => {
  if (flag === 'Ignore PD Cancels') {
    if (await trainsListMisc.getIgnoreToggleState() !== setting) {
      await trainsListMisc.clickIgnoreToggle();
    }
    browser.userTLShowCancelled = setting;
  }
  if (flag === 'Uncalled') {
    if (await trainsListMisc.getUncalledToggleState() !== setting) {
      await trainsListMisc.clickUncalledToggle();
    }
    browser.userTLShowUncalled = setting;
  }
  if (flag === 'Unmatched') {
    if (await trainsListMisc.getUnmatchedToggleState() !== setting) {
      await trainsListMisc.clickUnmatchedToggle();
    }
    browser.userTLShowUnmatched = setting;
  }
});

Given('I set Time to Appear Before to be {string}', async (setting: string) => {
  await trainsListMisc.setTimeToAppearBefore(setting);
});

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
Then('I should see the trains list configuration tabs as', async (table: any) => {
  const expectedTabs = table.hashes();
  const actualColHeader = await trainsListMisc.getTrainsListConfigTabNames();
  expectedTabs.forEach((expectedTabName: any) => {
    expect(actualColHeader).to.contain(expectedTabName.tabs);
  });
});
Then('I see the train list config tab title as {string}', async (title: string) => {
  const actualTitle: string = await trainsListMisc.getTabSectionHeader();
  expect(actualTitle).to.contain(title);
});
