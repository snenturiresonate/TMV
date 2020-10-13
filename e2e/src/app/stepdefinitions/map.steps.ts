import {Before, Given} from 'cucumber';
import {MapPage} from "../pages/map.po";

let page: MapPage;

Before(() => {
  page = new MapPage();
});

Given(/^I am viewing the map (.*)$/, async (mapId: String) => {
  await page.navigateTo(mapId);
});
