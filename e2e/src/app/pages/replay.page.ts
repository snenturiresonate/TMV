import {by, element, ElementArrayFinder, ElementFinder} from 'protractor';

export class ReplayPageObject {
  public mapList: ElementArrayFinder;

  public quickSelect: ElementFinder;
  public startDate: ElementFinder;
  public startTime: ElementFinder;
  public duration: ElementFinder;
  public endDateAndTime: ElementFinder;
  public startButton: ElementFinder;
  public bufferingIndicator: ElementFinder;
  public skipForwardButton: ElementFinder;
  public skipBackButton: ElementFinder;
  public playButton: ElementFinder;
  public stopButton: ElementFinder;
  public replayButton: ElementFinder;
  constructor() {
    this.mapList = element.all(by.css('.mapLink'));
    this.startButton = element(by.buttonText('Start'));
    this.startDate = element(by.xpath('//input[@formcontrolname="startDate"]'));
    this.startTime = element(by.id('timePicker'));
    this.quickSelect = element(by.xpath('//app-dropdown[preceding-sibling::span[text()="Quick"]]//ul'));
    this.duration = element(by.xpath('//app-dropdown[preceding-sibling::span[text()="Duration (minutes)"]]//ul'));
    this.endDateAndTime = element(by.xpath('//input[@formcontrolname="endDate"]'));
    this.bufferingIndicator = element(by.css('.bufferingIndicator'));
    this.skipForwardButton = element(by.xpath('//li[contains(text(),"skip_next")]'));
    this.skipBackButton = element(by.xpath('//li[contains(text(),"skip_previous")]'));
    this.playButton = element(by.xpath('//li[contains(text(),"play_circle_outline")]'));
    this.stopButton = element(by.xpath('//li[contains(text(),"stop")]'));
    this.replayButton = element(by.xpath('//li[contains(text(),"replay")]'));
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
  public async selectSkipForward(): Promise<void> {
    return this.skipForwardButton.click();
  }
  public async selectSkipBack(): Promise<void> {
    return this.skipBackButton.click();
  }
  public async selectPlay(): Promise<void> {
    return this.playButton.click();
  }
  public async selectStop(): Promise<void> {
    return this.stopButton.click();
  }
  public async selectReplay(): Promise<void> {
    return this.stopButton.click();
  }
}
