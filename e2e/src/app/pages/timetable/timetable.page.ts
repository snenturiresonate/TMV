import {browser, by, element, ElementFinder, ExpectedConditions} from 'protractor';
import {ModificationsTablerowPage} from './modifications.tablerow.page';

export class TimeTablePageObject {
  public timetableTab: ElementFinder;
  public headerScheduleType: ElementFinder;
  public headerSignal: ElementFinder;
  public headerLastReported: ElementFinder;
  public headerTrainUid: ElementFinder;
  public headerTrustId: ElementFinder;
  public headerTJM: ElementFinder;
  public headerHeadcode: ElementFinder;
  constructor() {
    this.timetableTab = element(by.id('timetable-table-tab'));
    this.headerScheduleType = element(by.id('timetableHeaderScheduleType'));
    this.headerHeadcode = element(by.id('timetable-header-service-information-current-train-description'));
    this.headerSignal = element(by.id('timetableHeaderSignalPlatedName'));
    this.headerLastReported = element(by.id('timetableHeaderTrainRunningInformation'));
    this.headerTrainUid = element(by.id('timetableHeaderPlanningUid'));
    this.headerTrustId = element(by.id('timetableHeaderTrustTrainId'));
    this.headerTJM = element(by.id('timetableHeaderTrainJourneyModification'));
  }
  public async isTimetableServiceDescriptionVisible(): Promise<boolean> {
    browser.wait(async () => {
      return element(by.id('timetable-header-service-information-current-train-description')).isPresent();
    }, browser.displayTimeout, 'The timetable service information description should be displayed');

    return element(by.id('timetable-header-service-information-current-train-description')).isPresent();
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
