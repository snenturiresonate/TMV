import {by, element, ElementArrayFinder, ElementFinder, browser, ExpectedConditions} from 'protractor';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';
import {SelectBox} from '../common/ui-element-handlers/selectBox';
import {InputBox} from '../common/ui-element-handlers/inputBox';

export class RestrictionsPageObject {
  public addRestrictionButton: ElementFinder;
  public restrictionRows: ElementArrayFinder;
  public editableRestrictionRows: ElementArrayFinder;
  public editableRestrictionTypes: ElementArrayFinder;
  public restrictionHeader: ElementFinder;
  public editableRowDoneButton: ElementFinder;
  public disabledEditableRowDoneButton: ElementFinder;
  public applyChangesButton: ElementFinder;
  public clearChangesButton: ElementFinder;
  public lastRowEditButton: ElementFinder;
  public spinner: ElementFinder;
  public clock: ElementFinder;

  constructor() {
    this.addRestrictionButton = element(by.css('#add-track-restriction-button'));
    this.restrictionRows = element.all(by.css('#restrictions-table-body tr'));
    this.editableRestrictionRows = element.all(by.css('.edit-mode-row'));
    this.editableRestrictionTypes = element.all(by.css('.edit-mode-row option'));
    this.restrictionHeader = element(by.xpath(`//div[contains(text(),'Track Division ID:')]`));
    this.editableRowDoneButton = element(by.css('.edit-mode-row em.edit-button'));
    this.disabledEditableRowDoneButton = element(by.css('.edit-mode-row em.disabled-track-restriction-table-button'));
    this.applyChangesButton = element(by.css('#track-restriction-apply-changes-button'));
    this.clearChangesButton = element(by.css('#track-restriction-clear-changes-button'));
    this.lastRowEditButton = element(by.css('#restrictions-table-body tr:last-child em.edit-button'));
    this.spinner = element(by.css('#loading-spinner-icon'));
    this.clock = element(by.css('#nav-bar-current-time'));

  }

  public async addRestriction(): Promise<void> {
    return CommonActions.waitAndClick(this.addRestrictionButton);
  }

  public async saveOpenRestriction(): Promise<void> {
    return CommonActions.waitAndClick(this.editableRowDoneButton);
  }

  public async editLastRestriction(): Promise<void> {
    return CommonActions.waitAndClick(this.lastRowEditButton);
  }

  public async applyChanges(): Promise<void> {
    await CommonActions.waitAndClick(this.applyChangesButton);
    await browser.wait(ExpectedConditions.invisibilityOf(this.spinner), 5000);
  }

  public async waitForSpinner(): Promise<void> {
    await browser.wait(ExpectedConditions.invisibilityOf(this.spinner), 5000);
  }

  public async waitForClock(): Promise<void> {
    await browser.wait(ExpectedConditions.presenceOf(this.clock), 5000);
  }

  public async clearChanges(): Promise<void> {
    return CommonActions.waitAndClick(this.clearChangesButton);
  }

  public async getRestrictionsCount(): Promise<number> {
    await this.waitForSpinner();
    return this.restrictionRows.count();
  }

  public async getRestrictionsHeaderValue(): Promise<string> {
    return this.restrictionHeader.getText();
  }

  public async getEditableRestrictionRowCount(): Promise<number> {
    return this.editableRestrictionRows.count();
  }

  public async getEditableRestrictionType(index: number): Promise<string> {
    return this.editableRestrictionTypes.get(index).getAttribute('label');
  }

  public async getSelectedType(): Promise<string> {
    return element(by.css('#select option[selected]')).getText();
  }

  public async sendKeys(field: string, value: string): Promise<void> {
    let editableElement: ElementFinder = element(by.css(`[id*=edit-${field}-input`));
    if (field === 'comment') {
      editableElement = element(by.css(`[id*=edit-${field}] textarea`));
    }
    await editableElement.sendKeys(value);
  }

  public async setValue(field: string, value: string): Promise<void> {
    if (field === 'type') {
      const editableElement: ElementFinder = element(by.css(`[id*=edit-${field}] select`));
      await SelectBox.selectByVisibleText(editableElement, value);
    } else if (field === 'start-date') {
      await this.setDateAndTimeInEditRecord('startDate', value);
    } else if (field === 'end-date') {
      await this.setDateAndTimeInEditRecord('endDate', value);
    } else if (field === 'comment') {
      const editableElement = element(by.css(`[id*=edit-${field}] textarea`));
      await InputBox.ctrlADeleteClear(editableElement);
      await InputBox.updateInputBoxAndTabOut(editableElement, value);
    } else {
      const editableElement: ElementFinder = element(by.css(`[id*=edit-${field}-input`));
      await InputBox.updateInputBox(editableElement, value);
    }
  }

  public async isEditableFieldPresent(field: string): Promise<boolean> {
    const editableElement: ElementFinder = element(by.css(`[id*=edit-${field}`));
    const elementFound: boolean = await editableElement.isPresent();
    return (elementFound);
  }

  public async getDisplayedTypeInEditRecord(): Promise<string> {
    const editableType: ElementFinder = element(by.css('.track-restriction-table-edit-type-dropdown-selected'));
    return editableType.getAttribute('label');
  }

  public async getDisplayedDateAndTimeInEditRecord(identifier: string): Promise<string> {
    const dateIdentifier = identifier;
    const timeIdentifier = identifier.replace('Date', 'Time');
    const editableDate: ElementFinder = element(by.css(`[formcontrolname=${dateIdentifier}]`));
    const editableTime: ElementFinder = element(by.css(`[formcontrolname=${timeIdentifier}] [id=timePicker]`));
    const datePart = await editableDate.getAttribute('value');
    const timePart = await editableTime.getAttribute('value');
    return datePart + ' ' +  timePart ;
  }

  public async getDisplayedValueInEditRecord(field: string): Promise<string> {
    let actualValue;
    if (field === 'type') {
      actualValue = await this.getDisplayedTypeInEditRecord();
    } else if (field === 'start-date') {
      actualValue = await this.getDisplayedDateAndTimeInEditRecord('startDate');
    } else if (field === 'end-date') {
      actualValue = await this.getDisplayedDateAndTimeInEditRecord('endDate');
    } else {
      let elementLocator = `[id*=edit-${field}-input]`;
      if (field === 'comment') {
        elementLocator = `[id*=edit-${field}] textarea`;
      }
      const editableElement: ElementFinder = element(by.css(elementLocator));
      actualValue = await editableElement.getAttribute('value');
    }
    return (actualValue);
  }

  public async setDateAndTimeInEditRecord(identifier: string, value: string): Promise<void> {
    if (value !== '') {
      const parts: string[] = value.split(' ');
      const dateIdentifier = identifier;
      const timeIdentifier = identifier.replace('Date', 'Time');
      const editableDate: ElementFinder = element(by.css(`[formcontrolname=${dateIdentifier}]`));
      const editableTime: ElementFinder = element(by.css(`[formcontrolname=${timeIdentifier}] [id=timePicker]`));
      await InputBox.ctrlADeleteClear (editableDate);
      await InputBox.updateInputBoxAndTabOut (editableDate, parts[0]);
      await InputBox.updateInputBoxAndTabOut (editableTime, parts[1]);
    }
  }

  public async getDisplayedValueInRow(rowIndex: number, field: string): Promise<string> {
    let elementLocator;
    if (field.endsWith('-miles')) {
      const fieldName = field.substr(0, field.indexOf('-miles'));
      elementLocator = `#track-restriction-table-${fieldName}-${rowIndex} span:nth-child(1)`;
    } else if (field.endsWith('-chains')) {
      const fieldName = field.substr(0, field.indexOf('-chains'));
      elementLocator = `#track-restriction-table-${fieldName}-${rowIndex} span:nth-child(2)`;
    } else if (field === 'comment') {
      elementLocator = `#track-restriction-table-comment-and-buttons-${rowIndex} div:first-child`;
    } else {
      elementLocator = `#track-restriction-table-${field}-${rowIndex}`;
    }
    const editableElement: ElementFinder = element(by.css(elementLocator));
    return editableElement.getText();
  }

  public async isValueInRowBlank(rowIndex: number, field: string): Promise<boolean> {
    let elementLocator;
    if (field.endsWith('-miles')) {
      const fieldName = field.substr(0, field.indexOf('-miles'));
      elementLocator = `#track-restriction-table-${fieldName}-${rowIndex}`;
    } else if (field.endsWith('-chains')) {
      const fieldName = field.substr(0, field.indexOf('-chains'));
      elementLocator = `#track-restriction-table-${fieldName}-${rowIndex}`;
    } else if (field === 'comment') {
      elementLocator = `#track-restriction-table-comment-and-buttons-${rowIndex} div:first-child`;
    } else {
      elementLocator = `#track-restriction-table-${field}-${rowIndex}`;
    }
    const editableElement: ElementFinder = element(by.css(elementLocator));
    const value = await editableElement.getText();
    return value  === '';
  }

  public async isEditableDoneButtonDisabled(): Promise<boolean> {
    return this.disabledEditableRowDoneButton.isPresent();
  }

}
