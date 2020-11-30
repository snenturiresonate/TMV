import {Before, Then, When} from 'cucumber';
import {TimetablePageObject} from '../pages/timetable.page';
import {expect} from 'chai';
import {Duration, LocalTime} from '@js-joda/core';

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
