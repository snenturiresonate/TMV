import {browser, by, element, ElementFinder} from 'protractor';

export class ContinuationLinkContextMenu {
  public continuationLinkContextMenu: ElementFinder;
  public mapName: ElementFinder;
  public mapAbbreviation: ElementFinder;
  public open: ElementFinder;
  public openNewTab: ElementFinder;

  constructor() {
    this.continuationLinkContextMenu = element(by.id('linkedMapContextMenu'));
    this.mapName = element(by.id('linked-map-context-menu-map-name'));
    this.mapAbbreviation = element(by.id('linked-map-context-menu-map-abbreviation'));
    this.open = element(by.xpath('//span[text()="Open"]'));
    this.openNewTab = element(by.xpath('//span[text()="Open (new tab)"]'));
  }
  public async selectOpen(): Promise<void> {
    browser.wait(() => this.open.isPresent(), 10 * 1000);
    await this.open.click();
  }
  public async selectOpenNewTab(): Promise<void> {
    browser.wait(() => this.openNewTab.isPresent(), 10 * 1000);
    await this.openNewTab.click();
  }
  public async isDisplayed(): Promise<boolean> {
    return this.continuationLinkContextMenu.isPresent();
  }

}
