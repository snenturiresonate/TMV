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
import {ChronoUnit, DateTimeFormatter, LocalDateTime, LocalTime} from '@js-joda/core';
import {ReplaySelectMapPage} from '../../pages/replay/replay.selectmap.page';
import {ReplaySelectTimerangePage} from '../../pages/replay/replay.selecttimerange.page';
import {TimeTablePageObject} from '../../pages/timetable/timetable.page';
import moment = require('moment');
// this import looks like its not used but is by expect().to.be.closeToTime()
import * as chaiDateTime from 'chai-datetime';
const chai = require('chai');
chai.use(require('chai-datetime'));
import {DateAndTimeUtils} from '../../pages/common/utilities/DateAndTimeUtils';
import {CucumberLog} from '../../logging/cucumber-log';
import {MapPageObject} from '../../pages/maps/map.page';
import {CssColorConverterService} from '../../services/css-color-converter.service';

const replayPage: ReplayMapPage = new ReplayMapPage();
const replaySelectMapPage: ReplaySelectMapPage = new ReplaySelectMapPage();
const replaySelectTimerangePage: ReplaySelectTimerangePage = new ReplaySelectTimerangePage();
const replayTimetablePage: TimeTablePageObject = new TimeTablePageObject();
let replayScenario: ReplayScenario;

When('I expand the replay group of maps with name {string}', async (mapName: string) => {
  await replaySelectMapPage.expandMapGroupingForName(mapName);
});

Then(/the following replay maps are listed/, async (mapNameDataTable: any) => {
  const expectedMapNames: any[] = mapNameDataTable.hashes();
  const actualMapNames: string = await replaySelectMapPage.getMapsListed();
  expectedMapNames.forEach(expectedName => {
    expect(actualMapNames, `${actualMapNames} did not contain ${expectedName}`).to.contain(expectedName.mapName);
  });
});

Then('the replay session header is correctly formatted', async () => {
  const replayWindowTitle = await replayPage.getReplayWindowTitle();
  const expectedTitleFormat: RegExp = new RegExp('Replay Session: . \\(Start Date: ..\\/..\\/.. Start Time: ..:..\\)');
  expect(replayWindowTitle, `Title \'${replayWindowTitle}\' did not match the expected format \'${expectedTitleFormat}\'`)
    .matches(expectedTitleFormat);
});

When('I select the map {string}', async (location: string) => {
  await replaySelectMapPage.openMapsList(location);
  await MapPageObject.waitForTracksToBeDisplayed();
});

When('I select Next', async () => {
  await replaySelectTimerangePage.selectNext();
});

Given(/^I load the replay data from scenario '(.*)'$/, async (filepath) => {
  const file = `.tmp/replay-recordings/${encodeURIComponent(filepath)}.json`;
  if (!fs.existsSync(file)) {
    const errorMessage = `ERROR - No replay recording was found: ${file}`;
    console.log(errorMessage);
    await CucumberLog.addText(errorMessage);
    return 'skipped';
  }
  const data = fs.readFileSync(file, 'utf8');
  replayScenario = JSON.parse(data);
});

Given(/^I have set replay time and date from the recorded session$/, async () => {
  await replaySelectTimerangePage.setStartDate(replayScenario.date);
  await replaySelectTimerangePage.setStartTime(replayScenario.startTime);
  await replaySelectTimerangePage.selectDurationOfReplay('10');
  await CucumberLog.addText(`Setting the replay to start on ${replayScenario.date} at ${replayScenario.startTime} for 10 minutes`);
});

Given(/^I set the date and time for replay to$/, async (dataTable) => {
  const table = dataTable.hashes()[0];
  await replaySelectTimerangePage.setStartDate(table.date);
  await replaySelectTimerangePage.setStartTime(table.time);
  await replaySelectTimerangePage.selectDurationOfReplay(table.duration);
});

Given(/^the maximum duration possible is (.*) minutes$/, async (expectedMaxDuration) => {
  const maxPossibleDuration: string = await replaySelectTimerangePage.getMaximumPossibleDuration();
  expect(maxPossibleDuration, `The maximum duration possible is was not ${expectedMaxDuration} minutes`)
    .to.equal(expectedMaxDuration);
});

Then(/^the replay start time is pre-populated with an initial value$/, async () => {
  const startTime: string = await replaySelectTimerangePage.getStartTime();
  const expectedTimeRegularExpression = new RegExp(`[[0-9]{2}:[0-9]{2}:[0-9]{2}`);
  expect(startTime, `Start time ${startTime} was not pre-populated with an initial value`)
    .to.match(expectedTimeRegularExpression);
});

Then(/^the replay date is pre-populated with an initial value$/, async () => {
  const startDate: string = await replaySelectTimerangePage.getStartDate();
  const expectedDateRegularExpression = new RegExp(`[[0-9]{2}/[0-9]{2}/[0-9]{4}`);
  expect(startDate, `Start date ${startDate} was not pre-populated with an initial value`)
    .to.match(expectedDateRegularExpression);
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
  await browser.wait(ExpectedConditions.visibilityOf(replayPage.continuationLinkContextMenu.open));
  expect(await replayPage.continuationLinkContextMenu.open.isPresent()).to.equal(true);
  expect(await replayPage.continuationLinkContextMenu.openNewTab.isPresent()).to.equal(true);
});

Then(/^the context menu for the berth has a berth name of '(.*)'$/, async (berthName) => {
  expect(await replayPage.berthContextMenu.berthName.getText()).to.contain(berthName);
});

Then(/^the context menu for the berth has a signal plated name of '(.*)'$/, async (signal) => {
  expect(await replayPage.berthContextMenu.signalName.getText()).to.contain(signal);
});

When('I make a note of the main replay map background colours', async () => {
  browser.referenceReplayBackgroundColours = await replayPage.getCurrentBackgroundColours();
});

When(/^I wait for the buffer to fill$/, async () => {
  await CommonActions.waitForElementToBeVisible(replayPage.bufferingIndicator);
});

When(/^I select skip forward until the end of the replay is reached$/, async () => {
  while (!(await replayPage.skipForwardButton.getAttribute('class')).includes('disabled')) {
    await replayPage.selectSkipForward();
  }
});
Given(/^I move the replay to the end of the captured scenario$/, async () => {
  await replayPage.moveReplayTimeTo(replayScenario.finishTime);
});

When(/^I move the replay forward until time (.*)$/, async (time) => {
  await replayPage.moveReplayTimeTo(time);
});

When(/^I search for replay map '(.*)'$/, async (input) => {
  await replaySelectMapPage.searchForMap(input);
});

Then(/^the replay time selection is presented$/, async () => {
  await browser.wait(ExpectedConditions.visibilityOf(replaySelectTimerangePage.selectYourTimeRangeTitle));
  expect((await replaySelectTimerangePage.quickContainer.isPresent())).to.equal(true);
  expect((await replaySelectTimerangePage.startDate.isPresent())).to.equal(true);
  expect((await replaySelectTimerangePage.startTime.isPresent())).to.equal(true);
  expect((await replaySelectTimerangePage.durationContainer.isPresent())).to.equal(true);
  expect((await replaySelectTimerangePage.endDateAndTime.isPresent())).to.equal(true);
});

Then(/^the replay map selection is presented$/, async () => {
  await browser.wait(ExpectedConditions.visibilityOf(replaySelectMapPage.selectYourMapTitle));
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

When(/^I set time period '(.*)' from the quick dropdown$/, async (duration) => {
  await replaySelectTimerangePage.setTimeRange(duration);
});

When(/^I expand the replay duration dropdown$/, async () => {
  await replaySelectTimerangePage.expandDurationDropdown();
});

Then(/^the replay duration dropdown does not display a scroll bar$/, async () => {
  const scrollBarDisplayed = await replaySelectTimerangePage.replayDurationDropdownDisplaysScrollBar();
  expect(scrollBarDisplayed, 'The replay duration dropdown displayed a scroll bar when it shouldn\'t').to.equal(false);
});

Then(/^the map view is opened ready for replaying with timestamp$/, async (dataTable) => {
  const table = dataTable.hashes()[0];
  const replayMapName = await replayPage.getMapName();
  expect(replayMapName).to.equal(table.mapName);
  const dateFormat = DateTimeFormatter.ofPattern('dd/MM/yyyy HH:mm:ss');
  let expectedDateTime;
  if (table.expectedTimestamp.toLowerCase().includes('as set')) {
    expectedDateTime = `${browser.startDate} ${browser.startTime}`;
  }
  else if (table.expectedTimestamp.includes('Last')) {
    expectedDateTime = DateAndTimeUtils.getCurrentDateTime()
      .minusMinutes(table.expectedTimestamp.split(' ')[1])
      .withSecond(0)
      .format(dateFormat);
  }
  else {
    expectedDateTime = table.expectedTimestamp;
  }
  const replayTimestamp: LocalDateTime = await replayPage.getTimestamp();
  const tolerance = ChronoUnit.MINUTES.between(replayTimestamp, LocalDateTime.parse(expectedDateTime, dateFormat));
  expect(Math.abs(tolerance), `The difference between replay time of ${replayTimestamp.format(dateFormat)} and expected time of ${expectedDateTime} was outside of the allowed tolerance`).to.be.lessThan(6);
});

When(/^I save the replay timestamp$/, async () => {
  const dateFormat = DateTimeFormatter.ofPattern('dd/MM/yyyy HH:mm:ss');
  const replayTimestamp: LocalDateTime = await replayPage.getTimestamp();
  browser.replayTimeStamp = replayTimestamp.format(dateFormat);
});

Then(/^the replay timestamp is equal to that which is saved$/, async () => {
  const dateFormat = DateTimeFormatter.ofPattern('dd/MM/yyyy HH:mm:ss');
  const replayTimestamp: LocalDateTime = await replayPage.getTimestamp();
  const expectedReplayTimestamp = replayTimestamp.format(dateFormat);
  const savedReplayTimestamp = browser.replayTimeStamp;
  expect(savedReplayTimestamp, `The saved replay timestamp: ${savedReplayTimestamp} was not as expected: ${expectedReplayTimestamp}`)
    .to.equal(expectedReplayTimestamp);
});

When(/^I select skip forward to just after replay scenario step '(.*)'$/, async (eventNum) => {
  const eventNumVal = parseInt(eventNum, 10);
  const eventTimeString: string = replayScenario.steps[eventNumVal].timestamp;
  const eventTime: LocalTime = LocalTime.parse(eventTimeString, DateTimeFormatter.ofPattern('HH:mm:ss'));
  const timeToCheck: LocalTime = eventTime.plusSeconds(1);
  const timeToCheckString = timeToCheck.format(DateTimeFormatter.ofPattern('HH:mm:ss'));
  await replayPage.moveReplayTimeTo(timeToCheckString);
});

Then('the timetable background colour is the same as the map background colour', async () => {
  const ttHeaderElementColour = await replayTimetablePage.getHeaderColour();
  const ttHeaderElementColourHex = CssColorConverterService.rgb2Hex(ttHeaderElementColour);
  expect(ttHeaderElementColourHex, 'The replay timetable background colour was not as expected')
    .to.equal(browser.referenceReplayBackgroundColour);
});

When('I click Play button', async () => {
  await replayPage.selectPlay();
});

When('I click minimised Play button', async () => {
  await replayPage.selectMinimisedPlay();
});

When('I click Stop button', async () => {
  await replayPage.selectStop();
});

When('I click Skip forward button', async () => {
  await replayPage.selectSkipForward();
});

When('I click Skip forward button {string} times', async (clickQuantity: number) => {
  for (let i = 0; i < clickQuantity; i++) {
    await replayPage.selectSkipForward();
  }
});

When('I click Skip back button', async () => {
  await replayPage.selectSkipBack();
});

When('I click Pause button', async () => {
  await replayPage.selectPause();
});

When('I click minimised Pause button', async () => {
  await replayPage.selectMinimisedPause();
});

When('I click replay button', async () => {
  await replayPage.selectReplay();
});

When('I click minimise button', async () => {
  await replayPage.clickMinimise();
});

Then('the replay playback speed is {string}', async (expectedSpeed: string) => {
  const actualSpeed = await CommonActions.waitForFunctionalStringResult(replayPage.getSpeedValue, null, expectedSpeed);
  return expect(actualSpeed, `replay playback speed is not as expected`)
    .to.contain(expectedSpeed);
});

When('I increase the replay speed at position {int}', async (position: number) => {
  position = position - 1;
  await replayPage.clickReplaySpeed();
  await replayPage.increaseReplaySpeed(position);
});

When('I increase the replay speed to {int}, using the manual input', async (speed: number) => {
  await replayPage.setManualInputSpeed(speed);
});

Then('the replay button {string} is {string}', async (button: string, expectedType: string) => {
  const actualType = await replayPage.getButtonType(button);
  if (expectedType === 'enabled') {
    return expect(actualType, `replay button ${button} is not as expected`)
      .to.not.contain('disabled');
  }
  else {
    return expect(actualType, `replay button ${button} is not as expected`)
      .to.contain(expectedType);
  }
});

Then('the replay play back control is {string}', async (expectedType: string) => {
  const actualType = await replayPage.getPlaybackControl();
  if (expectedType.toLowerCase() === 'collapsed') {
    return expect(actualType, `replay playback control is not as expected`)
      .to.contain('expand');
  }
  else if (expectedType.toLowerCase() === 'expanded') {
    return expect(actualType, `replay playback control is not as expected`)
      .to.contain('collapse');
  }
});

Then('my replay should skip {string} minute when I click forward button', async (increment: number) => {
  const dateTimeAtStart = await replayPage.getReplayTimestamp();
  const expectedTime: Date = await formulateIncrementedDateTime(dateTimeAtStart, increment);

  await replayPage.selectSkipForward();
  const dateTimeAfterForward = await replayPage.getReplayTimestamp();
  const actualTime = await formulateDateTime(dateTimeAfterForward);

  return expect(actualTime, `replay playback speed is not as expected`)
    .to.be.closeToTime(expectedTime, 3);
});

Then('my replay should skip {string} minute when I click backward button', async (decrement: number) => {
  const dateTimeAtStart = await replayPage.getReplayTimestamp();
  const expectedTime = await formulateDecrementedDateTime(dateTimeAtStart, decrement);

  await replayPage.selectSkipBack();
  const dateTimeAfterClick = await replayPage.getReplayTimestamp();
  const actualTime = await formulateDateTime(dateTimeAfterClick);

  return expect(actualTime, `replay playback speed is not as expected`)
    .to.be.closeToTime(expectedTime, 3);
});

Then('the replay is paused', async () => {
  browser.capturedReplayTimestamp = await replayPage.getReplayTimestamp();
  browser.sleep(2000);
  const latestReplayTimestamp = await replayPage.getReplayTimestamp();
  expect(latestReplayTimestamp, 'Replay has not been paused').to.equal(browser.capturedReplayTimestamp);
});

Given(/^this replay setup test has been moved to become part of the replay test: (.*)$/, async (replayTest: string) => {
  await CucumberLog.addText(`See ${replayTest}`);
});

When(/^I primary click the replay time$/, async () => {
  await replayPage.clickReplayPlaybackTime();
});

Then(/^the replay date and time text size is (.*)$/, async (expectedFontSize: string) => {
  const textSize: string = await replayPage.getReplayDateAndTimeFontSize();
  expect(textSize, `The replay date and time text size was not ${expectedFontSize} pixels, it was ${textSize}`)
    .to.equal(expectedFontSize);
});

Then(/^the replay playback time and status contains '(.*)'$/, async (expectedToContain: string) => {
  const replayPlaybackStatusText = await replayPage.getReplayPlaybackTimeAndStatus();
  expect(replayPlaybackStatusText, `The replay playback status text did not contain ${expectedToContain}`)
    .to.contain(expectedToContain);
});

Then(/^the replay playback time and status does not contain '(.*)'$/, async (expectedToNotContain: string) => {
  await browser.wait(async () => {
    const replayPlaybackStatusText = await replayPage.getReplayPlaybackTimeAndStatus();
    return !replayPlaybackStatusText.includes(expectedToNotContain);
  }, browser.params.replay_timeout, `The replay playback status text did not contain ${expectedToNotContain}`);
});

Then(/^the select map page (is not|is) displayed$/, async (negateFlag: string) => {
  const isDisplayed: boolean = await replaySelectMapPage.selectMapPageIsDisplayed();
  if (negateFlag === 'is not') {
    expect(isDisplayed, `Select map page is displayed but shouldn't be`).to.equal(false);
  }
  else {
    expect(isDisplayed, 'Select map page is not displayed but it should be').to.equal(true);
  }
});

When(/^I record the replay nav bar time$/, async () => {
  browser.replayNavBarTime = await replayPage.getReplayWindowTitle();
});

When(/^I record the replay control time$/, async () => {
  browser.replayControlTime = await replayPage.getReplayTimestamp();
});

Then(/^the replay nav bar time matches that which was recorded$/, async () => {
  expect(await replayPage.getReplayWindowTitle(), `The replay nav bar time did not match that which was recorded`)
    .to.equal(browser.replayNavBarTime);
});

Then(/^the replay control time matches that which was recorded$/, async () => {
  expect(await replayPage.getReplayTimestamp(), `The replay nav bar time did not match that which was recorded`)
    .to.equal(browser.replayControlTime);
});

Then(/^the replay nav bar time does not match that which was recorded$/, async () => {
  expect(await replayPage.getReplayWindowTitle(), `The replay nav bar time did not match that which was recorded`)
    .to.not.equal(browser.replayNavBarTime);
});

Then(/^the replay control time does not match that which was recorded$/, async () => {
  expect(await replayPage.getReplayTimestamp(), `The replay nav bar time did not match that which was recorded`)
    .to.not.equal(browser.replayControlTime);
});

async function formulateDateTime(timeStamp: string): Promise<Date> {
  const dateTime = LocalDateTime.parse(timeStamp, DateTimeFormatter.ofPattern('dd/MM/yyy HH:mm:ss'));
  const parsedDateTime = new Date(
    dateTime.year(), dateTime.monthValue(), dateTime.dayOfMonth(), dateTime.hour(), dateTime.minute(), dateTime.second());
  return moment(parsedDateTime).toDate();
}

async function formulateIncrementedDateTime(timeStamp: string, increment: number): Promise<Date> {
  const dateTime = LocalDateTime.parse(timeStamp, DateTimeFormatter.ofPattern('dd/MM/yyy HH:mm:ss'));
  const parsedDateTime = new Date(
    dateTime.year(), dateTime.monthValue(), dateTime.dayOfMonth(), dateTime.hour(), dateTime.minute(), dateTime.second());
  return moment(parsedDateTime).add(increment, 'minute').toDate();
}

async function formulateDecrementedDateTime(timeStamp: string, decrement: number): Promise<any> {
  const dateTime = LocalDateTime.parse(timeStamp, DateTimeFormatter.ofPattern('dd/MM/yyy HH:mm:ss'));
  const parsedDateTime = new Date(
    dateTime.year(), dateTime.monthValue(), dateTime.dayOfMonth(), dateTime.hour(), dateTime.minute(), dateTime.second());
  return moment(parsedDateTime).subtract(decrement, 'minute').toDate();
}
