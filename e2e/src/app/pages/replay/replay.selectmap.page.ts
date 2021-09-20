import {browser, by, element, ElementArrayFinder, ElementFinder} from 'protractor';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';

export class ReplaySelectMapPage {
  public selectYourMapTitle: ElementFinder;
  public mapsInputBox: ElementFinder;
  public mapsListContainer: ElementFinder;
  public mapList: ElementArrayFinder;
  public startButton: ElementFinder;
  public searchedMapResultItems: ElementArrayFinder;

  constructor() {
    this.selectYourMapTitle = element(by.cssContainingText('h1', 'Select your Map'));
    this.mapsInputBox = element(by.css('.map-search input'));
    this.mapsListContainer = element(by.css('.maps-container'));
    this.mapList = element.all(by.css('.mapLink'));
    this.searchedMapResultItems = element.all(by.css('.app-map-link'));
    this.startButton = element(by.buttonText('Start'));
  }

  public async expandMapGroupingForName(mapName: string): Promise<void> {
    const mapListItem: ElementFinder = element(by.xpath('//div[contains(text(),"' + mapName + '")]'));
    return mapListItem.click();
  }

  public async getMapsListed(): Promise<string> {
    return this.mapList.getText();
  }

  public async openMapsList(location: string): Promise<void> {
    const mapListItem: ElementFinder = element(by.xpath('//*[@id="map-link-' + location + '"]'));
    await mapListItem.click();
    await this.selectStart();
  }

  public async getSearchResults(): Promise<Array<string>> {
    return this.searchedMapResultItems.map(async item => {
      const text = await item.all(by.css('span:not(.tick)')).map(span => span.getText());
      return text.join('');
    });
  }

  public async selectStart(): Promise<void> {
    return CommonActions.waitAndClick(this.startButton);
  }

  public async searchForMap(input): Promise<void> {
    await this.mapsInputBox.sendKeys(input);
    browser.sleep(2000);
  }
}

