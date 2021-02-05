import {Then, When} from 'cucumber';
import {expect} from 'chai';
import {TrainsListIndicationTabPage} from '../../pages/trains-list-config/trains.list.indication.tab.page';
import {protractor} from 'protractor';
import {TrainsListTableColumnsPage} from '../../pages/trains-list/trains-list.tablecolumns.page';

const trainsListIndicationTab: TrainsListIndicationTabPage = new TrainsListIndicationTabPage();
const trainsListTable: TrainsListTableColumnsPage = new TrainsListTableColumnsPage();

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

When('I update only the below train list indication config settings as', {timeout: 6 * 5000}, async (dataTable: any) => {
  const expectedEntries = dataTable.hashes();
  const results: any[] = [];
  for (let i = 0; i < expectedEntries.length; i++) {
    const settingName = expectedEntries[i].name;
    const updateColour = await trainsListIndicationTab.updateTrainIndicationColourTextOfSetting(settingName, expectedEntries[i].colour);
    const updateToggleValue = await trainsListIndicationTab
      .updateTrainIndicationToggleOfSetting(settingName, expectedEntries[i].toggleValue);
    results.push(updateToggleValue);
    results.push(updateColour);
    if (expectedEntries[i].minutes) {
      switch (settingName) {
        case ('Next report overdue'):
          results.push(await trainsListIndicationTab.updateTrainIndicationColourMinutes(5, expectedEntries[i].minutes));
          break;
        case ('Origin Called'):
          results.push(await trainsListIndicationTab.updateTrainIndicationColourMinutes(6, expectedEntries[i].minutes));
          break;
        case ('Origin Departure Overdue'):
          results.push(await trainsListIndicationTab.updateTrainIndicationColourMinutes(7, expectedEntries[i].minutes));
          break;
      }
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


Then('I should see the train list row coloured as', async (table: any) => {
  const expectedEntries = table.hashes();
  const results: any[] = [];
  for (let i = 0; i < expectedEntries.length; i++) {
    const expectedBackgroundColour = expectedEntries[i].backgroundColour;
    const trainDescriberId = expectedEntries[i].trainDescriberId;
    results.push(expect(trainsListTable.getBackgroundColourOfRow(trainDescriberId)).to.include(expectedEntries));
  }
  return protractor.promise.all(results);
});
