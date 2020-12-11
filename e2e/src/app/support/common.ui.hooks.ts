import {After, AfterAll, Before, BeforeAll} from 'cucumber';
import {browser, logging} from 'protractor';
import {LocalStorage} from '../../../local-storage/local-storage';
import {CucumberLog} from '../logging/cucumber-log';
import {expect} from 'chai';


BeforeAll(async () => {
  browser.driver.manage().window().maximize();
});

// None arrow methods required to avoid the binding of keyword this
// tslint:disable-next-line:typedef
Before(async function() {
  await CucumberLog.attachLog(this);
});

Before('@newSession', async () => {
  LocalStorage.reset();
  browser.manage().deleteAllCookies();
});

After(async () => {
  // Assert that there are no errors emitted from the browser
  const logs = await browser.manage().logs().get(logging.Type.BROWSER);
  expect(logs).not.have.deep.property('level', logging.Level.SEVERE);
});

// None arrow methods required to avoid the binding of keyword this
// tslint:disable-next-line:typedef only-arrow-functions
After(async function(scenario){
  await CucumberLog.addScreenshotOnFailure(scenario);
});

AfterAll(async () => {
  LocalStorage.reset();
  browser.driver.quit();
});
