import { browser, by, element } from 'protractor';

export class MapPage {
  navigateTo(mapId: String): Promise<unknown> {
    return browser.get(browser.baseUrl + "/tmv/maps/" + mapId) as Promise<unknown>;
  }
}
