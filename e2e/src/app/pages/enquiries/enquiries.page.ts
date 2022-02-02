import {browser, by, element, ElementArrayFinder, ElementFinder, protractor} from 'protractor';
import {CucumberLog} from '../../logging/cucumber-log';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';
import {InputBox} from '../common/ui-element-handlers/inputBox';

export class EnquiriesPageObject {
  public mapSearchBox: ElementFinder;
  public mapAutoSuggestSearchResults: ElementArrayFinder;
  public viewButton: ElementFinder;
  public trainsListTableCols: ElementArrayFinder;
  public trainsListItems: ElementArrayFinder;
  public trainsListContextMenu: ElementFinder;
  public trainsListContextMenuItems: ElementArrayFinder;
  public validationError: ElementFinder;
  public startDateInput: ElementFinder;
  public endDateInput: ElementFinder;
  public startTimeInput: ElementFinder;
  public endTimeInput: ElementFinder;

  constructor() {
    this.mapSearchBox = element(by.css('#map-search-box'));
    this.mapAutoSuggestSearchResults = element.all(by.css('div#searchResults .result-item'));
    this.viewButton = element(by.css('#enquiries-form-submit'));
    this.trainsListTableCols = element.all(by.css('#trainList th[id^=tmv-train-table-header] span:nth-child(1)'));
    this.trainsListItems = element.all(by.css('#train-tbody tr'));
    this.trainsListContextMenu = element(by.id('trainlistcontextmenu'));
    this.trainsListContextMenuItems = element.all(by.css('.dropdown-item'));
    this.validationError = element(by.css('.validation-error'));
    this.startDateInput = element(by.id('mat-input-0'));
    this.endDateInput = element(by.id('mat-input-1'));
    this.endTimeInput = element(by.css('app-time-picker[formControlName="endTime"] > input#timePicker'));
    this.startTimeInput = element(by.css('app-time-picker[formControlName=startTime] > input#timePicker'));
  }

  public async enterLocationSearchString(searchString: string): Promise<void> {
    this.mapSearchBox.clear();
    return this.mapSearchBox.sendKeys(searchString);
  }

  public async clickLocationAutoSuggestSearchResult(position: number): Promise<void> {
    const rows = this.mapAutoSuggestSearchResults;
    await rows.get(position - 1).click();
  }

  public async clickViewButton(): Promise<void> {
    await this.viewButton.click();
  }

  public async getTrainsListColHeaders(): Promise<any> {
    await CommonActions.waitForElementToBeVisible(this.trainsListTableCols.first());
    return this.trainsListTableCols.getText();
  }

  public async columnsAre(expectedColHeaders: string[]): Promise<boolean> {
    const expectedNoOfCols = expectedColHeaders.length;
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
  }

  public async getTrainsListValuesForColumn(column: string): Promise<string[]> {
    const entryColValues: ElementArrayFinder = element.all(by.css('.trains-list-row-entry-' + column));
    return entryColValues.map((colValue: ElementFinder) => {
      return colValue.getText();
    });
  }

  public async getRowForSchedule(scheduleId: string): Promise<number> {
    const schedules = await this.getTrainsListValuesForColumn('train-description');
    return schedules.indexOf(scheduleId);
  }

  public async rightClickTrainListItem(scheduleString: string): Promise<void> {
    const trainScheduleId: ElementFinder = element(by.css('[id=\'trains-list-row-' + scheduleString + '\''));
    browser.actions().click(trainScheduleId, protractor.Button.RIGHT).perform();
  }

  public async rightClickTrainListItemNum(position: number): Promise<void> {
    const rows = this.trainsListItems;
    const targetRow = rows.get(position - 1);
    browser.actions().click(targetRow, protractor.Button.RIGHT).perform();
  }

  public async waitForContextMenu(): Promise<boolean> {
    await browser.wait(async () => {
      return this.trainsListContextMenu.isPresent();
    }, browser.params.general_timeout, 'The enquiries view context menu should be displayed');
    return this.trainsListContextMenu.isPresent();
  }

  public async getTrainsListContextMenuItem(rowIndex: number): Promise<string> {
    return this.trainsListContextMenuItems.get(rowIndex - 1).getText();
  }

  public async setStartTime(time: string): Promise<void> {
    await InputBox.ctrlADeleteClear(this.startTimeInput);
    await this.startTimeInput.sendKeys(time);
    return this.startTimeInput.sendKeys(protractor.Key.TAB);
  }

  public async isValidationErrorDisplayed(): Promise<boolean> {
    if (!await this.validationError.isPresent()) {
      return Promise.resolve(false);
    }
    return this.validationError.isDisplayed();
  }

  public async getStartDate(): Promise<string> {
    return this.startDateInput.getAttribute('value');
  }

  public async getStartTime(): Promise<string> {
    return this.startTimeInput.getAttribute('value');
  }

  public async getEndDate(): Promise<string> {
    return this.endDateInput.getAttribute('value');
  }

  public async getEndTime(): Promise<string> {
    return this.endTimeInput.getAttribute('value');
  }
}
