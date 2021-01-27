import {by, element, ElementArrayFinder, ElementFinder} from 'protractor';

export class BerthContextMenu {
  public berthContextMenu: ElementFinder;
  public berthName: ElementFinder;
  public signalName: ElementArrayFinder;

  constructor() {
    this.berthContextMenu = element(by.id('berthContextMenu'));
    this.berthName = element(by.id('berth-context-menu-berth-name'));
    this.signalName = element.all(by.xpath('//li[contains(@id, "berth-context-menu-signal")]//span'));
  }

  public async isDisplayed(): Promise<boolean> {
    return this.berthContextMenu.isPresent();
  }
}
