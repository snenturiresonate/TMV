import {by, element, ElementFinder} from 'protractor';
import {SearchResultsTableRowPage} from './search.results.tablerow.page';

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

  async getRowByService(service: string): Promise<SearchResultsTableRowPage> {
    const activeTable: ElementFinder = await this.getActiveTable();
    return new SearchResultsTableRowPage(activeTable.element(by.xpath(`//tr[descendant::td[text()='${service}']]`)));
  }

  async getRowByPlanningUIDAndScheduleType(planningUID: string, scheduleType: string): Promise<SearchResultsTableRowPage> {
    const activeTable: ElementFinder = await this.getActiveTable();
    return new SearchResultsTableRowPage(activeTable.element(by.xpath(`//tr[descendant::td[text()='${planningUID}'] and td[text()='${scheduleType}']]`)));
  }

}
