import {browser, by, ElementFinder, protractor} from 'protractor';

export class LastBerthServiceListTableRowPageObject {

  public service: ElementFinder;
  public operator: ElementFinder;
  public punctuality: ElementFinder;
  public actualArrivalTime: ElementFinder;
  public actualArrivalDate: ElementFinder;
  private rowLocator: ElementFinder;

  constructor(rowLocator: ElementFinder) {
    this.rowLocator = rowLocator;
    this.service = rowLocator.element(by.id('somethingTrainDesc'));
    this.operator = rowLocator.element(by.id('somethingOperator'));
    this.punctuality = rowLocator.element(by.id('somethingPunctuality'));
    this.actualArrivalTime = rowLocator.element(by.id('somethingTime'));
    this.actualArrivalDate = rowLocator.element(by.id('somethingDate'));
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
  async getArrivalTime(): Promise<string> {
    return this.actualArrivalTime.getText();
  }
  async getArrivalDate(): Promise<string> {
    return this.actualArrivalDate.getText();
  }

  async performRightClick(): Promise<void> {
    browser.actions().click(this.rowLocator, protractor.Button.RIGHT).perform();
  }

  async performLeftClick(): Promise<void> {
    this.rowLocator.click();
  }
}
