import { by, element, ElementArrayFinder, ElementFinder} from 'protractor';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';
import {browser} from 'protractor';
import { InputBox } from '../common/ui-element-handlers/inputBox';

export class TrainsListMiscConfigTab {
  public classHeader: ElementFinder;
  public classToggle: ElementArrayFinder;
  public className: ElementArrayFinder;
  public selectAllClassBtn: ElementFinder;
  public clearAllClassBtn: ElementFinder;
  public miscClassRight: ElementArrayFinder;
  public ignoreToggleButton: ElementFinder;
  public unmatchedToggleButton: ElementFinder;
  public uncalledToggleButton: ElementFinder;
  public timeToRemainBox: ElementFinder;
  public timeToAppearBeforeBox: ElementFinder;
  public trainsListConfigTabs: ElementArrayFinder;
  public tabSectionHeader: ElementFinder;
  constructor() {
    this.classHeader = element(by.css('#miscTabContent .punctuality-header'));
    this.classToggle = element.all(by.css('.misc-table .toggle-switch >span:nth-child(3)'));
    this.className = element.all(by.css('.misc-table td:nth-child(1)'));
    this.selectAllClassBtn = element(by.id('selectAllClasses'));
    this.clearAllClassBtn = element(by.id('clearAllClasses'));
    this.miscClassRight = element.all(by.css('.misc-div-container>div>div:nth-child(1)'));
    this.ignoreToggleButton = element(by.css('#ignorePdCancel-toggle-menu>label>span:nth-child(3)'));
    this.unmatchedToggleButton = element(by.css('#unmatched-toggle-menu>label>span:nth-child(3)'));
    this.uncalledToggleButton = element(by.css('#uncalled-toggle-menu>label>span:nth-child(3)'));
    this.timeToRemainBox = element(by.id('timeToRemain'));
    this.timeToAppearBeforeBox = element(by.id('timeToAppearBefore'));
    this.trainsListConfigTabs = element.all(by.css('#v-pills-tab li'));
    this.tabSectionHeader = element(by.css('.column-header.section-name'));
  }

  public async getTrainMiscClassHeader(): Promise<string> {
    return this.classHeader.getText();
  }

  public async getTrainMiscClassName(index: number): Promise<string> {
    return this.className.get(index).getText();
  }

  public async getTrainMiscClassToggle(index: number): Promise<string> {
    return this.classToggle.get(index).getText();
  }

  public async toggleClassOn(itemName: string): Promise<void> {
    const elm: ElementFinder = element(by.xpath(`//tr[.//text()='${itemName}'] //span[@class='absolute-off']`));
    await CommonActions.waitAndClick(elm);
  }
  public async selectAllButton(): Promise<void> {
    return this.selectAllClassBtn.click();
  }
  public async clearAllButton(): Promise<void> {
    return this.clearAllClassBtn.click();
  }
  public async getTrainMiscClassNameRight(index: number): Promise<string> {
    return this.miscClassRight.get(index).getText();
  }
  public async getIgnoreToggleState(): Promise<string> {
    return this.ignoreToggleButton.getText();
  }
  public async clickIgnoreToggle(): Promise<void> {
    return this.ignoreToggleButton.click();
  }
  public async getUnmatchedToggleState(): Promise<string> {
    return this.unmatchedToggleButton.getText();
  }
  public async clickUnmatchedToggle(): Promise<void> {
    return this.unmatchedToggleButton.click();
  }
  public async getUncalledToggleState(): Promise<string> {
    return this.uncalledToggleButton.getText();
  }
  public async clickUncalledToggle(): Promise<void> {
    return this.uncalledToggleButton.click();
  }
  public async getTimeToRemain(): Promise<string> {
    return this.timeToRemainBox.getAttribute('value');
  }
  public async clickTimeToRemain(): Promise<void> {
    return this.timeToRemainBox.click();
  }
  public async getTimeToAppearBefore(): Promise<string> {
    return this.timeToAppearBeforeBox.getAttribute('value');
  }
  public async clickTimeToAppearBefore(): Promise<void> {
    return this.timeToAppearBeforeBox.click();
  }
  public async setTimeToAppearBefore(val: string): Promise<void> {
    return browser.executeScript('document.getElementById(\'timeToAppearBefore\').value = ' + val + ';');
  }
  public async getTrainsListConfigTabNames(): Promise<any> {
    await CommonActions.waitForElementToBeVisible(this.trainsListConfigTabs.first());
    return this.trainsListConfigTabs.getText();
  }
  public async getTabSectionHeader(): Promise<string> {
    return CommonActions.waitAndGetText(this.tabSectionHeader);
  }
  public async getTrainMiscClassNameToggleValuesRight(label: string): Promise<string> {
    return CommonActions.waitAndGetText(this.rightClassTableToggleRouter(label));
  }
  public async getTrainMiscClassNameNumberValuesRight(label: string): Promise<string> {
    return InputBox.waitAndGetTextOfInputBox(this.rightClassTableNumberRouter(label));
  }
  public rightClassTableToggleRouter(label: string): ElementFinder {
    let routeLocator: ElementFinder;
    switch (label) {
      case ('Ignore PD Cancels'):
        routeLocator = this.ignoreToggleButton;
        break;
      case ('Unmatched'):
        routeLocator = this.unmatchedToggleButton;
        break;
      case ('Uncalled'):
        routeLocator = this.uncalledToggleButton;
        break;
      default:
        throw new Error(`Please verify the feature file table at ${label}`);
    }
    return routeLocator;
  }
  public rightClassTableNumberRouter(label: string): ElementFinder {
    let routeLocator: ElementFinder;
    switch (label) {
      case ('Time to remain on list'):
        routeLocator = this.timeToRemainBox;
        break;
      case ('Appear before current time on list'):
        routeLocator = this.timeToAppearBeforeBox;
        break;
    }
    return routeLocator;
  }
}
