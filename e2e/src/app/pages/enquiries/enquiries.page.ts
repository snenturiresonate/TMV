import {by, element, ElementArrayFinder, ElementFinder} from 'protractor';
import {CucumberLog} from '../../logging/cucumber-log';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';

export class EnquiriesPageObject {
  public mapSearchBox: ElementFinder;
  public mapAutoSuggestSearchResults: ElementArrayFinder;
  public viewButton: ElementFinder;
  public trainsListTableCols: ElementArrayFinder;

  constructor() {
    this.mapSearchBox = element(by.css('#map-search-box'));
    this.mapAutoSuggestSearchResults = element.all(by.css('div#searchResults .result-item'));
    this.viewButton = element(by.css('#enquiries-form-submit'));
    this.trainsListTableCols = element.all(by.css('#trainList th[id^=tmv-train-table-header] span:nth-child(1)'));
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

}
