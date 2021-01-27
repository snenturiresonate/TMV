import {ReplayPageObject} from '../pages/replay.page';
import {Given, Then, When} from 'cucumber';
import * as fs from 'fs';
import {ReplayScenario} from '../utils/replay/replay-scenario';
import {ReplayActionType} from '../utils/replay/replay-action-type';
import {ReplayRecordings} from '../utils/replay/replay-recordings';
import {ReplayStep} from '../utils/replay/replay-step';
import {CommonActions} from '../pages/common/ui-event-handlers/actionsAndWaits';
import {expect} from 'chai';
import {browser, ExpectedConditions} from 'protractor';

const replayPage: ReplayPageObject = new ReplayPageObject();
let replayScenario: ReplayScenario;

When('I expand the replay group of maps with name {string}', async (mapName: string) => {
  await replayPage.expandMapGroupingForName(mapName);
});

When('I select the map {string}', async (location: string) => {
  await replayPage.openMapsList(location);
});

When('I select Start', async () => {
  await replayPage.selectStart();
});

Given(/^I load the replay data from scenario '(.*)'$/, (filepath) => {
  const file = '.tmp/replay-recordings/' + filepath.replace(/ /g, '_') + '.json';
  if (!fs.existsSync(file)) {
    return 'skipped';
  }
  const data = fs.readFileSync(file, 'utf8');
  replayScenario = JSON.parse(data);
});

Given(/^I have set replay time and date from the recorded session$/, async () => {

  await replayPage.setStartDate(replayScenario.date);
  await replayPage.setStartTime(replayScenario.startTime);
  await replayPage.selectDurationOfReplay('10');
});

When(/^I capture a (INTERPOSE|CANCEL|STEP|SIGNAL_UPDATE|HEARTBEAT|MODIFY_TRAIN_JOURNEY|CHANGE_ID|ACTIVATE_TRAIN|VSTP|TRAIN_RUNNING_INFORMATION) action for replay$/,
  (replayActionType: string, table: any) => {
    ReplayRecordings.addStep(new ReplayStep(ReplayActionType[replayActionType], table.hashes()[0].actionData));
});

When(/^I select the continuation button '(.*)'$/, async (linkText) => {
  await replayPage.selectContinuationLink(linkText);
});

When(/^I open the context menu for the continuation button '(.*)'$/, async (linkText) =>  {
  await replayPage.rightClickContinuationLink(linkText);
});

When(/^I open the next map from the continuation button context menu$/, async () => {
  await replayPage.continuationLinkContextMenu.selectOpen();
});

When(/^I open the next map in a new tab from the continuation button context menu$/, async () => {
  await replayPage.continuationLinkContextMenu.selectOpenNewTab();
});

Then(/^the context menu for the continuation button has options to open the map within to the same view or new tab$/, async () => {
  browser.wait(ExpectedConditions.visibilityOf(replayPage.continuationLinkContextMenu.open));
  expect(await replayPage.continuationLinkContextMenu.open.isPresent()).to.equal(true);
  expect(await replayPage.continuationLinkContextMenu.openNewTab.isPresent()).to.equal(true);
});

Then(/^the context menu for the berth has a berth name of '(.*)'$/, async (berthName) => {
  expect(await replayPage.berthContextMenu.berthName.getText()).to.contain(berthName);
});

Then(/^the context menu for the berth has a signal plated name of '(.*)'$/, async (signal) => {
  expect(await replayPage.berthContextMenu.signalName.getText()).to.contain(signal);
});

When(/^I wait for the buffer to fill$/, async () => {
  await CommonActions.waitForElementToBeVisible(replayPage.bufferingIndicator);
});

When(/^I select skip forward until the end of the replay is reached$/, async () => {
  while (replayPage.skipForwardButton.isEnabled()) {
    await replayPage.selectSkipForward();
  }
});
Given(/^I move the replay to the end of the captured scenario$/, async () => {
  await replayPage.moveReplayTimeTo(replayScenario.finishTime);
});
