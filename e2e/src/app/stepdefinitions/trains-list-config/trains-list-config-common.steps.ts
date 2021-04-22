import {TrainsListConfigCommonPage} from '../../pages/trains-list-config/trains.list.config.common.page';
import {When, Then} from 'cucumber';
import { expect } from 'chai';

const page: TrainsListConfigCommonPage = new TrainsListConfigCommonPage();

When('I save the trains list config', async () => {
  await page.saveTrainListConfig();
});

Then('There is an unsaved indicator', async () => {
  expect(await page.isUnsaved()).to.equal(true);
});

Then('There is no unsaved indicator', async () => {
  expect(await page.isUnsaved()).to.equal(false);
});

When('I reset the trains list config', async () => {
  await page.saveTrainListConfig();
});
