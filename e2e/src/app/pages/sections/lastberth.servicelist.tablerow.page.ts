import {browser, by, ElementFinder, protractor} from 'protractor';

export class LastBerthServiceListTableRowPageObject {

  public service: ElementFinder;
  public operator: ElementFinder;
  public punctuality: ElementFinder;
  public eventDateTime: ElementFinder;
  // public actualArrivalTime: ElementFinder;
  // public actualArrivalDate: ElementFinder;
  private rowLocator: ElementFinder;

  constructor(rowLocator: ElementFinder) {
    this.rowLocator = rowLocator;
    this.service = rowLocator.element(by.css('.last-berth-item-train-desc span'));
    this.operator = rowLocator.element(by.css('.last-berth-item-operator-code span'));
    this.punctuality = rowLocator.element(by.css('.last-berth-item-punctuality span'));
    this.eventDateTime = rowLocator.element(by.css('.last-berth-item-event-date-time span'));
    // this.actualArrivalTime = rowLocator.element(by.id('somethingTime'));
    // this.actualArrivalDate = rowLocator.element(by.id('somethingDate'));
  }
  async isPresent(): Promise<boolean> {
    return this.rowLocator.isPresent();
  }
  async getService(): Promise<string> {
    return this.service.getText();
  }
  async getOperator(): Promise<string> {
    return this.operator.getText();
  }
  async getPunctuality(): Promise<string> {
    return this.punctuality.getText();
  }
  async getEventDateTime(): Promise<string> {
    return this.eventDateTime.getText();
  }
  // async getArrivalTime(): Promise<string> {
  //   return this.actualArrivalTime.getText();
  // }
  // async getArrivalDate(): Promise<string> {
  //   return this.actualArrivalDate.getText();
  // }

  async performRightClick(): Promise<void> {
    browser.actions().click(this.rowLocator, protractor.Button.RIGHT).perform();
  }

  async performLeftClick(): Promise<void> {
    this.rowLocator.click();
  }
}
