import {by, element, ElementArrayFinder, ElementFinder} from 'protractor';

export class ReplayPageObject {
  public mapList: ElementArrayFinder;

  public quickSelect: ElementFinder;
  public startDate: ElementFinder;
  public startTime: ElementFinder;
  public duration: ElementFinder;
  public endDateAndTime: ElementFinder;
  public startButton: ElementFinder;
  constructor() {
    this.mapList = element.all(by.css('.mapLink'));
    this.startButton = element(by.buttonText('Start'));
    this.startDate = element(by.xpath('//input[@formcontrolname="startDate"]'));
    this.startTime = element(by.id('timePicker'));
    this.quickSelect = element(by.xpath('//app-dropdown[preceding-sibling::span[text()="Quick"]]//ul'));
    this.duration = element(by.xpath('//app-dropdown[preceding-sibling::span[text()="Duration (minutes)"]]//ul'));
    this.endDateAndTime = element(by.xpath('//input[@formcontrolname="endDate"]'));
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
