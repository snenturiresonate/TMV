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
