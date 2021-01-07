import {browser, by, element, ElementArrayFinder, ElementFinder} from 'protractor';

export class TimeTablePageObject {
  public timetableTab: ElementFinder;
  public headerLabels: ElementArrayFinder;
  public headerScheduleType: ElementFinder;
  public headerSignal: ElementFinder;
  public headerLastReported: ElementFinder;
  public headerTrainUid: ElementFinder;
  public headerTrustId: ElementFinder;
  public headerTJM: ElementFinder;
  public changeEnRoute: ElementArrayFinder;
  constructor() {
    this.headerLabels = element.all(by.css('.tmv-header-content [id$=Label]'));
    this.timetableTab = element(by.id('timetable-table-tab'));
    this.headerScheduleType = element(by.id('timetableHeaderScheduleType'));
    this.headerSignal = element(by.id('timetableHeaderSignalPlatedName'));
    this.headerLastReported = element(by.id('timetableHeaderTrainRunningInformation'));
    this.headerTrainUid = element(by.id('timetableHeaderPlanningUid'));
    this.headerTrustId = element(by.id('timetableHeaderTrustTrainId'));
    this.headerTJM = element(by.id('timetableHeaderTrainJourneyModification'));
    this.changeEnRoute = element.all(by.css('.change-en-route-table >tbody >div >tr>td'));

  }
  public async isTimetableTableTabVisible(): Promise<boolean> {
    const timetableTabClasses: string = await element(by.id('timetable-table-tab')).getAttribute('class');
    return timetableTabClasses.indexOf('tmv-tab-timetable-active') > -1;
  }
  public async isTimetableServiceDescriptionVisible(): Promise<boolean> {
    browser.wait(async () => {
      return element(by.id('timetable-header-service-information-current-train-description')).isPresent();
    }, browser.displayTimeout, 'The timetable service information description should be displayed');

    return element(by.id('timetable-header-service-information-current-train-description')).isPresent();
  }

  public async getTimetableEntryColValues(timetableEntryId: string): Promise<string[]> {
    await browser.wait(async () => {
      return element(by.id('tmv-timetable-row-' + timetableEntryId)).isPresent();
    }, browser.displayTimeout, 'The timetable entry row should be displayed');

    const entryColValues: ElementArrayFinder = element.all(by.css('#tmv-timetable-row-' + timetableEntryId + ' td'));
    return entryColValues.map((colValue: ElementFinder) => {
      return colValue.getText();
    });
  }

  public async toggleInsertedLocationsOn(): Promise<void> {
    await element(by.css('#live-timetable-toggle-menu .toggle-switch .absolute-off')).click();
  }

  public async toggleInsertedLocationsOff(): Promise<void> {
    await element(by.css('#live-timetable-toggle-menu .toggle-switch .absolute-on')).click();
  }

  public async getLiveTimetableTabName(): Promise<string> {
    return this.timetableTab.getText();
  }

  public async openDetailsTab(): Promise<void> {
    await element(by.id('timetable-details-tab')).click();
  }

  public async getTimetableHeaderPropertyLabels(): Promise<string[]> {
    return this.headerLabels.map((labelValue: ElementFinder) => {
      return labelValue.getText();
    });
  }

  public async isTimetableDetailsTabVisible(): Promise<boolean> {
    browser.wait(async () => {
      return element(by.id('timetable-details-table')).isPresent();
    }, browser.displayTimeout, 'The timetable details table should be displayed');

    const timetableTabClasses: string = await element(by.id('timetable-details-tab')).getAttribute('class');
    return timetableTabClasses.indexOf('tmv-tab-timetable-active') > -1;
  }

  public async getTimetableModificationColValues(index: number): Promise<string[]> {
    const entryColValues: ElementArrayFinder = element.all(by.css('#timetable-modifications-' + (index - 1).toString() + ' td'));
    return entryColValues.map((colValue: ElementFinder) => {
      return colValue.getText();
    });
  }
  public async getTimetableAssociationsColValues(index: number): Promise<string[]> {
    const entryColValues: ElementArrayFinder = element.all(by.css('#timetable-associations-' + (index - 1).toString() + ' td'));
    return entryColValues.map((colValue: ElementFinder) => {
      return colValue.getText();
    });
  }

  public async getChangeEnRouteValues(): Promise<string> {
    return this.changeEnRoute.getText();
  }
}
