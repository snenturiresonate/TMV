import {Then, When} from 'cucumber';
import {expect} from 'chai';
import {TrainsListIndicationTabPage} from '../../pages/trains-list-config/trains.list.indication.tab.page';
import {protractor} from 'protractor';

const trainsListIndicationTab: TrainsListIndicationTabPage = new TrainsListIndicationTabPage();

When('I wait for the indication config data to be retrieved', async () => {
  await trainsListIndicationTab.waitForIndicationData();
});

When('I toggle the indication toggle at index {int}', async (index: number) => {
  await trainsListIndicationTab.toggleTrainIndicationClassToggle(index);
});

Then('the following can be seen on the trains indication table of trains list config', async (dataTable: any) => {
  const expectedEntries = dataTable.hashes();

  let index = 0;
  let minutesIndex = 0;
  for (const expectedEntry of expectedEntries) {
    const actualRowName = await trainsListIndicationTab.getTrainIndicationRowName(index);
    const actualToggleValue = await trainsListIndicationTab.getTrainIndicationClassToggle(index);
    const actualColour = await trainsListIndicationTab.getTrainIndicationColourText(index);

    if (expectedEntry.minutes) {
      const actualMinutes = await trainsListIndicationTab.getTrainIndicationColourMinutes(minutesIndex);
      expect(actualMinutes).to.contain(expectedEntry.minutes);
      minutesIndex++;
    }

    expect(actualRowName).to.contain(expectedEntry.name);
    expect(actualToggleValue).to.contain(expectedEntry.toggleValue);
    expect(actualColour).to.contain(expectedEntry.colour);
    index++;
  }
});

When('I update the train list indication config settings as', {timeout: 6 * 5000}, async (dataTable: any) => {
  const expectedEntries = dataTable.hashes();
  const results: any[] = [];
  for (let i = 0; i < expectedEntries.length; i++) {

    const updateColour = await trainsListIndicationTab.updateTrainIndicationColourText(i, expectedEntries[i].colour);
    const updateToggleValue = await trainsListIndicationTab.updateTrainIndicationToggle(i, expectedEntries[i].toggleValue);
    results.push(updateToggleValue);
    results.push(updateColour);

    if (expectedEntries[i].minutes !== '') {
      const updateMinutes = await trainsListIndicationTab.updateTrainIndicationColourMinutes(i, expectedEntries[i].minutes);
      results.push(updateMinutes);
    }

  }

  return protractor.promise.all(results);
});

Then('I should see the colour picker when any trains list colour box is clicked', {timeout: 4 * 5000}, async () => {
  const punctualityColourTextBoxes = await trainsListIndicationTab.colourText.count();
  const results: any[] = [];
  for (let i = 0; i < punctualityColourTextBoxes; i++) {
    await trainsListIndicationTab.clickTrainIndicationColourElement(i);
    const colourPickerIsDisplayed: boolean = await trainsListIndicationTab.colourPickerIsDisplayed();
    expect(colourPickerIsDisplayed).to.equal(true);
  }
});

Then('the train indication config header is displayed as {string}', async (expectedHeader: string) => {
  const actualHeader: string = await trainsListIndicationTab.getTrainIndicationHeader();
  expect(actualHeader).to.equal(expectedHeader);
});
