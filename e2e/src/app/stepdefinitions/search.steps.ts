import {Then} from 'cucumber';
import {SearchResultsPageObject} from '../pages/sections/search.results.page';
import {expect} from 'chai';

const searchResultsPage: SearchResultsPageObject = new SearchResultsPageObject();


Then(/^no results are returned with that planning UID '(.*)'$/, async (planningUID: string) => {
  const row = await searchResultsPage.getRowByPlanningUID(planningUID);
  expect(await row.isPresent()).to.equal(false);
});
