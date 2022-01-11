import {browser, by, element, ElementArrayFinder, ElementFinder, protractor} from 'protractor';
import {DateTimeFormatter, LocalDateTime, LocalTime} from '@js-joda/core';
import {ContinuationLinkContextMenu} from '../sections/replay.continuationlink.contextmenu';
import {BerthContextMenu} from '../sections/replay.berth.contextmenu';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';

export class ReplayMapPage {
  public static speedValue: ElementFinder = element(by.css('button[title*=speed]>span'));

  public bufferingIndicator: ElementFinder;
  public skipForwardButton: ElementFinder;
  public skipBackButton: ElementFinder;
  public playButton: ElementFinder;
  public minimisedPlayButton: ElementFinder;
  public pauseButton: ElementFinder;
  public minimisedPauseButton: ElementFinder;
  public stopButton: ElementFinder;
  public replayButton: ElementFinder;
  public replayContainer: ElementFinder;
  public continuationLinkContextMenu: ContinuationLinkContextMenu;
  public berthContextMenu: BerthContextMenu;
  public timestamp: ElementFinder;
  public replaySpeedButton: ElementFinder;
  public replayPlaybackTime: ElementFinder;
  public manualSpeedInput: ElementFinder;
  public mapName: ElementFinder;
  public replayTimestamp: ElementFinder;
  public replayIncreaseSpeed: ElementArrayFinder;
  public replayMinimise: ElementFinder;
  public replayWindowTitle: ElementFinder;
  constructor() {
    // Replay Map Page
    this.continuationLinkContextMenu = new ContinuationLinkContextMenu();
    this.berthContextMenu = new BerthContextMenu();
    this.bufferingIndicator = element.all(by.css('.buffering-indicator')).first();
    this.skipForwardButton = element(by.xpath('//li[contains(text(),"skip_next")]'));
    this.skipBackButton = element(by.xpath('//li[contains(text(),"skip_previous")]'));
    this.playButton = element(by.xpath('//li[contains(text(),"play_circle_outline")]'));
    this.minimisedPlayButton = element(by.xpath('//li[contains(text(),"play_arrow")]'));
    this.pauseButton = element(by.xpath('//li[contains(text(),"pause_circle_outline")]'));
    this.minimisedPauseButton = element(by.xpath('//li[contains(text(),"pause")]'));
    this.stopButton = element(by.xpath('//li[contains(text(),"stop")]'));
    this.replayButton = element(by.xpath('//li[contains(text(),"replay")]'));
    this.replayContainer = element(by.css('.reply-container'));
    this.timestamp = element.all(by.css('.playback-status div')).first();
    this.replaySpeedButton = element(by.xpath('//button[@title="Playback speed"]'));
    this.replayPlaybackTime = element(by.id('playback-time'));
    this.manualSpeedInput = element(by.id('speed-editor-manual-input'));
    this.mapName = element(by.css('.map-dropdown-button h2'));
    this.replayTimestamp = element(by.css('.playback-status >div'));
    this.replayIncreaseSpeed = element.all(by.css('.speed-editor-popup .speeds .speed'));
    this.replayMinimise = element(by.css('.collapse-button-container'));
    this.replayWindowTitle = element(by.css('[data-id=\'replay-window-title\']'));
  }

  public async selectContinuationLink(linkText): Promise<void> {
    this.getContinuationLinkLocator(linkText).click();
  }

  public async rightClickContinuationLink(linkText: any): Promise<void> {
    browser.actions().click(this.getContinuationLinkLocator(linkText), protractor.Button.RIGHT).perform();
    await browser.wait(this.continuationLinkContextMenu.isDisplayed());
  }

  private getContinuationLinkLocator(linkText): ElementFinder {
    return element(by.xpath(`//*[child::*[text()='${linkText.substring(2, 4)}']]
    [preceding-sibling::*[child::*[text()='${linkText.substring(0, 2)}']]]`));
  }

  public getReplayWindowTitle(): Promise<string> {
    return CommonActions.waitAndGetText(this.replayWindowTitle);
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

  public async selectMinimisedPlay(): Promise<void> {
    await CommonActions.waitAndClick(this.minimisedPlayButton);
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

  public async selectMinimisedPause(): Promise<void> {
    await CommonActions.waitAndClick(this.minimisedPauseButton);
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

  public async getCurrentBackgroundColours(): Promise<string[]> {
    const backgroundProperty = await this.replayContainer.getCssValue('background');
    return translateGradientToRGBColorStopList(backgroundProperty);
  }

  public async getTimestamp(): Promise<LocalDateTime> {
    const timestamp = await this.timestamp.getText();
    return LocalDateTime.parse(timestamp.replace('Replay: ', '').substr(0, 19),
      DateTimeFormatter.ofPattern('dd/MM/yyyy HH:mm:ss'));
  }

  private async setReplaySpeed(speed: ReplaySpeed): Promise<void> {
    await browser.wait(() => this.replaySpeedButton.isPresent(), browser.params.replay_timeout);
    await this.replaySpeedButton.click();
    const el = element(by.css('.speeds .speed:nth-child(' + speed.valueOf() + ')'));
    await browser.wait(() => el.isPresent(), browser.params.replay_timeout);
    await browser.actions().mouseMove(el).click().perform();
  }

  public async getMapName(): Promise<string> {
    return this.mapName.getText();
  }

  public async getSpeedValue(): Promise<string> {
    return ReplayMapPage.speedValue.getText();
  }

  public async getPlaybackControl(): Promise<string>{
    return this.replayMinimise.getAttribute('title');
  }

  public async getButtonType(button: string): Promise<string> {
    if (button === 'backward'){
      return this.skipBackButton.getAttribute('class');
    }
    if (button === 'forward'){
      return this.skipForwardButton.getAttribute('class');
    }
    if (button === 'play'){
      return this.playButton.getAttribute('class');
    }
    if (button === 'minimisedPlay'){
      return this.minimisedPlayButton.getAttribute('class');
    }
    if (button === 'minimisedPause'){
      return this.minimisedPauseButton.getAttribute('class');
    }
  }

  public async getReplayTimestamp(): Promise<any> {
    const fullString: string = await this.replayTimestamp.getText();
    return fullString.replace('Replay: ', '').substr(0, 19);
  }

  public async clickReplaySpeed(): Promise<void> {
    return this.replaySpeedButton.click();
  }

  public async clickReplayPlaybackTime(): Promise<void> {
    return this.replayPlaybackTime.click();
  }

  public async getReplayPlaybackTimeAndStatus(): Promise<string> {
    return this.replayPlaybackTime.getText();
  }

  public async setManualInputSpeed(speed: number): Promise<void> {
    await CommonActions.waitForElementInteraction(this.manualSpeedInput);
    await this.manualSpeedInput.clear();
    await this.manualSpeedInput.sendKeys(speed);
  }

  public async clickMinimise(): Promise<void> {
    return CommonActions.waitAndClick(this.replayMinimise);
  }

  public async increaseReplaySpeed(position: number): Promise<void> {
    const speed = this.replayIncreaseSpeed;
    await CommonActions.waitForElementInteraction(speed.get(position));
    browser.actions().mouseMove(speed.get(position)).click().perform();
  }
}

function translateGradientToRGBColorStopList(gradientString: string): string[] {
  const colourList = [];
  let startNum = 0;
  const numColours = gradientString.match(/rgb/g).length;
  for (let i = 0; i < numColours; i++) {
    const newString = gradientString.substr(gradientString.indexOf('rgb', startNum),
      (gradientString.indexOf(')', startNum) - gradientString.indexOf('rgb', startNum)) + 1);
    colourList.push(newString);
    startNum = gradientString.indexOf('rgb', startNum) + newString.length + 1;
  }
  return colourList;
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
