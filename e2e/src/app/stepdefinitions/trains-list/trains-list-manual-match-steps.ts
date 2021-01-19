import {Then} from 'cucumber';
import {expect} from 'chai';

import {TrainsListManualMatchPageObject} from '../../pages/trains-list/trains-list-manual-match-page';

const trainsListManualMatchPage: TrainsListManualMatchPageObject = new TrainsListManualMatchPageObject();

Then('a matched service is visible', async () =>  {
  const matchedService = await trainsListManualMatchPage.isMatchedServiceVisible();
  expect(matchedService).equals(true);
});

Then('no matched service is visible', async () =>  {
  const matchedService = await trainsListManualMatchPage.isMatchedServiceVisible();
  expect(matchedService).equals(false);
});
