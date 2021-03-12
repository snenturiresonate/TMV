import {browser, by, element, ElementFinder, ExpectedConditions} from 'protractor';
import {DateTimeFormatter, LocalDate} from '@js-joda/core';
import {Locale} from '@js-joda/locale_en';
import {InputBox} from '../common/ui-element-handlers/inputBox';
import {DatePicker} from '../sections/datepicker';
import {TimePicker} from '../sections/timepicker';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';

export class ReplaySelectTimerangePage {
  public selectYourTimeRangeTitle: ElementFinder;
  public quickContainer: ElementFinder;
  public quickExpand: ElementFinder;
  public startDate: ElementFinder;
  public openCalendarPickerButton: ElementFinder;
  public openTimePickerButton: ElementFinder;
  public startTime: ElementFinder;
  public durationContainer: ElementFinder;
  public durationExpand: ElementFinder;
  public endDateAndTime: ElementFinder;
  public nextButton: ElementFinder;
  public timePicker: TimePicker;
  public datePicker: DatePicker;
  public minimise: ElementFinder;
  constructor() {
    this.selectYourTimeRangeTitle = element(by.cssContainingText('h1', 'Select your time range'));
    this.nextButton = element(by.buttonText('Next'));
    this.startDate = element(by.xpath('//input[@formcontrolname="startDate"]'));
    this.openCalendarPickerButton = element(by.css('[aria-label="Open calendar"]'));
    this.startTime = element(by.id('timePicker'));
    this.quickContainer = element(by.xpath('//app-dropdown[preceding-sibling::span[text()="Quick"]]'));
    this.quickExpand = this.quickContainer.element(by.css('.dropdown-arrow'));
    this.durationContainer = element(by.xpath('//app-dropdown[preceding-sibling::span[text()="Duration (minutes)"]]'));
    this.durationExpand = this.durationContainer.element(by.css('.dropdown-arrow'));
    this.endDateAndTime = element(by.xpath('//input[@formcontrolname="endDate"]'));
    this.openTimePickerButton = element(by.css('.time-button'));
    this.timePicker = new TimePicker();
    this.datePicker = new DatePicker();
    this.minimise = element(by.css('.collapse-button'));
  }

  // Select Time Page
  public async setStartDate(date): Promise<void> {
    // not sure why but clearing box needs slowing down to work, normal clear() doesn't seem to work
    await browser.wait(ExpectedConditions.visibilityOf(this.startDate))
      .then(async () => {
        browser.sleep(1500);
        await InputBox.ctrlADeleteClear(this.startDate);
        browser.sleep(1500);
        await this.startDate.sendKeys(date);
      });
  }

  public async setStartTime(time): Promise<void> {
    // not sure why but clearing box needs slowing down to work, normal clear() doesn't seem to work
    await browser.wait(ExpectedConditions.visibilityOf(this.startTime))
      .then(async () => {
        browser.sleep(1500);
        await InputBox.ctrlADeleteClear(this.startTime);
        browser.sleep(1500);
        await this.startTime.sendKeys(time);
      });
  }

  public async selectDurationOfReplay(duration): Promise<void> {
    await this.durationExpand.click();
    await this.durationContainer.element(by.cssContainingText('li', duration)).click();
  }

  public async selectQuickDuration(duration): Promise<void> {
    await this.quickExpand.click();
    await this.quickContainer.element(by.cssContainingText('li', duration)).click();
    browser.sleep(5000);
  }

  public async setStartDateWithDropdown(date: any): Promise<void> {
    const dateJoda = LocalDate.parse(date, DateTimeFormatter.ofPattern('dd/MM/yyyy'));
    await this.openCalendarPickerButton.click();
    await this.datePicker.chooseThisMonthAndYearButton.click();
    browser.sleep(1000);
    await this.datePicker.selectFieldByValue(dateJoda.format(DateTimeFormatter.ofPattern('yyyy')));
    await this.datePicker.selectFieldByValue(dateJoda.format(DateTimeFormatter.ofPattern('MMM').withLocale(Locale.ENGLISH)).toUpperCase());
    await this.datePicker.selectFieldByValue(dateJoda.format(DateTimeFormatter.ofPattern('d')));
  }

  public async setStartTimeWithDropdown(time: any): Promise<void> {
    await this.openTimePickerButton.click();
    await this.timePicker.setTime(time);
    await this.timePicker.closeButton.click();
  }

  public async setTimeRange(duration: string): Promise<void> {
    await this.selectQuickDuration(duration);
    await this.selectNext();
  }

  public async selectNext(): Promise<void> {
    return CommonActions.waitAndClick(this.nextButton);
  }

  public async clickMinimise(): Promise<void> {
    return CommonActions.waitAndClick(this.nextButton);
  }
}
