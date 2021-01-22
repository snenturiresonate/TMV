import {browser, by, element, ElementFinder, ExpectedConditions} from 'protractor';
import {ModificationsTablerowPage} from './modifications.tablerow.page';
import {of} from 'rxjs';

export class TimeTablePageObject {
  public timetableTab: ElementFinder;
  public headerScheduleType: ElementFinder;
  public headerSignal: ElementFinder;
  public headerLastReported: ElementFinder;
  public headerTrainUid: ElementFinder;
  public headerTrustId: ElementFinder;
  public headerTJM: ElementFinder;
  public headerHeadcode: ElementFinder;
  public headerOldHeadcode: ElementFinder;
  constructor() {
    this.timetableTab = element(by.id('timetable-table-tab'));
    this.headerScheduleType = element(by.id('timetableHeaderScheduleType'));
    this.headerHeadcode = element(by.id('timetable-header-service-information-current-train-description'));
    this.headerOldHeadcode = element(by.id('timetable-header-service-information-planned-train-description'));
    this.headerSignal = element(by.id('timetableHeaderSignalPlatedName'));
    this.headerLastReported = element(by.id('timetableHeaderTrainRunningInformation'));
    this.headerTrainUid = element(by.id('timetableHeaderPlanningUid'));
    this.headerTrustId = element(by.id('timetableHeaderTrustTrainId'));
    this.headerTJM = element(by.id('timetableHeaderTrainJourneyModification'));
  }
  public async isTimetableServiceDescriptionVisible(): Promise<boolean> {
    browser.wait(async () => {
      return this.headerHeadcode.isPresent();
    }, browser.displayTimeout, 'The timetable service information description should be displayed');

    return this.headerHeadcode.isPresent();
  }

  public async getHeaderTrainDescription(): Promise<string> {
    await browser.wait(async () => {
      return this.headerHeadcode.isPresent();
    }, browser.displayTimeout, 'The timetable header train description should be displayed');

    const currentDescription: string = await this.headerHeadcode.getText();
    const plannedDescription: string = await this.headerOldHeadcode.isPresent()
      ? ' ' + await this.headerOldHeadcode.getText() : '';

    return of(currentDescription + plannedDescription).toPromise();
  }

  public async getLiveTimetableTabName(): Promise<string> {
    return this.timetableTab.getText();
  }

  public async openDetailsTab(): Promise<void> {
    await element(by.id('timetable-details-tab')).click();
  }

  public async getModificationsTableRows(): Promise<ModificationsTablerowPage[]> {
    browser.wait(ExpectedConditions.visibilityOf(element(by.css('table.modification-table tbody tr'))));
    const array = new Array<ModificationsTablerowPage>();
    await element.all(by.css('table.modification-table tbody tr'))
      .each((row, index) => {
        array.push(new ModificationsTablerowPage(element(by.css(`table.modification-table tbody tr:nth-child(${index + 1})`))));
      });
    return array;
  }
}
