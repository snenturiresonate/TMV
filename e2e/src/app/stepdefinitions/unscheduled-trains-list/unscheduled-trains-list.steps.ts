import {Before, Given, When, Then} from 'cucumber';
import {UnscheduledTrainsListPageObject} from '../../pages/unscheduled-trains-list/unscheduled.trains.list.page';
import {DelayUtils} from '../../utils/delayUtils';
import {expect} from 'chai';
import {UnscheduledTrain} from '../../pages/unscheduled-trains-list/unscheduled.train';
import {CommonActions} from '../../pages/common/ui-event-handlers/actionsAndWaits';
import {DateAndTimeUtils} from '../../pages/common/utilities/DateAndTimeUtils';

let unscheduledTrainsListPage: UnscheduledTrainsListPageObject;

Before(() => {
  unscheduledTrainsListPage = new UnscheduledTrainsListPageObject();
});

Given(/^I am on the unscheduled trains list$/, async () => {
  await unscheduledTrainsListPage.navigateTo();
  await DelayUtils.waitForTabTitleToContain('TMV Unscheduled Trains List');
  await CommonActions.waitForElementToBeVisible(unscheduledTrainsListPage.getTrainListElement());
});

Then(/^the following unscheduled trains list entry (can|cannot) be seen$/, async (canBeSeen: string, unscheduledTrainsListEntry: any) => {
  const expectedUnscheduledTrain: UnscheduledTrain[] = unscheduledTrainsListEntry.hashes();
  if (canBeSeen === 'can') {
    expect(await unscheduledTrainsListPage.isDisplayed(expectedUnscheduledTrain[0]),
      `Unscheduled train was not found on the unscheduled trains list: ${JSON.stringify(expectedUnscheduledTrain)}`)
      .to.equal(true);
  }
  else {
    expect(await unscheduledTrainsListPage.isDisplayed(expectedUnscheduledTrain[0]),
      `Unscheduled train was found on the unscheduled trains list: ${JSON.stringify(expectedUnscheduledTrain)}`)
      .to.equal(false);
  }
});

Then(/^the following column section names can be seen in the following order on the unscheduled trains list$/, async (sections: any) => {
  const expectedSectionNames: any[] = sections.hashes();
  const actualSectionNames = await unscheduledTrainsListPage.getColumnSectionNames();
  expectedSectionNames.forEach((expectedSectionName, index) => {
    actualSectionNames[index] = actualSectionNames[index] === undefined ? '' : actualSectionNames[index];
    expect(actualSectionNames[index], `Expected column section names: ${actualSectionNames} to match ${expectedSectionNames}`)
      .to.equal(expectedSectionName.columnSection);
  });
});

Then(/^the following table column names can be seen in the following order on the unscheduled trains list$/, async (columnNames: any) => {
  const expectedColumnNames: any[] = columnNames.hashes();
  const actualColumnNames = await unscheduledTrainsListPage.getTableColumnNames();
  expectedColumnNames.forEach((expectedColumnName, index) => {
    actualColumnNames[index] = actualColumnNames[index] === undefined ? '' : actualColumnNames[index];
    expect(actualColumnNames[index], `Expected table column names: ${actualColumnNames} to match ${expectedColumnNames}`)
      .to.equal(expectedColumnName.tableColumnName);
  });
});

Then(/^the unscheduled trains list is ordered by entry time, most recent first$/, async () => {
  const actualUnscheduledTrains: UnscheduledTrain[] = await unscheduledTrainsListPage.getUnscheduledTrainsListResults();
  const firstTrainTime: string = actualUnscheduledTrains[0].entryTime;
  const secondTrainTime: string = actualUnscheduledTrains[1].entryTime;
  expect(await DateAndTimeUtils.formulateDateTime(firstTrainTime, UnscheduledTrainsListPageObject.UNSCHEDULED_TRAINS_LIST_TIME_FORMAT),
    `Expected the unscheduled trains list to be ordered by entry time but ${firstTrainTime} was not after ${secondTrainTime}`)
    .to.be.afterTime(
      await DateAndTimeUtils.formulateDateTime(secondTrainTime, UnscheduledTrainsListPageObject.UNSCHEDULED_TRAINS_LIST_TIME_FORMAT));
});

When(/^I right click on the following unscheduled train$/, async (unscheduledTrainsListEntry: any) => {
  const unscheduledTrains: UnscheduledTrain[] = unscheduledTrainsListEntry.hashes();
  const trainIndex = await unscheduledTrainsListPage.getIndexOfUnscheduledTrain(unscheduledTrains[0]);
  expect(trainIndex, `Cannot find unscheduled train`).to.be.greaterThan(-1);
  await unscheduledTrainsListPage.rightClickOnTrainAtPosition(trainIndex);
});

When(/^I click match on the unscheduled trains list context menu$/, async () => {
  await unscheduledTrainsListPage.clickMatch();
});

When('I remove all trains from the unscheduled trains list', async () => {
  await unscheduledTrainsListPage.removeAllTrainsFromUnscheduledTrainsList();
});

Then(/^the find train sub-menu displays the following maps$/, async (expectedMapsTable: any) => {
  const expectedMapObjects: any[] = expectedMapsTable.hashes();
  const expectedMaps: string[] = expectedMapObjects.map(object => object.map);
  const actualMaps: string[] = await unscheduledTrainsListPage.getFindTrainMaps();
  expectedMaps.forEach(expectedMap => {
    expect(actualMaps, `${actualMaps} did not contain ${expectedMap}`).to.contain(expectedMap);
  });
});

When(/^I click on Print view button of unscheduledTrains page$/, async () => {
  await unscheduledTrainsListPage.clickPrintLink();
});

Then(/^I click the first map on the sub-menu$/, async () => {
  await unscheduledTrainsListPage.leftClickOnMapAtPosition(0);
});
