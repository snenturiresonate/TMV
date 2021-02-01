import {by, element, ElementFinder} from 'protractor';
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
    this.hourIncrement = element(by.css('.hour-spinner .increment-time'));
    this.hourValue = element(by.css('.hour-spinner input'));
    this.hourDecrement = element(by.css('.hour-spinner .decrement-time'));
    this.minuteIncrement = element(by.css('.minute-spinner .increment-time'));
    this.minuteValue = element(by.css('.minute-spinner input'));
    this.minuteDecrement = element(by.css('.minute-spinner .decrement-time'));
    this.secondIncrement = element(by.css('.second-spinner .increment-time'));
    this.secondValue = element(by.css('.second-spinner input'));
    this.secondDecrement = element(by.css('.second-spinner .decrement-time'));
    this.closeButton = element(by.css('.close-button'));
  }

  public async setTime(time: any): Promise<void> {
    const desiredTime = LocalTime.parse(time);
    const hourValue = await this.hourValue.getAttribute('value');
    const minuteValue = await this.minuteValue.getAttribute('value');
    const secondValue = await this.secondValue.getAttribute('value');

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
