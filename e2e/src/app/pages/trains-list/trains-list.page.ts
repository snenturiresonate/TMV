import {browser, by, element, ElementArrayFinder, ElementFinder, protractor} from 'protractor';
import {of} from 'rxjs';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';
import {RedisClient} from '../../api/redis/redis-client';
import {NFRConfig} from '../../config/nfr-config';
import {CucumberLog} from '../../logging/cucumber-log';


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
  public paginationPrevious: ElementFinder;
  public paginationNext: ElementFinder;

  private redisClient: RedisClient;

  // towards the end of the day, trains take a long time to appear on the trains list
  private trainsListDisplayTimeout = browser.params.general_timeout;

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
    this.matchUnmatchLink = element(by.id('match-unmatch-selection-item'));
    this.primarySortCol = element(by.css('.primary-sort-header'));
    this.secondarySortCol = element(by.css('.secondary-sort-header'));
    this.paginationPrevious = element(by.id('trains-list-pagination-previous'));
    this.paginationNext = element(by.id('trains-list-pagination-next'));
    this.redisClient = new RedisClient();
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
    await browser.wait(async () => {
      return element(by.id('train-tbody')).isPresent();
    }, browser.params.general_timeout, 'The trains list table should be displayed');

    return element(by.id('train-tbody')).isPresent();
  }
  public async waitForContextMenu(): Promise<boolean> {
    await browser.wait(async () => {
      return this.trainsListContextMenu.isPresent();
    }, browser.params.general_timeout, 'The trains list context menu should be displayed');
    return this.trainsListContextMenu.isPresent();
  }
  public async rightClickTrainListItemNum(position: number): Promise<void> {
    const rows = this.trainsListItems;
    const targetRow = rows.get(position - 1);
    browser.actions().click(targetRow, protractor.Button.RIGHT).perform();
  }
  public async rightClickTrainListItem(scheduleString: string): Promise<void> {
    const trainScheduleId: ElementFinder = element(by.css('[id=\'trains-list-row-' + scheduleString + '\''));
    browser.actions().click(trainScheduleId, protractor.Button.RIGHT).perform();
  }
  public async leftClickTrainListItemNum(position: number): Promise<void> {
    const rows = this.trainsListItems;
    const targetRow = rows.get(position - 1);
    browser.actions().click(targetRow, protractor.Button.LEFT).perform();
  }
  public async leftClickHeadcodeOnTrainListItem(scheduleString: string): Promise<void> {
    const trainScheduleId: ElementFinder = element(by.css('[id=\'trains-list-row-entry-train-description-' + scheduleString + '\''));
    browser.actions().click(trainScheduleId, protractor.Button.LEFT).perform();
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
    await browser.wait(async () => {
      return element(by.css('[id=\'trains-list-row-' + scheduleId + '\'')).isPresent();
    }, browser.params.general_timeout, 'The schedule should be displayed');
    const trainScheduleId: ElementFinder = element(by.css('[id=\'trains-list-row-' + scheduleId + '\''));
    return trainScheduleId.isPresent();
  }

  public async isTrainVisible(serviceId: string, trainUId: string, timeToWaitForTrain = this.trainsListDisplayTimeout): Promise<boolean> {
    try {
      await CommonActions.waitForElementToBeVisible(element.all(by.css(`[id^='trains-list-row-']`)).first(), timeToWaitForTrain);
      const trainScheduleId: ElementFinder =
        element.all(
          by.cssContainingText(`[id^=\'trains-list-row-entry-train-description-${trainUId}\'`, `${serviceId}`)).first();
      await CommonActions.waitForElementToBePresent(trainScheduleId, timeToWaitForTrain, `The Schedule is not displayed in first ${timeToWaitForTrain} milliseconds`);
    } catch (err) {
      return false;
    }
    return true;
  }

  public async getRowForSchedule(scheduleId: string): Promise<number> {
    const schedules = await this.getTrainsListValuesForColumn('train-description');
    return schedules.indexOf(scheduleId);
  }

  public async removeAllTrainsFromTrainsList(): Promise<void> {
    const trainslistRowKeys: string[] = await this.redisClient.listKeys('trainlist*');
    for (const rowKey of trainslistRowKeys) {
      await this.redisClient.keyDelete(rowKey);
    }
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
    }, this.trainsListDisplayTimeout, 'Could not find train description with schedule type ${scheduleType}');
  }

  public async columnsAre(expectedColHeaders: string[]): Promise<boolean> {
    const expectedNoOfCols = expectedColHeaders.length;

    return browser.wait(async () => {
      const actualColHeaders = await this.getTrainsListColHeaders();
      for (let i = 0; i < expectedNoOfCols; i++)
      {
        if (actualColHeaders[i] !== expectedColHeaders[i])
        {
          const msg = `${actualColHeaders[i]} is not equal to ${expectedColHeaders[i]}`;
          console.log(msg);
          await CucumberLog.addText(msg);
          return false;
        }
      }
      return true;
      }, browser.params.quick_timeout, 'Columns have not updated to reflect config changes');
   }

  public async trainDescriptionHasDisappeared(trainDescription: string): Promise<boolean> {
    try {
      const trainRow: ElementFinder = element(by.css('#trains-list-row-' + trainDescription));
      await browser.wait(async () => {
        return !(await trainRow.isPresent());
      }, browser.params.general_timeout, 'The train description did not disappear');
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
    }, browser.params.general_timeout, 'Train description with schedule type ${scheduleType} did not disappear');
  }

  public async getTrainsListRowFillForSchedule(scheduleId: string): Promise<string> {
    const trainDescriptionEntry: ElementFinder = element(by.css(`[id^='trains-list-row-${scheduleId}']`));
    const backgroundColour: string = await trainDescriptionEntry.getCssValue('background-color');
    const oddRowDefaultBackgroundColour = 'rgba(44, 44, 44, 1)';
    const evenRowDefaultBackgroundColour = 'rgba(0, 0, 0, 0)';
    return of(backgroundColour !== oddRowDefaultBackgroundColour && backgroundColour !== evenRowDefaultBackgroundColour
      ? backgroundColour : '').toPromise();
  }

  public async getTrainsListRowFillForRow(rowNum: number): Promise<string> {
    const rows = new TrainsListPageObject().trainsListItems;
    const trainDescriptionEntry = rows.get(rowNum);
    const backgroundColour: string = await trainDescriptionEntry.getCssValue('background-color');
    const oddRowDefaultBackgroundColour = 'rgba(44, 44, 44, 1)';
    const evenRowDefaultBackgroundColour = 'rgba(0, 0, 0, 0)';
    return of(backgroundColour !== oddRowDefaultBackgroundColour && backgroundColour !== evenRowDefaultBackgroundColour
      ? backgroundColour : '').toPromise();
  }

  public async getTrainsListTrainDescriptionEntryColFillForSchedule(scheduleId: string): Promise<string> {
    const trainDescriptionEntry: ElementFinder = element(by.css('[id=\'trains-list-row-entry-train-description-' + scheduleId + '\']'));
    return trainDescriptionEntry.getCssValue('background-color');
  }

  public async getTrainsListTrainDescriptionEntryColFillForRow(rowNum: number): Promise<string> {
    const rows =  new TrainsListPageObject().trainsListItems;
    const trainDescriptionRow = rows.get(rowNum);
    const trainDescriptionEntry: ElementFinder = trainDescriptionRow.$('.trains-list-row-entry-train-description');
    return trainDescriptionEntry.getCssValue('background-color');
  }

  public async getTrainsListValuesForColumn(column: string): Promise<string[]> {
    const entryColValues: ElementArrayFinder = element.all(by.css('.trains-list-row-entry-' + column));
    return entryColValues.map((colValue: ElementFinder) => {
      return colValue.getText();
    });
  }

  public async getTrainsListSchedules(): Promise<string[]> {
    const rows: ElementArrayFinder = element.all(by.css(`[id^='trains-list-row-entry-train-description-']`));
    return rows.map(async (row: ElementFinder) => {
      const rowId: string = await row.getAttribute('Id');
      return rowId.slice(40);
    });
  }

  public async getTrainsListValuesForSchedule(scheduleId: string): Promise<string[]> {
    const entryRowValues: ElementArrayFinder = element.all(by.css('[id=\'trains-list-row-' + scheduleId + '\'] td'));
    return entryRowValues.map((rowValue: ElementFinder) => {
      return rowValue.getText();
    });
  }

  public async getTrainsListValuesForFirstScheduleWithDescription(trainDesc: string): Promise<string[]> {
    const rowNum = this.getRowForSchedule(trainDesc);
    const rows = this.trainsListItems;
    const targetRow = rows.get(rowNum);
    const entryRowValues: ElementArrayFinder = targetRow.$$(' td');
    return entryRowValues.map((rowValue: ElementFinder) => {
      return rowValue.getText();
    });
  }

  public async getTrainsListValueForColumnAndSchedule(column: string, scheduleId: string): Promise<string> {
    const gridElement: ElementFinder = element(by.css('[id=\'trains-list-row-' + scheduleId + '\'] .trains-list-row-entry-' + column));
    return gridElement.getText();
  }

  public async getTrainsListValueForColumnAndUnmatchedTrain(column: string, trainDesc: string): Promise<string> {
    const rowNum = this.getRowForSchedule(trainDesc);
    const rows = this.trainsListItems;
    const targetRow = rows.get(rowNum);
    const gridElement: ElementFinder = targetRow.$('.trains-list-row-entry-' + column);
    return gridElement.getText();
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
  public async clickHeaderTextForColumn(colNum: string): Promise<void> {
    const elm: ElementFinder = element(by.css('#tmv-train-table-header-config-' + colNum + ' span:nth-child(1)'));
    await CommonActions.waitAndClick(elm);
    await browser.sleep(NFRConfig.E2E_TRANSMISSION_TIME_MS);
  }
  public async clickHeaderArrowForColumn(colNum: string): Promise<void> {
    const elm: ElementFinder = element(by.css('#tmv-train-table-header-config-' + colNum + ' span:nth-child(2)'));
    await CommonActions.waitAndClick(elm);
    await browser.sleep(NFRConfig.E2E_TRANSMISSION_TIME_MS);
  }

}
