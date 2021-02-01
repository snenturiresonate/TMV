import {browser, by, element, ElementFinder, protractor} from 'protractor';
import {DateTimeFormatter, LocalDateTime, LocalTime} from '@js-joda/core';
import {ContinuationLinkContextMenu} from '../sections/replay.continuationlink.contextmenu';
import {BerthContextMenu} from '../sections/replay.berth.contextmenu';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';

export class ReplayMapPage {
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
  public mapName: ElementFinder;

  constructor() {
    // Replay Map Page
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
    this.mapName = element(by.css('.map-dropdown-button h2'));
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
    await CommonActions.waitAndClick(this.skipForwardButton);
  }

  public async selectSkipBack(): Promise<void> {
    await CommonActions.waitAndClick(this.skipBackButton);
  }

  public async selectPlay(): Promise<void> {
    await CommonActions.waitAndClick(this.playButton);
  }

  public async selectStop(): Promise<void> {
    await CommonActions.waitAndClick(this.stopButton);
  }

  public async selectReplay(): Promise<void> {
    await CommonActions.waitAndClick(this.replayButton);
  }

  public async selectPause(): Promise<void> {
    await CommonActions.waitAndClick(this.pauseButton);
  }

  public async moveReplayTimeTo(time: string): Promise<void> {
    await this.setReplaySpeed(ReplaySpeed.x4);
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

  public async getTimestamp(): Promise<LocalDateTime> {
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

  public async getMapName(): Promise<string> {
    return this.mapName.getText();
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
