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
  public matchUnmatchLink: ElementFinder;
  public primarySortCol: ElementFinder;
  public secondarySortCol: ElementFinder;

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
    this.matchUnmatchLink = element(by.css('#match-unmatch-selection-item'));

    this.primarySortCol = element(by.css('.primary-sort-header'));
    this.secondarySortCol = element(by.css('.secondary-sort-header'));
  }

  public async getTrainsListEntryColValues(scheduleId: string): Promise<string[]> {
    const entryColValues: ElementArrayFinder = element.all(by.css('#trains-list-row-' + scheduleId + ' td'));
    return entryColValues.map((colValue: ElementFinder) => {
      return colValue.getText();
    });
  }


  public async getTrainsListValuesForRow(row: number): Promise<string[]> {
    const rowStr: string = row.toString();
    const values: ElementArrayFinder = element.all(by.css('#train-tbody tr:nth-child(' + rowStr + ') td'));
    return values.map((colValue: ElementFinder) => {
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

  public async getColIndex(colText: string): Promise<number> {
    const cols = await this.getTrainsListCols();
    const colsNoArrows = cols.map(item => item.replace('arrow_downward', '')
      .replace('arrow_upward', ''));

    const colStructure = colText.split('>', 2).map(item => item.trim());
    if (colStructure.length === 1) {
      return colsNoArrows.indexOf(colStructure[0]);
    }
    else {
      const parentColIndex = colsNoArrows.indexOf(colStructure[0]);
      return colsNoArrows.indexOf(colStructure[1], parentColIndex);
    }
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

  public async getTrainsListContextMenuItem(rowIndex: number): Promise<string> {
    return this.trainsListContextMenuItems.get(rowIndex - 1).getText();
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

  public async clickTrainListSettingsBtn(): Promise<void> {
    return CommonActions.waitAndClick(this.trainListSettingsBtn);
  }
  public async openManualMatch(): Promise<void> {
    return CommonActions.waitAndClick(this.matchUnmatchLink);
  }
  public async isScheduleVisible(scheduleId: string): Promise<boolean> {
    browser.wait(async () => {
      return element(by.css('#trains-list-row-' + scheduleId)).isPresent();
    }, browser.displayTimeout, 'The schedule should be displayed');
    const trainScheduleId: ElementFinder = element(by.css('#trains-list-row-' + scheduleId));
    return trainScheduleId.isPresent();
  }

  public async isTrainVisible(serviceId: string, trainUId: string): Promise<boolean> {
    const timeToWaitForTrain = 50000;
    await CommonActions.waitForElementToBeVisible(element.all(by.css(`[id^='trains-list-row-']`)).first());
    const trainScheduleId: ElementFinder = element.all(by.cssContainingText(`[id^=trains-list-row-entry-train-description-${trainUId}`, `${serviceId}`)).first();
    try {
      await CommonActions.waitForElementToBePresent(trainScheduleId, timeToWaitForTrain, `The Schedule is not displayed in first ${timeToWaitForTrain} milliseconds`);
    } catch (err) {
      await CommonActions.waitForElementToBePresent(trainScheduleId, timeToWaitForTrain, 'The Schedule is not displayed');
    }
    return trainScheduleId.isPresent();
  }

  public async getRowForSchedule(scheduleId: string): Promise<number> {
    const schedules = await this.getTrainsListValuesForColumn('train-description');
    return schedules.indexOf(scheduleId);
  }

  public async trainDescriptionHasScheduleType(trainDescription: string, scheduleType: string): Promise<boolean> {
    return browser.wait(async () => {
      try {
        const trainDescriptions = await this.getTrainsListValuesForColumn('train-description');
        const scheduleTypes = await this.getTrainsListValuesForColumn('schedule-type');
        for (let i = 0; i < trainDescriptions.length; i++)
        {
          if (trainDescriptions[i] === trainDescription && scheduleTypes[i] === scheduleType)
          {
            return true;
          }
        }
        return false;
      }
      catch (error) {
        if (error.name === 'StaleElementReferenceError')
        {
          // whilst checking, we may get a stale element as the row is dynamic, we will just try again
          return false;
        }
      }
    }, browser.displayTimeout, 'Cound not find train description with schedule type ${scheduleType}');
  }

  public async trainDescriptionHasDisappeared(trainDescription: string): Promise<boolean> {
    try {
      const trainRow: ElementFinder = element(by.css('#trains-list-row-' + trainDescription));
      await browser.wait(async () => {
        return !(await trainRow.isPresent());
      }, browser.displayTimeout, 'The train description did not disappear');
      return !(await trainRow.isPresent());
    }
    catch (error) {
      if (error.name === 'StaleElementReferenceError')
      {
        // whilst checking, we may get a stale element as the train has been removed, this is good so just return
        return true;
      }
    }
  }

  public async trainDescriptionWithScheduleTypeHasDisappeared(trainDescription: string, scheduleType: string): Promise<boolean> {
    return browser.wait(async () => {
      try {
        const trainDescriptions = await this.getTrainsListValuesForColumn('train-description');
        const scheduleTypes = await this.getTrainsListValuesForColumn('schedule-type');
        for (let i = 0; i < trainDescriptions.length; i++)
        {
          if (trainDescriptions[i] === trainDescription && scheduleTypes[i] === scheduleType)
          {
            return false;
          }
        }
        return true;
      }
      catch (error) {
        if (error.name === 'StaleElementReferenceError')
        {
          // whilst checking, we may get a stale element as the row is dynamic, so must have disappeared
          return true;
        }
      }
    }, browser.displayTimeout, 'Train description with schedule type ${scheduleType} did not disappear');
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

  public async getTrainsListValuesForColumn(column: string): Promise<string[]> {
    const entryColValues: ElementArrayFinder = element.all(by.css('.trains-list-row-entry-' + column));
    return entryColValues.map((colValue: ElementFinder) => {
      return colValue.getText();
    });
  }
  public async getTrainsListIndicationColoursRgb(): Promise<string[]> {
    const rowEntries: ElementArrayFinder = element.all(by.css('tr[id^=trains-list-row]'));
    return rowEntries.map((colValue: ElementFinder) => {
      return colValue.getCssValue('background-color');
    });
  }
  public async getPrimarySortColumnNameAndArrow(): Promise<string> {
    return this.primarySortCol.getText();
  }
  public async getSecondarySortColumnNameAndArrow(): Promise<string> {
    return this.secondarySortCol.getText();
  }
  public async clickHeaderText(header: string): Promise<void> {
    const testColIndex = await this.getColIndex(header) + 1;
    const testColString = testColIndex.toString();
    const elm: ElementFinder = element(by.css('#tmv-train-table-header-config-' + testColString + ' span:nth-child(1)'));
    return CommonActions.waitAndClick(elm);
  }
  public async clickHeaderArrow(header: string): Promise<void> {
    const testColIndex = await this.getColIndex(header) + 1;
    const testColString = testColIndex.toString();
    const elm: ElementFinder = element(by.css('#tmv-train-table-header-config-' + testColString + ' span:nth-child(2))'));
    return CommonActions.waitAndClick(elm);
  }

}
