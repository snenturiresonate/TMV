import {browser, by, element, ElementFinder, ExpectedConditions} from 'protractor';
import {DateTimeFormatter, LocalDate} from '@js-joda/core';
import {Locale} from '@js-joda/locale_en';
import {InputBox} from '../common/ui-element-handlers/inputBox';
import {DatePicker} from '../sections/datepicker';
import {TimePicker} from '../sections/timepicker';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';
import {DateAndTimeUtils} from '../common/utilities/DateAndTimeUtils';
import {CucumberLog} from '../../logging/cucumber-log';

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
  public expandedDurationSelector: ElementFinder;
  public endDateAndTime: ElementFinder;
  public nextButton: ElementFinder;
  public timePicker: TimePicker;
  public datePicker: DatePicker;
  public minimise: ElementFinder;
  constructor() {
    this.selectYourTimeRangeTitle = element(by.cssContainingText('h1', 'Select your Time Range'));
    this.nextButton = element(by.buttonText('Next'));
    this.startDate = element(by.xpath('//input[@formcontrolname="startDate"]'));
    this.openCalendarPickerButton = element(by.css('[aria-label="Open calendar"]'));
    this.startTime = element(by.id('timePicker'));
    this.quickContainer = element(by.xpath('//app-dropdown[preceding-sibling::span[text()="Quick"]]'));
    this.quickExpand = this.quickContainer.element(by.css('.dropdown-arrow'));
    this.durationContainer = element(by.xpath('//app-dropdown[preceding-sibling::span[text()="Duration (minutes)"]]'));
    this.durationExpand = this.durationContainer.element(by.css('.dropdown-arrow'));
    this.expandedDurationSelector = element(by.css('[class=\'show\']'));
    this.endDateAndTime = element(by.xpath('//input[@formcontrolname="endDate"]'));
    this.openTimePickerButton = element(by.css('.time-button'));
    this.timePicker = new TimePicker();
    this.datePicker = new DatePicker();
    this.minimise = element(by.css('.collapse-button'));
  }

  // Select Time Page
  public async setStartDate(date: string): Promise<void> {
    date = DateAndTimeUtils.convertToDesiredDateAndFormat(date, 'dd/MM/yyyy');
    browser.startDate = date;
    await browser.wait(ExpectedConditions.visibilityOf(this.startDate))
      .then(async () => {
        await InputBox.ctrlADeleteClear(this.startDate);
        await this.startDate.sendKeys(date);
      });
  }

  public async setStartTime(time: string): Promise<void> {
    if (time.toLowerCase().includes('now -') || time.toLowerCase().includes('now +') ) {
      time = await DateAndTimeUtils.adjustNowTime(time.charAt(4), parseInt(time.substr(6), 10));
    }
    browser.startTime = time;
    await browser.wait(ExpectedConditions.visibilityOf(this.startTime))
      .then(async () => {
        await InputBox.ctrlADeleteClear(this.startTime);
        await this.startTime.sendKeys(time);
      });
  }

  public async getStartTime(): Promise<string> {
    return this.startTime.getAttribute('value');
  }

  public async getStartDate(): Promise<string> {
    return this.startDate.getAttribute('value');
  }

  public async selectDurationOfReplay(duration): Promise<void> {
    await this.durationExpand.click();
    await this.durationContainer.all(by.cssContainingText('li', duration)).first().click();
  }

  public async getMaximumPossibleDuration(): Promise<string> {
    await this.durationExpand.click();
    return  this.durationContainer.all(by.css('li')).last().getText();
  }

  public async expandDurationDropdown(): Promise<void> {
    return this.durationExpand.click();
  }

  public async replayDurationDropdownDisplaysScrollBar(): Promise<boolean> {
    const height = (await this.expandedDurationSelector.getSize()).height;
    const scrollHeight = await this.expandedDurationSelector.getAttribute('scrollHeight');
    await CucumberLog.addText(`Height: ${height}, Scroll Height: ${scrollHeight}`);
    return Promise.resolve(parseInt(scrollHeight, 10) > height);
  }

  public async selectQuickDuration(duration): Promise<void> {
    await this.quickExpand.click();
    await this.quickContainer.element(by.cssContainingText('li', duration)).click();
    browser.sleep(5000);
  }

  public async setStartDateWithDropdown(date: any): Promise<void> {
    date = DateAndTimeUtils.convertToDesiredDateAndFormat(date, 'dd/MM/yyyy');
    browser.startDate = date;

    const dateJoda = LocalDate.parse(date, DateTimeFormatter.ofPattern('dd/MM/yyyy'));
    browser.startDate = date;
    await this.openCalendarPickerButton.click();
    await this.datePicker.chooseThisMonthAndYearButton.click();
    browser.sleep(1000);
    await this.datePicker.selectFieldByValue(dateJoda.format(DateTimeFormatter.ofPattern('yyyy')));
    await this.datePicker.selectFieldByValue(dateJoda.format(DateTimeFormatter.ofPattern('MMM').withLocale(Locale.ENGLISH)).toUpperCase());
    await this.datePicker.selectFieldByValue(dateJoda.format(DateTimeFormatter.ofPattern('d')));
  }

  public async setStartTimeWithDropdown(time: any): Promise<void> {
    if (time.toLowerCase().includes('now -') || time.toLowerCase().includes('now +') ) {
      time = await DateAndTimeUtils.adjustLocalNowTime(time.charAt(4), parseInt(time.substr(6), 10));
    }
    browser.startTime = time;

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
