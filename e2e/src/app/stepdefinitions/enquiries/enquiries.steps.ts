import {Given, When, Then} from 'cucumber';
import {EnquiriesPageObject} from '../../pages/enquiries/enquiries.page';
import {expect} from 'chai';
import {browser} from 'protractor';
import {DateAndTimeUtils} from '../../pages/common/utilities/DateAndTimeUtils';
import {DateTimeFormatter, LocalDateTime, LocalTime, ZoneId} from '@js-joda/core';

const enquiriesPage: EnquiriesPageObject = new EnquiriesPageObject();
const ENQUIRIES_LOAD_DELAY = 2000;


Given('I type {string} into the enquiries location search box', async (text: string) => {
  await enquiriesPage.enterLocationSearchString(text);
});

Given('I select the location at position {int} in the enquiries location auto suggest search results list', async (position: number) => {
  await enquiriesPage.clickLocationAutoSuggestSearchResult(position);
});

When('I click the enquiries view button', async () => {
  await enquiriesPage.clickViewButton();
  await browser.sleep(ENQUIRIES_LOAD_DELAY);
});

Then('I should see the enquiries columns as', {timeout: 2 * 20000}, async (table: any) => {
  const expectedColHeaders: string[] = table.hashes().map((Value: any) => {
    return Value.header;
  });
  const columnsAsExpected = await enquiriesPage.columnsAre(expectedColHeaders);
  expect(columnsAsExpected, 'Columns are not as expected').to.equal(true);
});

When('I invoke the context menu for todays train {string} schedule uid {string} from the enquiries page',
  async (serviceId: string, scheduleId: string) => {
    if (scheduleId === 'UNPLANNED') {
      const schedNum = await enquiriesPage.getRowForSchedule(serviceId) + 1;
      await enquiriesPage.rightClickTrainListItemNum(schedNum);
    }
    else {
      if (scheduleId === 'generatedTrainUId' || scheduleId === 'generated') {
        scheduleId = browser.referenceTrainUid;
      }
      const todaysScheduleString = scheduleId + ':' + DateAndTimeUtils.convertToDesiredDateAndFormat('today', 'yyyy-MM-dd');
      await enquiriesPage.rightClickTrainListItem(todaysScheduleString);
    }
  });

When('I primary click for todays train {string} schedule uid {string} from the enquiries page',
  async (trainDescription: string, scheduleId: string) => {
    if (trainDescription.includes('generated')) {
      trainDescription = browser.referenceTrainDescription;
    }
    if (scheduleId === 'UNPLANNED') {
      const schedNum = await enquiriesPage.getRowForSchedule(trainDescription) + 1;
      await enquiriesPage.leftClickTrainListItemNum(schedNum);
    } else {
      if (scheduleId === 'generatedTrainUId' || scheduleId === 'generated') {
        scheduleId = browser.referenceTrainUid;
      }
      const todaysScheduleString = scheduleId + ':' + DateAndTimeUtils.convertToDesiredDateAndFormat('today', 'yyyy-MM-dd');
      await enquiriesPage.leftClickHeadcodeOnTrainListItem(todaysScheduleString);
    }
  });

When('I wait for the enquiries page context menu to display', async () => {
  await enquiriesPage.waitForContextMenu();
});

When('I have set the start and end time to a period after the train finishes', async () => {
  const now = DateAndTimeUtils.getCurrentTime();
  await enquiriesPage.setStartTime(now.plusHours(3).format(DateTimeFormatter.ofPattern('HH:mm')));
  await enquiriesPage.setEndTime(now.plusHours(5).format(DateTimeFormatter.ofPattern('HH:mm')));
});

When('I have set the start and end time to a period before the train begins', async () => {
  const now = DateAndTimeUtils.getCurrentTime();
  await enquiriesPage.setStartTime(now.minusHours(5).format(DateTimeFormatter.ofPattern('HH:mm')));
  await enquiriesPage.setEndTime(now.minusHours(3).format(DateTimeFormatter.ofPattern('HH:mm')));
});

When('I have set the start time to {string}', async (startTime: string) => {
  await enquiriesPage.setStartTime(startTime);
});

When('I have set the end time to {string}', async (endTime: string) => {
  await enquiriesPage.setEndTime(endTime);
});

When('I uncheck the enquiries Originate checkbox for {string}', async (station: string) => {
  await enquiriesPage.clickStopTypeCheckbox('ORIGINATE', station);
});

When('I uncheck the enquiries Terminate checkbox for {string}', async (station: string) => {
  await enquiriesPage.clickStopTypeCheckbox('TERMINATE', station);
});

When('I uncheck the enquiries Stop checkbox for {string}', async (station: string) => {
  await enquiriesPage.clickStopTypeCheckbox('STOP', station);
});

When('I uncheck the enquiries Pass checkbox for {string}', async (station: string) => {
  await enquiriesPage.clickStopTypeCheckbox('PASS', station);
});

Then(/^the (Matched|Unmatched) version of the (Schedule-matching|Non-Schedule-matching) enquiries view context menu is displayed$/,
  async (matchType: string, userType: string) => {
    let expected1;
    let expected2;
    let expected3;
    if (matchType === 'Matched') {
      expected1 = 'Open Timetable';
      expected2 = 'Find Train';
      expected3 = 'Unmatch/Rematch';
    } else {
      expected1 = 'No Timetable';
      expected2 = 'Find Train';
      expected3 = 'Match';
    }
    const contextMenuItem1: string = await enquiriesPage.getTrainsListContextMenuItem(2);
    const contextMenuItem2: string = await enquiriesPage.getTrainsListContextMenuItem(3);
    const contextMenuItem3: string = await enquiriesPage.getTrainsListContextMenuItem(4);
    expect(contextMenuItem1.toLowerCase(), `Context menu does not imply ${matchType} state - does not contain ${expected1}`)
      .to.contain(expected1.toLowerCase());
    expect(contextMenuItem2.toLowerCase(), `Context menu does not imply ${matchType} state - does not contain ${expected2}`)
      .to.contain(expected2.toLowerCase());
    if (userType === 'Schedule-matching') {
      expect(contextMenuItem3.toLowerCase(), `Context menu does not imply ${matchType} state - does not contain ${expected2}`)
        .to.contain(expected3.toLowerCase());
    } else  {
      expect(contextMenuItem3.toLowerCase(), `Context menu does not imply ${userType} state - does not contain ${expected2}`)
        .to.not.contain(expected3.toLowerCase());
    }
  });

When(/^I set the start date to now (\+|-) (.*) minutes?$/, async (operator: string, minutes: number) => {
  let now;
  const timeFormat = 'HH:mm';
  if (! Boolean(operator)) {
    now = DateAndTimeUtils.getCurrentTimePlusOrMinusMins(0, 0, timeFormat);
  }
  if (operator === '+') {
    now = DateAndTimeUtils.getCurrentTimePlusOrMinusMins(minutes, 0, timeFormat);
  }
  if (operator === '-') {
    now = DateAndTimeUtils.getCurrentTimePlusOrMinusMins(0, minutes, timeFormat);
  }
  await enquiriesPage.setStartTime(now);
});

Then(/^(a|no) validation error is displayed$/, async (affirmity: string) => {
  await browser.wait(async () => {
    if (affirmity === 'a') {
      return (await enquiriesPage.isValidationErrorDisplayed()) === true;
    }
    else {
      return (await enquiriesPage.isValidationErrorDisplayed()) === false;
    }
  }, browser.params.quick_timeout, `Expected ${affirmity} validation error to be displayed`);
});

Then('the enquiries start time is about {int} minutes ago',
  async (minutes: number) => {
    let shown : number = LocalDateTime.parse(await enquiriesPage.getStartDate() + ' ' + await enquiriesPage.getStartTime(),
      DateTimeFormatter.ofPattern('dd/MM/yyyy HH:mm')).atZone(ZoneId.systemDefault()).toEpochSecond();
    let currentTime : number = LocalDateTime.now().atZone(ZoneId.systemDefault()).toEpochSecond();

    expect(shown, 'Incorrect start time').to.above(currentTime - minutes * 60 - 90);
    expect(shown, 'Incorrect start time').to.below(currentTime - minutes * 60 + 90);
  });

Then('the enquiries end time is in about {int} minutes',
  async (minutes: number) => {
    let shown : number = LocalDateTime.parse(await enquiriesPage.getEndDate() + ' ' + await enquiriesPage.getEndTime(),
      DateTimeFormatter.ofPattern('dd/MM/yyyy HH:mm')).atZone(ZoneId.systemDefault()).toEpochSecond();
    let currentTime : number = LocalDateTime.now().atZone(ZoneId.systemDefault()).toEpochSecond();

    expect(shown, 'Incorrect end time').to.above(currentTime + minutes * 60 - 90);
    expect(shown, 'Incorrect end time').to.below(currentTime + minutes * 60 + 90);
  });

Then('train {string} with schedule id {string} for today is not visible on the enquiries page',
  async (trainDescription: string, scheduleId: string) => {
    const todaysScheduleString = scheduleId + ':' + DateAndTimeUtils.convertToDesiredDateAndFormat('today', 'yyyy-MM-dd');
    const isScheduleVisible: boolean = await enquiriesPage.isTrainVisible(trainDescription, todaysScheduleString, 500);
    expect(isScheduleVisible, `Train ${trainDescription}:${scheduleId} was visible on the trains list`).to.equal(false);
  });
