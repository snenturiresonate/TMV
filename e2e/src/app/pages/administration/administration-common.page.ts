import {by, element, ElementArrayFinder} from 'protractor';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';

export class AdminPageCommon {
  public administrationTabs: ElementArrayFinder;

  constructor() {
    this.administrationTabs = element.all(by.css('.tmv-tabs-vertical li'));
  }

  public async getAdministrationTab(): Promise<string> {
    await CommonActions.waitForElementToBeVisible(this.administrationTabs.last());
    return this.administrationTabs.getText();
  }
  public async openTab(tabId: string): Promise<void> {
    return element(by.id(tabId)).click();
  }
}
