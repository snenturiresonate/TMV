import {Before, Given, Then, When} from 'cucumber';
import {TimetablePageObject} from '../pages/timetable.page';
import {expect} from 'chai';
import {Duration, LocalTime} from '@js-joda/core';
import {ScheduleBuilder} from '../utils/access-plan-requests/schedule-builder';
import {LocationBuilder} from '../utils/access-plan-requests/location-builder';
import {OriginLocationBuilder} from '../utils/access-plan-requests/origin-location-builder';
import {IntermediateLocationBuilder} from '../utils/access-plan-requests/intermediate-location-builder';
import {TerminatingLocationBuilder} from '../utils/access-plan-requests/terminating-location-builder';
import {AccessPlanRequestBuilder} from '../utils/access-plan-requests/access-plan-request-builder';
import {LinxRestClient} from '../api/linx/linx-rest-client';
import {ServiceCharacteristicsBuilder} from '../utils/access-plan-requests/service-characteristics-builder';
import {CucumberLog} from '../logging/cucumber-log';
import {ScheduleIdentifierBuilder} from '../utils/access-plan-requests/schedule-identifier-builder';
import {DateAndTimeUtils} from '../pages/common/utilities/DateAndTimeUtils';
import {DaysBuilder} from '../utils/access-plan-requests/days-builder';

let page: TimetablePageObject;
// No plans for parallel running, should be fine
let schedule: ScheduleBuilder;

Before(() => {
  page = new TimetablePageObject();
});

When('I am on the timetable view for service {string}', {timeout: 15 * 1000}, async (service: string) => {
  await page.navigateTo(service);
});

When(/^the Inserted toggle is '(on|off)'$/, async (state: string) => {
  await page.toggleInserted(state);
});

Then(/^no inserted locations are displayed$/, async () => {
  const locations = await page.getLocations();
  for (const location of locations) {
    expect(location).not.to.contain('[', 'Expect no additional locations. [location]');
    expect(location).not.to.contain(']', 'Expect no additional locations. [location]');
  }
});

Then('the inserted location {string} is displayed in square brackets', async (location: string) => {
  const locations = await page.getLocations()
    .then(allLocations => allLocations.filter(loc => loc.includes(location)));
  expect(locations).to.contain('[' + location + ']');
});

Then(/^the inserted location (.*) is (before|after) (.*)$/,
  async (insertedLocation: string, beforeAfter: string, otherLocation: string) => {
    const locations = await page.getLocations();
    const rowOfInserted = await page.getLocationRowIndex(page.ensureInsertedLocationFormat(insertedLocation));
    (beforeAfter === 'before') ?
      expect(locations[rowOfInserted + 1]).to.equal(otherLocation) :
      expect(locations[rowOfInserted - 1]).to.equal(otherLocation);
  });

Then(/^the expected arrival time for inserted location (.*) is (.*) percent between (.*) and (.*)$/, async (
  location: string, percentage: number, departure: string, arrival: string) => {
  const startingDepartureTime = LocalTime.parse(departure);
  const destinationArrivalTime = LocalTime.parse(arrival);
  const difference = Duration.between(startingDepartureTime, destinationArrivalTime).seconds();
  const expectedArrivalTime = startingDepartureTime.plusSeconds(difference * (percentage / 1000));
  const row = await page.getRowByLocation(page.ensureInsertedLocationFormat(location));
  row.plannedArr.getText().then(text => expect(text).to.equal(expectedArrivalTime.toString()));
});

Then(/^the locations line code matches the path code$/, async (locationsTable: any) => {
  const locations: any = locationsTable.hashes();
  for (const location of locations) {
    await page.lineTextToEqual(location.location, location.pathCode);
  }
});

Then(/^the locations line code matches the original line code$/, async (locationsTable: any) => {
  const rows: any = locationsTable.hashes();
  for (const row of rows) {
    await page.lineTextToEqual(row.location, row.lineCode);
  }
});

Then(/^the locations path code matches the original path code$/, async (locationsTable: any) => {
  const rows: any = locationsTable.hashes();
  for (const row of rows) {
    await page.pathTextToEqual(row.location, row.pathCode);
  }
});

Then('no line code is displayed for location {string}', async (location: string) => {
  await page.lineTextToEqual(location, '');
});

Then('no path code is displayed for location {string}', async (location: string) => {
  await page.pathTextToEqual(location, '');
});

Then(/^the path code for Location is correct$/, async (dataTable) => {
  const rows: any = dataTable.hashes();
  for (const row of rows) {
    await page.pathTextToEqual(row.location, row.pathCode);
  }
});

Then(/^the line code for Location is correct$/, async (dataTable) => {
  const rows: any = dataTable.hashes();
  for (const row of rows) {
    await page.lineTextToEqual(row.location, row.lineCode);
  }
});


Then(/^the path code for the To Location matches the line code for the From Location$/, async (dataTable) => {
  const rows: any = dataTable.hashes();
  for (const row of rows) {
    await page.pathTextToEqual(row.toLocation, row.lineCode);
  }
});

When('there is a Schedule for {string}', (service: string) => {
  schedule = new ScheduleBuilder()
    .withServiceCharacteristics(new ServiceCharacteristicsBuilder()
      .withTrainIdentity(service)
      .build());
});

When('that service has the cancellation status {string}', (service: string) => {
  schedule.withTrainStatus(service);
});

Given(/^it has Origin Details$/, async (table: any) => {
  const location: any = table.hashes()[0];
  schedule.withOriginLocation(new OriginLocationBuilder()
    .withLocation(new LocationBuilder().withTiploc(location.tiploc).build())
    .withScheduledDeparture(location.scheduledDeparture)
    .withLine(location.line)
    .build());
});

Given(/^it has Intermediate Details$/, async (table: any) => {
  const locations: any = table.hashes();
  locations.forEach((location: any) => {
    const int = new IntermediateLocationBuilder()
      .withLocation(new LocationBuilder().withTiploc(location.tiploc).build())
      .withScheduledArrival(location.scheduledArrival)
      .withScheduledDeparture(location.scheduledDeparture)
      .withPath(location.path)
      .build();
    schedule.withIntermediateLocation(int);
  });
});

Given(/^it has Terminating Details$/, async (table: any) => {
  const location: any = table.hashes()[0];
  schedule.withTerminatingLocation(new TerminatingLocationBuilder()
    .withLocation(new LocationBuilder().withTiploc(location.tiploc).build())
    .withScheduledArrival(location.scheduledArrival)
    .withPath(location.path)
    .build());
});

Given(/^the schedule has a basic timetable$/, () => {
  schedule.withOriginLocation(new OriginLocationBuilder()
    .withLocation(new LocationBuilder().withTiploc('OLDOXRS').build())
    .withScheduledDeparture('12:00')
    .withLine('')
    .build());
  schedule.withTerminatingLocation(new TerminatingLocationBuilder()
    .withLocation(new LocationBuilder().withTiploc('OLDOXRS').build())
    .withScheduledArrival('12:30')
    .withPath('')
    .build());
});

When('the schedule is received from LINX', () => {
  const accessPlan = new AccessPlanRequestBuilder()
    .full()
    .withSchedule(schedule.build())
    .build();
  CucumberLog.addJson(accessPlan);
  new LinxRestClient().writeAccessPlan(accessPlan);
});

Given(/^the schedule has schedule identifier characteristics$/, async (table: any) => {
  const characteristics: any = table.hashes();

  characteristics.forEach((characteristic: any) => {
    const scheduleIdentifier = new ScheduleIdentifierBuilder()
      .withTrainUid(characteristic.trainUid)
      .withStpIndicator(characteristic.stpIndicator)
      .withDateRunsFrom(characteristic.dateRunsFrom)
      .build();
    schedule.withScheduleIdentifier(scheduleIdentifier);
  });
});

Given(/^the schedule has a Date Run to of '(.*)'$/, (runToDate: string) => {
  schedule.withDateRunsTo(runToDate);
});

Given(/^the schedule has a Days Run of all Days$/, () => {
  schedule.withDaysRun(new DaysBuilder().allDays().build());
});

Given(/^the schedule does not run on a day that is today$/, () => {
  const today = DateAndTimeUtils.dayOfWeek();
  schedule.noRunDay(today, schedule);
});


Given(/^the schedule does not run on a day that is tommorow$/, () => {
  const tommorow = DateAndTimeUtils.dayOfWeekPlusDays(1);
  schedule.noRunDay(tommorow, schedule);
});



Given(/^the following basic schedules? (?:is|are) received from LINX$/, async (table: any) => {
  const messages: any = table.hashes();
  messages.forEach(message => {
    const accessPlan = new AccessPlanRequestBuilder()
      .full()
      .withSchedule(new ScheduleBuilder()
        .withServiceCharacteristics(new ServiceCharacteristicsBuilder()
          .withTrainIdentity(message.trainDescription)
          .build())
        .withScheduleIdentifier(new ScheduleIdentifierBuilder()
          .withTrainUid(message.trainUid)
          .withStpIndicator(message.stpIndicator)
          .withDateRunsFrom(message.dateRunsFrom)
          .build())
        .withDateRunsTo(message.dateRunsTo)
        .withDaysRun(new DaysBuilder()
          .withDayBits(message.daysRun)
          .build())
        .withOriginLocation(new OriginLocationBuilder()
          .withLocation(new LocationBuilder().withTiploc(message.origin).build())
          .withScheduledDeparture(message.departure)
          .withLine('')
          .build())
        .withTerminatingLocation(new TerminatingLocationBuilder()
          .withLocation(new LocationBuilder().withTiploc(message.termination).build())
          .withScheduledArrival(message.arrival)
          .withPath('')
          .build())
        .build())
      .build();
    CucumberLog.addJson(accessPlan);
    new LinxRestClient().writeAccessPlan(accessPlan);
  });
});

