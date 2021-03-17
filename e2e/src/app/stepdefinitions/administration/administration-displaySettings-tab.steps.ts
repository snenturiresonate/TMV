import { Then, When } from 'cucumber';
import { expect } from 'chai';
import { AdminPunctualityConfigTab } from '../../pages/administration/administration-displaySettings-tab.page';
import { protractor} from 'protractor';

const adminPunctuality: AdminPunctualityConfigTab = new AdminPunctualityConfigTab();

When('I have navigated to the {string} admin tab', async (tabId: string) => {
    await adminPunctuality.openTab(tabId);
});

Then('the admin punctuality header is displayed as {string}', async (expectedHeader: string) => {
    const headerIsDisplayed: boolean = await adminPunctuality.headerTextIsDisplayed(expectedHeader);
    expect(headerIsDisplayed).to.equal(true);
});

Then('the following can be seen on the admin punctuality settings table', async (table: any) => {
  const results: any[] = [];
  const expectedValues = table.hashes();
  const actualCountOFPunctualityBands: number = await adminPunctuality.getCountOfPunctualityBands();
  await adminPunctuality.pageLoad();
  for (let i = 0; i < table.hashes().length; i++) {
    const actualPunctualityColors = await adminPunctuality.getAdminPunctualityColor(i);
    const actualPunctualityEntries = await adminPunctuality.getAdminPunctualityText(i);
    const actualFromPunctualityTime = await adminPunctuality.getAdminPunctualityFromTime(i);
    const actualToPunctualityTime = await adminPunctuality.getAdminPunctualityToTime(i);

    results.push(expect(actualPunctualityColors).to.contain(expectedValues[i].punctualityColorText));
    results.push(expect(actualPunctualityEntries).to.contain(expectedValues[i].entryValue));
    results.push(expect(actualFromPunctualityTime).to.contain(expectedValues[i].fromTime));
    results.push(expect(actualToPunctualityTime).to.contain(expectedValues[i].toTime));
  }
  results.push(expect(expectedValues.length).to.equal(actualCountOFPunctualityBands));
  return protractor.promise.all(results);

});

Then('the train indication header is displayed as {string}', async (expectedHeader: string) => {
  const actualHeader: string = await adminPunctuality.getTrainIndicationHeader();
  expect(actualHeader).to.equal(expectedHeader);
});

When('I add a punctuality time-band', async () => {
  await adminPunctuality.clickAddTimeBand();
});

When('I delete the first punctuality time-band', async () => {
  await adminPunctuality.deleteFirstTimeBand();
});

When(`I add punctuality time-bands until count of {int}`, async (maxCount: number) => {
  const countOfBands: number = await adminPunctuality.getCountOfPunctualityBands();
  const bandsToBeAdded: number = maxCount - countOfBands;
  if (bandsToBeAdded !== 0) {
    for (let i = 1; i <= bandsToBeAdded; i++) {
      await adminPunctuality.clickAddTimeBand();
    }
  }
});

Then('I should not be able to add any more punctuality time-bands', async () => {
  const isAddTimeBandVisible: boolean = await adminPunctuality.addTimeBandsButtonIsVisible();
  expect(isAddTimeBandVisible).to.equal(false);
});

When('I edit the display name of the added time band as {string}', async (displayName: string) => {
  await adminPunctuality.updateDisplayName(displayName);
});

When('I save the punctuality settings', async () => {
  await adminPunctuality.clickSaveButton();
});

When('I reset the punctuality settings', async () => {
  await adminPunctuality.clickResetButton();
});

When('I update the admin punctuality settings as', {timeout: 2 * 5000}, async (table: any) => {
  const results: any[] = [];
  const updateValues = table.hashes();
  await adminPunctuality.pageLoad();
  for (let i = 0; i < table.hashes().length; i++) {
    const updatePunctualityColors = await adminPunctuality.updateAdminPunctualityColour(i, updateValues[i].punctualityColorText);
    const updatePunctualityEntries = await adminPunctuality.updateAdminPunctualityText(i, updateValues[i].entryValue);
    const updateFromPunctualityTime = await adminPunctuality.updateAdminPunctualityFromTime(i, updateValues[i].fromTime);
    const updateToPunctualityTime = await adminPunctuality.updateAdminPunctualityToTime(i, updateValues[i].toTime);

    results.push(updatePunctualityColors);
    results.push(updatePunctualityEntries);
    results.push(updateFromPunctualityTime);
    results.push(updateToPunctualityTime);
  }
  return protractor.promise.all(results);

});

Then('the following can be seen on the trains list indication table', async (dataTable: any) => {
  const expectedEntries = dataTable.hashes();

  let index = 0;
  let minutesIndex = 0;
  for (const expectedEntry of expectedEntries) {
    const actualRowName = await adminPunctuality.getTrainIndicationRowName(index);
    const actualToggleValue = await adminPunctuality.getTrainIndicationClassToggle(index);
    const actualColour = await adminPunctuality.getTrainIndicationColourText(index);

    if (expectedEntry.minutes) {
      const actualMinutes = await adminPunctuality.getTrainIndicationColourMinutes(minutesIndex);
      expect(actualMinutes).to.contain(expectedEntry.minutes);
      minutesIndex++;
    }

    expect(actualRowName).to.contain(expectedEntry.name);
    expect(actualToggleValue, `Toggle value of ${expectedEntry.name} is not as expected`).to.contain(expectedEntry.toggleValue);
    expect(actualColour, `Colour of ${expectedEntry.name} is not as expected`).to.contain(expectedEntry.colour);
    index++;
  }
});

When('I update the train list indication table as', async (dataTable: any) => {
  const expectedEntries = dataTable.hashes();
  const results: any[] = [];
  for (let i = 0; i < expectedEntries.length; i++) {

    const updateColour = await adminPunctuality.updateTrainIndicationColourText(i, expectedEntries[i].colour);
    const updateToggleValue = await updateTrainIndicationToggle(i, expectedEntries[i].toggleValue);
    results.push(updateToggleValue);
    results.push(updateColour);

    if (expectedEntries[i].minutes !== '') {
      const updateMinutes = await adminPunctuality.updateTrainIndicationColourMinutes(i, expectedEntries[i].minutes);
      results.push(updateMinutes);
    }

  }

  return protractor.promise.all(results);
});

When('I toggle the indication toggle at index {int}', async (index: number) => {
  await adminPunctuality.toggleTrainIndicationClassToggle(index);
});

async function updateTrainIndicationToggle(index: number, update: string): Promise<void> {
  const selectUpdate: boolean = await convertToggleToBoolean(update);
  const currentSelection: string = await adminPunctuality.getTrainIndicationClassToggle(index);
  const currentSelectionToBoolean: boolean = await convertToggleToBoolean(currentSelection);

  if (selectUpdate !== currentSelectionToBoolean) {
    return adminPunctuality.toggleTrainIndicationClassToggle(index);
  } else {
    return;
  }
}

async function convertToggleToBoolean(toggleUpdate: string): Promise<boolean> {
  return (toggleUpdate === 'on' || toggleUpdate === 'On');
}
