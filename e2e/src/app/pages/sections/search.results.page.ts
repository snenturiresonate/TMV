import {by, element, ElementArrayFinder, ElementFinder} from 'protractor';
import {SearchResultsTableRowPage} from './search.results.tablerow.page';
import * as assert from 'assert';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';

export class SearchResultsPageObject {

  public close: ElementFinder;
  public trainSearchResults: ElementFinder;
  public timetableSearchResults: ElementFinder;
  public signalSearchResults: ElementFinder;

  constructor() {
    this.close = element(by.css('.tmv-btn-cancel'));
    this.trainSearchResults = element(by.id('trainSearchResults'));
    this.timetableSearchResults = element(by.id('timetableSearchResults'));
    this.signalSearchResults = element(by.id('signalSearchResults'));
  }

  async getActiveTable(): Promise<ElementFinder> {
    const searchType = await element(by.id('national-search-dropdown-toggle')).getText();
    await CommonActions.waitForElementToBePresent(element.all(by.css(`[id*='SearchResults']`)).first());
    switch (searchType) {
      case 'Train':
        return this.trainSearchResults;
      case 'Timetable':
        return this.timetableSearchResults;
      case 'Signal':
        return this.signalSearchResults;
    }
  }

  async getHeaders(): Promise<string[]> {
    const headers = (await this.getActiveTable()).all(by.xpath('//tr'));
    return headers.map(header => header.getText());
  }

  async getRowByIndex(index: number): Promise<SearchResultsTableRowPage> {
    const activeTable: ElementFinder = await this.getActiveTable();
    return new SearchResultsTableRowPage(activeTable.element(by.css(`tr:nth-child(${index})`)));
  }

  async getRowByPlanningUID(planningUID: string): Promise<SearchResultsTableRowPage> {
    const activeTable: ElementFinder = await this.getActiveTable();
    return new SearchResultsTableRowPage(activeTable.element(by.xpath(`//tr[descendant::td[text()='${planningUID}']]`)));
  }

  async noResultsAreFound(): Promise<boolean> {
    const searchType = await element(by.id('national-search-dropdown-toggle')).getText();
    const noResultsFoundText: ElementFinder = element(by.id(`no-${searchType}-search-results`.toLowerCase()));
    return noResultsFoundText.isDisplayed();
  }

  async getRowByPlanningUIDandDate(planningUID: string, runDate: string): Promise<SearchResultsTableRowPage> {
    const activeTable: ElementFinder = await this.getActiveTable();
    const rows: ElementArrayFinder = activeTable.all(by.xpath(`//tr[descendant::td[text()='${planningUID}'] and descendant::td[text()='${runDate}']]`));
    const numRows = await rows.count();
    if (numRows > 1) {
      assert.fail(`multiple (${numRows} rows returned for planningUID ${planningUID} and runDate ${runDate}`);
    }
    if (numRows < 1) {
      assert.fail(`no rows returned for planningUID ${planningUID} and runDate ${runDate}`);
    }
    return new SearchResultsTableRowPage(rows.get(0));
  }

  async rowByPlanningUIDandDateExists(planningUID: string, runDate: string): Promise<boolean> {
    const activeTable: ElementFinder = await this.getActiveTable();
    const rows: ElementArrayFinder = activeTable.all(by.xpath(`//tr[descendant::td[text()='${planningUID}'] and descendant::td[text()='${runDate}']]`));
    const numRows = await rows.count();
    if (numRows > 0) {
      return Promise.resolve(true);
    }
    if (numRows < 1) {
      return Promise.resolve(false);
    }
  }

  async getRowByService(service: string): Promise<SearchResultsTableRowPage> {
    const activeTable: ElementFinder = await this.getActiveTable();
    return new SearchResultsTableRowPage(activeTable.element(by.xpath(`//tr[descendant::td[text()='${service}']]`)));
  }

  async getRowByPlanningUIDAndScheduleType(planningUID: string, scheduleType: string): Promise<SearchResultsTableRowPage> {
    const activeTable: ElementFinder = await this.getActiveTable();
    return new SearchResultsTableRowPage(activeTable.element(by.xpath(`//tr[descendant::td[text()='${planningUID}'] and td[text()='${scheduleType}']]`)));
  }

  async getRowBySignalID(signalID: string): Promise<SearchResultsTableRowPage> {
    const activeTable: ElementFinder = await this.getActiveTable();
    return new SearchResultsTableRowPage(activeTable.element(by.xpath(`//tr[descendant::td[text()='${signalID}']]`)));
  }
}
