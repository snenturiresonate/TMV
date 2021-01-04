import {browser, by, element, ElementArrayFinder, ElementFinder, protractor} from 'protractor';

export class TrainsListPageObject {

  public trainsListContextMenu: ElementFinder;
  public trainsListItems: ElementArrayFinder;
  public timeTableLink: ElementFinder;
  constructor() {
    this.trainsListContextMenu = element(by.id('trainlistcontextmenu'));
    this.trainsListItems = element.all(by.css('#train-tbody tr'));
    this.timeTableLink = element(by.cssContainingText('#trainlistcontextmenu', 'Open timetable'));
  }

  public async isTrainsListTableVisible(): Promise<boolean> {
    browser.wait(async () => {
      return element(by.id('train-tbody')).isPresent();
    }, browser.displayTimeout, 'The trains list table should be displayed');
    return element(by.id('train-tbody')).isPresent();
  }

  public async isContextMenuVisible(): Promise<boolean> {
    return this.trainsListContextMenu.isPresent();
  }
  public async rightClickTrainListItem(position: number): Promise<void> {
    const rows = this.trainsListItems;
    const targetRow = rows.get(position - 1);
    browser.actions().click(targetRow, protractor.Button.RIGHT).perform();
  }

  public async waitForContextMenu(): Promise<boolean> {
    browser.wait(async () => {
      return this.trainsListContextMenu.isPresent();
    }, browser.displayTimeout, 'The trains list context menu should be displayed');
    return this.trainsListContextMenu.isPresent();
  }
}
