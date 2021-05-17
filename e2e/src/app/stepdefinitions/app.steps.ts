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
import {LocalStorage} from '../../../local-storage/local-storage';
import {AuthenticationModalDialoguePage} from '../pages/authentication-modal-dialogue.page';
import {TrainActivationMessageBuilder} from '../utils/train-activation/train-activation-message';
import {HomePageObject} from '../pages/home.page';
import {DateAndTimeUtils} from '../pages/common/utilities/DateAndTimeUtils';
import {DateTimeFormatter, LocalDateTime, LocalTime, ZonedDateTime, ZoneId} from '@js-joda/core';
import '@js-joda/timezone';
import {NavBarPageObject} from '../pages/nav-bar.page';
import {RedisClient} from '../api/redis/redis-client';

const page: AppPage = new AppPage();
const linxRestClient: LinxRestClient = new LinxRestClient();
const adminRestClient: AdminRestClient = new AdminRestClient();
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
      await page.navigateTo(`/tmv/maps/1`);
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
  // Below steps to be replaced to logout steps once DEV implementation is done
  await LocalStorage.reset();
  await browser.waitForAngularEnabled(false);
  await browser.get(browser.baseUrl);
  expect(await authPage.signInModalIsVisible(), 'Sign In Modal is not visible').to.equal(true);
  if (await authPage.reAuthenticationModalIsVisible()) {
    await authPage.clickSignInAsDifferentUser();
  }
  await browser.waitForAngularEnabled(true);
});

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
// something here about resetting to the defaults
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
When(/^I give the system (.*) seconds? to load$/, async (seconds: number) => {
  await browser.sleep(seconds * 1000);
});


When(/^the following berth interpose messages? (?:is|are) sent from LINX(.*)$/,
  async (explanation: string, berthInterposeMessageTable: any) => {
    const berthInterposeMessages: any = berthInterposeMessageTable.hashes();

    for (const berthInterposeMessage of berthInterposeMessages) {
      const berthInterpose: BerthInterpose = new BerthInterpose(
        berthInterposeMessage.timestamp,
        berthInterposeMessage.toBerth,
        berthInterposeMessage.trainDescriber,
        berthInterposeMessage.trainDescription
      );
      await CucumberLog.addJson(berthInterpose);
      await linxRestClient.postBerthInterpose(berthInterpose);
    }
    await linxRestClient.waitMaxTransmissionTime();
  });

When(/^the following live berth interpose messages? (?:is|are) sent from LINX(.*)$/,
  async (explanation: string, berthInterposeMessageTable: any) => {
    const berthInterposeMessages: any = berthInterposeMessageTable.hashes();
    const now = new Date();

    for (const berthInterposeMessage of berthInterposeMessages) {
      const berthInterpose: BerthInterpose = new BerthInterpose(
        now.toTimeString().substr(0, 8),
        berthInterposeMessage.toBerth,
        berthInterposeMessage.trainDescriber,
        berthInterposeMessage.trainDescription
      );
      await CucumberLog.addJson(berthInterpose);
      await linxRestClient.postBerthInterpose(berthInterpose);
    }
    await linxRestClient.waitMaxTransmissionTime();
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

When(/^the following live berth step messages? (?:is|are) sent from LINX (.*)$/,
  async (explanation: string, berthStepMessageTable: any) => {
    const berthStepMessages: any = berthStepMessageTable.hashes();
    const now = new Date();

    for (const berthStepMessage of berthStepMessages) {
      const berthStep: BerthStep = new BerthStep(
        berthStepMessage.fromBerth,
        now.toTimeString().substr(0, 8),
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

When(/^the following signalling update messages? (?:is|are) sent from LINX$/, async (signallingUpdateMessageTable: any) => {
  const signallingUpdateMessages: any = signallingUpdateMessageTable.hashes();

  signallingUpdateMessages.forEach((signallingUpdateMessage: any) => {
    const signallingUpdate: SignallingUpdate = new SignallingUpdate(
      signallingUpdateMessage.address,
      signallingUpdateMessage.data,
      signallingUpdateMessage.timestamp,
      signallingUpdateMessage.trainDescriber
    );
    CucumberLog.addJson(signallingUpdate);
    linxRestClient.postSignallingUpdate(signallingUpdate);
  });
  await linxRestClient.waitMaxTransmissionTime();
});

When(/^the following live signalling update messages? (?:is|are) sent from LINX (.*)$/,
  async (explanation: string, signallingUpdateMessageTable: any) => {
    const signallingUpdateMessages: any = signallingUpdateMessageTable.hashes();
    const now = new Date();
    signallingUpdateMessages.forEach((signallingUpdateMessage: any) => {
      const signallingUpdate: SignallingUpdate = new SignallingUpdate(
        signallingUpdateMessage.address,
        signallingUpdateMessage.data,
        now.toTimeString().substr(0, 8),
        signallingUpdateMessage.trainDescriber
      );
      CucumberLog.addJson(signallingUpdate);
      linxRestClient.postSignallingUpdate(signallingUpdate);
    });
    await linxRestClient.waitMaxTransmissionTime();
  });

When(/^the following heartbeat messages? (?:is|are) sent from LINX$/, async (heartbeatMessageTable: any) => {
  const heartbeatMessages: any = heartbeatMessageTable.hashes();

  heartbeatMessages.forEach((heartbeatMessage: any) => {
    const heartbeat: Heartbeat = new Heartbeat(
      heartbeatMessage.timestamp,
      heartbeatMessage.trainDescriber,
      heartbeatMessage.trainDescriberTimestamp
    );
    CucumberLog.addJson(heartbeat);
    linxRestClient.postHeartbeat(heartbeat);
  });
  await linxRestClient.waitMaxTransmissionTime();
});

When(/^the following train journey modification messages? (?:is|are) sent from LINX$/,
  async (trainJourneyModificationMessageTable: any) => {
    const trainJourneyModificationMessages: any = trainJourneyModificationMessageTable.hashes();

    trainJourneyModificationMessages.forEach((trainJourneyModificationMessage: any) => {
      linxRestClient.postTrainJourneyModification(trainJourneyModificationMessage.asXml);
    });
    await linxRestClient.waitMaxTransmissionTime();
  });

When(/^the following train journey modification change of id messages? (?:is|are) sent from LINX$/,
  async (trainJourneyModificationChangeOfIdMessageTable: any) => {
    const trainJourneyModificationChangeOfIdMessages: any = trainJourneyModificationChangeOfIdMessageTable.hashes();

    trainJourneyModificationChangeOfIdMessages.forEach((trainJourneyModificationChangeOfIdMessage: any) => {
      linxRestClient.postTrainJourneyModificationIdChange(trainJourneyModificationChangeOfIdMessage.asXml);
    });
    await linxRestClient.waitMaxTransmissionTime();
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
  // tslint:disable-next-line:prefer-for-of
  for (let i = 0; i < trainActivationMessages.length; i++) {
    const trainActivationMessageBuilder: TrainActivationMessageBuilder = new TrainActivationMessageBuilder();
    const trainUID = trainActivationMessages[i].trainUID;
    const trainNumber = trainActivationMessages[i].trainNumber;
    const scheduledDepartureTime = () => {
      if ((trainActivationMessages[i].scheduledDepartureTime).toLowerCase() === 'now') {
        const now = new Date();
        return `${Number(now.getHours()).toString().padStart(2, '0')}:${Number(now.getMinutes()).toString().padStart(2, '0')}:${Number(now.getSeconds()).toString().padStart(2, '0')}`;
      } else {
          return trainActivationMessages[i].scheduledDepartureTime;
      }
    };
    const departureDate = () => {
      if ((trainActivationMessages[i].departureDate).toLowerCase() === 'today' ||
        (trainActivationMessages[i].departureDate).toLowerCase() === 'yesterday' ||
        (trainActivationMessages[i].departureDate).toLowerCase() === 'tomorrow') {
        return DateAndTimeUtils.convertToDesiredDateAndFormat((trainActivationMessages[i].departureDate).toLowerCase(), 'yyyy-MM-dd');
      } else if (trainActivationMessages[i].departureDate === undefined){
        return DateAndTimeUtils.convertToDesiredDateAndFormat('today', 'yyyy-MM-dd');
      } else {
        return trainActivationMessages[i].scheduledDepartureTime;
      }
    };
    const actualDepartureHour = () => {
      // tslint:disable-next-line:max-line-length
      if ((trainActivationMessages[i].actualDepartureHour).toLowerCase() === 'now' || trainActivationMessages[i].departureDate === undefined) {
        const now = new Date();
        return `${Number(now.getHours()).toString().padStart(2, '0')}`;
      } else {
        return trainActivationMessages[i].actualDepartureHour;
      }
    };
    const locationPrimaryCode = trainActivationMessages[i].locationPrimaryCode;
    const locationSubsidiaryCode = trainActivationMessages[i].locationSubsidiaryCode;
    const asmVal = trainActivationMessages[i].asm ? trainActivationMessages[i].asm : 0;
    const trainActMss = trainActivationMessageBuilder.buildMessage(locationPrimaryCode, locationSubsidiaryCode,
      scheduledDepartureTime().toString(), trainNumber, trainUID, departureDate().toString(), actualDepartureHour().toString(), asmVal);
    await linxRestClient.postTrainActivation(trainActMss.toString({prettyPrint: true}));
    await CucumberLog.addText(`Train Activation message: ${trainActMss.toString({prettyPrint: true})}`);
    await linxRestClient.waitMaxTransmissionTime();
  }
});

When('the activation message from location {string} is sent from LINX', async (xmlFilePath: string) => {
  const rawData: Buffer = fs.readFileSync(path.join(ProjectDirectoryUtil.testDataFolderPath(), xmlFilePath));
  linxRestClient.postTrainActivation(rawData.toString());

  await linxRestClient.waitMaxTransmissionTime();
});

When(/^the following VSTP messages? (?:is|are) sent from LINX$/, async (vstpMessageTable: any) => {
  const vstpMessages: any = vstpMessageTable.hashes();

  vstpMessages.forEach((vstpMessage: any) => {
    linxRestClient.postVstp(vstpMessage.asXml);
  });
  await linxRestClient.waitMaxTransmissionTime();
});

Then(/^I should see nothing$/, async () => {

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
  await browser.driver.wait(ExpectedConditions.titleContains(expectedTabTitle));
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
  } catch (UnexpectedAlertOpenError) {
    await acceptUnexpectedAlert();
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
  const messages: any = table.hashes();
  messages.forEach((message: any) => {
    const now = LocalDateTime.now();
    let depHour = now.format(DateTimeFormatter.ofPattern('HH'));
    let timeStamp = now.format(DateTimeFormatter.ofPattern('HH:mm:ss'));
    if (message.departureHour !== 'now') {
      depHour = message.departureHour;
    }
    if (message.time !== 'now') {
      timeStamp = message.time;
    }
    const tjmBuilder = createBaseTjmMessage(message.trainNumber, message.trainUid, depHour)
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

    linxRestClient.postTrainJourneyModification(tjmMessage.toXML());
    TestData.addTJM(tjmMessage);
  });
  await linxRestClient.waitMaxTransmissionTime();
});

When(/^the following change of ID TJM is received$/, async (table: any) => {
  const messages: any = table.hashes();

  messages.forEach((message: any) => {
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

    linxRestClient.postTrainJourneyModificationIdChange(tjmMessage.toXML());
    TestData.addTJM(tjmMessage);
  });
  await linxRestClient.waitMaxTransmissionTime();
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

function createBaseTjmMessage(trainNumber, trainUid, departureHour): TrainJourneyModificationMessageBuilder {
  return new TrainJourneyModificationMessageBuilder()
    .create()
    .withOperationalTrainNumberIdentifier(new OperationalTrainNumberIdentifierBuilder()
      .withOperationalTrainNumber(trainNumber)
      .build())
    .calculateSenderReferenceWith(trainUid, departureHour);
}

When(/^I step through the Berth Level Schedule for '(.*)'$/, async (uid: string) => {
  const client = new RedisClient();
  const data = await client.getBerthLevelSchedule(uid);

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
      }
      else {
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
          }
          else {
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

Given(/^I log the berth level schedule for '(.*)'$/, async (trainUid) => {
  const berthLevelSchedule = await new RedisClient().getBerthLevelSchedule(trainUid);
  await CucumberLog.addJson(berthLevelSchedule);
});

Given(/^I log the berth & locations from the berth level schedule for '(.*)'$/, async (trainUid) => {
  const client = new RedisClient();
  const berthLevelSchedule = await client.getBerthLevelSchedule(trainUid);

  for (const pathEntry of berthLevelSchedule.berthLevelSchedule.pathEntries) {
    if (pathEntry.berths.length > 0) {
      const berth = pathEntry.berths[0];
      const info = await client.getBerthInformation(`${berth.trainDescriberCode}${berth.berthName}`);
      await CucumberLog.addText(`${berth.plannedStepTime} ${info.id} ${info.berthLocation}`);
    }
  }
});
