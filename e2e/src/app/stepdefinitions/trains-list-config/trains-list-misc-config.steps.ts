import {Given, Then, When} from 'cucumber';
import {expect} from 'chai';
import {TrainsListMiscConfigTab} from '../../pages/trains-list-config/trains.list.misc.config.tab';
import {browser, protractor} from 'protractor';
import {CheckBox} from '../../pages/common/ui-element-handlers/checkBox';

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
  expect(actualHeader, 'Misc class header is not as expected')
    .to.equal(expectedHeader);
});

Then('the following can be seen on the class table', async (miscEntryDataTable: any) => {
  const expectedMiscEntries = miscEntryDataTable.hashes();

  let index = 0;
  for (const expectedMiscEntry of expectedMiscEntries) {
    const actualMiscClass = await trainsListMisc.getTrainMiscClassName(index);
    const actualMiscToggle = await trainsListMisc.getTrainMiscClassToggle(index);
    expect(actualMiscClass, `The class table does not contain ${expectedMiscEntry.classValue}`)
      .to.contain(expectedMiscEntry.classValue);
    expect(actualMiscToggle, `The class table does not contain ${expectedMiscEntry.toggleValue}`)
      .to.contain(expectedMiscEntry.toggleValue);
    index++;
  }
});

Then('the following toggle values can be seen on the right class table', async (miscRightEntryDataTable: any) => {
  const expectedMiscRightEntries = miscRightEntryDataTable.hashes();
  const results: any[] = [];
  for (let i = 0; i < expectedMiscRightEntries.length; i++) {
    const classValue = expectedMiscRightEntries[i].classValue;
    const toggleValue = (expectedMiscRightEntries[i].toggleValue).toLowerCase();
    results.push(
      expect(await trainsListMisc.getTrainMiscClassNameRight(i), `${classValue} not found in right class table`)
        .to.contain(classValue));
    if (toggleValue === 'on' || toggleValue === 'off') {
      const expectedToggleValue = await CheckBox.convertToggleToBoolean(toggleValue);
      const miscValue: boolean = await trainsListMisc.getTrainMiscClassNameToggleValuesRight(classValue);
      results.push(
        expect(miscValue, `Toggle was not ${expectedToggleValue}`)
          .to.equal(expectedToggleValue));
    } else {
      const miscValue: string = await trainsListMisc.getTrainMiscClassNameNumberValuesRight(classValue);
      results.push(
        expect(miscValue, `Toggle did not contain ${toggleValue}`)
          .to.contain(toggleValue));
    }
  }
  return protractor.promise.all(results);
});

When('I update the following misc options', async (miscRightEntryDataTable: any) => {
  const expectedMiscRightEntries = miscRightEntryDataTable.hashes();
  const results: any[] = [];
  for (let i = 0; i < expectedMiscRightEntries.length; i++) {
    const classValue = expectedMiscRightEntries[i].classValue.toLowerCase();
    const toggleValue = (expectedMiscRightEntries[i].toggleValue).toLowerCase();
    if (toggleValue === 'on' || toggleValue === 'off') {
      results.push(await trainsListMisc.updateTrainMiscSettingToggles(classValue, toggleValue));
    } else if (classValue === 'time to remain on list') {
      results.push(await trainsListMisc.setTimeToRemain(toggleValue));
    } else if (classValue === 'appear before current time on list') {
      results.push(await trainsListMisc.setTimeToAppearBefore(toggleValue));
    } else {
      throw new Error(`Please check the class value on feature file row ${i + 1}`);
    }
  }
  return protractor.promise.all(results);
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
  expect(actualHeader, `Toggle state of Ignore PD Cancels is not as expected`)
    .to.equal(expectedHeader);
});

Then('the time to remain on list displayed as {string}', async (expectedHeader: string) => {
  const actualHeader: string = await trainsListMisc.getTimeToRemain();
  expect(actualHeader, `Time to remain is not as expected`)
    .to.equal(expectedHeader);
});
When('I click on the time to remain', async () => {
  await trainsListMisc.clickTimeToRemain();
});
Then('I should see the trains list configuration tabs as', async (table: any) => {
  const expectedTabs = table.hashes();
  const actualColHeader = await trainsListMisc.getTrainsListConfigTabNames();
  expectedTabs.forEach((expectedTabName: any) => {
    expect(actualColHeader, `Tab name ${expectedTabName.tabs} not present`)
      .to.contain(expectedTabName.tabs);
  });
});
Then('I see the train list config tab title as {string}', async (title: string) => {
  const actualTitle: string = await trainsListMisc.getTabSectionHeader();
  expect(actualTitle, `Title does not contain ${title}`)
    .to.contain(title);
});

When('the following class table updates are made', async (table: any) => {
  const tableValues = table.hashes();
  const results: any[] = [];
  for (let i = 0; i < tableValues.length; i++) {
    await trainsListMisc.updateToggleOfClassName(tableValues[i].classValue, tableValues[i].toggleValue);
  }
  return protractor.promise.all(results);
});
