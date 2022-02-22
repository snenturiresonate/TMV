import {by, element, ElementArrayFinder, ElementFinder} from 'protractor';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';

export class RestrictionsPageObject {
  public addRestrictionButton: ElementFinder;
  public restrictionRows: ElementArrayFinder;
  public editableRestrictionRows: ElementArrayFinder;
  public editablerestrictionTypes: ElementArrayFinder;
  public restrictionHeader: ElementFinder;


  constructor() {
    this.addRestrictionButton = element(by.css('#add-track-restriction-button'));
    this.restrictionRows = element.all(by.css('#restrictions-table-body tr'));
    this.editableRestrictionRows = element.all(by.css('.edit-mode-row'));
    this.editablerestrictionTypes = element.all(by.css('.edit-mode-row option'));
    this.restrictionHeader = element(by.xpath(`//div[contains(text(),'Track Division ID:')]`));
  }

  public async addRestriction(): Promise<void> {
    return CommonActions.waitAndClick(this.addRestrictionButton);
  }

  public async getRestrictionsCount(): Promise<number> {
    return this.restrictionRows.count();
  }

  public async getRestrictionsHeaderValue(): Promise<string> {
    return this.restrictionHeader.getText();
  }

  public async getEditableRestrictionRowCount(): Promise<number> {
    return this.editableRestrictionRows.count();
  }

  public async getEditableRestrictionType(index: number): Promise<string> {
    return this.editablerestrictionTypes.get(index).getAttribute('label');
  }

  public async getSelectedType(): Promise<string> {
    return element(by.css('#select option[selected]')).getText();
  }

  public async setValue(field: string, value: string): Promise<void> {
    let editableElement: ElementFinder = element(by.css(`[id*=edit-${field}-input`));
    if (field === 'comment') {
      editableElement = element(by.css(`[id*=edit-${field}] textarea`));
    }
    await editableElement.sendKeys(value);
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
    }
    else if (field === 'start-date') {
      actualValue = await this.getDisplayedDateAndTimeInEditRecord('startDate');
    }
    else if (field === 'end-date') {
      actualValue = await this.getDisplayedDateAndTimeInEditRecord('endDate');
    }
    else {
      let elementLocator = `[id*=edit-${field}-input]`;
      if (field === 'comment') {
        elementLocator = `[id*=edit-${field}] textarea`;
      }
      const editableElement: ElementFinder = element(by.css(elementLocator));
      actualValue = await editableElement.getAttribute('value');
    }
    return (actualValue);
  }
}
