import {by, element, ElementFinder} from 'protractor';

export class DatePicker {

  public chooseThisMonthAndYearButton: ElementFinder;

  constructor() {
    this.chooseThisMonthAndYearButton = element(by.css('[aria-label="Choose month and year"]'));
  }

  public async selectFieldByValue(value): Promise<void> {
    const el = element(by.cssContainingText('button.mat-calendar-body-cell:not([aria-disabled=true])', ` ${value} `));
    await el.click();
  }
}
