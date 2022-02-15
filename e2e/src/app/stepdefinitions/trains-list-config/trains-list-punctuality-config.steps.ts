import {Then, When} from 'cucumber';
import { expect } from 'chai';
import {TrainsListPunctualityConfigTab} from '../../pages/trains-list-config/trains.list.punctuality.config.tab';
import {ElementArrayFinder, protractor} from 'protractor';
import {TrainsListTableColumnsPage} from '../../pages/trains-list/trains-list.tablecolumns.page';
import {CheckBox} from '../../pages/common/ui-element-handlers/checkBox';

const trainsListPunctuality: TrainsListPunctualityConfigTab = new TrainsListPunctualityConfigTab();
const trainsListTable: TrainsListTableColumnsPage = new TrainsListTableColumnsPage();

Then('the punctuality header is displayed as {string}', async (expectedHeader: string) => {
  const actualHeader: string = await trainsListPunctuality.getTrainPunctualityHeader();
  expect(actualHeader).to.equal(expectedHeader);
});

Then('the following can be seen on the punctuality table', {timeout: 8 * 5000}, async (table: any) => {
  const results: any[] = [];
  const expectedValues = table.hashes();
  for (let i = 0; i < table.hashes().length; i++) {
    const actualPunctualityColors: string = await trainsListPunctuality.getTrainPunctualityColor(i);
    const actualPunctualityEntries: string = await trainsListPunctuality.getTrainPunctualityText(i);
    const actualFromPunctualityTime: string = await trainsListPunctuality.getPunctualityFromTime(i);
    const actualToPunctualityTime: string = await trainsListPunctuality.getPunctualityToTime(i);
    const actualIncludeToggle: boolean = await trainsListPunctuality.getPunctualityToggle(i);

    results.push(expect(actualPunctualityColors).to.contain(expectedValues[i].punctualityColorText));
    results.push(expect(actualPunctualityEntries).to.contain(expectedValues[i].entryValue));
    results.push(expect(actualFromPunctualityTime).to.contain(expectedValues[i].fromTime));
    results.push(expect(actualToPunctualityTime).to.contain(expectedValues[i].toTime));
    results.push(expect(actualIncludeToggle).to.equal(await CheckBox.convertToggleToBoolean(expectedValues[i].include)));
  }
  return protractor.promise.all(results);

});

When('I update the punctuality settings to new values', async (editedEntries: any) => {
  let i = 0;
  editedEntries.hashes().forEach((editedEntry: any) => {
    i = i + 1;
    trainsListPunctuality.setTrainDisplayNameText('display-name-' + i.toString(), editedEntry.displayName);
  });
});

Then('the following settings are displayed', async (newEntries: any) => {
  let i = 0;
  for (const newEntry of newEntries.hashes()) {
    i = i + 1;
    const actualDisplayName = await trainsListPunctuality.getTrainDisplayNameText('display-name-' + i.toString());
    expect(actualDisplayName).to.contain(newEntry.displayName);
  }
});

When('I toggle all trains list punctuality toggles {string}', async (toggleState: string) => {
  const results: any[] = [];
  const updateToPunctualityToggle = await trainsListPunctuality.toggleAllPunctualityToggles(toggleState);
  results.push(updateToPunctualityToggle);
  return protractor.promise.all(results);
});

When('I update the trains list punctuality settings as', {timeout: 8 * 5000}, async (table: any) => {
  const results: any[] = [];
  const updateValues = table.hashes();
  for (let i = 0; i < table.hashes().length; i++) {
    const updatePunctualityColors = await trainsListPunctuality.updatePunctualityColor(i, updateValues[i].punctualityColorText);
    const updatePunctualityEntries = await trainsListPunctuality.updatePunctualityText(i, updateValues[i].entryValue);
    const updateFromPunctualityTime = await trainsListPunctuality.updatePunctualityTime(i, updateValues[i].fromTime, 'fromTime');
    const updateToPunctualityTime = await trainsListPunctuality.updatePunctualityTime(i, updateValues[i].toTime, 'toTime');
    const updateToPunctualityToggle = await trainsListPunctuality.updatePunctualityToggle(i, updateValues[i].include);

    results.push(updatePunctualityColors);
    results.push(updatePunctualityEntries);
    results.push(updateFromPunctualityTime);
    results.push(updateToPunctualityTime);
    results.push(updateToPunctualityToggle);
  }
  return protractor.promise.all(results);
});

Then('I should see the colour picker when any punctuality colour box is clicked', {timeout: 4 * 5000}, async () => {
  const punctualityColourTextBoxes = await trainsListPunctuality.punctualityColor.count();
  const results: any[] = [];
  for (let i = 0; i < punctualityColourTextBoxes; i++) {
    await trainsListPunctuality.clickPunctualityColourElement(i);
    const colourPickerIsDisplayed: boolean = await trainsListPunctuality.punctualityColourPickerIsDisplayed();
    expect(colourPickerIsDisplayed).to.equal(true);
  }
});

Then('I should see the colour picker is defaulted with the colour for the selected time-band', {timeout: 6 * 5000}, async () => {
  const punctualityColourTextBoxes = await trainsListPunctuality.punctualityColor.count();
  const results: any[] = [];
  for (let i = 0; i < punctualityColourTextBoxes; i++) {
    const defaultColour: string = await trainsListPunctuality.getTrainPunctualityColor(i);
    await trainsListPunctuality.clickPunctualityColourElement(i);
    const colourFrmPicker: string = await trainsListPunctuality.getTrainPunctualityColorFrmColourPicker();
    expect(defaultColour).to.equal(colourFrmPicker);
  }
});

Then('I should see the punctuality colour for the time-bands as', async (table: any) => {
  const tableValues = table.hashes();
  const results: any[] = [];
  let trainsTested = 0;
  // tslint:disable-next-line:prefer-for-of
  for (let i = 0; i < tableValues.length; i++) {
    const punctualityFromTime = (tableValues[i].fromTime !== '') ? tableValues[i].fromTime : -1000;
    const punctualityToTime = (tableValues[i].toTime !== '') ? tableValues[i].toTime : 1000;
    const punctualityColour = tableValues[i].punctualityColor;
    const punctualityColumn: ElementArrayFinder = trainsListTable.punctuality;
    const backgroundColours = await
      trainsListTable.getBackgroundColourOfValuesWithinRange(punctualityColumn, punctualityFromTime, punctualityToTime);
    backgroundColours.forEach((item: string) => {
      results.push(expect(item).to.contain(punctualityColour));
    });
    trainsTested = trainsTested + backgroundColours.length;
  }
  expect(trainsTested, `No trains tested`).greaterThan(0);
  return protractor.promise.all(results);
});

Then(/^the trains list number controls for the punctuality bands are clear$/, async () => {
  const punctualityAdjustmentsAvailable: boolean = await trainsListPunctuality.arePunctualityAdjustmentsAvailable();
  expect(punctualityAdjustmentsAvailable, 'Number controls for trains list punctuality bands are not available').to.equal(true);
});
