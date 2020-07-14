import {After, Before, Given, Then, When} from 'cucumber';
import {AppPage} from '../pages/app.po';
import {browser, logging} from 'protractor';
import { expect } from 'chai';

let page: AppPage;

Before(() => {
  page = new AppPage();
});

Given(/^I am on the home page$/, async () => {
  await page.navigateTo();
});

When(/^I do nothing$/, () => {});

Then(/^I should see nothing$/, async () => {

});

After(async () => {
  // Assert that there are no errors emitted from the browser
  const logs = await browser.manage().logs().get(logging.Type.BROWSER);
  expect(logs).not.have.deep.property('level', logging.Level.SEVERE);
});
