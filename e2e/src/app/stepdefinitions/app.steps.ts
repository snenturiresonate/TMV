import {Before, Given, Then, When} from 'cucumber';
import {AppPage} from '../pages/app.po';
import {expect} from 'chai';
import {LinxRestClient} from '../api/linx/linx-rest-client';
import {AdminRestClient} from '../api/admin/admin-rest-client';
import {BerthCancel, BerthInterpose, BerthStep, Heartbeat, SignallingUpdate} from '../../../../src/app/api/linx/models';
import {CucumberLog} from '../logging/cucumber-log';
import * as fs from 'fs';
import * as path from 'path';
import {ProjectDirectoryUtil} from '../utils/project-directory.util';
import {browser, ExpectedConditions} from 'protractor';
import {TrainJourneyModificationMessageBuilder} from '../utils/train-journey-modifications/train-journey-modification-message';
import {TrainJourneyModificationBuilder} from '../utils/train-journey-modifications/train-journey-modification';
import {OperationalTrainNumberIdentifierBuilder} from '../utils/train-journey-modifications/operational-train-number-identifier';
import {ReferenceOTNBuilder} from '../utils/train-journey-modifications/reference-otn';
import {LocationModifiedBuilder} from '../utils/train-journey-modifications/location-modified';
import {TimingBuilder} from '../utils/train-journey-modifications/timing';
import {TimingAtLocationBuilder} from '../utils/train-journey-modifications/timing-at-location';
import {LocationBuilder} from '../utils/train-journey-modifications/location';
import {LocationSubsidiaryIdentificationBuilder} from '../utils/train-journey-modifications/location-subsidiary-identification';
import {TestData} from '../logging/test-data';
import {AuthenticationModalDialoguePage} from '../pages/authentication-modal-dialogue.page';
import {TrainActivationMessageBuilder} from '../utils/train-activation/train-activation-message';
import {HomePageObject} from '../pages/home.page';
import {DateAndTimeUtils} from '../pages/common/utilities/DateAndTimeUtils';
import {DateTimeFormatter, LocalTime, ZonedDateTime, ZoneId} from '@js-joda/core';
import '@js-joda/timezone';
import {NavBarPageObject} from '../pages/nav-bar.page';
import {RedisClient} from '../api/redis/redis-client';
import {TrainUIDUtils} from '../pages/common/utilities/trainUIDUtils';
import {DynamodbClient} from '../api/dynamo/dynamodb-client';
import {MapPageObject} from '../pages/maps/map.page';

const page: AppPage = new AppPage();
const linxRestClient: LinxRestClient = new LinxRestClient();
const adminRestClient: AdminRestClient = new AdminRestClient();
const dynamoDBClient: DynamodbClient = new DynamodbClient();
const authPage: AuthenticationModalDialoguePage = new AuthenticationModalDialoguePage();
const homePage: HomePageObject = new HomePageObject();
const navBar: NavBarPageObject = new NavBarPageObject();

const userForRole = {
  matching: 'admin',
};


Before(() => {
  TestData.resetTJMsCaptured();
});

Given(/^I navigate to (.*) page$/, async (pageName: string) => {

  switch (pageName) {
    case 'Home':
      await page.navigateTo('');
      break;
    case 'TrainsList':
      await page.navigateTo('/tmv/trains-list');
      break;
    case 'LogViewer':
      await page.navigateTo('/tmv/log-viewer');
      break;
    case 'Replay':
      await page.navigateTo('/tmv/replay');
      break;
    case 'UserManagement':
      await page.navigateTo('/tmv/user-management');
      break;
    case 'Maps':
      await page.navigateTo(`/tmv/maps/hdgw01paddington.v`);
      break;
    case 'TrainsListConfig':
      await page.navigateTo('/tmv/trains-list-config');
      break;
    case 'TimeTable':
      await page.navigateTo('/tmv/live-timetable/1');
      break;
    case 'Admin':
      await page.navigateTo('/tmv/administration');
      break;
  }
});

Given(/^I navigate to (.*) page as (.*) user$/, async (pageName: string, user: string) => {

  switch (pageName) {
    case 'Home':
      await page.navigateTo('', user);
      break;
    case 'TrainsList':
      await page.navigateTo('/tmv/trains-list', user);
      break;
    case 'LogViewer':
      await page.navigateTo('/tmv/log-viewer', user);
      break;
    case 'Replay':
      await page.navigateTo('/tmv/replay', user);
      break;
    case 'Maps':
      await page.navigateTo(`/tmv/maps/1`, user);
      break;
    case 'TrainsListConfig':
      await page.navigateTo('/tmv/trains-list-config', user);
      break;
    case 'Admin':
      await page.navigateTo('/tmv/administration', user);
      break;
    case 'Enquiries':
      await page.navigateTo('/tmv/enquiries', user);
      break;
  }
});

Given(/^I navigate to (.*) page without prior authentication$/, async (pageName: string) => {

  switch (pageName) {
    case 'Home':
      await page.navigateToWithoutSignIn('');
      break;
    case 'TrainsList':
      await page.navigateToWithoutSignIn('/tmv/trains-list');
      break;
    case 'LogViewer':
      await page.navigateToWithoutSignIn('/tmv/log-viewer');
      break;
    case 'Replay':
      await page.navigateToWithoutSignIn('/tmv/replay');
      break;
    case 'Maps':
      await page.navigateToWithoutSignIn(`/tmv/maps/1`);
      break;
    case 'TrainsListConfig':
      await page.navigateToWithoutSignIn('/tmv/trains-list-config');
      break;
    case 'Admin':
      await page.navigateToWithoutSignIn('/tmv/administration');
      break;
    case 'Enquiries':
      await page.navigateToWithoutSignIn('/tmv/enquiries');
      break;
  }
});

Given(/^I am viewing the map (.*)$/, {timeout: 40000}, async (mapId: string) => {
  const url = '/tmv/maps/' + mapId;
  await page.navigateTo(url);
  await MapPageObject.waitForTracksToBeDisplayed();
});

Given(/^I view the map (.*) as (.*) user$/, {timeout: 40000}, async (mapId: string, user: string) => {
  const url = '/tmv/maps/' + mapId;
  await page.navigateTo(url, user);
});

Given(/^I view the map (.*) without prior authentication$/, {timeout: 40000}, async (mapId: string) => {
  const url = '/tmv/maps/' + mapId;
  await page.navigateToWithoutSignIn(url);
});

// tslint:disable-next-line:max-line-length
Then(/^I navigate to the timetable page of train UID (.*) and date (.*) as (.*) user$/, async (trainUID: string, date: string, user: string) => {
  const dateInFormat = DateAndTimeUtils.convertToDesiredDateAndFormat(date, 'yyyy-MM-dd');
  const url = `/tmv/live-timetable/${trainUID}:${dateInFormat}`;
  await page.navigateTo(url, user);
});

// tslint:disable-next-line:max-line-length
Then(/^I navigate to the timetable page of train UID (.*) and date (.*) without prior authentication$/, async (trainUID: string, date: string) => {
  const dateInFormat = DateAndTimeUtils.convertToDesiredDateAndFormat(date, 'yyyy-MM-dd');
  const url = `/tmv/live-timetable/${trainUID}:${dateInFormat}`;
  await page.navigateToWithoutSignIn(url);
});

Then(/^I navigate to the schedule matching page for the following train$/, async (table: any) => {
  const trainDetails = table.hashes()[0];
  const dateInFormat = DateAndTimeUtils.convertToDesiredDateAndFormat(trainDetails.scheduleDate, 'yyyy-MM-dd');
  const trainUID = trainDetails.trainUID;
  const trainDescription = trainDetails.trainDesc;
  const url = `/tmv/manual-match-selection?scheduleId=${trainUID}:${dateInFormat}&trainDesc=${trainDescription}`;
  await browser.get(url);
});

Then(/^I navigate to the restrictions page for track id (.*)$/, async (trackId: string) => {
  const url = `/tmv/restrictions?trackId=${trackId}`;
  await browser.get(url);
});

Then(/^I am re-directed to home page$/, async () => {
  expect(await homePage.getWelcomeMessageText()).to.contain('Welcome to TMV');
});

Then(/^I am not re-directed to home page$/, async () => {
  expect(await navBar.navBarIsDisplayed()).to.equal(true);
  expect(await homePage.homePageDisplayed()).to.equal(false);
});

Given(/^I have not already authenticated$/, {timeout: 5 * 10000}, async () => {
  await logout();
});

async function logout(): Promise<void> {
  await browser.waitForAngularEnabled(false);
  await browser.get(browser.baseUrl);
  if (await homePage.userProfileIcon.isPresent()) {
    await navBar.openUserProfileMenu();
    await navBar.clickSignOutButton();
  }
  if (await authPage.signInModalIsPresent() === false) {
    // An error must have occurred, so recursively retry
    await CucumberLog.addText('Logout error occured - retrying logout...');
    await logout();
    return;
  }
  expect(await authPage.signInModalIsVisible(), 'Sign In Modal is not visible').to.equal(true);
  if (await authPage.reAuthenticationModalIsVisible()) {
    await authPage.clickSignInAsDifferentUser();
  }
  await browser.waitForAngularEnabled(true);
}

Given(/^I am on the home page$/, {timeout: 5 * 10000}, async () => {
  await page.navigateTo('');
});

Given(/^I am authenticated to use TMV$/, async () => {
  await page.navigateTo('');
});

Given('I am authenticated to use TMV with {string} role', {timeout: 5 * 10000}, async (userRole: string) => {
  await page.navigateTo('', userForRole[userRole]);
});

Given(/^I have not opened the trains list before$/, async () => {
  await dynamoDBClient.deleteTable('TrainsListSettings-' + `${browser.params.dynamo_suffix}`);
  await dynamoDBClient.addTable('TrainsListSettings-' + `${browser.params.dynamo_suffix}`);
});

Given(/^The admin setting defaults are as originally shipped$/, async () => {
  const rawData: Buffer = fs.readFileSync(path.join(ProjectDirectoryUtil.testDataFolderPath(), 'admin/admin-defaults.json'));
  const adminDefaults = rawData.toString();
  await CucumberLog.addJson(adminDefaults);
  expect(await adminRestClient.postAdminConfiguration(adminDefaults)).to.equal(200);
  await adminRestClient.waitMaxTransmissionTime();
});

When(/^I do nothing$/, async () => {
  await browser.sleep(5000);
});
When(/^I give the (.*) (.*) seconds? to (.*)$/, async (system: string, seconds: number, action: string) => {
  await CucumberLog.addText(`Giving the ${system} ${seconds} seconds to ${action}`);
  await browser.sleep(seconds * 1000);
});

When(/^the following berth interpose messages? (?:is|are) sent from LINX(.*)$/,
  async (explanation: string, berthInterposeMessageTable: any) => {
    const berthInterposeMessages: any = berthInterposeMessageTable.hashes();

    for (const berthInterposeMessage of berthInterposeMessages) {
      await linxRestClient.postInterpose(
        berthInterposeMessage.timeStamp,
        berthInterposeMessage.toBerth,
        berthInterposeMessage.trainDescriber,
        berthInterposeMessage.trainDescription);
    }
  });

When(/^the following live berth interpose messages? (?:is|are) sent from LINX(.*)$/,
  async (explanation: string, berthInterposeMessageTable: any) => {
    const berthInterposeMessages: any = berthInterposeMessageTable.hashes();
    const now = DateAndTimeUtils.getCurrentTimeString();
    for (const berthInterposeMessage of berthInterposeMessages) {
      await linxRestClient.postInterpose(
        now, berthInterposeMessage.toBerth, berthInterposeMessage.trainDescriber, berthInterposeMessage.trainDescription);
    }
  });

When(/^the following live (.) (.*) minutes? berth interpose messages? (?:is|are) sent from LINX(.*)$/,
  async (operator: string, minutesToAdjust: number, explanation: string, berthInterposeMessageTable: any) => {
    const adjustedTime: string = await DateAndTimeUtils.adjustNowTime(operator, minutesToAdjust);
    const berthInterposeMessages: any = berthInterposeMessageTable.hashes();
    for (const berthInterposeMessage of berthInterposeMessages) {
      await linxRestClient.postInterpose(
        adjustedTime, berthInterposeMessage.toBerth, berthInterposeMessage.trainDescriber, berthInterposeMessage.trainDescription);
    }
  });

When(/^the following berth step messages? (?:is|are) sent from LINX(.*)$/, async (explanation: string, berthStepMessageTable: any) => {
  const berthStepMessages: any = berthStepMessageTable.hashes();

  for (const berthStepMessage of berthStepMessages) {
    const berthStep: BerthStep = new BerthStep(
      berthStepMessage.fromBerth,
      berthStepMessage.timestamp,
      berthStepMessage.toBerth,
      berthStepMessage.trainDescriber,
      berthStepMessage.trainDescription
    );
    await CucumberLog.addJson(berthStep);
    await linxRestClient.postBerthStep(berthStep);
  }
  await linxRestClient.waitMaxTransmissionTime();
});

When(/^the following live berth step messages? (?:is|are) sent from LINX(.*)$/,
  async (explanation: string, berthStepMessageTable: any) => {
    const berthStepMessages: any = berthStepMessageTable.hashes();
    const now = DateAndTimeUtils.getCurrentTimeString();
    for (const berthStepMessage of berthStepMessages) {
      const berthStep: BerthStep = new BerthStep(
        berthStepMessage.fromBerth,
        now,
        berthStepMessage.toBerth,
        berthStepMessage.trainDescriber,
        berthStepMessage.trainDescription
      );
      await CucumberLog.addJson(berthStep);
      await linxRestClient.postBerthStep(berthStep);
    }
    await linxRestClient.waitMaxTransmissionTime();
  });

When(/^the following live (.) (.*) minutes? berth step messages? (?:is|are) sent from LINX(.*)$/,
  async (operator: string, minutesToAdjust: number, explanation: string, berthStepMessageTable: any) => {
    const adjustedTime: string = await DateAndTimeUtils.adjustNowTime(operator, minutesToAdjust);
    const berthStepMessages: any = berthStepMessageTable.hashes();
    for (const berthStepMessage of berthStepMessages) {
      const berthStep: BerthStep = new BerthStep(
        berthStepMessage.fromBerth,
        adjustedTime,
        berthStepMessage.toBerth,
        berthStepMessage.trainDescriber,
        berthStepMessage.trainDescription
      );
      await CucumberLog.addJson(berthStep);
      await linxRestClient.postBerthStep(berthStep);
    }
    await linxRestClient.waitMaxTransmissionTime();
  });

When(/^the following berth cancel messages? (?:is|are) sent from LINX$/, async (berthCancelMessageTable: any) => {
  const berthCancelMessages: any = berthCancelMessageTable.hashes();

  for (const berthCancelMessage of berthCancelMessages) {
    const berthCancel: BerthCancel = new BerthCancel(
      berthCancelMessage.fromBerth,
      berthCancelMessage.timestamp,
      berthCancelMessage.trainDescriber,
      berthCancelMessage.trainDescription
    );
    await CucumberLog.addJson(berthCancel);
    await linxRestClient.postBerthCancel(berthCancel);
  }
  await linxRestClient.waitMaxTransmissionTime();
});

When(/^the following live berth cancel messages? (?:is|are) sent from LINX$/, async (berthCancelMessageTable: any) => {
  const berthCancelMessages: any = berthCancelMessageTable.hashes();
  for (const berthCancelMessage of berthCancelMessages) {
    const now = DateAndTimeUtils.getCurrentTimeString();
    const berthCancel: BerthCancel = new BerthCancel(
      berthCancelMessage.fromBerth,
      now,
      berthCancelMessage.trainDescriber,
      berthCancelMessage.trainDescription
    );
    await CucumberLog.addJson(berthCancel);
    await linxRestClient.postBerthCancel(berthCancel);
  }
  await linxRestClient.waitMaxTransmissionTime();
});

When(/^the following signalling update messages? (?:is|are) sent from LINX$/, async (signallingUpdateMessageTable: any) => {
  const signallingUpdateMessages: any = signallingUpdateMessageTable.hashes();

  for (const signallingUpdateMessage of signallingUpdateMessages) {
    const signallingUpdate: SignallingUpdate = new SignallingUpdate(
      signallingUpdateMessage.address,
      signallingUpdateMessage.data,
      signallingUpdateMessage.timestamp,
      signallingUpdateMessage.trainDescriber
    );
    await CucumberLog.addJson(signallingUpdate);
    await linxRestClient.postSignallingUpdate(signallingUpdate);
  }
});

When(/^the following live signalling update messages? (?:is|are) sent from LINX(.*)$/,
  async (explanation: string, signallingUpdateMessageTable: any) => {
    const signallingUpdateMessages: any = signallingUpdateMessageTable.hashes();
    const now = DateAndTimeUtils.getCurrentTimeString();

    for (const signallingUpdateMessage of signallingUpdateMessages) {
      const signallingUpdate: SignallingUpdate = new SignallingUpdate(
        signallingUpdateMessage.address,
        signallingUpdateMessage.data,
        now,
        signallingUpdateMessage.trainDescriber
      );
      await CucumberLog.addJson(signallingUpdate);
      await linxRestClient.postSignallingUpdate(signallingUpdate);
    }
  });

When(/^the following heartbeat messages? (?:is|are) sent from LINX$/, async (heartbeatMessageTable: any) => {
  const heartbeatMessages: any = heartbeatMessageTable.hashes();

  for (const heartbeatMessage of heartbeatMessages) {
    const heartbeat: Heartbeat = new Heartbeat(
      heartbeatMessage.timestamp,
      heartbeatMessage.trainDescriber,
      heartbeatMessage.trainDescriberTimestamp
    );
    await CucumberLog.addJson(heartbeat);
    await linxRestClient.postHeartbeat(heartbeat);
  }
});

When(/^the following train journey modification messages? (?:is|are) sent from LINX$/,
  async (trainJourneyModificationMessageTable: any) => {
    const trainJourneyModificationMessages: any = trainJourneyModificationMessageTable.hashes();

    for (const trainJourneyModificationMessage of trainJourneyModificationMessages) {
      await linxRestClient.postTrainJourneyModification(trainJourneyModificationMessage.asXml);
    }
  });

When(/^the following train journey modification change of id messages? (?:is|are) sent from LINX$/,
  async (trainJourneyModificationChangeOfIdMessageTable: any) => {
    const trainJourneyModificationChangeOfIdMessages: any = trainJourneyModificationChangeOfIdMessageTable.hashes();

    for (const trainJourneyModificationChangeOfIdMessage of trainJourneyModificationChangeOfIdMessages) {
      await linxRestClient.postTrainJourneyModificationIdChange(trainJourneyModificationChangeOfIdMessage.asXml);
    }
  });

/**
 * Used for sending train activation message with the following fields
 * | trainUID (mandatory) | trainNumber (mandatory) | scheduledDepartureTime (mandatory - hh:mm accepts 'now')
 * | locationPrimaryCode (mandatory) | locationSubsidiaryCode (mandatory)
 * |departureDate (mandatory-dd-mm-yyyy accepts 'yesterday', 'today', 'tomorrow')
 * |actualDepartureHour (Optional - hh:mm accepts 'now' Defaults to current hour)|asm (Optional - Defaults to '0')|
 */

When(/^the following train activation? (?:message|messages)? (?:is|are) sent from LINX$/, async (trainActivationMessageTable: any) => {
  const trainActivationMessages = trainActivationMessageTable.hashes();
  for (const activation of trainActivationMessages) {
    const trainActivationMessageBuilder: TrainActivationMessageBuilder = new TrainActivationMessageBuilder();
    let trainUID = activation.trainUID;
    if (trainUID === 'generatedTrainUId') {
      trainUID = browser.referenceTrainUid;
    }
    const trainNumber = activation.trainNumber;
    const schedDepString = (activation.scheduledDepartureTime).toLowerCase();
    const scheduledDepartureTime = () => {
      if (schedDepString === 'now') {
        return DateAndTimeUtils.getCurrentTimeString();
      } else if (schedDepString.includes('now + ')) {
        const offset = parseInt(schedDepString.substr(6, schedDepString.length - 6), 10);
        return DateAndTimeUtils.getCurrentTime().plusMinutes(offset).format(DateTimeFormatter.ofPattern('HH:mm:ss'));
      } else if (schedDepString.includes('now - ')) {
        const offset = parseInt(schedDepString.substr(6, schedDepString.length - 6), 10);
        return DateAndTimeUtils.getCurrentTime().minusMinutes(offset).format(DateTimeFormatter.ofPattern('HH:mm:ss'));
      } else {
        return activation.scheduledDepartureTime;
      }
    };
    const departureDate = () => {
      if ((activation.departureDate).toLowerCase() === 'today' ||
        (activation.departureDate).toLowerCase() === 'yesterday' ||
        (activation.departureDate).toLowerCase() === 'tomorrow') {
        return DateAndTimeUtils.convertToDesiredDateAndFormat((activation.departureDate).toLowerCase(), 'yyyy-MM-dd');
      } else if (activation.departureDate === undefined) {
        return DateAndTimeUtils.convertToDesiredDateAndFormat('today', 'yyyy-MM-dd');
      } else {
        return activation.scheduledDepartureTime;
      }
    };
    const actualDepartureHour = () => {
      let aDH = activation.actualDepartureHour;
      if (aDH === undefined) {
        aDH = 'now';
      }
      if (aDH.toLowerCase() === 'now' || activation.departureDate === undefined) {
        return DateAndTimeUtils.getCurrentTimeString('HH');
      }
      return activation.actualDepartureHour;
    };
    const locationPrimaryCode = activation.locationPrimaryCode;
    const locationSubsidiaryCode = activation.locationSubsidiaryCode;
    const asmVal = activation.asm ? activation.asm : 1;
    const trainActMss = trainActivationMessageBuilder.buildMessage(locationPrimaryCode, locationSubsidiaryCode,
      scheduledDepartureTime().toString(), trainNumber, trainUID, departureDate().toString(), actualDepartureHour().toString(), asmVal);
    await linxRestClient.postTrainActivation(trainActMss.toString({prettyPrint: true}));
    await CucumberLog.addText(`Train Activation message: ${trainActMss.toString({prettyPrint: true})}`);
  }
});

When('the activation message from location {string} is sent from LINX', async (xmlFilePath: string) => {
  const rawData: Buffer = fs.readFileSync(path.join(ProjectDirectoryUtil.testDataFolderPath(), xmlFilePath));
  await linxRestClient.postTrainActivation(rawData.toString());
});

When(/^the following VSTP messages? (?:is|are) sent from LINX$/, async (vstpMessageTable: any) => {
  const vstpMessages: any = vstpMessageTable.hashes();
  for (const vstpMessage of vstpMessages) {
    await linxRestClient.postVstp(vstpMessage.asXml);
  }
});

Then(/^I should see nothing$/, async () => {
  return;
});

Then('a modal displays with title {string}', async (modalTitle: string) => {
  const displayedTitle: string = await page.getModalWindowTitle();
  expect(displayedTitle, 'Modal title is not correct')
    .to.contain(modalTitle);
});

Then('the modal contains a {string} button', async (buttonName: string) => {
  const displayedButtons: string = await page.getModalButtons();
  expect(displayedButtons, `Button ${buttonName} is not on the Modal`)
    .to.contain(buttonName);
});

Given(/^I am on the trains list page$/, {timeout: 4 * 10000}, async () => {
  await page.navigateTo('/tmv/trains-list');
});

Given(/^I am on the trains list Config page$/, {timeout: 4 * 10000}, async () => {
  await page.navigateTo('/tmv/trains-list-config');
});

Given(/^I am on the log viewer page$/, async () => {
  await page.navigateTo('/tmv/log-viewer');
});

Given(/^I am on the admin page$/, {timeout: 5 * 10000}, async () => {
  try {
    await page.navigateTo('/tmv/administration');
  } catch (UnexpectedAlertOpenError) {
    await handleUnexpectedAlertAndNavigateTo('/tmv/administration');
  }
});

Given(/^I am on the replay page$/, {timeout: 2 * 20000}, async () => {
  await page.navigateTo('/tmv/replay/replay-session-1');
});

Given(/^I am on the replay page as existing user$/, {timeout: 2 * 20000}, async () => {
  await page.navigateToAndSignIn('/tmv/replay/replay-session-1');
});

Given('I am on the live timetable page with schedule id {string}', async (scheduleId: string) => {
  await page.navigateTo(`tmv/live-timetable/${scheduleId}`);
});


Then('the tab title is {string}', async (expectedTabTitle: string) => {
  await browser.driver.wait(ExpectedConditions.titleContains(expectedTabTitle));
  const actualTabTitle: string = await browser.driver.getTitle();
  expect(actualTabTitle, `Tab title is ${actualTabTitle} not ${expectedTabTitle}`)
    .to.contains(expectedTabTitle);
});

Then('the tab title contains {string}', async (expectedTabTitle: string) => {
  await browser.driver.wait(async () => {
    const tabTitle: string = await browser.driver.getTitle();
    return tabTitle.includes(expectedTabTitle);
  });
  const actualTabTitle: string = await browser.driver.getTitle();
  expect(actualTabTitle, `Tab title is ${actualTabTitle} not ${expectedTabTitle}`)
    .to.contains(expectedTabTitle);
});

Then('the tab title contains the selected Train', async () => {
  await browser.driver.wait(ExpectedConditions.titleContains(browser.selectedTrain));
  const actualTabTitle: string = await browser.driver.getTitle();
  expect(actualTabTitle, `Tab title is ${actualTabTitle} not TMV Replay Timetable ${browser.selectedTrain}`)
    .to.contains(browser.selectedTrain);
});
When('I open {string} page in a new tab', async (pageName: string) => {
  try {
    await OpenNewTab();
  } catch (e) {
    await CucumberLog.addText(e.message);
    if (e.message.includes('unexpected alert')) {
      await acceptUnexpectedAlert();
    }
  }
  switch (pageName) {
    case 'admin': {
      await page.navigateTo('/tmv/administration');
      break;
    }
    case 'trains list Config': {
      await page.navigateTo('/tmv/trains-list-config');
      break;
    }
    case 'trains list config': {
      await page.navigateTo('/tmv/trains-list-config');
      break;
    }
    case 'trains list': {
      await page.navigateTo('/tmv/trains-list');
      break;
    }
    case 'home': {
      await page.navigateTo('');
      break;
    }
  }
});

async function handleUnexpectedAlertAndNavigateTo(url: string): Promise<any> {
  const alert = await browser.switchTo().alert();
  await alert.accept();
  await page.navigateTo(url);
}

async function acceptUnexpectedAlert(): Promise<any> {
  const alert = await browser.switchTo().alert();
  await alert.accept();
}

async function OpenNewTab(): Promise<any> {
  return browser.executeAsyncScript('window.open()');
}

When(/^the following TJMs? (?:is|are) received$/, async (table: any) => {
  let runDate = 'today';
  const messages: any = table.hashes();
  for (const message of messages) {
    const now = DateAndTimeUtils.getCurrentDateTime();
    let depHour = now.format(DateTimeFormatter.ofPattern('HH'));
    let timeStamp = now.format(DateTimeFormatter.ofPattern('HH:mm:ss'));
    if (message.departureHour !== 'now') {
      depHour = message.departureHour;
    }
    if (message.time !== 'now') {
      timeStamp = message.time;
    }
    if (message.runDate === 'tomorrow') {
      runDate = 'tomorrow';
    }
    const tjmBuilder = createBaseTjmMessage(message.trainNumber, message.trainUid, depHour, runDate)
      .withTrainJourneyModification(createBaseTjm(message.indicator,
        message.statusIndicator,
        message.primaryCode,
        message.subsidiaryCode,
        timeStamp)
        .build())
      .withModificationReason(message.modificationReason)
      .withNationalDelayCode(message.nationalDelayCode);
    if (message.modificationTime !== undefined) {
      tjmBuilder.withTrainJourneyModificationTime(message.modificationTime);
    }
    const tjmMessage = tjmBuilder.build();

    await linxRestClient.postTrainJourneyModification(tjmMessage.toXML());
    TestData.addTJM(tjmMessage);
    await linxRestClient.waitMaxTransmissionTime();
  }
});

When(/^the following change of ID TJM is received$/, async (table: any) => {
  const messages: any = table.hashes();
  for (const message of messages) {
    const tjmBuilder = createBaseTjmMessage(message.newTrainNumber, message.trainUid, message.departureHour)
      .withTrainJourneyModification(new TrainJourneyModificationBuilder()
        .withTrainJourneyModificationIndicator(message.indicator)
        .withLocationModified(new LocationModifiedBuilder()
          .withModificationStatusIndicator(message.statusIndicator)
          .withLocation(new LocationBuilder()
            .withLocationPrimaryCode(message.primaryCode)
            .build())
          .build())
        .build())
      .withReferenceOTN(new ReferenceOTNBuilder()
        .withOperationalTrainNumberIdentifier(new OperationalTrainNumberIdentifierBuilder()
          .withOperationalTrainNumber(message.oldTrainNumber)
          .build())
        .build());
    if (message.modificationTime !== undefined) {
      tjmBuilder.withTrainJourneyModificationTime(message.modificationTime);
    }
    const tjmMessage = tjmBuilder.build();

    await linxRestClient.postTrainJourneyModificationIdChange(tjmMessage.toXML());
    TestData.addTJM(tjmMessage);
    await linxRestClient.waitMaxTransmissionTime();
  }
});

function createBaseTjm(modificationIndicator, modificationStatusIndicator, locationPrimaryCode, locationSubsidiaryCode, time)
  : TrainJourneyModificationBuilder {
  return new TrainJourneyModificationBuilder()
    .withTrainJourneyModificationIndicator(modificationIndicator)
    .withLocationModified(new LocationModifiedBuilder()
      .withModificationStatusIndicator(modificationStatusIndicator)
      .withLocation(new LocationBuilder()
        .withLocationPrimaryCode(locationPrimaryCode)
        .withLocationSubsidiaryIdentification(new LocationSubsidiaryIdentificationBuilder()
          .withLocationSubsidiaryCode(locationSubsidiaryCode)
          .build())
        .build())
      .withTimingAtLocation(new TimingAtLocationBuilder()
        .withTiming(new TimingBuilder()
          .withTime(time)
          .build())
        .build())
      .build());
}

function createBaseTjmMessage(trainNumber, trainUid, departureHour, runDate: string = 'today'): TrainJourneyModificationMessageBuilder {
  return new TrainJourneyModificationMessageBuilder()
    .create()
    .withOperationalTrainNumberIdentifier(new OperationalTrainNumberIdentifierBuilder()
      .withOperationalTrainNumber(trainNumber)
      .build())
    .calculateSenderReferenceWith(trainUid, departureHour, runDate);
}

When(/^I step through the Berth Level Schedule for '(.*)'$/, async (uid: string) => {
  const client = new RedisClient();
  const key = `${uid}:${DateAndTimeUtils.getCurrentDateTimeString('yyyy-MM-dd')}`;
  const data = await client.hgetParseJSON('berth-level-schedule-pairs', key);

  const berthLevelSchedule = data.berthLevelSchedule;
  let currentBerth = '';
  let currentBerthDescriber = '';
  let lastTiming = '';
  for (const pathEntry of berthLevelSchedule.pathEntries) {
    if (pathEntry.berths.length > 0) {
      const berth = pathEntry.berths[0];
      const plannedStepTime = ZonedDateTime.parse(berth.plannedStepTime)
        .withZoneSameInstant(ZoneId.of('Europe/London'))
        .format(DateTimeFormatter.ofPattern('HH:mm:ss'));
      if (currentBerth === '') {
        await linxRestClient.postBerthInterpose(new BerthInterpose(
          plannedStepTime,
          berth.berthName,
          berth.trainDescriberCode,
          berthLevelSchedule.plannedTrainDescription
        ));
        currentBerth = berth.berthName;
        currentBerthDescriber = berth.trainDescriberCode;
        lastTiming = plannedStepTime;
      } else {
        const stepsOutOfTime = LocalTime.parse(lastTiming).isAfter(LocalTime.parse(plannedStepTime));
        if (currentBerth !== berth.berthName || !stepsOutOfTime) {
          if (currentBerthDescriber !== berth.trainDescriberCode) {
            await linxRestClient.postBerthCancel(new BerthCancel(
              currentBerth,
              lastTiming,
              currentBerthDescriber,
              berthLevelSchedule.plannedTrainDescription
            ));
            await linxRestClient.postBerthInterpose(new BerthInterpose(
              plannedStepTime,
              berth.berthName,
              berth.trainDescriberCode,
              berthLevelSchedule.plannedTrainDescription
            ));
          } else {
            await linxRestClient.postBerthStep(new BerthStep(
              currentBerth,
              plannedStepTime,
              berth.berthName,
              berth.trainDescriberCode,
              berthLevelSchedule.plannedTrainDescription
            ));
          }
          currentBerth = berth.berthName;
          currentBerthDescriber = berth.trainDescriberCode;
          lastTiming = plannedStepTime;
        }
      }
    }
  }
});

Given(/^I generate a new trainUID$/, async () => {
  browser.referenceTrainUid = await TrainUIDUtils.generateUniqueTrainUid();
});

Given(/^I log the berth level schedule for '(.*)'$/, async (trainUid) => {
  const key = `${trainUid}:${DateAndTimeUtils.getCurrentDateTimeString('yyyy-MM-dd')}`;
  const berthLevelSchedule = await new RedisClient().hgetParseJSON('berth-level-schedule-pairs', key);
  await CucumberLog.addJson(berthLevelSchedule);
});

Given(/^I log the berth & locations from the berth level schedule for '(.*)'$/, async (trainUid) => {
  const client = new RedisClient();
  const scheduleKey = `${trainUid}:${DateAndTimeUtils.getCurrentDateTimeString('yyyy-MM-dd')}`;
  const berthLevelSchedule = await client.hgetParseJSON('{schedule-matching}-berth-level-schedules-cache', scheduleKey);

  for (const pathEntry of berthLevelSchedule.pathEntries) {
    if (pathEntry.berths.length > 0) {
      const berth = pathEntry.berths[0];
      const berthKey = `${berth.trainDescriberCode}${berth.berthName}`;
      const info = await client.hgetParseJSON('{schedule-matching}-schedule-matching-berths', berthKey);
      await CucumberLog.addText(`${berth.plannedStepTime} ${info.id} ${info.berthLocation}`);
    }
  }
});
