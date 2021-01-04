import {AdministrationLoginMessageTab} from '../../pages/administration/administration-loginMessage-tab.page';
import {Then, When} from 'cucumber';
import { expect } from 'chai';

const adminLoginMessage: AdministrationLoginMessageTab = new AdministrationLoginMessageTab();

When('I update login settings {string} as {string}', async (setting: string, message: string) => {
  await adminLoginMessage.updateLoginMessage(setting, message);
});

Then('I should be able to save the login message settings', async () => {
  await adminLoginMessage.clickSaveButton();
});

When ('I reset the login message settings', async () => {
  await adminLoginMessage.clickResetButton();
});

Then('I should see the login settings {string} as {string}', async (setting: string, expectedText: string) => {
  const actualText = await adminLoginMessage.getLoginMessage(setting);
  return expect(actualText).to.contain(expectedText);
});

Then('the unsaved indicator is displayed on the sign in message tab', async () => {
  const unsavedIndicator = await adminLoginMessage.isUnsavedIndicatorPresent();
  expect(unsavedIndicator).to.equal(true);
});

Then('the unsaved indicator is not displayed on the sign in message tab', async () => {
  const unsavedIndicator = await adminLoginMessage.isUnsavedIndicatorPresent();
  expect(unsavedIndicator).to.equal(false);
});
