import {Before, Given, Then, When} from 'cucumber';
import {AppPage} from '../pages/app.po';
import {expect} from 'chai';
import {LinxRestClient} from '../api/linx/linx-rest-client';
import {BerthCancel, BerthInterpose, BerthStep, Heartbeat, SignallingUpdate} from '../../../../src/app/api/linx/models';
import {CucumberLog} from '../logging/cucumber-log';
import * as fs from 'fs';
import * as path from 'path';
import {ProjectDirectoryUtil} from '../utils/project-directory.util';

let page: AppPage;
let linxRestClient: LinxRestClient;

Before(() => {
  page = new AppPage();
  linxRestClient = new LinxRestClient();
});

Given(/^I am on the home page$/, {timeout: 15 * 1000}, async () => {
  await page.navigateTo('');
});

Given(/^I am authenticated to use TMV$/, async () => {
  await page.navigateTo('');
});

When(/^I do nothing$/, () => {
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

When(/^the following train activation messages? (?:is|are) sent from LINX$/, async (trainActivationMessageTable: any) => {
  const trainActivationMessages: any = trainActivationMessageTable.hashes();

  trainActivationMessages.forEach((trainActivationMessage: any) => {
    linxRestClient.postTrainActivation(trainActivationMessage.asXml);
  });
  await linxRestClient.waitMaxTransmissionTime();
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
  expect(displayedTitle).to.contain(modalTitle);
});

Then('the modal contains a {string} button', async (buttonName: string) => {
  const displayedButtons: string = await page.getModalButtons();
  expect(displayedButtons).to.contain(buttonName);
});

Given(/^I am on the trains list page$/, async () => {
  await page.navigateTo('/tmv/trains-list');
});

Given(/^I am on the trains list Config page$/, async () => {
  await page.navigateTo('/tmv/trains-list-config');
});

Given(/^I am on the log viewer page$/, async () => {
  await page.navigateTo('/tmv/log-viewer');
});

Given(/^I am on the admin page$/, async () => {
  await page.navigateTo('/tmv/administration');
});

Given(/^I am on the replay page$/, async () => {
  await page.navigateTo('/tmv/replay/replay-session-1');
});
