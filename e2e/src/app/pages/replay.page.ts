import {browser, by, element, ElementArrayFinder, ElementFinder, protractor} from 'protractor';

export class ReplayPageObject {
  public mapList: ElementArrayFinder;
  public startButton: ElementFinder;
  constructor() {
    this.mapList = element.all(by.css('.mapLink'));
    this.startButton = element(by.buttonText('Start'));
  }
  public async expandMapGroupingForName(mapName: string): Promise<void>
  {
    const mapListItem: ElementFinder = element(by.xpath('//div[contains(text(),"' + mapName + '")]'));
    return mapListItem.click();
  }
  public async getMapsListed(): Promise<string> {
    return this.mapList.getText();
  }

  public async openMapsList(location: string): Promise<void> {
    const mapListItem: ElementFinder = element(by.xpath('//*[@id="map-link-' + location + '"]'));
    const nextButton: ElementFinder = element(by.buttonText('Next'));
    await mapListItem.click();
    await nextButton.click();
  }

  public async selectStart(): Promise<void> {
    return this.startButton.click();
  }
}
