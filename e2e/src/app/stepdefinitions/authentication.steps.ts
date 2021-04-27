import {Given, Then, When} from 'cucumber';
import {AuthenticationModalDialoguePage} from '../pages/authentication-modal-dialogue.page';
import {AppPage} from '../pages/app.po';
import {expect} from 'chai';
import {WelcomeModalPage} from '../pages/welcome-modal-dialogue.page';
import {browser} from 'protractor';

const authPage: AuthenticationModalDialoguePage = new AuthenticationModalDialoguePage();
const appPage: AppPage = new AppPage();
const welcomeModal: WelcomeModalPage = new WelcomeModalPage();

Given('I sign back in as existing user', async (role: string) => {
  await authPage.signBackIntoCurrentRole();
});

When(/^I access the home page without being signed in$/, {timeout: 5 * 10000}, async () => {
  await appPage.navigateToWithoutSignIn('');
});

Then(/^I am presented with the sign in screen$/, async () => {
  await browser.waitForAngularEnabled(false);
  expect(await authPage.signInModalTitleIsPresent()).to.equal(true);
  await browser.waitForAngularEnabled(true);
});

When(/^I access the home page without valid credentials$/, {timeout: 5 * 10000}, async () => {
  await appPage.navigateToWithInvalidLogin('');
});

Then(/^I am informed that the details entered are incorrect$/, async () => {
  await browser.waitForAngularEnabled(false);
  expect(await authPage.signInModalTitleIsPresent()).to.equal(true);
  await browser.waitForAngularEnabled(true);
});

When(/^I access the homepage as (.*)$/, {timeout: 5 * 10000}, async (role: string) => {
  await appPage.authenticateOnlyWithoutReNavigation('', role);
});

Then(/^I am authenticated and see the welcome message$/, async () => {
  expect(await welcomeModal.welcomeModalIsVisible()).to.equal(true);
});
