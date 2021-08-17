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
    expect(await lastBerthServiceListPageObject.isDisplayed(), 'Last service list not displayed').to.equal(true);
    const actualServiceTable = await lastBerthServiceListPageObject.getServiceListRows();
    expect(actualServiceTable.length, `Expected ${expectedNumServices} services listed but got ${actualServiceTable.length}`)
      .to.equal(Number(expectedNumServices));

    const expectedTable = expectedlastServicesTable.hashes();
    for (let i = 0; i <= actualServiceTable.length - 1; i++) {
      const rowNumber = i + 1;
      const expectedRecord = expectedTable[i];
      const actualRow = actualServiceTable[i];
      const expectedService = expectedRecord.serviceDescription;
      const expectedOperator = expectedRecord.operatorCode;
      const expectedPunctuality = expectedRecord.punct;
      let expectedEventDateTime: string = expectedRecord.eventDateTime;
      expectedEventDateTime = await DateAndTimeUtils.adjustNowTime(
        expectedEventDateTime.substr(4, 1), parseInt(expectedEventDateTime.substr(6), 10));
      expectedEventDateTime = expectedEventDateTime.substr(0, 4);
      expect(await actualRow.getService(), `The service was not as expected on row ${rowNumber}`).to.equal(expectedService);
      expect(await actualRow.getOperator(), `The Operator was not as expected on row ${rowNumber}`).to.equal(expectedOperator);
      expect(expectedPunctuality, `The Punctuality was not as expected on row ${rowNumber}`)
        .to.contain((await actualRow.getPunctuality()).split(' ')[0]);
    }
  });

Then(/^the records in the last berth service list are in reverse date-time order$/, async () => {
  const serviceTable = await lastBerthServiceListPageObject.getServiceListRows();
  const services = serviceTable.map(async (row) => (await row.getService()));
  const times = serviceTable.map(async (row) => (await row.getEventDateTime()));

  for (let i = 0; i < (times.length - 1); i++) {
    const dateFormat = 'dd/MM/yyyy HH:mm';
    const rowTime = LocalDateTime.parse(await times[i], DateTimeFormatter.ofPattern(dateFormat));
    const nextRowTime = LocalDateTime.parse(await times[i + 1], DateTimeFormatter.ofPattern(dateFormat));
    expect(rowTime.isAfter(nextRowTime) || rowTime.isEqual(nextRowTime),
      `Services are not in reverse time order. ${services[i]} not after ${services[i + 1]}`)
      .to.equal(true);
  }
});

