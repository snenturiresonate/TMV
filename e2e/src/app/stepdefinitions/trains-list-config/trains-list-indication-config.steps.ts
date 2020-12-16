import {Then, When} from 'cucumber';
import {expect} from 'chai';
import {TrainsListIndicationTabPage} from '../../pages/trains-list-config/trains.list.indication.tab.page';

const trainsListIndicationTab: TrainsListIndicationTabPage = new TrainsListIndicationTabPage();

When('I wait for the indication config data to be retrieved', async () => {
  await trainsListIndicationTab.waitForIndicationData();
});

When('I toggle the indication toggle at index {int}', async (index: number) => {
  await trainsListIndicationTab.toggleTrainIndicationClassToggle(index);
});

Then('the following can be seen on the trains list indication table', async (dataTable: any) => {
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
