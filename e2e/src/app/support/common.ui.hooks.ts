import {After, AfterAll, Before, BeforeAll, Scenario} from 'cucumber';
import {browser, logging} from 'protractor';
import {LocalStorage} from '../../../local-storage/local-storage';
import {CucumberLog} from '../logging/cucumber-log';
import {expect} from 'chai';
import {ReplayRecordings} from '../utils/replay/replay-recordings';


BeforeAll(async () => {
  const {setDefaultTimeout} = require('cucumber');
  setDefaultTimeout(60 * 1000);
  browser.driver.manage().window().maximize();
});

// None arrow methods required to avoid the binding of keyword this
// tslint:disable-next-line:typedef
Before(async function() {
  await CucumberLog.attachLog(this);
});

// tslint:disable-next-line:only-arrow-functions
Before('@replaySetup', async function(scenario: Scenario): Promise<void> {
  ReplayRecordings.start(scenario);
});
// tslint:disable-next-line:only-arrow-functions
After('@replaySetup', async function(scenario: Scenario): Promise<void> {
  ReplayRecordings.finish(scenario);
});

Before('@newSession', async () => {
  await LocalStorage.reset();
});

Before('@loginPageTest', async () => {
  await browser.waitForAngularEnabled(false);
});

After('@loginPageTest', async () => {
  await browser.waitForAngularEnabled(true);
});

// None arrow methods required to avoid the binding of keyword this
// tslint:disable-next-line:typedef only-arrow-functions
After(async function(scenario) {
  await handleUnexpectedAlert();
  await CucumberLog.addScreenshotOnFailure(scenario);
  browser.manage().logs().get(logging.Type.BROWSER)
    .then(logs => expect(logs).not.have.deep.property('level', logging.Level.SEVERE))
    .catch(reason => console.log(scenario.name + ' : ' + reason));
});


AfterAll(async () => {
  ReplayRecordings.writeFiles();
});

async function handleUnexpectedAlert(): Promise<any> {
  try {
    const alert = await browser.switchTo().alert();
    await alert.accept();
  } catch (NoSuchAlertError) {
  }
}
