import {browser, by, element, ElementArrayFinder, ElementFinder, protractor} from 'protractor';
import {of} from 'rxjs';


export class TrainsListPageObject {
  public trainsListItems: ElementArrayFinder;
  public trainsListContextMenu: ElementFinder;
  public timeTableLink: ElementFinder;
  constructor() {
    this.trainsListItems = element.all(by.css('#train-tbody tr'));
    this.trainsListContextMenu = element(by.id('trainlistcontextmenu'));
    this.timeTableLink = element(by.css('#trainlistcontextmenu >li:nth-child(2)'));
  }
  public async isTrainsListTableVisible(): Promise<boolean> {
    browser.wait(async () => {
      return element(by.id('train-tbody')).isPresent();
    }, browser.displayTimeout, 'The trains list table should be displayed');

    return element(by.id('train-tbody')).isPresent();
  }
  public async waitForContextMenu(): Promise<boolean> {
    browser.wait(async () => {
      return this.trainsListContextMenu.isPresent();
    }, browser.displayTimeout, 'The trains list context menu should be displayed');
    return this.trainsListContextMenu.isPresent();
  }
  public async rightClickTrainListItem(position: number): Promise<void> {
    const rows = this.trainsListItems;
    const targetRow = rows.get(position - 1);
    browser.actions().click(targetRow, protractor.Button.RIGHT).perform();
  }
  public async isTrainsListContextMenuDisplayed(): Promise<boolean> {
    return this.trainsListContextMenu.isPresent();
  }
}
