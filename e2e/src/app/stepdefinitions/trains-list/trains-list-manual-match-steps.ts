import {Then, When} from 'cucumber';
import {expect} from 'chai';

import {TrainsListManualMatchPageObject} from '../../pages/trains-list/trains-list-manual-match-page';

const trainsListManualMatchPage: TrainsListManualMatchPageObject = new TrainsListManualMatchPageObject();

When('I un-match the currently matched schedule', async () =>  {
  await trainsListManualMatchPage.clickUnMatch();
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
