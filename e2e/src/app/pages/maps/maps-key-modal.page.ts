import {by, element, ElementArrayFinder, ElementFinder} from 'protractor';

export class MapsKeyPageObject {
  public keyTabs: ElementArrayFinder;
  public colourTab: ElementFinder;
  public symbolTab: ElementFinder;
  public tdTab: ElementFinder;
  public activeTab: ElementFinder;
  public closeButton: ElementFinder;
  public closeButtonX: ElementFinder;
  public tdEntries: ElementArrayFinder;
  public modalWindow: ElementFinder;
  public keyPunctualityEntries: ElementArrayFinder;
  public keyBerthEntries: ElementArrayFinder;

  constructor() {
    this.keyTabs = element.all(by.css('.tmv-tabs li'));
    this.colourTab = element(by.id('punctuality'));
    this.symbolTab = element(by.id('symbol'));
    this.tdTab = element(by.id('describer'));
    this.activeTab = element(by.css('.tmv-tab-active'));
    this.closeButton = element(by.css('.tmv-btn-cancel'));
    this.closeButtonX = element(by.css('.closemodal material-icons'));
    this.tdEntries = element.all(by.css('#trainDescriberTable tr'));
    this.modalWindow = element(by.css('.modalpopup'));
    this.keyPunctualityEntries = element.all(by.css('.key-punctuality-entry'));
    this.keyBerthEntries = element.all(by.css('.key-berth-entry'));
  }

  public async getKeyTabNames(): Promise<string> {
    return this.keyTabs.getText();
  }

  public async openColourTab(): Promise<void> {
    return this.colourTab.click();
  }

  public async openSymbolTab(): Promise<void> {
    return this.symbolTab.click();
  }

  public async openTDTab(): Promise<void> {
    return this.tdTab.click();
  }

  public async getTDlist(): Promise<string> {
    return this.tdEntries.getText();
  }

  public async getLineStatuses(): Promise<string> {
    const lineStatuses: ElementArrayFinder = element.all(by.css('.line-status-table-entry-text'));
    return lineStatuses.getText();
  }

  public async getLinesideFeatures(): Promise<string> {
    const linesideFeatures: ElementArrayFinder = element.all(by.css('.lineside-feature-table-entry-text'));
    return linesideFeatures.getText();
  }

  public async closeTMVKey(): Promise<void> {
    return this.closeButton.click();
  }

  public async closeTMVKeyX(): Promise<void> {
    return this.closeButton.click();
  }

  public async getModalWindow(): Promise<boolean> {
    return this.modalWindow.isPresent();
  }

  public async getActiveTabName(): Promise<string> {
    return this.activeTab.getText();
  }

  public async getKeyTableColumnNames(): Promise<string> {
    return element.all(by.css('.tmv-tab-content-active th')).getText();
  }

  public async getKeyPunctualityText(index: number): Promise<string> {
    return this.keyPunctualityEntries.get(index).getText();
  }

  public async getKeyPunctualityPropertyValue(index: number, property: string): Promise<string> {
    return this.keyPunctualityEntries.get(index).getCssValue(property);
  }

  public async getKeyBerthText(index: number): Promise<string> {
    return this.keyPunctualityEntries.get(index).getText();
  }

  public async getKeyBerthPropertyValue(index: number, property: string): Promise<string> {
    const keyPunctualityEntries: ElementArrayFinder = element.all(by.css('.key-berth-entry'));
    return keyPunctualityEntries.get(index).getCssValue(property);
  }
}
