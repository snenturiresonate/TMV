import {TrainsListServiceFilterTabPage} from '../../pages/trains-list-config/trains.list.service.filter.tab.page';
import {Then, When} from 'cucumber';
import {expect} from 'chai';

const trainsListServiceFilterTabPage: TrainsListServiceFilterTabPage = new TrainsListServiceFilterTabPage();

When('I wait for the trust ID data to be retrieved', async () => {
  await trainsListServiceFilterTabPage.waitForTrustIds();
});

When('I input {string} in the TRUST input field', async (trustIdString: string) => {
  await trainsListServiceFilterTabPage.inputTrustId(trustIdString);
});

When('I click the add button for TRUST Service Filter', async () => {
  await trainsListServiceFilterTabPage.clickTrustIdsAdd();
});

When('I click the clear all button for TRUST Service Filter', async () => {
  await trainsListServiceFilterTabPage.clickTrustIdsClearAll();
});

When('I save the service filter changes', async () => {
  await trainsListServiceFilterTabPage.clickSaveBtn();
});

When('I save the service filter changes for Trust Id', async () => {
  await trainsListServiceFilterTabPage.clickTrustIdSaveBtn();
});

Then('The TRUST ID table contains the following results', async (trustIdDataTable: any) => {

  const expectedTrustIds: string[] = trustIdDataTable.hashes();
  const actualTrustIds: string = await trainsListServiceFilterTabPage.getSelectedTrustIds();

  expectedTrustIds.forEach((expectedTrustId: any) => {
    expect(actualTrustIds, `Trust ID ${actualTrustIds} does not match the expected ${expectedTrustId.trustId}`)
      .to.contain(expectedTrustId.trustId);
  });
});

Then('The TRUST ID table does not contain the following results', async (trustIdDataTable: any) => {

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

When('I remove the trust {string} from the selected trusts', async (itemName: string) => {
  await trainsListServiceFilterTabPage.removeItem(itemName);
});

Then('I see the selected trusts table to not have any items', async () => {
  const tableItemsDisplayed: boolean = await trainsListServiceFilterTabPage.tableDataIsPresent();
  expect(tableItemsDisplayed, 'TrustId table is not empty')
    .to.equal(false);
});
