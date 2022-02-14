import {TrainsListConfigCommonPage} from '../../pages/trains-list-config/trains.list.config.common.page';
import {When, Then} from 'cucumber';
import { expect } from 'chai';
import {browser} from 'protractor';
import {TrainsListPunctualityConfigTab} from '../../pages/trains-list-config/trains.list.punctuality.config.tab';
import {TrainsListColumnConfigTabPageObject} from '../../pages/trains-list-config/trains.list.column.config.tab.page';
import {TrainsListRailwayUndertakingConfigTabPageObject} from '../../pages/trains-list-config/trains.list.railway.undertaking.config.tab.page';
import {TrainsListLocationSelectionTab} from '../../pages/trains-list-config/trains.list.location.selection.tab.page';
import {TrainsListIndicationTabPage} from '../../pages/trains-list-config/trains.list.indication.tab.page';
import {TrainsListMiscConfigTab} from '../../pages/trains-list-config/trains.list.misc.config.tab';

const page: TrainsListConfigCommonPage = new TrainsListConfigCommonPage();
const trainsListColumnConfigPage: TrainsListColumnConfigTabPageObject = new TrainsListColumnConfigTabPageObject();
const trainsListPunctuality: TrainsListPunctualityConfigTab = new TrainsListPunctualityConfigTab();
const trainsListRailwayUndertakingConfigPage: TrainsListRailwayUndertakingConfigTabPageObject =
  new TrainsListRailwayUndertakingConfigTabPageObject();
const trainsListLocationSelectionConfig: TrainsListLocationSelectionTab = new TrainsListLocationSelectionTab();
const trainsListIndicationTab: TrainsListIndicationTabPage = new TrainsListIndicationTabPage();
const trainsListMisc: TrainsListMiscConfigTab = new TrainsListMiscConfigTab();
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
  await page.resetTrainListConfig();
});

When('I save the following config changes', async (inputs: any) => {
  const configChanges: any = inputs.hashes();
  for (const configChange of configChanges) {
    await trainsListColumnConfigPage.openTab(configChange.tab);
    switch (configChange.tab) {
      case 'Punctuality':
        await trainsListPunctuality.makeChange(configChange);
        break;
      case 'Columns':
        await trainsListColumnConfigPage.makeChange(configChange);
        break;
      case 'TOC/FOC':
        await trainsListRailwayUndertakingConfigPage.makeChange(configChange);
        break;
      case 'Locations':
        await trainsListLocationSelectionConfig.makeChange(configChange);
        break;
      case 'Train Indication':
        await trainsListIndicationTab.makeChange(configChange);
        break;
      case 'Train Class & MISC':
        await trainsListMisc.makeChange(configChange);
        break;
      case 'Nominated Services':
        break;
      case 'Region/Route':
        break;
      default:
        throw new Error(`Please check the tab value in feature file`);
    }
  }
  await page.saveTrainListConfig();
  await browser.sleep(TRAINS_LIST_CONFIG_SAVED_DELAY);
});

