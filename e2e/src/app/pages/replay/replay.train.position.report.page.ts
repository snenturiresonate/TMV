import {browser, by, element, ElementArrayFinder, ElementFinder, protractor} from 'protractor';

export class ReplayTrainPositionReportPage {
  public tprLink: ElementFinder;
  public tprTable: ElementFinder;
  public trainDescription: ElementArrayFinder;
  public operator: ElementArrayFinder;
  public berth: ElementArrayFinder;
  public punctuality: ElementArrayFinder;
  public time: ElementArrayFinder;
  public reportFilter: ElementFinder;
  public tprPrint: ElementFinder;
  public pageNumber: ElementFinder;
  public pageNext: ElementFinder;
  public pagePrevious: ElementFinder;
  public arrowType: ElementFinder;
  constructor() {
    this.tprTable = element(by.id('reports-table'));
    this.tprLink = element(by.css('.tpr-link>span'));
    this.trainDescription = element.all(by.css('#reports-table >tbody >tr >td:nth-child(1)'));
    this.operator = element.all(by.css('#reports-table >tbody >tr >td:nth-child(2)'));
    this.berth = element.all(by.css('#reports-table >tbody >tr >td:nth-child(3)'));
    this.punctuality = element.all(by.css('#reports-table >tbody >tr >td:nth-child(4)'));
    this.time = element.all(by.css('#reports-table >tbody >tr >td:nth-child(5)'));
    this.reportFilter = element(by.id('reports-filter-box'));
    this.tprPrint = element(by.id('print'));
    this.pageNumber = element(by.id('activePage'));
    this.pageNext = element(by.id('paginationNext'));
    this.pagePrevious = element(by.id('paginationPrevious'));
    this.arrowType = element(by.className('arrow-style'));
  }
  public async componentLoad(): Promise<void> {
    const EC = protractor.ExpectedConditions;
    return browser.wait(EC.presenceOf(this.tprTable));
  }
  public async clickTprLink(): Promise<void> {
    return this.tprLink.click();
  }
  public async getTrainDescription(index: number): Promise<string> {
    await this.componentLoad();
    return this.trainDescription.get(index).getText();
  }
  public async getOperator(index: number): Promise<string> {
    return this.operator.get(index).getText();
  }
  public async getBerth(index: number): Promise<string> {
    return this.berth.get(index).getText();
  }
  public async getPunctuality(index: number): Promise<string> {
    return this.punctuality.get(index).getText();
  }
  public async getTime(index: number): Promise<string> {
    return this.time.get(index).getText();
  }
  public async sortTprTable(sortId: string): Promise<void> {
    return element(by.id(sortId)).click();
  }
  public async getTprFilterPlaceHolder(): Promise<string> {
    return this.reportFilter.getAttribute('placeholder');
  }
  public async enterReportFilterSearch(searchValue: string): Promise<void> {
    await this.reportFilter.sendKeys(searchValue);
  }
  public async clickTprPrint(): Promise<void> {
    return this.tprLink.click();
  }
  public async getPageNumber(): Promise<string> {
    return this.pageNumber.getText();
  }
  public async clickNextPage(): Promise<void> {
    return this.pageNext.click();
  }
  public async clickPreviousPage(): Promise<void> {
    return this.pagePrevious.click();
  }
  public async getArrowType(): Promise<string> {
    return this.reportFilter.getAttribute('class');
  }
}
