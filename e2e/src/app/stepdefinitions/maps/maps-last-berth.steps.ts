import {Then, When, Given} from 'cucumber';
import {LastberthServicelistPageObject} from '../../pages/sections/lastberth.servicelist.page';
import {expect} from 'chai';
import {DateTimeFormatter, LocalDateTime} from '@js-joda/core';
import {DateAndTimeUtils} from '../../pages/common/utilities/DateAndTimeUtils';
import {browser} from 'protractor';

const lastBerthServiceListPageObject: LastberthServicelistPageObject = new LastberthServicelistPageObject();

Given('Last berth data has been loaded for {string}', async (lastBerth: string) => {
  expect(browser.loadedLastBerthData, `last berth data not loaded for ${lastBerth}`).contains(lastBerth);
});

Then('I make a note that last berth data has been loaded for {string}', async (lastBerth: string) => {
  browser.loadedLastBerthData.push(lastBerth);
});

When('I use the primary mouse on train {string}', async (trainDesc: string) => {
  const trainRecord = await lastBerthServiceListPageObject.getRowByService(trainDesc);
  await trainRecord.performLeftClick();
});

Then('the user is presented with a list of the last {string} services that have {string} this berth',
  async (expectedNumServices: string, expectedBehavior: string, expectedlastServicesTable: any) => {
    expect(lastBerthServiceListPageObject.isDisplayed(), 'Last service list not displayed').to.equal(true);
    const actualServiceTable = await lastBerthServiceListPageObject.getServiceListRows();
    expect(actualServiceTable.length, `Expected ${expectedNumServices} services listed but got ${actualServiceTable.length}`)
      .to.equal(Number(expectedNumServices));
    for (const expectedRecord of expectedlastServicesTable) {
      let found = false;
      const expectedService = expectedRecord.serviceDescription;
      const expectedOperator = expectedRecord.operatorCode;
      const expectedPunctuality = expectedRecord.punct;
      const expectedArrivalTime = expectedRecord.arrivalTime;
      const expectedArrivalDate = DateAndTimeUtils.convertToDesiredDateAndFormat(expectedRecord.arrivalDate, 'dd-MM-yy');
      for (const row of actualServiceTable) {
        const service = await row.getService() === expectedService;
        const operator = await row.getOperator() === expectedOperator;
        const punctuality = await row.getPunctuality() === expectedPunctuality;
        const arrivalTime = await row.getArrivalTime() === expectedArrivalTime;
        const arrivalDate = await row.getArrivalTime() === expectedArrivalDate;
        found = (service && operator && punctuality && arrivalTime && arrivalDate);
        if (found) {
          break;
        }
      }
      expect(found,
        `No record found in the modifications table with ${expectedService}, ${expectedOperator},
      ${expectedPunctuality}, ${expectedArrivalTime}, ${expectedArrivalDate}`)
        .to.equal(true);
    }
  });

Then(/^the records in the last berth service list are in reverse date-time order$/, async () => {
  const serviceTable = await lastBerthServiceListPageObject.getServiceListRows();
  const services = serviceTable.map(async (row) => (await row.getArrivalDate()));
  const dates = serviceTable.map(async (row) => (await row.getArrivalDate()));
  const times = serviceTable.map(async (row) => (await row.getArrivalTime()));

  for (let i = 0; i < (dates.length - 1); i++) {
    const dateFormat = 'dd/MM/yyyy';
    const rowDate = LocalDateTime.parse(await dates[i], DateTimeFormatter.ofPattern(dateFormat));
    const nextRowDate = LocalDateTime.parse(await dates[i + 1], DateTimeFormatter.ofPattern(dateFormat));

    expect(rowDate.isAfter(nextRowDate) || rowDate.isEqual(nextRowDate),
      `Services are not in reverse date order. ${services[i]} not after ${services[i + 1]}`)
      .to.equal(true);
  }

  for (let i = 0; i < (times.length - 1); i++) {
    const dateFormat = 'dd/MM/yyyy HH:mm';
    const rowTime = LocalDateTime.parse(await times[i], DateTimeFormatter.ofPattern(dateFormat));
    const nextRowTime = LocalDateTime.parse(await times[i + 1], DateTimeFormatter.ofPattern(dateFormat));
    if (dates[i] === dates[i + 1]) {
      expect(rowTime.isAfter(nextRowTime) || rowTime.isEqual(nextRowTime),
        `Services are not in reverse time order. ${services[i]} not after ${services[i + 1]}`)
        .to.equal(true);
    }
  }
});

