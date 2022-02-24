import {AppPage} from '../app.po';
import {browser, by, element, ElementArrayFinder, ElementFinder} from 'protractor';
import {UnscheduledTrain} from './unscheduled.train';
import {CucumberLog} from '../../logging/cucumber-log';
import {expect} from 'chai';
// this import looks like its not used but is by expect().to.be.closeToTime()
import * as chaiDateTime from 'chai-datetime';
import {DateAndTimeUtils} from '../common/utilities/DateAndTimeUtils';

export class UnscheduledTrainsListPageObject {
  public static UNSCHEDULED_TRAINS_LIST_TIME_FORMAT = 'dd/MM/yyyy HH:mm:ss';

  private appPage: AppPage;
  private trainListElement: ElementFinder;
  private columnSectionNames: ElementArrayFinder;
  private columnTableNames: ElementArrayFinder;

  constructor() {
    this.appPage = new AppPage();
    this.trainListElement = element(by.id('trainList'));
    this.columnSectionNames = element.all(by.css('.unscheduled-trains-list-section-header'));
    this.columnTableNames = element.all(by.css('[id^=tmv-train-table-header-config-] span'));
  }

  public getTrainListElement(): ElementFinder {
    return this.trainListElement;
  }

  public async navigateTo(): Promise<void> {
    await this.appPage.navigateTo(`/tmv/unscheduled`);
  }

  public async isDisplayed(unscheduledTrain: UnscheduledTrain): Promise<boolean> {
    if (unscheduledTrain.trainId.includes('generated')) {
      unscheduledTrain.trainId = browser.referenceTrainDescription;
    }
    if (unscheduledTrain.time.includes('now')) {
      unscheduledTrain.time = DateAndTimeUtils
        .getCurrentDateTimeString(UnscheduledTrainsListPageObject.UNSCHEDULED_TRAINS_LIST_TIME_FORMAT);
    }
    await CucumberLog.addText(`Expected: ${JSON.stringify(unscheduledTrain)}`);
    const actualUnscheduledTrains: UnscheduledTrain[] = await this.getUnscheduledTrainsListResults();
    await CucumberLog.addText(`Actual: ${JSON.stringify(actualUnscheduledTrains)}`);

    // filter the actual list down to a likely candidate
    const actualFiltered: UnscheduledTrain[] = actualUnscheduledTrains.filter((actualTrain) => {
      return (
        actualTrain.trainId === unscheduledTrain.trainId &&
        actualTrain.berth === unscheduledTrain.berth &&
        actualTrain.trainDescriber === unscheduledTrain.trainDescriber &&
        actualTrain.signal === unscheduledTrain.signal &&
        actualTrain.location === unscheduledTrain.location
      );
    });
    await CucumberLog.addText(`Filtered: ${JSON.stringify(actualFiltered)}`);
    if (actualFiltered.length < 1) {
      return Promise.resolve(false);
    }

    expect(actualFiltered.length, `Found more unscheduled trains than expected: ${JSON.stringify(actualFiltered)}`)
      .to.equal(1);

    // Check that the times are within a close margin of each other
    const expectedTime = await DateAndTimeUtils
      .formulateDateTime(unscheduledTrain.time, UnscheduledTrainsListPageObject.UNSCHEDULED_TRAINS_LIST_TIME_FORMAT);
    const actualTime = await DateAndTimeUtils
      .formulateDateTime(actualFiltered[0].time, UnscheduledTrainsListPageObject.UNSCHEDULED_TRAINS_LIST_TIME_FORMAT);
    expect(actualTime, `${actualTime} was not close enough to ${expectedTime}: ${JSON.stringify(actualFiltered[0])}`)
      .to.be.closeToTime(expectedTime, 60);

    return Promise.resolve(true);
  }

  public async getUnscheduledTrainsListResults(): Promise<UnscheduledTrain[]> {
    const results = [];
    const resultElements: ElementArrayFinder = element.all(by.css('[id^=trains-list-row]'));
    await resultElements.each(async (result) => {
      const actualTrainDescription = await result.element(by.css('.trains-list-row-entry-train-description')).getText();
      const actualTime = await result.all(by.css('.trains-list-row-entry-schedule-type')).get(0).getText();
      const actualBerth = await result.all(by.css('.trains-list-row-entry-schedule-type')).get(1).getText();
      const actualSignal = await result.all(by.css('.trains-list-row-entry-schedule-type')).get(2).getText();
      const actualLocation = await result.all(by.css('.trains-list-row-entry-schedule-type')).get(3).getText();
      const actualTrainDescriber = await result.all(by.css('.trains-list-row-entry-schedule-type')).get(4).getText();
      results.push(
        {
          trainId: actualTrainDescription,
          time: actualTime,
          berth: actualBerth,
          signal: actualSignal,
          location: actualLocation,
          trainDescriber: actualTrainDescriber
        });
    });
    return results;
  }

  public async getColumnSectionNames(): Promise<string[]> {
    return this.columnSectionNames.map(sectionName => sectionName.getText());
  }

  public async getTableColumnNames(): Promise<string[]> {
    return this.columnTableNames.map(columnName => columnName.getText());
  }

}
