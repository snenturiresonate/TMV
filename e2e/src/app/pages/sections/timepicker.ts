import {browser, by, element, ElementFinder} from 'protractor';
import {LocalTime} from '@js-joda/core';

export class TimePicker {
  public hourIncrement: ElementFinder;
  public hourValue: ElementFinder;
  public hourDecrement: ElementFinder;
  public minuteIncrement: ElementFinder;
  public minuteValue: ElementFinder;
  public minuteDecrement: ElementFinder;
  public secondIncrement: ElementFinder;
  public secondValue: ElementFinder;
  public secondDecrement: ElementFinder;
  public closeButton: ElementFinder;

  constructor() {
    this.hourIncrement = element(by.css('.show .hour-spinner .increment-time'));
    this.hourValue = element(by.css('.show .hour-spinner input'));
    this.hourDecrement = element(by.css('.show .hour-spinner .decrement-time'));
    this.minuteIncrement = element(by.css('.show .minute-spinner .increment-time'));
    this.minuteValue = element(by.css('.show .minute-spinner input'));
    this.minuteDecrement = element(by.css('.show .minute-spinner .decrement-time'));
    this.secondIncrement = element(by.css('.show .second-spinner .increment-time'));
    this.secondValue = element(by.css('.show .second-spinner input'));
    this.secondDecrement = element(by.css('.show .second-spinner .decrement-time'));
    this.closeButton = element(by.css('.show .close-button'));
  }

  public async setTime(time: any): Promise<void> {
    const desiredTime = LocalTime.parse(time);
    const hourValue = await browser.executeScript(`return arguments[0].value`, this.hourValue);
    const minuteValue = await browser.executeScript(`return arguments[0].value`, this.minuteValue);
    const secondValue = await browser.executeScript(`return arguments[0].value`, this.secondValue);

    await this.setValue(this.hourIncrement, this.hourDecrement, Number(hourValue) - desiredTime.hour());
    await this.setValue(this.minuteIncrement, this.minuteDecrement, Number(minuteValue) - desiredTime.minute());
    await this.setValue(this.secondIncrement, this.secondDecrement, Number(secondValue) - desiredTime.second());
  }

  public async setValue(upButton: ElementFinder, downButton: ElementFinder, difference: number): Promise<void> {
    let el: ElementFinder;
    if (difference > 0) {
      el = downButton;
    }
    else if (difference < 0) {
      el = upButton;
    }
    for (let i = 0; i < Math.abs(difference); i ++) {
      await el.click();
    }
  }
}
