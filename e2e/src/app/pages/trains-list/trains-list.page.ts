import {browser, by, element, ElementArrayFinder, ElementFinder, protractor} from 'protractor';
import {of} from 'rxjs';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';


export class TrainsListPageObject {
  public trainsListItems: ElementArrayFinder;
  public trainsListContextMenu: ElementFinder;
  public timeTableLink: ElementFinder;
  public trainsListContextMenuItems: ElementArrayFinder;
  public trainServiceCriteria: ElementFinder;
  public trainServiceEntity: ElementFinder;
  public trainLocationCriteria: ElementFinder;
  public locationDetail: ElementArrayFinder;
  public locationStop: ElementArrayFinder;
  public colourText: ElementArrayFinder;
  public trainsListTableCols: ElementArrayFinder;
  public trainListSettingsBtn: ElementFinder;

  constructor() {
    this.trainsListItems = element.all(by.css('#train-tbody tr'));
    this.trainsListContextMenu = element(by.id('trainlistcontextmenu'));
    this.timeTableLink = element(by.css('#trainlistcontextmenu >li:nth-child(2)'));
    this.trainsListContextMenuItems = element.all(by.css('.dropdown-item'));
    this.trainServiceCriteria = element(by.css('.selection-criteria-entry-divider >div:nth-child(3)>div>h6'));
    this.trainServiceEntity = element(by.css('.selection-criteria-entry-divider >div:nth-child(3)'));
    this.trainLocationCriteria = element(by.css('.col-sm-4>div>div>div>h6'));
    this.locationDetail = element.all(by.css('.selection-criteria-entry-row .col-sm-7'));
    this.locationStop = element.all(by.css('.selection-criteria-entry-row .col-sm-5'));
    this.colourText = element.all(by.css('.indication-div-container input[class*=punctuality-colour]'));
    this.trainsListTableCols = element.all(by.css('#trainList th[id^=tmv-train-table-header] span:nth-child(1)'));
    this.trainListSettingsBtn = element(by.css('#settings-menu-button'));
  }

  public async getTrainsListEntryColValues(scheduleId: string): Promise<string[]> {
    const entryColValues: ElementArrayFinder = element.all(by.css('#trains-list-row-' + scheduleId + ' td'));
    return entryColValues.map((colValue: ElementFinder) => {
      return colValue.getText();
    });
  }

  public async getTrainsListCols(): Promise<string[]> {
    const colValues: ElementArrayFinder = element.all(by.css('.trains-list-table-header > th'));
    return colValues.map((colValue: ElementFinder) => {
      return colValue.getText();
    });
  }

  public async getTrainsListColHeaders(): Promise<any> {
    await CommonActions.waitForElementToBeVisible(this.trainsListTableCols.first());
    return this.trainsListTableCols.getText();
  }

  public async getTrainsListColHeaderByIndex(index: number): Promise<string> {
    const indexForCss = index + 1;
    const elm: ElementFinder = element(by.css(`#trainList th:nth-child(${indexForCss})[id^=tmv-train-table-header] span:nth-child(1)`));
    return CommonActions.waitAndGetText(elm);
  }

  public async getTrainsListColHeaderCount(): Promise<any> {
    await CommonActions.waitForElementToBeVisible(this.trainsListTableCols.first());
    return this.trainsListTableCols.count();
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

  public async clickTrainListSettingsBtn(): Promise<void> {
    return CommonActions.waitAndClick(this.trainListSettingsBtn);
  }
  public async isScheduleVisible(scheduleId: string): Promise<boolean> {
    browser.wait(async () => {
      return element(by.css('#trains-list-row-' + scheduleId)).isPresent();
    }, browser.displayTimeout, 'The schedule should be displayed');
    const trainScheduleId: ElementFinder = element(by.css('#trains-list-row-' + scheduleId));
    return trainScheduleId.isPresent();
  }
  public async getTrainsListRowColFill(scheduleId: string): Promise<string> {
    const trainDescriptionEntry: ElementFinder = element(by.css('#trains-list-row-' + scheduleId));
    const backgroundColour: string = await trainDescriptionEntry.getCssValue('background-color');

    const oddRowDefaultBackgroundColour = 'rgba(44, 44, 44, 1)';
    const evenRowDefaultBackgroundColour = 'rgba(0, 0, 0, 0)';
    return of(backgroundColour !== oddRowDefaultBackgroundColour && backgroundColour !== evenRowDefaultBackgroundColour
      ? backgroundColour : '').toPromise();
  }

  public async getTrainsListTrainDescriptionEntryColFill(scheduleId: string): Promise<string> {
    const trainDescriptionEntry: ElementFinder = element(by.css('#trains-list-row-entry-train-description-' + scheduleId));
    return trainDescriptionEntry.getCssValue('background-color');
  }
}
