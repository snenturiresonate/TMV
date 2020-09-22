import {After, Before, Given, Then, When} from 'cucumber';
import {AppPage} from '../pages/app.po';
import {browser, logging} from 'protractor';
import { expect } from 'chai';
import {LinxRestClient} from '../api/linx/linx-rest-client';
import {BerthCancel, BerthInterpose, BerthStep, Heartbeat} from '../../../../src/app/api/linx/models';

let page: AppPage;
let linxRestClient: LinxRestClient;

Before(() => {
  page = new AppPage();
  linxRestClient = new LinxRestClient();
});

Given(/^I am on the home page$/, async () => {
  await page.navigateTo();
});

When(/^I do nothing$/, () => {});

When(/^the following berth interpose messages? (?:is|are) sent from LINX$/, async (berthInterposeMessageTable: any) => {
  const berthInterposeMessages: any = berthInterposeMessageTable.hashes();

  berthInterposeMessages.forEach((berthInterposeMessage: any) => {
    const berthInterpose: BerthInterpose = new BerthInterpose(
      berthInterposeMessage.timestamp,
      berthInterposeMessage.toBerth,
      berthInterposeMessage.trainDescriber,
      berthInterposeMessage.trainDescription
    );

    linxRestClient.postBerthInterpose(berthInterpose);
  });
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

    linxRestClient.postBerthStep(berthStep);
  });
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

    linxRestClient.postBerthCancel(berthCancel);
  });
});

When(/^the following heartbeat messages? (?:is|are) sent from LINX$/, async (heartbeatMessageTable: any) => {
  const heartbeatMessages: any = heartbeatMessageTable.hashes();

  heartbeatMessages.forEach((heartbeatMessage: any) => {
    const heartbeat: Heartbeat = new Heartbeat(
      heartbeatMessage.timestamp,
      heartbeatMessage.trainDescriber,
      heartbeatMessage.trainDescriberTimestamp
    );

    linxRestClient.postHeartbeat(heartbeat);
  });
});

When(/^the following train journey modification messages? (?:is|are) sent from LINX$/,
  async (trainJourneyModificationMessageTable: any) => {
  const trainJourneyModificationMessages: any = trainJourneyModificationMessageTable.hashes();

  trainJourneyModificationMessages.forEach((trainJourneyModificationMessage: any) => {
    linxRestClient.postTrainJourneyModification(trainJourneyModificationMessage.asXml);
  });
});

When(/^the following train journey modification change of id messages? (?:is|are) sent from LINX$/,
  async (trainJourneyModificationChangeOfIdMessageTable: any) => {
  const trainJourneyModificationChangeOfIdMessages: any = trainJourneyModificationChangeOfIdMessageTable.hashes();

  trainJourneyModificationChangeOfIdMessages.forEach((trainJourneyModificationChangeOfIdMessage: any) => {
    linxRestClient.postTrainJourneyModificationIdChange(trainJourneyModificationChangeOfIdMessage.asXml);
  });
});

When(/^the following train activation messages? (?:is|are) sent from LINX$/, async (trainActivationMessageTable: any) => {
  const trainActivationMessages: any = trainActivationMessageTable.hashes();

  trainActivationMessages.forEach((trainActivationMessage: any) => {
    linxRestClient.postTrainActivation(trainActivationMessage.asXml);
  });
});

When(/^the following VSTP messages? (?:is|are) sent from LINX$/, async (vstpMessageTable: any) => {
  const vstpMessages: any = vstpMessageTable.hashes();

  vstpMessages.forEach((vstpMessage: any) => {
    linxRestClient.postVstp(vstpMessage.asXml);
  });
});

When(/^the following train running information messages? (?:is|are) sent from LINX$/, async (trainRunningInformationMessageTable: any) => {
  const trainRunningInformationMessages: any = trainRunningInformationMessageTable.hashes();

  trainRunningInformationMessages.forEach((trainRunningInformationMessage: any) => {
    linxRestClient.postTrainRunningInformation(trainRunningInformationMessage.asXml);

  });
});

Then(/^I should see nothing$/, async () => {

});

After(async () => {
  // Assert that there are no errors emitted from the browser
  const logs = await browser.manage().logs().get(logging.Type.BROWSER);
  expect(logs).not.have.deep.property('level', logging.Level.SEVERE);
});
