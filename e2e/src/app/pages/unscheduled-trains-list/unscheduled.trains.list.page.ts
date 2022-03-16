import {AppPage} from '../app.po';
import {browser, by, element, ElementArrayFinder, ElementFinder, protractor} from 'protractor';
import {UnscheduledTrain} from './unscheduled.train';
import {CucumberLog} from '../../logging/cucumber-log';
import {expect} from 'chai';
// this import looks like its not used but is by expect().to.be.closeToTime()
import * as chaiDateTime from 'chai-datetime';
import {DateAndTimeUtils} from '../common/utilities/DateAndTimeUtils';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';
import {PostgresClient} from '../../api/postgres/postgres-client';

export class UnscheduledTrainsListPageObject {
  public static UNSCHEDULED_TRAINS_LIST_TIME_FORMAT = 'dd/MM/yyyy HH:mm:ss';

  private appPage: AppPage;
  private trainListElement: ElementFinder;
  private trainListPrintIcon: ElementFinder;
  private columnSectionNames: ElementArrayFinder;
  private columnTableNames: ElementArrayFinder;
  private trainRows: ElementArrayFinder;
  private mapRows: ElementArrayFinder;
  private matchContextMenu: ElementFinder;
  private findTrainSubMenuMaps: ElementArrayFinder;

  private postgresClient: PostgresClient;

  constructor() {
    this.appPage = new AppPage();
    this.trainListElement = element(by.id('trainList'));
    this.columnSectionNames = element.all(by.css('.unscheduled-trains-list-section-header'));
    this.columnTableNames = element.all(by.css('[id^=tmv-train-table-header-config-] span'));
    this.trainRows = element.all(by.css('[id^=trains-list-row]'));
    this.mapRows = element.all(by.css('[id^=find-map-list]'));
    this.matchContextMenu = element(by.id('match-unmatch-selection-item'));
    this.findTrainSubMenuMaps = element.all(by.css('#find-map-list span'));
    this.trainListPrintIcon = element(by.id('trains-list-icon-print'));
    this.postgresClient = new PostgresClient();
  }

  public getTrainListElement(): ElementFinder {
    return this.trainListElement;
  }

  public async navigateTo(): Promise<void> {
    await this.appPage.navigateTo(`/tmv/unscheduled`);
  }

  public async clickPrintLink(): Promise<void> {
    return this.trainListPrintIcon.click();
  }

  public async isDisplayed(unscheduledTrain: UnscheduledTrain): Promise<boolean> {
    if (unscheduledTrain.trainId.includes('generated')) {
      unscheduledTrain.trainId = browser.referenceTrainDescription;
    }
    if (unscheduledTrain.entryTime.includes('now')) {
      unscheduledTrain.entryTime = DateAndTimeUtils
        .getCurrentDateTimeString(UnscheduledTrainsListPageObject.UNSCHEDULED_TRAINS_LIST_TIME_FORMAT);
    }
    await CucumberLog.addText(`Expected: ${JSON.stringify(unscheduledTrain)}`);
    const actualUnscheduledTrains: UnscheduledTrain[] = await this.getUnscheduledTrainsListResults();
    await CucumberLog.addText(`Actual: ${JSON.stringify(actualUnscheduledTrains)}`);

    // filter the actual list down to a likely candidate
    const actualFiltered: UnscheduledTrain[] = actualUnscheduledTrains.filter((actualTrain) => {
      return (
        actualTrain.trainId === unscheduledTrain.trainId &&
        actualTrain.entryBerth === unscheduledTrain.entryBerth &&
        actualTrain.entrySignal === unscheduledTrain.entrySignal &&
        actualTrain.entryLocation === unscheduledTrain.entryLocation &&
        actualTrain.currentBerth === unscheduledTrain.currentBerth &&
        actualTrain.currentSignal === unscheduledTrain.currentSignal &&
        actualTrain.currentLocation === unscheduledTrain.currentLocation &&
        actualTrain.currentTrainDescriber === unscheduledTrain.currentTrainDescriber
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
      .formulateDateTime(unscheduledTrain.entryTime, UnscheduledTrainsListPageObject.UNSCHEDULED_TRAINS_LIST_TIME_FORMAT);
    const actualTime = await DateAndTimeUtils
      .formulateDateTime(actualFiltered[0].entryTime, UnscheduledTrainsListPageObject.UNSCHEDULED_TRAINS_LIST_TIME_FORMAT);
    expect(actualTime, `${actualTime} was not close enough to ${expectedTime}: ${JSON.stringify(actualFiltered[0])}`)
      .to.be.closeToTime(expectedTime, 90);

    return Promise.resolve(true);
  }

  public async getUnscheduledTrainsListResults(): Promise<UnscheduledTrain[]> {
    const results = [];
    const resultElements: ElementArrayFinder = element.all(by.css('[id^=trains-list-row]'));
    await resultElements.each(async (result) => {
      const actualTrainDescription = await result.element(by.css('.trains-list-row-entry-train-description')).getText();
      const actualEntryTime = await result.all(by.css('.trains-list-row-entry-schedule-type')).get(0).getText();
      const actualEntryBerth = await result.all(by.css('.trains-list-row-entry-schedule-type')).get(1).getText();
      const actualEntrySignal = await result.all(by.css('.trains-list-row-entry-schedule-type')).get(2).getText();
      const actualEntryLocation = await result.all(by.css('.trains-list-row-entry-schedule-type')).get(3).getText();
      const actualCurrentBerth = await result.all(by.css('.trains-list-row-entry-schedule-type')).get(4).getText();
      const actualCurrentSignal = await result.all(by.css('.trains-list-row-entry-schedule-type')).get(5).getText();
      const actualCurrentLocation = await result.all(by.css('.trains-list-row-entry-schedule-type')).get(6).getText();
      const actualCurrentTrainDescriber = await result.all(by.css('.trains-list-row-entry-schedule-type')).get(7).getText();
      results.push(
        {
          trainId: actualTrainDescription,
          entryTime: actualEntryTime,
          entryBerth: actualEntryBerth,
          entrySignal: actualEntrySignal,
          entryLocation: actualEntryLocation,
          currentBerth: actualCurrentBerth,
          currentSignal: actualCurrentSignal,
          currentLocation: actualCurrentLocation,
          currentTrainDescriber: actualCurrentTrainDescriber
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

  public async getIndexOfUnscheduledTrain(unscheduledTrain: UnscheduledTrain): Promise<number> {
    if (unscheduledTrain.trainId.includes('generated')) {
      unscheduledTrain.trainId = browser.referenceTrainDescription;
    }
    const actualUnscheduledTrains: UnscheduledTrain[] = await this.getUnscheduledTrainsListResults();

    const trainIndex: number = actualUnscheduledTrains.findIndex((train) => {
      return (
        train.trainId === unscheduledTrain.trainId &&
        train.entryBerth === unscheduledTrain.entryBerth &&
        train.entrySignal === unscheduledTrain.entrySignal &&
        train.entryLocation === unscheduledTrain.entryLocation &&
        train.currentBerth === unscheduledTrain.currentBerth &&
        train.currentSignal === unscheduledTrain.currentSignal &&
        train.currentLocation === unscheduledTrain.currentLocation &&
        train.currentTrainDescriber === unscheduledTrain.currentTrainDescriber
      );
    });
    return Promise.resolve(trainIndex);
  }

  public async removeAllTrainsFromUnscheduledTrainsList(): Promise<void> {
    await this.postgresClient.clearAllUnscheduled();
  }

  public async rightClickOnTrainAtPosition(index: number): Promise<void> {
    return browser.actions().click(this.trainRows.get(index), protractor.Button.RIGHT).perform();
  }

  public async leftClickOnMapAtPosition(index: number): Promise<void> {
    return browser.actions().click(this.mapRows.get(index), protractor.Button.LEFT).perform();
  }

  public async clickMatch(): Promise<void> {
    await CommonActions.waitForElementToBeVisible(this.matchContextMenu);
    return this.matchContextMenu.click();
  }

  public async getFindTrainMaps(): Promise<string[]> {
    return this.findTrainSubMenuMaps.map(map => map.getText());
  }
}
