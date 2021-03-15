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

const page: AppPage = new AppPage();
const linxRestClient: LinxRestClient = new LinxRestClient();
const adminRestClient: AdminRestClient = new AdminRestClient();
const authPage: AuthenticationModalDialoguePage = new AuthenticationModalDialoguePage();


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

Given(/^I have not opened the trains list before$/, async () => {
// something here about resetting to the defaults
});

Given(/^The admin setting defaults are as originally shipped$/, async () => {
  const rawData: Buffer = fs.readFileSync(path.join(ProjectDirectoryUtil.testDataFolderPath(), 'admin/admin-defaults.json'));
  const adminDefaults = rawData.toString();
  await CucumberLog.addJson(adminDefaults);
  adminRestClient.postAdminConfiguration(adminDefaults);
  await adminRestClient.waitMaxTransmissionTime();
});

When(/^I do nothing$/, () => {
  browser.sleep(5000);
});

When(/^the following berth interpose messages? (?:is|are) sent from LINX$/, async (berthInterposeMessageTable: any) => {
  const berthInterposeMessages: any = berthInterposeMessageTable.hashes();

  berthInterposeMessages.forEach((berthInterposeMessage: any) => {
    const berthInterpose: BerthInterpose = new BerthInterpose(
      berthInterposeMessage.timestamp,
      berthInterposeMessage.toBerth,
      berthInterposeMessage.trainDescriber,
      berthInterposeMessage.trainDescription
    );
    CucumberLog.addJson(berthInterpose);
    linxRestClient.postBerthInterpose(berthInterpose);
  });
  await linxRestClient.waitMaxTransmissionTime();
});

When(/^the following live berth interpose messages? (?:is|are) sent from LINX$/, async (berthInterposeMessageTable: any) => {
  const berthInterposeMessages: any = berthInterposeMessageTable.hashes();
  const now = new Date();

  berthInterposeMessages.forEach((berthInterposeMessage: any) => {
    const berthInterpose: BerthInterpose = new BerthInterpose(
      now.toTimeString().substr(0, 8),
      berthInterposeMessage.toBerth,
      berthInterposeMessage.trainDescriber,
      berthInterposeMessage.trainDescription
    );
    CucumberLog.addJson(berthInterpose);
    linxRestClient.postBerthInterpose(berthInterpose);
  });
  await linxRestClient.waitMaxTransmissionTime();
});


When(/^the following berth step messages? (?:is|are) sent from LINX$/, async (berthStepMessageTable: any) => {
  const berthStepMessages: any = berthStepMessageTable.hashes();

  berthStepMessages.forEach((berthStepMessage: any) => {
    const berthStep: BerthStep = new BerthStep(
      berthStepMessage.fromBerth,
      berthStepMessage.timestamp,
      berthStepMessage.toBerth,
      berthStepMessage.trainDescriber,
      berthStepMessage.trainDescription
    );
    CucumberLog.addJson(berthStep);
    linxRestClient.postBerthStep(berthStep);
  });
  await linxRestClient.waitMaxTransmissionTime();
});

When(/^the following live berth step messages? (?:is|are) sent from LINX$/, async (berthStepMessageTable: any) => {
  const berthStepMessages: any = berthStepMessageTable.hashes();
  const now = new Date();

  berthStepMessages.forEach((berthStepMessage: any) => {
    const berthStep: BerthStep = new BerthStep(
      berthStepMessage.fromBerth,
      now.toTimeString().substr(0, 8),
      berthStepMessage.toBerth,
      berthStepMessage.trainDescriber,
      berthStepMessage.trainDescription
    );
    CucumberLog.addJson(berthStep);
    linxRestClient.postBerthStep(berthStep);
  });
  await linxRestClient.waitMaxTransmissionTime();
});

When(/^the following berth cancel messages? (?:is|are) sent from LINX$/, async (berthCancelMessageTable: any) => {
  const berthCancelMessages: any = berthCancelMessageTable.hashes();

  berthCancelMessages.forEach((berthCancelMessage: any) => {
    const berthCancel: BerthCancel = new BerthCancel(
      berthCancelMessage.fromBerth,
      berthCancelMessage.timestamp,
      berthCancelMessage.trainDescriber,
      berthCancelMessage.trainDescription
    );
    CucumberLog.addJson(berthCancel);
    linxRestClient.postBerthCancel(berthCancel);
  });
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

When(/^the following train activation? (?:message|messages)? (?:is|are) sent from LINX$/, async (trainActivationMessageTable: any) => {
  const trainActivationMessages = trainActivationMessageTable.hashes();
  for (let i = 0; i < trainActivationMessages.length; i++){
  const trainActivationMessageBuilder: TrainActivationMessageBuilder = new TrainActivationMessageBuilder();
  const trainUID = trainActivationMessages[i].trainUID;
  const trainNumber = trainActivationMessages[i].trainNumber;
  const scheduledDepartureTime = trainActivationMessages[i].scheduledDepartureTime;
  const locationPrimaryCode = trainActivationMessages[i].locationPrimaryCode;
  const locationSubsidiaryCode = trainActivationMessages[i].locationSubsidiaryCode;
  const trainActMss = trainActivationMessageBuilder.buildMessage(locationPrimaryCode, locationSubsidiaryCode,
    scheduledDepartureTime, trainNumber, trainUID);
  await linxRestClient.postTrainActivation(trainActMss.toString({prettyPrint: true}));

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

When(/^the following train running information messages? (?:is|are) sent from LINX$/, async (trainRunningInformationMessageTable: any) => {
  const trainRunningInformationMessages: any = trainRunningInformationMessageTable.hashes();

  trainRunningInformationMessages.forEach((trainRunningInformationMessage: any) => {
    linxRestClient.postTrainRunningInformation(trainRunningInformationMessage.asXml);
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

Given(/^I am on the trains list page$/, async () => {
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
  return browser.executeScript('window.open()');
}

When(/^the following TJMs? (?:is|are) received$/, async (table: any) => {
  const messages: any = table.hashes();
  messages.forEach((message: any) => {
    const tjmBuilder = createBaseTjmMessage(message.trainNumber, message.trainUid, message.departureHour)
      .withTrainJourneyModification(createBaseTjm(message.indicator,
        message.statusIndicator,
        message.primaryCode,
        message.subsidiaryCode,
        message.time)
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
      .withTrainJourneyModification(createBaseTjm(message.indicator,
        message.statusIndicator,
        message.primaryCode,
        message.subsidiaryCode,
        message.time)
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

    linxRestClient.postTrainJourneyModification(tjmMessage.toXML());
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
