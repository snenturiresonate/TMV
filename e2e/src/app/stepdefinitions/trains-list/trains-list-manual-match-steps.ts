import {Then, When} from 'cucumber';
import {expect} from 'chai';

import {TrainsListManualMatchPageObject} from '../../pages/trains-list/trains-list-manual-match-page';
import {DateAndTimeUtils} from '../../pages/common/utilities/DateAndTimeUtils';
import * as moment from 'moment';

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

Then('no matched service is visible', async () =>  {
  const matchedService = await trainsListManualMatchPage.isMatchedServiceVisible();
  expect(matchedService, `Matched service is visible when shouldn't be`)
    .equals(false);
});

Then('the unmatched search results show the following {int} results', async (numExpectedSearchResults: number, expectedResults: any) =>  {
  const expectedSearchResults: any[] = expectedResults.hashes();
  const numActualSearchResults = await trainsListManualMatchPage.getNumServicesListed();
  const now = new Date();
  let expectedOriginTime: Date;
  expect(numActualSearchResults, `Number of search results incorrect`).to.equal(numExpectedSearchResults);
  for (const expectedSearchResult of expectedSearchResults) {
    const expectedDate = DateAndTimeUtils.convertToDesiredDateAndFormat(expectedSearchResult.date, 'dd/MM/YYYY');
    const timeAdjust = parseFloat(expectedSearchResult.originTime.toString.subst(7, 5));
    if (expectedSearchResult.originTime.toString.subst(4, 1) === '-') {
      expectedOriginTime = moment(now).subtract(timeAdjust, 'minute').toDate();
    }
    else if (expectedSearchResult.originTime.toString.subst(4, 1) === '+') {
      expectedOriginTime = moment(now).add(timeAdjust, 'minute').toDate();
    }
    const actualSearchValues: string[] = await trainsListManualMatchPage.getSearchEntryValues(expectedSearchResult.planUID);
    expect(actualSearchValues[searchColumnIndexes.service]).to.equal(expectedSearchResult.trainNumber);
    expect(actualSearchValues[searchColumnIndexes.status]).to.equal(expectedSearchResult.status);
    expect(actualSearchValues[searchColumnIndexes.sched]).to.equal(expectedSearchResult.sched);
    expect(actualSearchValues[searchColumnIndexes.schedDate]).to.equal(expectedDate);
    expect(actualSearchValues[searchColumnIndexes.origin]).to.equal(expectedSearchResult.origin);
    expect(actualSearchValues[searchColumnIndexes.time]).to.equal(expectedOriginTime.toTimeString().substr(0, 5));
    expect(actualSearchValues[searchColumnIndexes.dest]).to.equal(expectedSearchResult.dest);
  }
});

Then('the unmatched search results shows no results', async () =>  {
  const numActualSearchResults = await trainsListManualMatchPage.getNumServicesListed();
  expect(numActualSearchResults, `Expecting search results to be empty`).to.equal(0);
});
