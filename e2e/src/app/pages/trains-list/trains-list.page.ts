import {browser, by, element, ElementArrayFinder, ElementFinder, protractor} from 'protractor';
import {of} from 'rxjs';


export class TrainsListPageObject {
  public trainListCriteria: ElementFinder;
  public filterIcon: ElementFinder;
  public firstRefEntityContent: ElementFinder;
  public secondRefEntityContent: ElementFinder;
  public thirdRefEntityContent: ElementFinder;
  public trainsListItems: ElementArrayFinder;
  public trainsListContextMenu: ElementFinder;
  public trainsListContextMenuItems: ElementArrayFinder;
  public trainServiceCriteria: ElementFinder;
  public trainServiceEntity: ElementFinder;
  public trainLocationCriteria: ElementFinder;
  public locationDetail: ElementArrayFinder;
  public locationStop: ElementArrayFinder;
  public colourText: ElementArrayFinder;

  constructor() {
    this.filterIcon  = element(by.css('.tmv-filter >div >span'));
    this.trainListCriteria  = element(by.css('.selection-criteria-entry-divider >div:nth-child(2)>div>h6'));
    this.filterIcon  = element(by.css('.tmv-filter >div >span'));
    this.firstRefEntityContent = element(by.css('.selection-criteria-entry-box-results> p:nth-child(1)'));
    this.secondRefEntityContent = element(by.css('.selection-criteria-entry-box-results> p:nth-child(2)'));
    this.thirdRefEntityContent = element(by.css('.selection-criteria-entry-box-results> p:nth-child(3)'));
    this.trainsListItems = element.all(by.css('#train-tbody tr'));
    this.trainsListContextMenu = element(by.id('trainlistcontextmenu'));
    this.trainsListContextMenuItems = element.all(by.css('.dropdown-item'));
    this.trainServiceCriteria = element(by.css('.selection-criteria-entry-divider >div:nth-child(3)>div>h6'));
    this.trainServiceEntity = element(by.css('.selection-criteria-entry-divider >div:nth-child(3)'));
    this.trainLocationCriteria = element(by.css('.col-sm-4>div>div>div>h6'));
    this.locationDetail = element.all(by.css('.selection-criteria-entry-row .col-sm-7'));
    this.locationStop = element.all(by.css('.selection-criteria-entry-row .col-sm-5'));
    this.colourText = element.all(by.css('.indication-div-container input[class*=punctuality-colour]'));

  }

  public async getTrainsListEntryColValues(scheduleId: string): Promise<string[]> {
    const entryColValues: ElementArrayFinder = element.all(by.css('#trains-list-row-' + scheduleId + ' td'));
    return entryColValues.map((colValue: ElementFinder) => {
      return colValue.getText();
    });
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

  public async getTrainsListCols(): Promise<string[]> {
    const colValues: ElementArrayFinder = element.all(by.css('.trains-list-table-header > th'));
    return colValues.map((colValue: ElementFinder) => {
      return colValue.getText();
    });
  }

  public async isTrainsListTableVisible(): Promise<boolean> {
    browser.wait(async () => {
      return element(by.id('train-tbody')).isPresent();
    }, browser.displayTimeout, 'The trains list table should be displayed');

    return element(by.id('train-tbody')).isPresent();
  }
  public async getFilterValue(): Promise<string> {
    const filter: ElementFinder = element(by.css('.inline-header:nth-child(2)'));
    return filter.getText();
  }

  public async isPaginationControlVisible(pageNumber: number): Promise<boolean> {
    return element(by.id('train-list-pagination-' + pageNumber.toString())).isPresent();
  }

  public async increaseTrainsListPageNumber(): Promise<void> {
    await element(by.id('trainsListPaginationNext')).click();
  }

  public async decreaseTrainsListPageNumber(): Promise<void> {
    await element(by.id('trainsListPaginationPrevious')).click();
  }

  public async isPaginationControlActive(pageNumber: number): Promise<boolean> {
    const classNames: string = await element(by.css('#activePage')).getAttribute('class');
    return classNames.indexOf('active') > -1;
  }

  public async isTrainListCriteriaDisplayed(): Promise<boolean> {
    return this.trainListCriteria.isDisplayed();
  }

  public async getMiscSelectionCriteriaFieldText(cssFieldName: string): Promise<string> {
    return element(by.id('trains-list-filter-misc-' + cssFieldName)).getText();
  }

  public async clickFilterIcon(): Promise<void> {
    await this.filterIcon.click();
  }

  public async getTrainUserPrefValue(): Promise<string> {
    return this. trainListCriteria.getText();
  }

  public async getTrainServiceValue(): Promise<string> {
    return this. trainServiceCriteria.getText();
  }

  public async getTrainLocationValue(): Promise<string> {
    return this. trainLocationCriteria.getText();
  }

  public async getTrainLocationName(): Promise<string> {
    return this.locationDetail.getText();
  }

  public async getTrainLocationStops(): Promise<string> {
    return this.locationStop.getText();
  }


  public async getServiceEntity(): Promise<string> {
    return this. trainServiceEntity.getText();
  }

  public async getFirstReferenceEntity(): Promise<string> {
    return this. firstRefEntityContent.getText();
  }

  public async getSecondReferenceEntity(): Promise<string> {
    return this. secondRefEntityContent.getText();
  }

  public async getThirdReferenceEntity(): Promise<string> {
    return this. thirdRefEntityContent.getText();
  }

  public async getTrainsListContextMenuItem(rowIndex: number): Promise<string> {
    return this.trainsListContextMenuItems.get(rowIndex - 1).getText();
  }

  public async waitForContextMenu(): Promise<boolean> {
    browser.wait(async () => {
      return this.trainsListContextMenu.isPresent();
    }, browser.displayTimeout, 'The trains list context menu should be displayed');
    return this.trainsListContextMenu.isPresent();
  }

  public async isContextMenuVisible(): Promise<boolean> {
    return this.trainsListContextMenu.isPresent();
  }

  public async rightClickTrainListItem(position: number): Promise<void> {
    const rows = this.trainsListItems;
    const targetRow = rows.get(position - 1);
    browser.actions().click(targetRow, protractor.Button.RIGHT).perform();
  }

  public async getScheduleValuesForRow(row: number): Promise<string[]> {
    const rowStr: string = row.toString();
    const values: ElementArrayFinder = element.all(by.css('#train-tbody tr:nth-child(' + rowStr + ') td'));
    return values.map((colValue: ElementFinder) => {
      return colValue.getText();
    });
  }

  public async getCountOfPredictedTimesForRow(row: number): Promise<number> {
    const rowStr: string = row.toString();
    const predictedValues: ElementArrayFinder = element.all(by.css('#train-tbody tr:nth-child(' + rowStr + ') td .predicted-data'));
    return predictedValues.count();
  }

  public async getCountOfPredictedTimesForContext(): Promise<number> {
    const predictedValues: ElementArrayFinder = element.all(by.css('li .predicted-data'));
    return predictedValues.count();
  }
}
