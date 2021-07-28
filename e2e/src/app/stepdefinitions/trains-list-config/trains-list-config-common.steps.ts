import {TrainsListConfigCommonPage} from '../../pages/trains-list-config/trains.list.config.common.page';
import {When, Then} from 'cucumber';
import { expect } from 'chai';
import {browser} from 'protractor';

const page: TrainsListConfigCommonPage = new TrainsListConfigCommonPage();
const TRAINS_LIST_CONFIG_SAVED_DELAY = 2000;

When('I save the trains list config', async () => {
  await page.saveTrainListConfig();
  await browser.sleep(TRAINS_LIST_CONFIG_SAVED_DELAY);
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
