import {Then, When} from 'cucumber';
import {expect} from 'chai';

import {TrainsListManualMatchPageObject} from '../../pages/trains-list/trains-list-manual-match-page';
import {DateAndTimeUtils} from '../../pages/common/utilities/DateAndTimeUtils';
import {DateTimeFormatter, LocalDateTime} from '@js-joda/core';

const trainsListManualMatchPage: TrainsListManualMatchPageObject = new TrainsListManualMatchPageObject();

const searchColumnIndexes = {
  service: 0,
  trustId: 1,
  planId: 2,
  status: 3,
  sched: 4,
  schedDate: 5,
  origin: 6,
  time: 7,
  dest: 8
};

When('I un-match the currently matched schedule', async () =>  {
  await trainsListManualMatchPage.clickUnMatch();
});

When('I select to match the result for planning Id {string}', async (planId: string) =>  {
  await trainsListManualMatchPage.selectService(planId);
  await trainsListManualMatchPage.clickMatch();
  await trainsListManualMatchPage.enterConfirmMessage('Test match');
  await trainsListManualMatchPage.clickSaveMessage();
});

Then('a matched service is visible', async () =>  {
  const matchedService = await trainsListManualMatchPage.isMatchedServiceVisible();
  expect(matchedService, `Matched service is not visible`)
    .equals(true);
});

Then('the matched service is shown as {string}', async (expectedMatchedServiceText: string) =>  {
  const actualMatchedServiceText = await trainsListManualMatchPage.matchedTrainDesc.getText();
  expect(actualMatchedServiceText, `Matched service is not visible`)
    .equals(expectedMatchedServiceText);
});

Then('the matched service uid is shown as {string}', async (expectedMatchedServiceUIDText: string) =>  {
  const actualMatchedServiceText = await trainsListManualMatchPage.matchedTrainUID.getText();
  expect(actualMatchedServiceText, `UID for Matched service is not correct`)
    .equals(expectedMatchedServiceUIDText);
});


Then('no matched service is visible', async () =>  {
  const matchedService = await trainsListManualMatchPage.isMatchedServiceVisible();
  expect(matchedService, `Matched service is visible when shouldn't be`)
    .equals(false);
});

Then(/^the unmatched search results show the following (.*) results?$/,
  async (numExpectedSearchResultsString: string, expectedResults: any) =>  {
  const expectedSearchResults: any[] = expectedResults.hashes();
  const numExpectedSearchResults = parseFloat(numExpectedSearchResultsString);
  const numActualSearchResults = await trainsListManualMatchPage.getNumServicesListed();
  const now = DateAndTimeUtils.getCurrentDateTime();
  let expectedOriginTime: LocalDateTime;
  expect(numActualSearchResults, `Number of search results incorrect`).to.equal(numExpectedSearchResults);
  for (const expectedSearchResult of expectedSearchResults) {
    const expectedDate = DateAndTimeUtils.convertToDesiredDateAndFormat(expectedSearchResult.date, 'dd-MM-yyyy');
    const expectedPlanUID = expectedSearchResult.planUID;
    const timeAdjust = parseFloat(expectedSearchResult.originTime.substr(7, 5));
    if (expectedSearchResult.originTime.substr(4, 1) === '-') {
      expectedOriginTime = now.minusMinutes(timeAdjust);
    }
    else if (expectedSearchResult.originTime.substr(4, 1) === '+') {
      expectedOriginTime = now.plusMinutes(timeAdjust);
    }
    expect(await trainsListManualMatchPage.isServiceListed(expectedPlanUID), `Service for ${expectedPlanUID} not listed`)
      .to.equal(true);
    const actualSearchValues: string[] = await trainsListManualMatchPage.getSearchEntryValues(expectedPlanUID);
    const expectedTime = await hhmmToMinutesPastMidnight(expectedOriginTime.format(DateTimeFormatter.ofPattern('HHmm')));
    const actualTime = await hhmmToMinutesPastMidnight(actualSearchValues[searchColumnIndexes.time]);
    const timeDiff = Math.abs(actualTime - expectedTime);
    const timesCloseEnough = (timeDiff <= 2) || (timeDiff >= 1438);
    expect(actualSearchValues[searchColumnIndexes.service], `Service for ${expectedPlanUID} is incorrect`)
      .to.equal(expectedSearchResult.trainNumber);
    expect(actualSearchValues[searchColumnIndexes.status], `Status for ${expectedPlanUID} is incorrect`)
      .to.equal(expectedSearchResult.status);
    expect(actualSearchValues[searchColumnIndexes.sched], `Sched. for ${expectedPlanUID} is incorrect`)
      .to.equal(expectedSearchResult.sched);
    expect(actualSearchValues[searchColumnIndexes.schedDate], `Sched. Date for ${expectedPlanUID} is incorrect`)
      .to.equal(expectedDate);
    expect(actualSearchValues[searchColumnIndexes.origin], `Origin for ${expectedPlanUID} is incorrect`)
      .to.equal(expectedSearchResult.origin);
    expect(timesCloseEnough, `Origin Time for ${expectedPlanUID} is incorrect`)
      .to.equal(true);
    expect(actualSearchValues[searchColumnIndexes.dest], `Dest. for ${expectedPlanUID} is incorrect`)
      .to.equal(expectedSearchResult.dest);
  }
});

Then('the unmatched search results shows no results', async () =>  {
  const numActualSearchResults = await trainsListManualMatchPage.getNumServicesListed();
  expect(numActualSearchResults, `Expecting search results to be empty`).to.equal(0);
});

async function hhmmToMinutesPastMidnight(timeString: string): Promise<number> {
  return (parseFloat(timeString.substr(0, 2)) * 60) +
      parseFloat(timeString.substr(3, 3));
}
