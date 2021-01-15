import {After, AfterAll, Before, BeforeAll} from 'cucumber';
import {browser, logging} from 'protractor';
import {LocalStorage} from '../../../local-storage/local-storage';
import {CucumberLog} from '../logging/cucumber-log';
import {expect} from 'chai';

BeforeAll(async () => {
  const {setDefaultTimeout} = require('cucumber');
  setDefaultTimeout(20 * 1000);
  browser.driver.manage().window().maximize();
});

// None arrow methods required to avoid the binding of keyword this
// tslint:disable-next-line:typedef
Before(async function() {
  await CucumberLog.attachLog(this);
});

Before('@newSession', async () => {
  LocalStorage.reset();
  browser.manage().deleteAllCookies().catch(() => console.log('cannot delete browser cookies'));
});

// tslint:disable-next-line:typedef only-arrow-functions
Before(async () => {
  await handleUnexpectedAlert();
});

// None arrow methods required to avoid the binding of keyword this
// tslint:disable-next-line:typedef only-arrow-functions
After(async function(scenario){
  await handleUnexpectedAlert();
  await CucumberLog.addScreenshotOnFailure(scenario);
  browser.manage().logs().get(logging.Type.BROWSER)
    .then( logs => expect(logs).not.have.deep.property('level', logging.Level.SEVERE))
    .catch(reason => console.log(scenario.name + ' : ' + reason));
});

AfterAll(async () => {
  LocalStorage.reset();
  browser.driver.quit();
});

async function handleUnexpectedAlert(): Promise<any> {
  try {
    const alert = await browser.switchTo().alert();
    await alert.accept();
  } catch (NoSuchAlertError) {
  }
}
