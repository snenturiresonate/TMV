import {browser, by, element, ElementArrayFinder, ElementFinder, protractor} from 'protractor';
import {InputBox} from '../common/ui-element-handlers/inputBox';
import {CheckBox} from '../common/ui-element-handlers/checkBox';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';
import {DateAndTimeUtils} from '../common/utilities/DateAndTimeUtils';
import {DateTimeFormatter, LocalDate} from '@js-joda/core';
import {DatePicker} from '../sections/datepicker';
import {Locale} from '@js-joda/locale_en';

export class LogsPage {
  public logTabs: ElementArrayFinder;
  public visibleValidationError: ElementFinder;
  public visibleOpenCalendarPickerButton: ElementFinder;
  public datePickerSelectedElement: ElementFinder;

  private static getDivIdStarter(tabName: string): string {
    return tabName.toLowerCase();
  }

  private static async setSearchField(divIdStarter: string, fieldName: string, searchVal: any): Promise<void> {
    const inputTextElement: ElementFinder = element(by.css(`div[id*=${divIdStarter}] input[formcontrolname = ${fieldName}]`));
    const trimmedValue = searchVal.trim();
    if (!(!searchVal || trimmedValue.length === 0)) {   // if not blank
      await InputBox.updateInputBox(inputTextElement, trimmedValue);
    }
  }

  private static async setCheckBox(divIdStarter: string, fieldName: string, value: any): Promise<void> {
    const checkBoxElement: ElementFinder = element(by.css(`div[id*=${divIdStarter}] input[id = ${fieldName}]`));
    await CheckBox.updateCheckBox(checkBoxElement, value);
  }

  private static async setTimePicker(divIdStarter: string, fieldName: string, value: any): Promise<void> {
    const timePicker: ElementFinder = element(by.css(`div[id*=${divIdStarter}] app-time-picker[formcontrolname=${fieldName}] input[id = timePicker]`));
    const trimmedValue = value.trim();
    if (!(!value || trimmedValue.length === 0)) {   // if not blank
      await InputBox.ctrlADeleteClear(timePicker);
      await InputBox.updateInputBoxAndTabOut(timePicker, trimmedValue);
    }
  }

  constructor() {
    this.logTabs = element.all(by.css('.tmv-tabs-vertical li span'));
    this.visibleValidationError = element(by.css('.tmv-tab-content-active .validation-error'));
    this.visibleOpenCalendarPickerButton = element(by.css('.tmv-tab-content-active [aria-label="Open calendar"]'));
    this.datePickerSelectedElement = element(by.css('.mat-datepicker-content td[aria-selected = "true"]'));
  }

  public async openTab(tabId: string): Promise<void> {
    return element(by.cssContainingText('.tmv-tabs-vertical li span', tabId)).click();
  }

  public async getDisplayedValue(tabName: string, fieldName: string): Promise<string> {
    const divIdStarter = LogsPage.getDivIdStarter(tabName);
    const inputTextElement: ElementFinder = element(by.css(`div[id*=${divIdStarter}].tmv-tab-content-active input[formcontrolname = ${fieldName}]`));
    return inputTextElement.getAttribute('value');
  }

  public async isFieldPresent(tabName: string, fieldName: string): Promise<boolean> {
    const divIdStarter = LogsPage.getDivIdStarter(tabName);
    const targetElement: ElementFinder = element(by.css(`div[id*=${divIdStarter}].tmv-tab-content-active input[formcontrolname = ${fieldName}]`));
    const elementFound: boolean = await targetElement.isPresent();
    return (elementFound);
  }

  public async setVisibleDateField(value: any): Promise<void> {
    const visibleDatePicker: ElementFinder = element(by.css(`.tmv-tab-content-active input[formcontrolname=date]`));
    const date = DateAndTimeUtils.convertToDesiredDateAndFormat(value, 'dd/MM/yyyy');
    if (!(!date || date.length === 0)) {   // if not blank
      await InputBox.ctrlADeleteClear(visibleDatePicker);
      await InputBox.updateInputBoxAndTabOut(visibleDatePicker, date);
    }
  }

  public async searchSingleField(tabName: string, fieldName: string, searchVal: string): Promise<void> {
    const divIdStarter = LogsPage.getDivIdStarter(tabName);
    if (fieldName === 'date') {
      await this.setVisibleDateField(searchVal);
    }
    else {
      await LogsPage.setSearchField(divIdStarter, fieldName, searchVal);
    }
    const searchButton: ElementFinder = element(by.css(`button[id^=${divIdStarter}][id$=submit]`));
    return searchButton.click();
  }

  public async searchMultipleFields(tabName: string, criteria: any): Promise<void> {
    await CommonActions.scrollToTopOfWindow();
    const divIdStarter = LogsPage.getDivIdStarter(tabName);
    for (const [field, value] of Object.entries(criteria)) {
      if (value === 'checked' || value === 'unchecked') {
        await LogsPage.setCheckBox(divIdStarter, field, value);
      } else if (field === 'startTime' || field === 'endTime') {
        await LogsPage.setTimePicker(divIdStarter, field, value);
      } else {
        await LogsPage.setSearchField(divIdStarter, field, value);
      }
    }
    const searchButton: ElementFinder = element(by.css(`button[id^=${divIdStarter}][id$=submit]`));
    return searchButton.click();
  }

  public async exportMultipleFields(tabName: string, criteria: any): Promise<void> {
    await CommonActions.scrollToTopOfWindow();
    const divIdStarter = LogsPage.getDivIdStarter(tabName);
    for (const [field, value] of Object.entries(criteria)) {
      if (value === 'checked' || value === 'unchecked') {
        await LogsPage.setCheckBox(divIdStarter, field, value);
      } else {
        await LogsPage.setSearchField(divIdStarter, field, value);
      }
    }
    const submitButton: ElementFinder = element(by.xpath('//*[@id="signalling-logs-form-export"]'));
    return submitButton.click();
  }

  public async getLogResultsTableColumnName(pos: number): Promise<string> {
    const colNames: ElementArrayFinder =  element.all(by.css('.tmv-tab-content-active th'));
    return colNames.get(pos).getText();
  }

  public async getMovementLogResultsValuesForRow(tab: string, row: number): Promise<string[]> {
    await CommonActions.scrollToBottomOfWindow();
    const rowStr: string = row.toString();
    const values: ElementArrayFinder = element.all(by.css(`#${tab}-logs-table tbody :nth-child(${rowStr}) td`));
    return values.map((colValue: ElementFinder) => {
      return colValue.getText();
    });
  }

  public async getLogRowCount(): Promise<number> {
    const rows: ElementArrayFinder = element.all(by.css(`[id*=logs-table] tbody tr`));
    return rows.count();
  }

  public async leftClickLogResultItem(dataItem: string): Promise<void> {
    const logRowLocator: string = '//td[text()=\'' + dataItem + '\']//parent::tr';
    const logRow: ElementFinder = element(by.xpath(logRowLocator));
    browser.actions().click(logRow, protractor.Button.LEFT).perform();
  }

  public async leftClickDatePicker(): Promise<void> {
    await browser.actions().click(this.visibleOpenCalendarPickerButton, protractor.Button.LEFT).perform();
  }

  public async setDateWithDropdown(date: any): Promise<boolean> {
    date = DateAndTimeUtils.convertToDesiredDateAndFormat(date, 'dd/MM/yyyy');
    const dateJoda = LocalDate.parse(date, DateTimeFormatter.ofPattern('dd/MM/yyyy'));
    await this.visibleOpenCalendarPickerButton.click();
    const datePicker = new DatePicker();
    await datePicker.chooseThisMonthAndYearButton.click();
    browser.sleep(1000);
    try {
      await datePicker.selectFieldByValue(dateJoda.format(DateTimeFormatter.ofPattern('yyyy')));
      await datePicker.selectFieldByValue(dateJoda.format(DateTimeFormatter.ofPattern('MMM').withLocale(Locale.ENGLISH)).toUpperCase());
      await datePicker.selectFieldByValue(dateJoda.format(DateTimeFormatter.ofPattern('d')));
    }
    catch (e) {
      return false;
    }
    return true;
  }

  public async getSearchError(tab: string): Promise<string> {
    const value: ElementFinder = element(by.css(`#${tab}-logs-form-submit + span`));
    return value.getText();
  }

  public async getVisibleValidationError(): Promise<string> {
    return this.visibleValidationError.getText();
  }

  public async getDatePickerDateSelected(): Promise<string> {
    return this.datePickerSelectedElement.getAttribute('aria-label');
  }

  public async isDatePickerPresent(): Promise<boolean> {
    return this.datePickerSelectedElement.isPresent();
  }
}
