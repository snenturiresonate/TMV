import {by, element, ElementFinder} from 'protractor';

export class DatePicker {

  public chooseThisMonthAndYearButton: ElementFinder;

  constructor() {
    this.chooseThisMonthAndYearButton = element(by.css('[aria-label="Choose month and year"]'));
  }

  public async selectFieldByValue(value): Promise<void> {
    const el = element(by.xpath(`//td[not(@aria-disabled)]//div[contains(@class, "mat-calendar-body-cell-content")][normalize-space()="${value}"]`));
    await el.click();
  }
}
