import {Given, When, Then} from 'cucumber';
import {EnquiriesPageObject} from '../../pages/enquiries/enquiries.page';
import {expect} from 'chai';

const enquiriesPage: EnquiriesPageObject = new EnquiriesPageObject();


Given('I type {string} into the enquiries location search box', async (text: string) => {
  await enquiriesPage.enterLocationSearchString(text);
});

Given('I select the location at position {int} in the enquiries location auto suggest search results list', async (position: number) => {
  await enquiriesPage.clickLocationAutoSuggestSearchResult(position);
});

When('I click the enquiries view button', async () => {
  await enquiriesPage.clickViewButton();
});

Then('I should see the enquiries columns as', {timeout: 2 * 20000}, async (table: any) => {
  const expectedColHeaders: string[] = table.hashes().map((Value: any) => {
    return Value.header;
  });
  const columnsAsExpected = await enquiriesPage.columnsAre(expectedColHeaders);
  expect(columnsAsExpected, 'Columns are not as expected').to.equal(true);
});



