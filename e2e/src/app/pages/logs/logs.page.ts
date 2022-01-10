import {by, element, ElementArrayFinder, ElementFinder} from 'protractor';

export class LogsPage {
  public logTabs: ElementArrayFinder;

  constructor() {
    this.logTabs = element.all(by.css('.tmv-tabs-vertical li span'));
  }

  public async openTab(tabId: string): Promise<void> {
    return element(by.cssContainingText('.tmv-tabs-vertical li span', tabId)).click();
  }

  public async searchSingleField(tabName: string, fieldName: string, searchVal: string): Promise<void> {
    let divIdStarter = tabName.toLowerCase();
    if (tabName === 'Signal') {
      divIdStarter = 'latch';
    }
    else if (tabName === 'S-Class') {
      divIdStarter = 's';
    }

    const inputTextElement: ElementFinder =
      element(by.css('div[id*=' + divIdStarter + '] input[formcontrolname = ' + fieldName + ']'));
    const searchButton: ElementFinder = element(by.css('button[id^=' + divIdStarter + '][id$=submit]'));
    await inputTextElement.clear();
    await inputTextElement.sendKeys(searchVal);
    return searchButton.click();
  }

  public async getLogResultsTableColumnName(pos: number): Promise<string> {
    const colNames: ElementArrayFinder =  element.all(by.css('.tmv-tab-content-active th'));
    return colNames.get(pos).getText();
  }
}
