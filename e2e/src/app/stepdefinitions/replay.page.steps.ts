import {ReplayPageObject} from '../pages/replay.page';
import {Then, When} from 'cucumber';
import {expect} from 'chai';
import {browser, by, element} from 'protractor';

const replayPage: ReplayPageObject = new ReplayPageObject();

When('I expand the replay group of maps with name {string}', async (mapName: string) => {
  await replayPage.expandMapGroupingForName(mapName);
});

When('I select the map {string}', async (location: string) => {
  await replayPage.openMapsList(location);
});

When('I select Start', async () => {
  await replayPage.selectStart();
});
