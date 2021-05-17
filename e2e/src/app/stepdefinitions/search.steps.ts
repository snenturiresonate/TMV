import {When, Then} from 'cucumber';
import {SearchResultsPageObject} from '../pages/sections/search.results.page';
import {expect} from 'chai';
import {browser} from 'protractor';

const searchResultsPage: SearchResultsPageObject = new SearchResultsPageObject();


Then(/^no results are returned with that planning UID '(.*)'$/, async (planningUID: string) => {
  const row = await searchResultsPage.getRowByPlanningUID(planningUID);
  expect(await row.isPresent(), `Row with planning UID ${planningUID} is present`)
    .to.equal(false);
});

Then(/^results are returned with that planning UID '(.*)'$/, async (planningUID: string) => {
  const row = await searchResultsPage.getRowByPlanningUID(planningUID);
  await browser.wait(async () => await row.isPresent(),
    browser.displayTimeout,
    `Waiting for search result row ${planningUID}`);
  expect(await row.isPresent(), `Row with planning UID ${planningUID} is not present`)
    .to.equal(true);
});

Then(/^results are returned with that signal ID '(.*)'$/, async (signalID: string) => {
  const row = await searchResultsPage.getRowBySignalID(signalID);
  expect(await row.isPresent()).to.equal(true);
});

Then('results are returned with planning UID {string} and schedule type {string}', async (planningUID: string, scheduleType: string) =>
{
  const row = await searchResultsPage.getRowByPlanningUIDAndScheduleType(planningUID, scheduleType.toUpperCase());
  expect(await row.isPresent(), `Row with planning UID ${planningUID} & schedule type ${scheduleType} is not present`)
    .to.equal(true);
});

When('I invoke the context menu from train with planning UID {string} on the search results table', async (planningUID: string) => {
  const targetRow = await searchResultsPage.getRowByPlanningUID(planningUID);
  await targetRow.performRightClick();
});
