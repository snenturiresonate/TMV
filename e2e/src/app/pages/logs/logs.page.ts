import {browser, by, element, ElementArrayFinder, ElementFinder, protractor} from 'protractor';
import {InputBox} from '../common/ui-element-handlers/inputBox';
import {CheckBox} from '../common/ui-element-handlers/checkBox';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';

export class LogsPage {
  public logTabs: ElementArrayFinder;

  private static getDivIdStarter(tabName: string): string {
    return tabName.toLowerCase();
  }

  private static async setSearchField(divIdStarter: string, fieldName: string, searchVal: any): Promise<void> {
    const inputTextElement: ElementFinder = element(by.css(`div[id*=${divIdStarter}] input[formcontrolname = ${fieldName}]`));
    const trimmedValue = searchVal.trim();
    if (!(!searchVal || trimmedValue.length === 0)) {   // if not blank
      await InputBox.updateInputBox(inputTextElement, trimmedValue);
    }
  }

  private static async setCheckBox(divIdStarter: string, fieldName: string, value: any): Promise<void> {
    const checkBoxElement: ElementFinder = element(by.css(`div[id*=${divIdStarter}] input[id = ${fieldName}]`));
    await CheckBox.updateCheckBox(checkBoxElement, value);
  }

  private static async setTimePicker(divIdStarter: string, fieldName: string, value: any): Promise<void> {
    const timePicker: ElementFinder = element(by.css(`div[id*=${divIdStarter}] app-time-picker[formcontrolname=${fieldName}] input[id = timePicker]`));
    const trimmedValue = value.trim();
    if (!(!value || trimmedValue.length === 0)) {   // if not blank
      await InputBox.ctrlADeleteClear(timePicker);
      await InputBox.updateInputBoxAndTabOut(timePicker, trimmedValue);
    }
  }

  constructor() {
    this.logTabs = element.all(by.css('.tmv-tabs-vertical li span'));
  }

  public async openTab(tabId: string): Promise<void> {
    return element(by.cssContainingText('.tmv-tabs-vertical li span', tabId)).click();
  }

  public async searchSingleField(tabName: string, fieldName: string, searchVal: string): Promise<void> {
    const divIdStarter = LogsPage.getDivIdStarter(tabName);
    await LogsPage.setSearchField(divIdStarter, fieldName, searchVal);
    const searchButton: ElementFinder = element(by.css(`button[id^=${divIdStarter}][id$=submit]`));
    return searchButton.click();
  }

  public async searchMultipleFields(tabName: string, criteria: any): Promise<void> {
    await CommonActions.scrollToTopOfWindow();
    const divIdStarter = LogsPage.getDivIdStarter(tabName);
    for (const [field, value] of Object.entries(criteria)) {
      if (value === 'checked' || value === 'unchecked') {
        await LogsPage.setCheckBox(divIdStarter, field, value);
      } else if (field === 'startTime' || field === 'endTime') {
        await LogsPage.setTimePicker(divIdStarter, field, value);
      } else {
        await LogsPage.setSearchField(divIdStarter, field, value);
      }
    }
    const searchButton: ElementFinder = element(by.css(`button[id^=${divIdStarter}][id$=submit]`));
    return searchButton.click();
  }

  public async exportMultipleFields(tabName: string, criteria: any): Promise<void> {
    await CommonActions.scrollToTopOfWindow();
    const divIdStarter = LogsPage.getDivIdStarter(tabName);
    for (const [field, value] of Object.entries(criteria)) {
      if (value === 'checked' || value === 'unchecked') {
        await LogsPage.setCheckBox(divIdStarter, field, value);
      } else {
        await LogsPage.setSearchField(divIdStarter, field, value);
      }
    }
    const submitButton: ElementFinder = element(by.xpath('//*[@id="signalling-logs-form-export"]'));
    return submitButton.click();
  }

  public async getLogResultsTableColumnName(pos: number): Promise<string> {
    const colNames: ElementArrayFinder =  element.all(by.css('.tmv-tab-content-active th'));
    return colNames.get(pos).getText();
  }

  public async getMovementLogResultsValuesForRow(tab: string, row: number): Promise<string[]> {
    await CommonActions.scrollToBottomOfWindow();
    const rowStr: string = row.toString();
    const values: ElementArrayFinder = element.all(by.css(`#${tab}-logs-table tbody :nth-child(${rowStr}) td`));
    return values.map((colValue: ElementFinder) => {
      return colValue.getText();
    });
  }

  public async getLogRowCount(): Promise<number> {
    const rows: ElementArrayFinder = element.all(by.css(`[id*=logs-table] tbody tr`));
    return rows.count();
  }

  public async leftClickLogResultItem(dataItem: string): Promise<void> {
    const logRowLocator: string = '//td[text()=\'' + dataItem + '\']//parent::tr';
    const logRow: ElementFinder = element(by.xpath(logRowLocator));
    browser.actions().click(logRow, protractor.Button.LEFT).perform();
  }

  public async getSearchError(tab: string): Promise<string> {
    const value: ElementFinder = element(by.css(`#${tab}-logs-form-submit + span`));
    return value.getText();
  }
}
