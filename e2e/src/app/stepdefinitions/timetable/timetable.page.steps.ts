import {Given, When, Then} from 'cucumber';
import {expect} from 'chai';
import {TimeTablePageObject} from '../../pages/timetable/timetable.page';
import {Duration, LocalTime} from '@js-joda/core';
import {ScheduleBuilder} from '../../utils/access-plan-requests/schedule-builder';
import {LocationBuilder} from '../../utils/access-plan-requests/location-builder';
import {OriginLocationBuilder} from '../../utils/access-plan-requests/origin-location-builder';
import {IntermediateLocationBuilder} from '../../utils/access-plan-requests/intermediate-location-builder';
import {TerminatingLocationBuilder} from '../../utils/access-plan-requests/terminating-location-builder';
import {AccessPlanRequestBuilder} from '../../utils/access-plan-requests/access-plan-request-builder';
import {LinxRestClient} from '../../api/linx/linx-rest-client';
import {ServiceCharacteristicsBuilder} from '../../utils/access-plan-requests/service-characteristics-builder';
import {CucumberLog} from '../../logging/cucumber-log';
import {ScheduleIdentifierBuilder} from '../../utils/access-plan-requests/schedule-identifier-builder';
import {DateAndTimeUtils} from '../../pages/common/utilities/DateAndTimeUtils';
import {DaysBuilder} from '../../utils/access-plan-requests/days-builder';

const timetablePage: TimeTablePageObject = new TimeTablePageObject();
// No plans for parallel running, should be fine
let schedule: ScheduleBuilder;

const timetableColumnIndexes = {
  location: 0,
  workingArrivalTime: 1,
  workingDeptTime: 2,
  publicArrivalTime: 3,
  publicDeptTime: 4,
  originalAssetCode: 5,
  originalPathCode: 6,
  originalLineCode: 7,
  allowances: 8,
  activities: 9,
  arrivalDateTime: 10,
  deptDateTime: 11,
  assetCode: 12,
  pathCode: 13,
  lineCode: 14,
  punctuality: 15
};

const punctualityColourHex = {
  palepink: '#ffb4b4',
  lilac: '#e5b4ff',
  paleblue: '#78e7ff',
  palegreen: '#78ff78',
  green: '#00ff00',
  yellow: '#ffff00',
  orange: '#ffa700',
  red: '#ff0000',
  darkpink: '#ff009c'
};

Then('The timetable service description is visible', async () => {
  const isTimetableServiceDescriptionVisible: boolean = await timetablePage.isTimetableServiceDescriptionVisible();
  expect(isTimetableServiceDescriptionVisible).to.equal(true);
});

Then('the timetable header train description is {string}', async (expectedTrainDescription: string) => {
  const trainDescription: string = await timetablePage.getHeaderTrainDescription();
  expect(trainDescription).to.equal(expectedTrainDescription);
});

Then('The live timetable tab will be titled {string}', async (expectedTabName: string) => {
  const actualTimetableTabName: string = await timetablePage.getLiveTimetableTabName();

  expect(actualTimetableTabName).to.equal(expectedTabName);

});


Then('The values for the header properties are as follows',
  async (headerPropertyValues: any) => {
    const expectedHeaderPropertyValues: any = headerPropertyValues.hashes()[0];
    const actualHeaderScheduleType: string = await timetablePage.headerScheduleType.getText();
    const actualHeaderSignal: string = await timetablePage.headerSignal.getText();
    const actualHeaderLastReported: string = await timetablePage.headerLastReported.getText();
    const actualHeaderTrainUid: string = await timetablePage.headerTrainUid.getText();
    const actualHeaderTrustId: string = await timetablePage.headerTrustId.getText();
    const actualHeaderTJM: string = await timetablePage.headerTJM.getText();

    expect(actualHeaderScheduleType).to.equal(expectedHeaderPropertyValues.schedType);
    expect(actualHeaderSignal).to.equal(expectedHeaderPropertyValues.lastSignal);
    expect(actualHeaderLastReported).to.equal(expectedHeaderPropertyValues.lastReport);
    expect(actualHeaderTrainUid).to.equal(expectedHeaderPropertyValues.trainUid);
    expect(actualHeaderTrustId).to.equal(expectedHeaderPropertyValues.trustId);
    expect(actualHeaderTJM).to.equal(expectedHeaderPropertyValues.lastTJM);
  });

When('I switch to the timetable details tab', async () => {
  await timetablePage.openDetailsTab();
});

Then('The timetable service description is visible', async () => {
  const isTimetableServiceDescriptionVisible: boolean = await timetablePage.isTimetableServiceDescriptionVisible();
  expect(isTimetableServiceDescriptionVisible).to.equal(true);
});

Then(/^the headcode in the header row is '(.*)'$/, async (header: string) => {
  const headerHeadcode = await timetablePage.headerHeadcode.getText();
  expect(headerHeadcode).to.equal(header);
});

Then(/^there is a record in the modifications table$/, async (table: any) => {
  const modificationsTable = await timetablePage.getModificationsTableRows();
  const expectedRecords = table.hashes();
  for (const expectedRecord of expectedRecords) {
    let found = false;
    for (const row of modificationsTable) {
      const reason = await row.getTypeOfModification() === expectedRecord.description;
      const location = await row.getLocation() === expectedRecord.location;
      const time = await row.getTime() === expectedRecord.time;
      const type = await row.getModificationReason() === expectedRecord.type;
      found = (reason && location && time && type);
    }
    expect(found).to.equal(true, 'No record with value found in the modifications table');
  }
});

Then(/^the last TJM is$/, async (table: any) => {
  const lastTjm = await timetablePage.headerTJM.getText();
  const expected = table.hashes()[0];
  expect(lastTjm).to.equal(`${expected.description}, ${expected.location}, ${expected.time}`);
});

When('I toggle the inserted locations on', async () => {
  await timetablePage.toggleInsertedLocationsOn();
});

When('I toggle the inserted locations off', async () => {
  await timetablePage.toggleInsertedLocationsOff();
});

Then('The timetable header contains the following property labels:',
  async (headerPropertyLabels: any) => {
    const expectedHeaderPropertyLabels: any[] = headerPropertyLabels.hashes();
    const actualHeaderPropertyLabels: string[] = await timetablePage.getTimetableHeaderPropertyLabels();
    expectedHeaderPropertyLabels.forEach((expectedPropertyValue: any, i: number) => {
      expect(actualHeaderPropertyLabels[i]).contains(expectedPropertyValue.property);
    });
  });

Then('The timetable details tab is visible', async () => {
  const isTimetableDetailsTabVisible: boolean = await timetablePage.isTimetableDetailsTabVisible();
  expect(isTimetableDetailsTabVisible).to.equal(true);
});

Then('The entry {int} of the timetable modifications table contains the following data in each column',
  async (index: number, timetableModificationsDataTable: any) => {
    const expectedTimetableModificationsColValues: any[] = timetableModificationsDataTable.hashes();
    const actualTimetableModificationColValues: string[] = await timetablePage.getTimetableModificationColValues(index);

    expectedTimetableModificationsColValues.forEach((expectedAppName: any, i: number) => {
      expect(actualTimetableModificationColValues[i]).to.equal(expectedAppName.column);
    });
  });

Then('The entry {int} of the timetable associations table contains the following data in each column',
  async (index: number, timetableAssociationsDataTable: any) => {
    const expectedTimetableAssociationsColValues: any[] = timetableAssociationsDataTable.hashes();
    const actualTimetableAssociationsColValues: string[] = await timetablePage.getTimetableAssociationsColValues(index);

    expectedTimetableAssociationsColValues.forEach((expectedAppName: any, i: number) => {
      expect(actualTimetableAssociationsColValues[i]).to.equal(expectedAppName.column);
    });
  });

Then('The entry of the change en route table contains the following data', async (changeEnRouteDataTable: any) => {
  const expectedChangeEnRouteColValues = changeEnRouteDataTable.hashes();
  const actualChangeEnRouteColValues = await timetablePage.getChangeEnRouteValues();
  expectedChangeEnRouteColValues.forEach((expectedChangeEnRouteColValue: any) => {
    expect(actualChangeEnRouteColValues).to.contain(expectedChangeEnRouteColValue.columnName);
  });
});

Then('The timetable entries contains the following data',
  async (timetableEntryDataTable: any) => {
    const expectedTimetableEntryColValues: any[] = timetableEntryDataTable.hashes();
    for (const expectedTimetableEntryCol of expectedTimetableEntryColValues) {
      const actualTimetableEntryColValues: string[] = await timetablePage.getTimetableEntryColValues(expectedTimetableEntryCol.entryId);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.location]).to.equal(expectedTimetableEntryCol.location);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.workingArrivalTime])
        .to.equal(expectedTimetableEntryCol.workingArrivalTime);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.workingDeptTime]).to.equal(expectedTimetableEntryCol.workingDeptTime);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.publicArrivalTime]).to.equal(expectedTimetableEntryCol.publicArrivalTime);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.publicDeptTime]).to.equal(expectedTimetableEntryCol.publicDeptTime);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.originalAssetCode]).to.equal(expectedTimetableEntryCol.originalAssetCode);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.originalPathCode]).to.equal(expectedTimetableEntryCol.originalPathCode);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.originalLineCode]).to.equal(expectedTimetableEntryCol.originalLineCode);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.allowances]).to.equal(expectedTimetableEntryCol.allowances);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.activities]).to.equal(expectedTimetableEntryCol.activities);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.arrivalDateTime]).to.equal(expectedTimetableEntryCol.arrivalDateTime);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.deptDateTime]).to.equal(expectedTimetableEntryCol.deptDateTime);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.assetCode]).to.equal(expectedTimetableEntryCol.assetCode);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.pathCode]).to.equal(expectedTimetableEntryCol.pathCode);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.lineCode]).to.equal(expectedTimetableEntryCol.lineCode);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.punctuality]).to.equal(expectedTimetableEntryCol.punctuality);
    }
  });

Then('the navbar punctuality indicator is displayed as {string}', async (expectedColor: string) => {
  const actualColorHex: string = await timetablePage.getNavBarIndicatorColorHex();
  const expectedColourHex = punctualityColourHex[expectedColor];
  expect(actualColorHex).to.equal(expectedColourHex);
});

Then('the punctuality is displayed as {string}', async (expectedText: string) => {
  const actualText: string = await timetablePage.getNavBarIndicatorText();
  expect(actualText).to.equal(expectedText);
});

Then('The timetable details table contains the following data in each row', async (detailsDataTable: any) => {
  const expectedDetailsRowValues: any = detailsDataTable.hashes()[0];

  expect(await timetablePage.getTimetableDetailsRowValueDaysRun()).to.equal(expectedDetailsRowValues.daysRun);
  expect(await timetablePage.getTimetableDetailsRowValueRuns()).to.equal(expectedDetailsRowValues.runs);
  expect(await timetablePage.getTimetableDetailsRowValueBankHoliday()).to.equal(expectedDetailsRowValues.bankHoliday);
  expect(await timetablePage.getTimetableDetailsRowValueBerthId()).to.equal(expectedDetailsRowValues.berthId);
  expect(await timetablePage.getTimetableDetailsRowValueOperator()).to.equal(expectedDetailsRowValues.operator);
  expect(await timetablePage.getTimetableDetailsRowValueTrainServiceCode()).to.equal(expectedDetailsRowValues.trainServiceCode);
  expect(await timetablePage.getTimetableDetailsRowValueTrainCategory()).to.equal(expectedDetailsRowValues.trainCategory);
  expect(await timetablePage.getTimetableDetailsRowValueDirection()).to.equal(expectedDetailsRowValues.direction);
  expect(await timetablePage.getTimetableDetailsRowValueCateringCode()).to.equal(expectedDetailsRowValues.cateringCode);
  expect(await timetablePage.getTimetableDetailsRowValueClass()).to.equal(expectedDetailsRowValues.class);
  expect(await timetablePage.getTimetableDetailsRowValueReservations()).to.equal(expectedDetailsRowValues.reservations);
  expect(await timetablePage.getTimetableDetailsRowValueTimingLoad()).to.equal(expectedDetailsRowValues.timingLoad);
  expect(await timetablePage.getTimetableDetailsRowValuePowerType()).to.equal(expectedDetailsRowValues.powerType);
  expect(await timetablePage.getTimetableDetailsRowValueSpeed()).to.equal(expectedDetailsRowValues.speed);
  expect(await timetablePage.getTimetableDetailsRowValuePortionId()).to.equal(expectedDetailsRowValues.portionId);
  expect(await timetablePage.getTimetableDetailsRowValueTrainLength()).to.equal(expectedDetailsRowValues.trainLength);
  expect(await timetablePage.getTimetableDetailsRowValueTrainOperatingCharacteristcs())
    .to.equal(expectedDetailsRowValues.trainOperatingCharacteristcs);
  expect(await timetablePage.getTimetableDetailsRowValueServiceBranding()).to.equal(expectedDetailsRowValues.serviceBranding);
});

When('I am on the timetable view for service {string}', {timeout: 15 * 1000}, async (service: string) => {
  await timetablePage.navigateTo(service);
});

When(/^the Inserted toggle is '(on|off)'$/, async (state: string) => {
  await timetablePage.toggleInserted(state);
});

Then(/^no inserted locations are displayed$/, async () => {
  const locations = await timetablePage.getLocations();
  for (const location of locations) {
    expect(location).not.to.contain('[', 'Expect no additional locations. [location]');
    expect(location).not.to.contain(']', 'Expect no additional locations. [location]');
  }
});

Then('the inserted location {string} is displayed in square brackets', async (location: string) => {
  const locations = await timetablePage.getLocations()
    .then(allLocations => allLocations.filter(loc => loc.includes(location)));
  expect(locations).to.contain('[' + location + ']');
});

Then(/^the inserted location (.*) is (before|after) (.*)$/,
  async (insertedLocation: string, beforeAfter: string, otherLocation: string) => {
    const locations = await timetablePage.getLocations();
    const rowOfInserted = await timetablePage.getLocationRowIndex(timetablePage.ensureInsertedLocationFormat(insertedLocation));
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
  const row = await timetablePage.getRowByLocation(timetablePage.ensureInsertedLocationFormat(location));
  row.plannedArr.getText().then(text => expect(text).to.equal(expectedArrivalTime.toString()));
});

Then(/^the locations line code matches the path code$/, async (locationsTable: any) => {
  const locations: any = locationsTable.hashes();
  for (const location of locations) {
    await timetablePage.lineTextToEqual(location.location, location.pathCode);
  }
});

Then(/^the locations line code matches the original line code$/, async (locationsTable: any) => {
  const rows: any = locationsTable.hashes();
  for (const row of rows) {
    await timetablePage.lineTextToEqual(row.location, row.lineCode);
  }
});

Then(/^the locations path code matches the original path code$/, async (locationsTable: any) => {
  const rows: any = locationsTable.hashes();
  for (const row of rows) {
    await timetablePage.pathTextToEqual(row.location, row.pathCode);
  }
});

Then('no line code is displayed for location {string}', async (location: string) => {
  await timetablePage.lineTextToEqual(location, '');
});

Then('no path code is displayed for location {string}', async (location: string) => {
  await timetablePage.pathTextToEqual(location, '');
});

Then(/^the path code for Location is correct$/, async (dataTable) => {
  const rows: any = dataTable.hashes();
  for (const row of rows) {
    await timetablePage.pathTextToEqual(row.location, row.pathCode);
  }
});

Then(/^the line code for Location is correct$/, async (dataTable) => {
  const rows: any = dataTable.hashes();
  for (const row of rows) {
    await timetablePage.lineTextToEqual(row.location, row.lineCode);
  }
});


Then(/^the path code for the To Location matches the line code for the From Location$/, async (dataTable) => {
  const rows: any = dataTable.hashes();
  for (const row of rows) {
    await timetablePage.pathTextToEqual(row.toLocation, row.lineCode);
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
