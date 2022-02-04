import {browser, by, element, ElementArrayFinder, ElementFinder, protractor} from 'protractor';
import {InputBox} from '../common/ui-element-handlers/inputBox';

export class LogsPage {
  public logTabs: ElementArrayFinder;

  private static getDivIdStarter(tabName: string): string {
    let divIdStarter = tabName.toLowerCase();
    if (tabName === 'Signal') {
      divIdStarter = 'latch';
    }
    else if (tabName === 'S-Class') {
      divIdStarter = 's';
    }
    return divIdStarter;
  }

  private static async setSearchField(divIdStarter: string, fieldName: string, searchVal: any): Promise<void> {
    const inputTextElement: ElementFinder = element(by.css(`div[id*=${divIdStarter}] input[formcontrolname = ${fieldName}]`));
    const trimmedValue = searchVal.trim();
    if (!(!searchVal || trimmedValue.length === 0)) {   // if not blank
      await InputBox.updateInputBox(inputTextElement, trimmedValue);
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
    const divIdStarter = LogsPage.getDivIdStarter(tabName);
    for (const [field, value] of Object.entries(criteria)) {
      await LogsPage.setSearchField(divIdStarter, field, value);
    }
    const searchButton: ElementFinder = element(by.css(`button[id^=${divIdStarter}][id$=submit]`));
    return searchButton.click();
  }

  public async getLogResultsTableColumnName(pos: number): Promise<string> {
    const colNames: ElementArrayFinder =  element.all(by.css('.tmv-tab-content-active th'));
    return colNames.get(pos).getText();
  }

  public async getMovementLogResultsValuesForRow(tab: string, row: number): Promise<string[]> {
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
