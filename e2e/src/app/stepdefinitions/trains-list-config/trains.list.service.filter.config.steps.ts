import {TrainsListServiceFilterTabPage} from '../../pages/trains-list-config/trains.list.service.filter.tab.page';
import {Then, When} from 'cucumber';
import {expect} from 'chai';
import {browser} from 'protractor';
import {DateAndTimeUtils} from '../../pages/common/utilities/DateAndTimeUtils';

const trainsListServiceFilterTabPage: TrainsListServiceFilterTabPage = new TrainsListServiceFilterTabPage();

When('I wait for the trust ID data to be retrieved', async () => {
  await trainsListServiceFilterTabPage.waitForTrustIds();
});

When('I input {string} in the TRUST input field', async (trustIdString: string) => {
  await trainsListServiceFilterTabPage.inputTrainId(trustIdString);
});

When('I input {string} in the {string} input box', async (inputString: string, inputBoxId) => {
  if (inputBoxId === 'monthInput') {
    if (inputString === 'today') {
      inputString = DateAndTimeUtils.getCurrentDateTimeString('dd');
    }
  }
  await trainsListServiceFilterTabPage.inputToBox(inputBoxId, inputString);
});

Then(/^the train ID input box (is|is not) disabled$/, async (negate: string) => {
  const canInput: boolean = await trainsListServiceFilterTabPage.canInputTrustId();
  if (negate === 'is not') {
    expect(canInput, 'The trust ID input box was disabled').is.equal(true);
  }
  else {
    expect(canInput, 'The trust ID input box was not disabled').is.equal(false);
  }
});

When('I click the add button for Nominated Services Filter', async () => {
  await trainsListServiceFilterTabPage.clickNominatedServicesAdd();
});

When(/^I add (\d+) TRUST IDs to the filter list$/, async (numberOfTrustIds: number) => {
  for (let i = 0; i < numberOfTrustIds; i++) {
    await trainsListServiceFilterTabPage.inputTrainId(i.toString());
    await trainsListServiceFilterTabPage.clickNominatedServicesAdd();
  }
});

When('I click the clear all button for Nominated Services Filter', async () => {
  await trainsListServiceFilterTabPage.clickTrustIdsClearAll();
});

When('I save the service filter changes', async () => {
  await trainsListServiceFilterTabPage.clickSaveBtn();
  await browser.sleep(2000);
});

When('I save the service filter changes for Nominated Services', async () => {
  await trainsListServiceFilterTabPage.clickTrustIdSaveBtn();
});

Then('The Nominated Services table contains the following results', async (trustIdDataTable: any) => {

  const expectedTrustIds: string[] = trustIdDataTable.hashes();
  const actualTrustIds: string = await trainsListServiceFilterTabPage.getSelectedTrustIds();

  expectedTrustIds.forEach((expectedTrustId: any) => {
    const expandedExpectedTrustId = expectedTrustId.trustId.replace('today', DateAndTimeUtils.getCurrentDateTimeString('dd'));
    expect(actualTrustIds, `Trust ID ${actualTrustIds} does not match the expected ${expandedExpectedTrustId}`)
      .to.contain(expandedExpectedTrustId);
  });
});

When(/^the TRUST ID table contains (\d+) IDs$/, async (expectedIDQuantity: number) => {
  const actualTrustIds = await trainsListServiceFilterTabPage.getSelectedTrustIds();
  expect(actualTrustIds.length, 'Expected ' + expectedIDQuantity + 'TRUST IDs but found ' + actualTrustIds.length)
    .to.equal(expectedIDQuantity);
});

Then('The Nominated Services table does not contain the following results', async (trustIdDataTable: any) => {

  const expectedTrustIds: string[] = trustIdDataTable.hashes();
  const actualTrustIds: string = await trainsListServiceFilterTabPage.getSelectedTrustIds();

  expectedTrustIds.forEach((expectedTrustId: any) => {
    expect(actualTrustIds).not.to.contain(expectedTrustId.trustId);
  });
});

Then('the trustId tab header is displayed as {string}', async (expectedHeader: string) => {
  const actualHeader: string = await trainsListServiceFilterTabPage.getTrustIdHeader();
  expect(actualHeader, 'TrustId tab header is not as expected')
    .to.equal(expectedHeader);
});

Then('I should see the trustId table with header as {string}', async (expectedHeader: string) => {
  const actualHeader: string = await trainsListServiceFilterTabPage.getSelectedTrustIdsTableHeader();
  expect(actualHeader, 'TrustId table header is not as expected')
    .to.equal(expectedHeader);
});

When('I remove the service {string} from the selected nominated services', async (itemName: string) => {
  await trainsListServiceFilterTabPage.removeItem(itemName);
});

Then('the selected Nominated Services table is empty', async () => {
  const tableItemsDisplayed: boolean = await trainsListServiceFilterTabPage.tableDataIsPresent();
  expect(tableItemsDisplayed, 'TrustId table is not empty')
    .to.equal(false);
});

When('the Nominated Services toggle is enabled', async () => {
  const nomindatedServicesToggleState: boolean = await trainsListServiceFilterTabPage.nominatedServicesToggleState();
  expect(nomindatedServicesToggleState).to.equal(true);
});

When('I toggle the evens button', async () => {
  await trainsListServiceFilterTabPage.toggleEvens();
});

When('I toggle the odds button', async () => {
  await trainsListServiceFilterTabPage.toggleOdds();
});
