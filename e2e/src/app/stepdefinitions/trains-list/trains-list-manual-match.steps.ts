import {Then, When} from 'cucumber';
import {expect} from 'chai';

import {TrainsListManualMatchPageObject} from '../../pages/trains-list/trains-list-manual-match-page';
import {DateAndTimeUtils} from '../../pages/common/utilities/DateAndTimeUtils';
import {DateTimeFormatter} from '@js-joda/core';
import {browser} from 'protractor';

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
  await trainsListManualMatchPage.enterConfirmMessage('Test unmatch');
  await trainsListManualMatchPage.clickSaveMessage();
});

When('I click unmatch', async () =>  {
  await trainsListManualMatchPage.clickUnMatch();
});

When('I click the unmatch cancel option', async () =>  {
  await trainsListManualMatchPage.clickClose();
});

When('I click the unmatch save option', async () =>  {
  await trainsListManualMatchPage.clickSaveMessage();
});

Then(/^the (?:Unmatch|Match) confirmation dialogue is displayed$/, async () =>  {
  await trainsListManualMatchPage.isConfirmationDialogueDisplayed();
});

When('I select to match the result for todays service with planning Id {string}', async (planId: string) =>  {
  if (planId.includes('generated')) {
    planId = browser.referenceTrainUid;
  }
  await trainsListManualMatchPage.selectTodaysService(planId);
  await trainsListManualMatchPage.clickMatch();
  await trainsListManualMatchPage.enterConfirmMessage('Test match');
  await trainsListManualMatchPage.clickSaveMessage();
});

When(/^I open today's timetable with planning UID (.*) from the match table$/, async (trainUid: string) => {
  if (trainUid.includes('generated')) {
    trainUid = browser.referenceTrainUid;
  }
  await trainsListManualMatchPage.openTodayTimetableForTrainUid(trainUid);
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
  if (expectedMatchedServiceUIDText.includes('generated')) {
    expectedMatchedServiceUIDText = browser.referenceTrainUid;
  }
  const actualMatchedServiceText = await trainsListManualMatchPage.matchedTrainUID.getText();
  expect(actualMatchedServiceText, `UID for Matched service is not correct`)
    .equals(expectedMatchedServiceUIDText);
});

Then('no matched service is visible', async () =>  {
  await browser.wait(async () => {
    const matchedService = await trainsListManualMatchPage.isMatchedServiceVisible();
    return matchedService === false;
  }, browser.params.quick_timeout, `Matched service is visible when shouldn't be`);
});

Then(/^the unmatched search results show the following (.*) results?$/,
  async (numExpectedSearchResultsString: string, expectedResults: any) =>  {
  const expectedSearchResults: any[] = expectedResults.hashes();
  const numExpectedSearchResults = parseFloat(numExpectedSearchResultsString);
  const numActualSearchResults = await trainsListManualMatchPage.getNumServicesListed();
  const now = DateAndTimeUtils.getCurrentTime();
  let expectedOriginTime = now;
  expect(numActualSearchResults, `Number of search results incorrect`).to.equal(numExpectedSearchResults);
  for (const expectedSearchResult of expectedSearchResults) {
    const expectedDate = DateAndTimeUtils.convertToDesiredDateAndFormat(expectedSearchResult.date, 'dd-MM-yyyy');
    let expectedPlanUID = expectedSearchResult.planUID;
    if (expectedPlanUID.includes('generated')) {
      expectedPlanUID = browser.referenceTrainUid;
    }
    const timeAdjust = parseFloat(expectedSearchResult.originTime.substr(6));
    if (expectedSearchResult.originTime.substr(4, 1) === '-') {
      expectedOriginTime = now.minusMinutes(timeAdjust);
    }
    else if (expectedSearchResult.originTime.substr(4, 1) === '+') {
      expectedOriginTime = now.plusMinutes(timeAdjust);
    }
    expect(await trainsListManualMatchPage.isServiceListed(expectedPlanUID), `Service for ${expectedPlanUID} not listed`)
      .to.equal(true);
    const actualSearchValues: string[] = await trainsListManualMatchPage
      .getSearchEntryValues(expectedPlanUID, expectedDate.replace('-', '/').replace('-', '/'));
    const expectedTime = expectedOriginTime.format(DateTimeFormatter.ofPattern('HH:mm'));
    const actualTime = actualSearchValues[searchColumnIndexes.time];
    const expectedTimeMinsPastMidnight = await hhmmToMinutesPastMidnight(expectedTime);
    const actualTimeMinsPastMidnight = await hhmmToMinutesPastMidnight(actualTime);
    const timeDiff = Math.abs(actualTimeMinsPastMidnight - expectedTimeMinsPastMidnight);
    const timesCloseEnough = (timeDiff <= 2) || (timeDiff >= 1438);
    let trainDescription = expectedSearchResult.trainNumber;
    if (trainDescription.includes('generated')) {
      trainDescription = browser.referenceTrainDescription;
    }
    expect(actualSearchValues[searchColumnIndexes.service], `Service for ${expectedPlanUID} is incorrect`)
      .to.equal(trainDescription);
    expect(actualSearchValues[searchColumnIndexes.status], `Status for ${expectedPlanUID} is incorrect`)
      .to.equal(expectedSearchResult.status);
    expect(actualSearchValues[searchColumnIndexes.sched], `Sched. for ${expectedPlanUID} is incorrect`)
      .to.equal(expectedSearchResult.sched);
    expect(actualSearchValues[searchColumnIndexes.schedDate], `Sched. Date for ${expectedPlanUID} is incorrect`)
      .to.equal(expectedDate.replace('-', '/').replace('-', '/'));
    expect(actualSearchValues[searchColumnIndexes.origin], `Origin for ${expectedPlanUID} is incorrect`)
      .to.equal(expectedSearchResult.origin);
    expect(timesCloseEnough, `Origin Time for ${expectedPlanUID} is incorrect - expecting ${expectedTime} was ${actualTime}.
    now is ${now}, expectedOriginTime is ${expectedOriginTime} and timeAdjust is ${timeAdjust}`)
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
