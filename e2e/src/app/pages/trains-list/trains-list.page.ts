import {browser, by, element, ElementArrayFinder, ElementFinder, protractor} from 'protractor';
import {of} from 'rxjs';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';
import {NFRConfig} from '../../config/nfr-config';
import {CucumberLog} from '../../logging/cucumber-log';
import {PostgresClient} from '../../api/postgres/postgres-client';
import {AccessPlanService} from '../../services/access-plan.service';
import {DateAndTimeUtils} from '../common/utilities/DateAndTimeUtils';
import {BackEndChecksService} from '../../services/back-end-checks.service';
import {TrainActivationService} from '../../services/train-activation.service';
import {TrainUIDUtils} from '../common/utilities/trainUIDUtils';

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
  public hiddenFilter: ElementFinder;
  public filterIcon: ElementFinder;
  public toggleMenu: ElementFinder;
  public trainsListToggleMenu: ElementFinder;
  public hiddenToggleOn: ElementFinder;
  public hiddenToggleOff: ElementFinder;
  public unhideAllTrainsMenuItem: ElementFinder;
  public findTrainSearchContext: ElementFinder;
  private hideOnce: ElementFinder;
  private hideAlways: ElementFinder;
  private unhideTrain: ElementFinder;
  private trainsListMenuButton: ElementFinder;
  private displayAllHiddenTrainsSlider: ElementFinder;
  private hideOnceGreyedOut: ElementFinder;

  private postgresClient: PostgresClient;

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
    this.postgresClient = new PostgresClient();
    this.hiddenFilter = element(by.css('.hidden-filter'));
    this.filterIcon = element(by.id('trains-list-filter-toggle-icon'));
    this.toggleMenu = element(by.id('trains-list-menu-button'));
    this.trainsListToggleMenu = element(by.css('.trains-list-toggle-div'));
    this.hiddenToggleOn = element(by.css('#hiddentoggle .toggle-switch .absolute-off'));
    this.hiddenToggleOff = element(by.css('#hiddentoggle .toggle-switch .absolute-on'));
    this.unhideAllTrainsMenuItem = element(by.id('unhide-all'));
    this.findTrainSearchContext = element(by.cssContainingText('span', 'Find Train'));
    this.hideOnce = element(by.cssContainingText('#hide-once-selection-item', 'Hide Once'));
    this.hideAlways = element(by.cssContainingText('#hide-always-selection-item', 'Hide Always'));
    this.unhideTrain = element(by.id('unhide-selection-item'));
    this.trainsListMenuButton = element(by.cssContainingText('#trains-list-menu-button', 'layers'));
    this.displayAllHiddenTrainsSlider = element(by.css('#hiddentoggle .toggle-switch'));
    this.hideOnceGreyedOut = element(by.cssContainingText('.disabled', 'Hide Once'));
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
    await CommonActions.waitForElementToBePresent(this.trainsListContextMenu);
    await CommonActions.waitForElementToBeVisible(this.trainsListContextMenu);
    return this.trainsListContextMenu.isDisplayed();
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
    await browser.actions().click(trainScheduleId, protractor.Button.LEFT).perform();
  }
  public async isTrainsListContextMenuDisplayed(): Promise<boolean> {
    return this.trainsListContextMenu.isPresent();
  }

  public async getTrainsListContextMenuItem(rowIndex: number): Promise<string> {
    return this.trainsListContextMenuItems.get(rowIndex - 1).getText();
  }

  public async getTrainsListContextMenuItemColor(rowIndex: number): Promise<string> {
    return this.trainsListContextMenuItems.get(rowIndex - 1).getCssValue('color');
  }

  public async getTrainsListContextMenuItemTextDecorationLine(rowIndex: number): Promise<string> {
    return this.trainsListContextMenuItems.get(rowIndex - 1).getCssValue('text-decoration-line');
  }

  public async hoverOverContextMenuRow(rowIndex: number): Promise<void> {
    await CommonActions.waitForElementInteraction(this.trainsListContextMenuItems.get(rowIndex - 1));
    await browser.actions().mouseMove(this.trainsListContextMenuItems.get(rowIndex - 1)).perform();
  }

  public async isHideOnceGreyedOut(): Promise<boolean> {
    return this.hideOnceGreyedOut.isDisplayed();
  }

  public async clickHideOnce(): Promise<void> {
    await this.hideOnce.click();
  }

  public async clickHideAlways(): Promise<void> {
    await this.hideAlways.click();
  }

  public async clickUnhideTrain(): Promise<void> {
    await this.unhideTrain.click();
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
    await this.postgresClient.clearAll();
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
    await CommonActions.waitForElementToBeVisible(trainDescriptionEntry);
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

  public async isFilterPresent(): Promise<boolean> {
    const filterIsHidden = await this.hiddenFilter.isPresent();
    return !filterIsHidden;
  }

  public async setFilterDisplay(requiredFilterState: string): Promise<void> {
    const filterIsHidden = await this.hiddenFilter.isPresent();
    if ((!filterIsHidden && (requiredFilterState === 'collapsed')) || (filterIsHidden && (requiredFilterState === 'expanded'))) {
      await CommonActions.waitAndClick(this.filterIcon);
    }
  }

  public async getMiscFilterItemValue(property: string): Promise<string> {
    const elm: ElementFinder = element(by.css(`#trains-list-filter-misc-${property}`));
    return elm.getText();
  }

  public async getOtherFilterItemValue(property: string): Promise<string> {
    const settingsBoxElement: ElementFinder = await element(by.cssContainingText('.selection-criteria-entry-box', property));
    const settingsBoxContentsElements: ElementArrayFinder = await settingsBoxElement.element(by.css('.selection-criteria-entry-row'));
    return settingsBoxContentsElements.getText();
  }

  public async clickToggleMenu(): Promise<void> {
    await this.toggleMenu.click();
  }

  public async isToggleMenuVisible(): Promise<boolean> {
    return this.trainsListToggleMenu.isPresent();
  }

  public async hiddenToggleState(): Promise<boolean> {
    return this.hiddenToggleOn.isPresent();
  }
  public async toggleHiddenOn(): Promise<void> {
    await this.hiddenToggleOn.click();
  }

  public async toggleHiddenOff(): Promise<void> {
    await this.hiddenToggleOff.click();
  }

  public async clickHideOnceSubmenuItem(): Promise<void> {
    await this.hideOnce.click();
  }

  public async clickHideAlwaysSubmenuItem(): Promise<void> {
    await this.hideAlways.click();
  }

  public async clickUnhideMenuItem(): Promise<void> {
    await this.unhideTrain.click();
  }

  public async isHideOnceSubmenuItemDisabled(): Promise<boolean> {
    return !this.hideOnce.isEnabled();
  }

  public async clickUnhideAllTrains(): Promise<void> {
    await this.unhideAllTrainsMenuItem.click();
  }

  public async isUnhideAllTrainsMenuItemVisible(): Promise<boolean> {
    return this.unhideAllTrainsMenuItem.isPresent();
  }

  public async getTrainsListHiddenIcon(scheduleId: string): Promise<string> {
    if (scheduleId === 'generatedTrainUId' || scheduleId === 'generated') {
      scheduleId = browser.referenceTrainUid;
    }
    const todaysScheduleString = scheduleId + '\\:' + DateAndTimeUtils.convertToDesiredDateAndFormat('today', 'yyyy-MM-dd');
    const trainDescriptionEntry: ElementFinder =
      element(by.css('#trains-list-row-entry-train-description-' + todaysScheduleString + ' #hidden-icon'));
    const isPresent: boolean = await trainDescriptionEntry.isPresent();
    if (!isPresent) {
      return '';
    }
    return trainDescriptionEntry.getAttribute('src');
  }

  public async hoverOverContextMenuMapsLink(): Promise<void> {
    await CommonActions.waitForElementInteraction(this.findTrainSearchContext);
    await browser.actions().mouseMove(this.findTrainSearchContext).perform();
  }

  public async openMap(mapName: string): Promise<void> {
    await this.hoverOverContextMenuMapsLink();
    const mapLink = element(by.xpath(`//li//span[text() = '${mapName}']`));
    await CommonActions.waitAndClick(mapLink);
  }


  public async clickTrainsListMenuButton(): Promise<void> {
    return this.trainsListMenuButton.click();
  }

  public async clickDisplayAllHiddenTrainsSlider(): Promise<void> {
    await CommonActions.waitForElementInteraction(this.displayAllHiddenTrainsSlider);
    return this.displayAllHiddenTrainsSlider.click();
  }

  public async generateTrains(numberOfTrains: number): Promise<void> {
    for (let i = 0; i < numberOfTrains; i++) {
      // generate train details and store for later
      browser.referenceTrainDescription = await TrainUIDUtils.generateTrainDescription();
      browser.referenceTrainUid = await TrainUIDUtils.generateUniqueTrainUid();
      console.log(`Generating train: ${browser.referenceTrainDescription}, ${browser.referenceTrainUid}`);

      // send CIF
      const cifInputs =
        JSON.parse(
          `
        {
          "filePath": "access-plan/1D46_PADTON_OXFD.cif",
          "refLocation": "PADTON",
          "refTimingType": "WTT_dep",
          "newTrainDescription": "generated",
          "newPlanningUid": "generated"
        }
      `
        );
      await AccessPlanService.processCifInputsAndSubmit(cifInputs, i);

      // wait for CIF to load
      const date: string = await DateAndTimeUtils.getCurrentDateTimeString('yyyy-MM-dd');
      await BackEndChecksService.waitForTrainUid('generated', date);

      // send activation
      const trainActivationMessages =
        JSON.parse(
          `
            [
              {
                "trainUID": "generated",
                "trainNumber": "generated",
                "actualDepartureHour": "now",
                "scheduledDepartureTime": "now",
                "locationPrimaryCode": "99999",
                "locationSubsidiaryCode": "PADTON",
                "departureDate": "today"
              }
            ]
          `
        );
      await TrainActivationService.processTrainActivationMessagesAndSubmit(trainActivationMessages);
    }
  }
}
