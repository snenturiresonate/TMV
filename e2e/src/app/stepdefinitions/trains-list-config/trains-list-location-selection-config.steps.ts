import { Then, When } from 'cucumber';
import { expect } from 'chai';
import { TrainsListLocationSelectionTab } from '../../pages/trains-list-config/trains.list.location.selection.tab.page';
import {protractor} from 'protractor';
import {SelectBox} from '../../pages/common/ui-element-handlers/selectBox';
import {GeneralUtils} from '../../pages/common/utilities/generalUtils';

const trainsListLocationSelectionConfig: TrainsListLocationSelectionTab = new TrainsListLocationSelectionTab();
const countDeltaValue = 5;

Then('the location search box has value {string}', async (expectedText: string) => {
  const message: string = await trainsListLocationSelectionConfig.getLocationSearchBoxText();
  expect(message).to.equal(expectedText);
});

Then('the location auto-suggest list is hidden', async () => {
  const isDisplayed: boolean = await trainsListLocationSelectionConfig.isLocationSuggestSearchResultDisplayed();
  const isHidden: boolean = !isDisplayed;
  expect(isHidden).to.equal(true);
});
Then('the location auto-suggest list is not hidden', async () => {
  const isDisplayed: boolean = await trainsListLocationSelectionConfig.isLocationSuggestSearchResultDisplayed();
  const isHidden: boolean = !isDisplayed;
  expect(isHidden).to.equal(false);
});

Then('the location auto-suggest list has atleast {int} entries', async (count: number) => {
  const suggestSearchResults: string = await trainsListLocationSelectionConfig.getLocationSuggestSearchResults();
  expect(suggestSearchResults.length).to.closeTo(count, countDeltaValue);
});
Then('the location auto-suggest list has {int} entries', async (count: number) => {
  const suggestSearchResults: string = await trainsListLocationSelectionConfig.getLocationSuggestSearchResults();
  expect(suggestSearchResults.length).to.equal(count);
});
Then('the location auto-suggest list contains {string} at position {int}', async (expectedText: string, position: number) => {
  const actualMapNames: string = await trainsListLocationSelectionConfig.getLocationSuggestSearchResults();
  expect(actualMapNames[position - 1]).to.equal(expectedText);
});
When('I type {string} into the location search box', async (text: string) => {
  await trainsListLocationSelectionConfig.enterLocationSearchString(text);
});
Then('the location search box dropdown has value {string}', async (expectedValue: string) => {
  const actualValue: string = await trainsListLocationSelectionConfig.getLocationFilterValue();
  expect(actualValue).to.equal(expectedValue);
});
When('I click on the location filter', async () => {
  await trainsListLocationSelectionConfig.clickLocationFilter();
});

Then('the following values can be seen on the locations filter', async (locationValueDataTable: any) => {
  const expectedLocationFilterValues = locationValueDataTable.hashes();
  const actualLocationFilterValues = await trainsListLocationSelectionConfig.getLocationFilterValue();

  expectedLocationFilterValues.forEach((expectedLocationFilterValue: any) => {
    expect(actualLocationFilterValues).to.contain(expectedLocationFilterValue.locationFilter);
  });
});

Then('the following can be seen on the location order type table', async (locationEntryDataTable: any) => {
  const expectedLocationEntries = locationEntryDataTable.hashes();
  const results: any[] = [];
  const actualNoOfLocations = await trainsListLocationSelectionConfig.getLocationCount();
  // tslint:disable-next-line:prefer-for-of
  for (let i = 0; i < expectedLocationEntries.length; i++) {
    const expectedLocationName = expectedLocationEntries[i].locationNameValue;

    const stopTypeOriginate = await trainsListLocationSelectionConfig.getStopTypeCheckedState('Originate', expectedLocationName);
    const stopTypeStop = await trainsListLocationSelectionConfig.getStopTypeCheckedState('Stop', expectedLocationName);
    const stopTypePass = await trainsListLocationSelectionConfig.getStopTypeCheckedState('Pass', expectedLocationName);
    const stopTypeTerminate = await trainsListLocationSelectionConfig.getStopTypeCheckedState('Terminate', expectedLocationName);

    results.push(expect(stopTypeOriginate).to.contain(GeneralUtils.
      convertCheckboxSelectionToBoolean(expectedLocationEntries[i].Originate)));
    results.push(expect(stopTypeStop).to.contain(GeneralUtils.convertCheckboxSelectionToBoolean(expectedLocationEntries[i].Stop)));
    results.push(expect(stopTypePass).to.contain(GeneralUtils.convertCheckboxSelectionToBoolean(expectedLocationEntries[i].Pass)));
    results.push(expect(stopTypeTerminate).to.contain(GeneralUtils.
      convertCheckboxSelectionToBoolean(expectedLocationEntries[i].Terminate)));
  }
  expect(actualNoOfLocations).to.equal(expectedLocationEntries.length);
  return protractor.promise.all(results);
});

When('I click the first suggested location', async () => {
  await trainsListLocationSelectionConfig.clickLocationResult();
});

When('I cancel the location at position {int}', async (position: number) => {
  await trainsListLocationSelectionConfig.cancelLocation(position);
});

When('I uncheck the Originate checkbox', async () => {
  await trainsListLocationSelectionConfig.clickOriginateCheckbox();
});

Then('the Originate checkbox is unchecked', async () => {
  const isOriginateCheckboxSelected: boolean = await trainsListLocationSelectionConfig.isOriginateSelected();
  expect(isOriginateCheckboxSelected).to.equal(false);
});

Then('the Originate checkbox is checked', async () => {
  const isOriginateCheckboxSelected: boolean = await trainsListLocationSelectionConfig.isOriginateSelected();
  expect(isOriginateCheckboxSelected).to.equal(true);
});

Then('the locations tab header is displayed as {string}', async (expectedTitle: string) => {
  const actualTabTitle: string = await trainsListLocationSelectionConfig.getLocationTabTitle();
  expect(actualTabTitle).to.equal(expectedTitle);
});

Then('I should see the following stop types in the given order within each location', async (table: any) => {
  const results: any[] = [];
  const tableValues = table.hashes();
  const locationRowCount = await trainsListLocationSelectionConfig.getLocationTableRowCount();
  for (let i = 0; i < locationRowCount; i++) {
      for (let elmOrder = 0; elmOrder < tableValues.length; elmOrder++) {
        const actualResult: string = await trainsListLocationSelectionConfig.getStopTypeOfRow(i, elmOrder);
        results.push(expect(actualResult).to.equal(tableValues[elmOrder].stopTypes));
      }
  }
  return protractor.promise.all(results);
});

When('I choose the location filter as {string}', async (option: string) => {
  await SelectBox.selectByVisibleText(trainsListLocationSelectionConfig.locationFilterValue, option);
});

When('I move {string} the location {string}', async (arrowDir: string, option: string) => {
  await trainsListLocationSelectionConfig.moveElementOnePosition(arrowDir, option);
});

When('I remove the location {string}', async (option: string) => {
  await trainsListLocationSelectionConfig.removeLocation(option);
});

When('I remove the following locations', async (table: any) => {
  const tableValues = table.hashes();
  // tslint:disable-next-line:prefer-for-of
  for (let i = 0; i < tableValues.length; i++) {
    await trainsListLocationSelectionConfig.removeLocation(tableValues[i].locations);
  }
});

Then('I should not see the location re-ordering arrows', async () => {
  return expect(await trainsListLocationSelectionConfig.locationTableArrowsDisplay()).to.not.include(true);
});

When('I have only the following locations and stop types selected', async (table: any) => {
  const tableValues = table.hashes();
  await trainsListLocationSelectionConfig.removeAllLocations();
  for (let i = 0; i < tableValues.length; i++) {
    const locationName = tableValues[i].locationNameValue;
    await trainsListLocationSelectionConfig.enterLocationSearchString(locationName);
    await trainsListLocationSelectionConfig.clickLocationResult();
    await trainsListLocationSelectionConfig.setStopTypeCheckedState('Originate', locationName, tableValues[i].Originate);
    await trainsListLocationSelectionConfig.setStopTypeCheckedState('Stop', locationName, tableValues[i].Stop);
    await trainsListLocationSelectionConfig.setStopTypeCheckedState('Pass', locationName, tableValues[i].Pass);
    await trainsListLocationSelectionConfig.setStopTypeCheckedState('Terminate', locationName, tableValues[i].Terminate);
  }
});
