import {Before, Given, Then, When} from 'cucumber';
import {TimetablePageObject} from '../pages/timetable.page';
import {assert, expect} from 'chai';
import {Duration, LocalTime} from '@js-joda/core';
import {ScheduleBuilder} from '../utils/access-plan-requests/schedule-builder';
import {LocationBuilder} from '../utils/access-plan-requests/location-builder';
import {OriginLocationBuilder} from '../utils/access-plan-requests/origin-location-builder';
import {IntermediateLocationBuilder} from '../utils/access-plan-requests/intermediate-location-builder';
import {TerminatingLocationBuilder} from '../utils/access-plan-requests/terminating-location-builder';
import {AccessPlanRequestBuilder} from '../utils/access-plan-requests/access-plan-request-builder';
import {LinxRestClient} from '../api/linx/linx-rest-client';

let page: TimetablePageObject;

Before(() => {
  page = new TimetablePageObject();
});

When('I am on the timetable view for service {string}', async (service: string) => {
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
    const row = await page.getRowByLocation(location.location);
    const text = await row.ln.getText();
    assert(location.pathCode === text, `location ${location.location} should have Line Code ${text}`);
  }
});

Then(/^the locations line code matches the original line code$/, async (locationsTable: any) => {
  const locations: any = locationsTable.hashes();
  for (const location of locations) {
    const row = await page.getRowByLocation(location.location);
    const text = await row.ln.getText();
    assert(location.lineCode === text, `location ${location.location} should have Line Code ${text}`);
  }
});

Then(/^the locations path code matches the original path code$/, async (locationsTable: any) => {
  const locations: any = locationsTable.hashes();
  for (const location of locations) {
    const row = await page.getRowByLocation(location.location);
    const text = await row.path.getText();
    assert(location.pathCode === text, `location ${location.location} should have Path Code ${text}`);
  }
});


Then('no line code is displayed for location {string}', async (location: string) => {
  const row = await page.getRowByLocation(location);
  const text = await row.ln.getText();
  assert('' === text, `location ${location} should have Line Code not set, was ${text}`);
});

Then('no path code is displayed for location {string}', async (location: string) => {
  const row = await page.getRowByLocation(location);
  const text = await row.path.getText();
  assert('' === text, `location ${location} should have Path Code not set, was ${text}`);
});


Given(/^I generate an access plan request$/, async () => {
  // this is a work in progress, currently blocked by https://resonatevsts.visualstudio.com/illuminati/_workitems/edit/50347
  const origin = new OriginLocationBuilder()
    .withLocation(new LocationBuilder().withTiploc('PADTON').build())
    .withScheduledDeparture('09:58')
    .build();
  const int = new IntermediateLocationBuilder()
    .withLocation(new LocationBuilder().withTiploc('ROYAOJN').build())
    .withScheduledArrival('10:00')
    .withLine('LIN')
    .withPath('PAT')
    .build();
  const term = new TerminatingLocationBuilder()
    .withLocation(new LocationBuilder().withTiploc('OLDOXRS').build())
    .withScheduledArrival('10:13')
    .withPath('PAT')
    .build();
  const schedule = new ScheduleBuilder()
    .withOriginLocation(origin)
    .withIntermediateLocation(int)
    .withTerminatingLocation(term)
    .build();
  const accessPlan = new AccessPlanRequestBuilder()
    .withSchedule(schedule)
    .build();
  new LinxRestClient().writeAccessPlan(accessPlan);
  console.log(JSON.stringify(accessPlan));
});
Then(/^the path code for the To Location matches the line code for the From Location$/, async (dataTable) => {
  const rules: any = dataTable.hashes();
  for (const rule of rules) {
    const row = await page.getRowByLocation(rule.toLocation);
    const text = await row.path.getText();
    assert(rule.lineCode === text, `location ${rule.toLocation} should have path code ${rule.lineCode}`);
  }
});
Then(/^the locations path code matches the original path code$/, function() {

});
