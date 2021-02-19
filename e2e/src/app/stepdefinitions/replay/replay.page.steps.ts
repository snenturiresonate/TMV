import {ReplayMapPage} from '../../pages/replay/replay.map.page';
import {Given, Then, When} from 'cucumber';
import * as fs from 'fs';
import {ReplayScenario} from '../../utils/replay/replay-scenario';
import {ReplayActionType} from '../../utils/replay/replay-action-type';
import {ReplayRecordings} from '../../utils/replay/replay-recordings';
import {ReplayStep} from '../../utils/replay/replay-step';
import {CommonActions} from '../../pages/common/ui-event-handlers/actionsAndWaits';
import {assert, expect} from 'chai';
import {browser, by, element, ExpectedConditions} from 'protractor';
import {DateTimeFormatter, LocalDateTime} from '@js-joda/core';
import {ReplaySelectMapPage} from '../../pages/replay/replay.selectmap.page';
import {ReplaySelectTimerangePage} from '../../pages/replay/replay.selecttimerange.page';
import {TimeTablePageObject} from '../../pages/timetable/timetable.page';
import moment = require('moment');
import * as chaiDateTime from 'chai-datetime';

const replayPage: ReplayMapPage = new ReplayMapPage();
const replaySelectMapPage: ReplaySelectMapPage = new ReplaySelectMapPage();
const replaySelectTimerangePage: ReplaySelectTimerangePage = new ReplaySelectTimerangePage();
const replayTimetablePage: TimeTablePageObject = new TimeTablePageObject();
let replayScenario: ReplayScenario;

When('I expand the replay group of maps with name {string}', async (mapName: string) => {
  await replaySelectMapPage.expandMapGroupingForName(mapName);
});

When('I select the map {string}', async (location: string) => {
  await replaySelectMapPage.openMapsList(location);
});

When('I select Start', async () => {
  await replaySelectTimerangePage.selectStart();
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

  await replaySelectTimerangePage.setStartDate(replayScenario.date);
  await replaySelectTimerangePage.setStartTime(replayScenario.startTime);
  await replaySelectTimerangePage.selectDurationOfReplay('10');
});

Given(/^I set the date and time for replay to$/, async (dataTable) => {
  const table = dataTable.hashes()[0];
  await replaySelectTimerangePage.setStartDate(table.date);
  await replaySelectTimerangePage.setStartTime(table.time);
  await replaySelectTimerangePage.selectDurationOfReplay(table.duration);
});

When(/^I set the date and time using the dropdowns for replay to$/, async (dataTable) => {
  const table = dataTable.hashes()[0];
  await replaySelectTimerangePage.setStartDateWithDropdown(table.date);
  await replaySelectTimerangePage.setStartTimeWithDropdown(table.time);
  await replaySelectTimerangePage.selectDurationOfReplay(table.duration);
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

When('I make a note of the main replay map background colour', async () => {
  browser.referenceReplayBackgroundColours = await replayPage.getCurrentBackgroundColours();
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
When(/^I search for replay map '(.*)'$/, async (input) => {
  await replaySelectMapPage.searchForMap(input);
});

Then(/^the replay time selection is presented$/, async () => {
  browser.wait(ExpectedConditions.visibilityOf(replaySelectTimerangePage.selectYourTimeRangeTitle));
  expect((await replaySelectTimerangePage.quickContainer.isPresent())).to.equal(true);
  expect((await replaySelectTimerangePage.startDate.isPresent())).to.equal(true);
  expect((await replaySelectTimerangePage.startTime.isPresent())).to.equal(true);
  expect((await replaySelectTimerangePage.durationContainer.isPresent())).to.equal(true);
  expect((await replaySelectTimerangePage.endDateAndTime.isPresent())).to.equal(true);
});

Then(/^the replay map selection is presented$/, async () => {
  browser.wait(ExpectedConditions.visibilityOf(replaySelectMapPage.selectYourMapTitle));
  expect((await replaySelectMapPage.mapsInputBox.isPresent())).to.equal(true);
  expect((await replaySelectMapPage.mapsListContainer.isPresent())).to.equal(true);
});
Then(/^all replay map search results contain '(.*)'$/, async (searchTerm) => {
  const returnedMaps = await replaySelectMapPage.getSearchResults();
  expect(returnedMaps.length).to.be.greaterThan(0);
  returnedMaps.forEach(map => expect(map).to.contain(searchTerm));
});
Then(/^replay map '(.*)' is present in the tree view$/, async (map) => {
  const el = element(by.cssContainingText('.app-map-link', map));
  await browser.wait(ExpectedConditions.visibilityOf(el))
    .catch(() => assert.fail(`map ${map} is not visible in the tree view`));
});
When(/^I select time period '(.*)' from the quick dropdown$/, async (duration) => {
  await replaySelectTimerangePage.selectQuickDuration(duration);
});
Then(/^the map view is opened ready for replaying with timestamp$/, async (dataTable) => {
  const table = dataTable.hashes()[0];
  const replayMapName = await replayPage.getMapName();
  expect(replayMapName).to.equal(table.mapName);
  const dateFormat = DateTimeFormatter.ofPattern('dd/MM/yyyy HH:mm:ss');
  let expectedDateTime;
  if (table.expectedTimestamp.includes('Last')) {
    expectedDateTime = LocalDateTime.now()
      .minusMinutes(table.expectedTimestamp.split(' ')[1])
      .withSecond(0)
      .format(dateFormat);
  }
  else {
    expectedDateTime = table.expectedTimestamp;
  }
  const replayTimestamp = await replayPage.getTimestamp();
  expect(replayTimestamp.format(dateFormat)).to.equal(expectedDateTime);
});

When(/^I select skip forward to just after replay scenario step '(.*)'$/, async (eventNum) => {
  const eventNumVal = parseInt(eventNum, 10);
  const eventTimeString: string = replayScenario.steps[eventNumVal].timestamp;
  const eventTime: LocalDateTime = LocalDateTime.parse(eventTimeString, DateTimeFormatter.ofPattern('HH:mm:ss'));
  const timeToCheck: LocalDateTime = eventTime.plusSeconds(1);
  const timeToCheckString = timeToCheck.format(DateTimeFormatter.ofPattern('HH:mm:ss'));
  await replayPage.moveReplayTimeTo(timeToCheckString);
});

Then('the timetable background colour is the same as the map background colour', async () => {
  const timetableHeaderElementColours = await replayTimetablePage.getHeaderColours();
  for (const elem of timetableHeaderElementColours) {
    expect(elem).oneOf(browser.referenceReplayBackgroundColours);
  }
});

When('I click Play button', async () => {
  /*  const waitTime = 10;
    await replaySessionPage.waitForTimePeriod(waitTime);*/
  await replayPage.selectPlay();
});

When('I click Stop button', async () => {
  await replayPage.selectStop();
});

When('I click Pause button', async () => {
  await replayPage.selectPause();
});

Then('the replay playback {string} is {string}', async (speed: string, expectedSpeed: string) => {
  const actualSpeed = await replayPage.getSpeedValue(speed);
  return expect(actualSpeed, `replay playback ${speed} is not as expected`)
    .to.contain(expectedSpeed);
});

When('I increase the replay speed at position {int}', async (position: number) => {
  await replayPage.clickReplaySpeed();
  await replayPage.increaseReplaySpeed(position);
});

Then('the replay button {string} is {string}', async (button: string, expectedType: string) => {
  const actualType = await replayPage.getButtonType(button);
  return expect(actualType, `replay button ${button} is not as expected`)
    .to.contain(expectedType);
});

Then('my replay should skip {string} minute when I click forward button', async (increment: number) => {
  const dateTimeAtStart = await replayPage.getReplayTimestamp();
  const expectedTime = await formulateIncrementedDateTime(dateTimeAtStart, increment);

  await replayPage.selectSkipForward();
  const dateTimeAfterForward = await replayPage.getReplayTimestamp();
  const actualTime = await formulateDateTime(dateTimeAfterForward);

  expect(actualTime).to.be.closeToTime(expectedTime, 3);
});

Then('my replay should skip {string} minute when I click backward button', async (decrement: number) => {
  const dateTimeAtStart = await replayPage.getReplayTimestamp();
  const expectedTime = await formulateDecrementedDateTime(dateTimeAtStart, decrement);

  await replayPage.selectSkipBack();
  const dateTimeAfterClick = await replayPage.getReplayTimestamp();
  const actualTime = await formulateDateTime(dateTimeAfterClick);

  expect(actualTime).to.be.closeToTime(expectedTime, 3);
});

async function formulateDateTime(timeStamp: string): Promise<any> {
  const parsedDateTime = new Date(timeStamp);
  return moment(parsedDateTime).toDate();
}

async function formulateIncrementedDateTime(timeStamp: string, increment: number): Promise<any> {
  const parsedDateTime = new Date(timeStamp);
  return moment(parsedDateTime).add(increment, 'minute').toDate();
}

async function formulateDecrementedDateTime(timeStamp: string, decrement: number): Promise<any> {
  const parsedDateTime = new Date(timeStamp);
  return moment(parsedDateTime).add(decrement, 'minute').toDate();
}
