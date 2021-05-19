import {When, Then} from 'cucumber';
import {SearchResultsPageObject} from '../pages/sections/search.results.page';
import {expect} from 'chai';
import {DateAndTimeUtils} from '../pages/common/utilities/DateAndTimeUtils';

const searchResultsPage: SearchResultsPageObject = new SearchResultsPageObject();


Then(/^no results are returned with that planning UID '(.*)'$/, async (planningUID: string) => {
  const row = await searchResultsPage.getRowByPlanningUID(planningUID);
  expect(await row.isPresent(), `Row with planning UID ${planningUID} is present`)
    .to.equal(false);
});

Then(/^results are returned with that planning UID '(.*)'$/, async (planningUID: string) => {
  const row = await searchResultsPage.getRowByPlanningUID(planningUID);
  expect(await row.isPresent(), `Row with planning UID ${planningUID} is not present`)
    .to.equal(true);
});

Then(/^one result is returned for today with that planning UID (.*) and it has status (.*) and sched (.*) and service (.*)$/,
    async (planningUID: string, expectedStatus: string, expectedSchedType: string, expectedServDesc: string) => {
  const dateString = DateAndTimeUtils.convertToDesiredDateAndFormat('today', 'dd/MM/yyyy');
  const row = await searchResultsPage.getRowByPlanningUIDandDate(planningUID, dateString);
  expect(await row.status.getText(), `Row for today's schedule with planning UID ${planningUID} should have status  ${expectedStatus}`)
    .to.equal(expectedStatus);
  expect(await row.sched.getText(), `Row for today's schedule with planning UID ${planningUID} should have sched  ${expectedSchedType}`)
        .to.equal(expectedSchedType);
  expect(await row.service.getText(), `Row for today's schedule with planning UID ${planningUID} should have service  ${expectedServDesc}`)
        .to.equal(expectedServDesc);
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
