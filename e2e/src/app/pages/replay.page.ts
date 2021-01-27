import {browser, by, element, ElementArrayFinder, ElementFinder, protractor} from 'protractor';
import {DateTimeFormatter, LocalDateTime, LocalTime} from '@js-joda/core';
import {ContinuationLinkContextMenu} from './sections/replay.continuationlink.contextmenu';
import {BerthContextMenu} from './sections/replay.berth.contextmenu';
import {InputBox} from './common/ui-element-handlers/inputBox';

export class ReplayPageObject {
  public mapList: ElementArrayFinder;

  public quickSelect: ElementFinder;
  public startDate: ElementFinder;
  public startTime: ElementFinder;
  public durationContainer: ElementFinder;
  public durationExpand: ElementFinder;
  public endDateAndTime: ElementFinder;
  public startButton: ElementFinder;
  public bufferingIndicator: ElementFinder;
  public skipForwardButton: ElementFinder;
  public skipBackButton: ElementFinder;
  public playButton: ElementFinder;
  public pauseButton: ElementFinder;
  public stopButton: ElementFinder;
  public replayButton: ElementFinder;
  public continuationLinkContextMenu: ContinuationLinkContextMenu;
  public berthContextMenu: BerthContextMenu;
  public timestamp: ElementFinder;
  public replaySpeedButton: ElementFinder;

  constructor() {
    this.mapList = element.all(by.css('.mapLink'));
    this.startButton = element(by.buttonText('Start'));
    this.startDate = element(by.xpath('//input[@formcontrolname="startDate"]'));
    this.startTime = element(by.id('timePicker'));
    this.quickSelect = element(by.xpath('//app-dropdown[preceding-sibling::span[text()="Quick"]]//ul'));
    this.durationContainer = element(by.xpath('//app-dropdown[preceding-sibling::span[text()="Duration (minutes)"]]'));
    this.durationExpand = this.durationContainer.element(by.css('.dropdown-arrow'));
    this.endDateAndTime = element(by.xpath('//input[@formcontrolname="endDate"]'));
    this.continuationLinkContextMenu = new ContinuationLinkContextMenu();
    this.berthContextMenu = new BerthContextMenu();
    this.bufferingIndicator = element(by.css('.bufferingIndicator'));
    this.skipForwardButton = element(by.xpath('//li[contains(text(),"skip_next")]'));
    this.skipBackButton = element(by.xpath('//li[contains(text(),"skip_previous")]'));
    this.playButton = element(by.xpath('//li[contains(text(),"play_circle_outline")]'));
    this.pauseButton = element(by.xpath('//li[contains(text(),"pause_circle_outline")]'));
    this.stopButton = element(by.xpath('//li[contains(text(),"stop")]'));
    this.replayButton = element(by.xpath('//li[contains(text(),"replay")]'));
    this.timestamp = element(by.css('.playback-status div'));
    this.replaySpeedButton = element(by.xpath('//button[@title="Playback speed"]'));
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
    const nextButton: ElementFinder = element(by.buttonText('Next'));
    await mapListItem.click();
    await nextButton.click();
  }

  public async selectStart(): Promise<void> {
    browser.wait(this.startButton.isPresent());
    return this.startButton.click();
  }

  public async selectContinuationLink(linkText): Promise<void> {
    this.getContinuationLinkLocator(linkText).click();
  }

  public async rightClickContinuationLink(linkText: any): Promise<void> {
    browser.actions().click(this.getContinuationLinkLocator(linkText), protractor.Button.RIGHT).perform();
    browser.wait(this.continuationLinkContextMenu.isDisplayed());
  }

  private getContinuationLinkLocator(linkText): ElementFinder {
    return element(by.xpath(`//*[child::*[text()='${linkText.substring(0, 2)}']][child::*[text()='${linkText.substring(2, 4)}']]`));
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

  public async selectPause(): Promise<void> {
    return this.pauseButton.click();
  }

  public async moveReplayTimeTo(time: string): Promise<void> {
    await this.setReplaySpeed(ReplaySpeed.x5);
    const timeAsLocalTime = LocalTime.parse(time);
    while ((await this.getTimestamp()).toLocalTime().hour() < timeAsLocalTime.hour()) {
      await this.selectSkipForward();
    }
    while ((await this.getTimestamp()).toLocalTime().minute() < timeAsLocalTime.minute()) {
      await this.selectSkipForward();
    }
    await this.selectPlay();
    while ((await this.getTimestamp()).toLocalTime() < timeAsLocalTime) {
      if (!this.skipForwardButton.isEnabled()) {
        break;
      }
    }
    await this.selectPause();
    await this.setReplaySpeed(ReplaySpeed.x1);
  }

  private async getTimestamp(): Promise<LocalDateTime> {
    const timestamp = await this.timestamp.getText();
    return LocalDateTime.parse(timestamp.replace('Replay: ', ''),
      DateTimeFormatter.ofPattern('dd/MM/yyyy HH:mm:ss'));
  }

  private async setReplaySpeed(speed: ReplaySpeed): Promise<void> {
    await browser.wait(() => this.replaySpeedButton.isPresent(), 20 * 1000);
    await this.replaySpeedButton.click();
    const el = element(by.css('.speeds .speed:nth-child(' + speed.valueOf() + ')'));
    await browser.wait(() => el.isPresent(), 20 * 1000);
    await browser.actions().mouseMove(el).click().perform();
  }

  public async setStartDate(date): Promise<void> {
    await InputBox.ctrlADeleteClear(this.startDate);
    await this.startDate.sendKeys(date);
    browser.sleep(1000);
  }

  public async setStartTime(time): Promise<void> {
    await InputBox.ctrlADeleteClear(this.startTime);
    await this.startTime.sendKeys(time);
    browser.sleep(1000);
  }

  public async selectDurationOfReplay(duration): Promise<void> {
    await this.durationExpand.click();
    await this.durationContainer.element(by.cssContainingText('li', duration)).click();
  }
}

export enum ReplaySpeed {
  x1 = 1,
  x2,
  x3,
  x4,
  x5,
  x10,
  x15,
  x20,
  x25,
  x30
}

