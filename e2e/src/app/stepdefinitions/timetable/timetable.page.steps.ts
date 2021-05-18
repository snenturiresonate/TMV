import {Given, Then, When} from 'cucumber';
import {expect} from 'chai';
import {TimeTablePageObject} from '../../pages/timetable/timetable.page';
import {Locale} from '@js-joda/locale_en';
import {ChronoUnit, DateTimeFormatter, Duration, LocalDate, LocalDateTime, LocalTime, OffsetDateTime} from '@js-joda/core';
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
import {CommonActions} from '../../pages/common/ui-event-handlers/actionsAndWaits';
import {AppPage} from '../../pages/app.po';
import {browser, by, element, ElementFinder, ExpectedConditions} from 'protractor';
import {ReplayScenario} from '../../utils/replay/replay-scenario';
import {TestData} from '../../logging/test-data';
import {TrainJourneyModificationMessage} from '../../utils/train-journey-modifications/train-journey-modification-message';
import {TRITrainLocationReport} from '../../utils/train-running-information/train-location-report';
import {ProjectDirectoryUtil} from '../../utils/project-directory.util';

const appPage: AppPage = new AppPage();

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
  expect(isTimetableServiceDescriptionVisible, 'Timetable service description is not visible')
    .to.equal(true);
});

Then('the timetable header train description is {string}', async (expectedTrainDescription: string) => {
  const trainDescription: string = await timetablePage.getHeaderTrainDescription();
  expect(trainDescription, 'Timetable header train description is not visible')
    .to.equal(expectedTrainDescription);
});

Then('the timetable header train UID is {string}', async (expectedTrainUID: string) => {
  const trainUID: string = await timetablePage.getHeaderTrainUID();
  expect(trainUID, 'Timetable header train UID is not visible')
    .to.equal(expectedTrainUID);
});

Then('The live timetable tab will be titled {string}', async (expectedTabName: string) => {
  const actualTimetableTabName: string = await timetablePage.getLiveTimetableTabName();

  expect(actualTimetableTabName, `Live timetable tab is not titled ${expectedTabName}`)
    .to.equal(expectedTabName);

});


Then('The values for the header properties are as follows',
  async (headerPropertyValues: any) => {
    const expectedHeaderPropertyValues: any = headerPropertyValues.hashes()[0];
    await CommonActions.waitForElementToBeVisible(timetablePage.headerHeadcode);
    const actualHeaderHeadcode = await timetablePage.headerHeadcode.getText();
    const actualHeaderScheduleType: string = await timetablePage.headerScheduleType.getText();
    const actualHeaderSignal: string = await timetablePage.headerSignal.getText();
    const actualHeaderLastReported: string = await timetablePage.headerLastReported.getText();
    const actualHeaderTrainUid: string = await timetablePage.headerTrainUid.getText();
    const actualHeaderTrustId: string = await timetablePage.headerTrustId.getText();
    const actualHeaderTJM: string = await timetablePage.headerTJM.getText();

    expect(actualHeaderHeadcode, 'Headcode is not as expected')
      .to.equal(expectedHeaderPropertyValues.headCode);
    expect(actualHeaderScheduleType, 'Schedule type is not as expected')
      .to.equal(expectedHeaderPropertyValues.schedType);
    expect(actualHeaderSignal, 'Last Signal is not as expected')
      .to.equal(expectedHeaderPropertyValues.lastSignal);
    expect(actualHeaderLastReported, 'Last Reported is not as expected')
      .to.equal(expectedHeaderPropertyValues.lastReport);
    expect(actualHeaderTrainUid, 'Train UID is not as expected')
      .to.equal(expectedHeaderPropertyValues.trainUid);
    expect(actualHeaderTrustId, 'Trust ID is not as expected')
      .to.equal(expectedHeaderPropertyValues.trustId);
    expect(actualHeaderTJM, 'Last TJM is not as expected')
      .to.equal(expectedHeaderPropertyValues.lastTJM);
  });

Then('the last reported information displayed matches that provided in the TRI message', async () => {
  const expectedTime = TRITrainLocationReport.locationDateTime;
  const actualHeaderLastReported: string = await timetablePage.headerLastReported.getText();
  expect(actualHeaderLastReported, 'Last Reported is not as expected')
    .to.equal(expectedTime);
});

Then('The values for {string} are the following as time passes',
  async (propertyName: string, expectedValues: any) => {
    const expectedVals = expectedValues.split(',', 10).map(item => item.trim());
    for (const val of expectedVals) {
      if (val === 'blank') {
        await timetablePage.waitUntilPropertyValueIs(propertyName, '');
      } else {
        await timetablePage.waitUntilPropertyValueIs(propertyName, val);
      }
    }
  });

When('I switch to the timetable details tab', async () => {
  await timetablePage.openDetailsTab();
});

Then('The timetable service description is visible', async () => {
  const isTimetableServiceDescriptionVisible: boolean = await timetablePage.isTimetableServiceDescriptionVisible();
  expect(isTimetableServiceDescriptionVisible, 'Timetable Service Description is not visible')
    .to.equal(true);
});

Then(/^the headcode in the header row is '(.*)'$/, async (header: string) => {
  const headerHeadcode = await timetablePage.headerHeadcode.getText();
  expect(headerHeadcode, 'Headcode in the header row is not as expected')
    .to.equal(header);
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
      if (found) {
        break;
      }
    }
    expect(found, 'No record with value found in the modifications table')
      .to.equal(true);
  }
});

Then(/^the sent TJMs are in the modifications table$/, async () => {
  for (const expectedRecord of TestData.getTJMs()) {
    const expectedTypeOfModification = getExpectedModificationType(
      expectedRecord.TrainJourneyModification.TrainJourneyModificationIndicator);
    const expectedTime = LocalDateTime
        .parse(expectedRecord.TrainJourneyModificationTime, DateTimeFormatter.ISO_OFFSET_DATE_TIME)
        .format(DateTimeFormatter.ofPattern('dd/MM/yyyy HH:mm').withLocale(Locale.ENGLISH));
    const expectedLocation = (expectedTypeOfModification === 'Change Of Identity') ? '' : tiplocToLocation(expectedRecord
      .TrainJourneyModification
      .LocationModified
      .Location
      .LocationSubsidiaryIdentification
      .LocationSubsidiaryCode);
    const expectedReason = (expectedRecord.ModificationReason === undefined ? '' : expectedRecord.ModificationReason);

    const row: ElementFinder = element(by.xpath(`//tbody[@id='details-modification-tbody']//tr[descendant::td[text()='${expectedTypeOfModification}']][descendant::td[text()='${expectedLocation}']][descendant::td[text()='${expectedTime}']][descendant::td[text()='${expectedReason}']]`));
    await browser.wait(ExpectedConditions.presenceOf(row), 10000);
    expect(await row.isPresent(),
      `No record found in the modifications table with ${expectedTypeOfModification}, ${expectedLocation}, ${expectedTime}, ${expectedReason}`)
      .to.equal(true);
  }
});

Then(/^the sent TJMs in the modifications table are in time order$/, async () => {
  const modificationsTable = await timetablePage.getModificationsTableRows();
  const times = await Promise.all(modificationsTable.map(async (row) => await row.getTime()));
  for (let i = 0; i < (times.length - 1); i++) {
    const dateFormat = 'dd/MM/yyyy HH:mm';
    const rowTime = LocalDateTime.parse(times[i], DateTimeFormatter.ofPattern(dateFormat));
    const nextRowTime = LocalDateTime.parse(times[i + 1], DateTimeFormatter.ofPattern(dateFormat));

    expect(rowTime.isAfter(nextRowTime) || rowTime.isEqual(nextRowTime),
      `Modifications are not in time order. ${times[i]} not after ${times[i + 1]}`)
      .to.equal(true);
  }
});

function tiplocToLocation(tiploc: string): any {
  const csvToJson = require('convert-csv-to-json');
  const locations = csvToJson.fieldDelimiter(',').getJsonFromCsv(`${ProjectDirectoryUtil.testDataFolderPath()}/TMVLocation.csv`);
  return locations.filter(loc => loc.PlanningLocation.trim() === tiploc)[0].locationName.trim();
}

function getExpectedModificationType(trainJourneyModificationIndicator): string {
  switch (trainJourneyModificationIndicator) {
    case '06':
      return 'Change Of Location';
    case '07':
      return 'Change Of Identity';
    case '91':
      return 'Cancellation';
    case '92':
      return 'Cancellation';
    case '94':
      return 'Change Of Origin';
    case '96':
      return 'Reinstatement';
    default:
      return 'Unknown Modification Type';
  }
}

Then(/^there are no records in the modifications table$/, async () => {
  const modificationEntries: boolean = await timetablePage.modification.isPresent();
  expect(modificationEntries, 'Modification entries found when expected there to be none').to.equal(false);
});

Then(/^the last TJM is correct$/, async () => {
  const tjmsSent = TestData.getTJMs();
  await assertLastTJM(tjmsSent[tjmsSent.length - 1]);
});

Then(/^the last TJM is the TJM with the latest time$/, async () => {
  const lastTjmSent = sortTJMsByModificationTime(TestData.getTJMs());
  await assertLastTJM(lastTjmSent[lastTjmSent.length - 1]);
});

function sortTJMsByReceivedDateTime(array): TrainJourneyModificationMessage[] {
  return array.sort((a, b) => {
    const lta: OffsetDateTime = OffsetDateTime.parse(a.MessageHeader.MessageReference.MessageDateTime);
    const ltb: OffsetDateTime = OffsetDateTime.parse(b.MessageHeader.MessageReference.MessageDateTime);
    if (lta.isBefore(ltb)) {
      return -1;
    }
    if (ltb.isBefore(lta)) {
      return 1;
    }
    return 0;
  });
}

function sortTJMsByModificationTime(array): TrainJourneyModificationMessage[] {
  return array.sort((a, b) => {
    const lta: OffsetDateTime = OffsetDateTime.parse(a.TrainJourneyModificationTime);
    const ltb: OffsetDateTime = OffsetDateTime.parse(b.TrainJourneyModificationTime);
    if (lta.isBefore(ltb)) {
      return -1;
    }
    if (ltb.isBefore(lta)) {
      return 1;
    }
    return 0;
  });
}

async function assertLastTJM(tjmMessage: TrainJourneyModificationMessage): Promise<void> {
  const expectedTypeOfModification = getExpectedModificationType(
    tjmMessage.TrainJourneyModification.TrainJourneyModificationIndicator);
  const expectedTime = LocalDateTime
    .parse(tjmMessage.TrainJourneyModificationTime, DateTimeFormatter.ISO_OFFSET_DATE_TIME)
    .format(DateTimeFormatter.ofPattern('dd/MM/yyyy HH:mm').withLocale(Locale.ENGLISH));
  const expectedLocation = (expectedTypeOfModification === 'Change Of Identity') ? '' : tiplocToLocation(tjmMessage
    .TrainJourneyModification
    .LocationModified
    .Location
    .LocationSubsidiaryIdentification
    .LocationSubsidiaryCode);
  const expectedReason = (tjmMessage.ModificationReason === undefined ? '' : tjmMessage.ModificationReason);

  const expectedMessages = new Array();
  expectedMessages.push(expectedTypeOfModification);
  if (Boolean(expectedLocation)) { expectedMessages.push(expectedLocation); }
  if (Boolean(expectedReason)) { expectedMessages.push(expectedReason); }
  expectedMessages.push(expectedTime);
  const expectedLastTjm = expectedMessages.join(', ');
  const errorMessage = `Last TJM is not ${expectedLastTjm}`;
  await browser.wait(ExpectedConditions.textToBePresentInElement(timetablePage.headerTJM, expectedLastTjm), 10000, errorMessage);
  expect(await timetablePage.headerTJM.getText(), errorMessage).to.equal(expectedLastTjm);
}

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
      expect(actualHeaderPropertyLabels[i], `Timetable header does not contain label ${actualHeaderPropertyLabels[i]}`)
        .contains(expectedPropertyValue.property);
    });
  });

Then('The timetable details tab is visible', async () => {
  const isTimetableDetailsTabVisible: boolean = await timetablePage.isTimetableDetailsTabVisible();
  expect(isTimetableDetailsTabVisible, 'Timetable details page is not visible')
    .to.equal(true);
});

Then('The entry {int} of the timetable modifications table contains the following data in each column',
  async (index: number, timetableModificationsDataTable: any) => {
    const expectedTimetableModificationsColValues: any[] = timetableModificationsDataTable.hashes();
    const actualTimetableModificationColValues: string[] = await timetablePage.getTimetableModificationColValues(index);

    expectedTimetableModificationsColValues.forEach((expectedAppName: any, i: number) => {
      expect(actualTimetableModificationColValues[i], `Row ${index} of Modifications table, column ${i} doesn't equal ${expectedAppName.column}`)
        .to.equal(expectedAppName.column);
    });
  });

Then('The entry {int} of the timetable associations table contains the following data in each column',
  async (index: number, timetableAssociationsDataTable: any) => {
    const expectedTimetableAssociationsColValues: any[] = timetableAssociationsDataTable.hashes();
    const actualTimetableAssociationsColValues: string[] = await timetablePage.getTimetableAssociationsColValues(index);

    expectedTimetableAssociationsColValues.forEach((expectedAppName: any, i: number) => {
      expect(actualTimetableAssociationsColValues[i], `Row ${index} of Associations table, column ${i} doesn't equal ${expectedAppName.column}`)
        .to.equal(expectedAppName.column);
    });
  });

Then('The entry of the change en route table contains the following data', async (changeEnRouteDataTable: any) => {
  const expectedChangeEnRouteColValues = changeEnRouteDataTable.hashes();
  const actualChangeEnRouteColValues = await timetablePage.getChangeEnRouteValues();
  expectedChangeEnRouteColValues.forEach((expectedChangeEnRouteColValue: any) => {
    expect(actualChangeEnRouteColValues, `Change en route does not contain ${expectedChangeEnRouteColValue.columnName}`)
      .to.contain(expectedChangeEnRouteColValue.columnName);
  });
});

Then('The timetable entries contains the following data',
  async (timetableEntryDataTable: any) => {
    const expectedTimetableEntryColValues: any[] = timetableEntryDataTable.hashes();
    for (const expectedTimetableEntryCol of expectedTimetableEntryColValues) {
      const actualTimetableEntryColValues: string[] = await timetablePage.getTimetableEntryColValues(expectedTimetableEntryCol.entryId);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.location], 'Timetable entry Location is not correct')
        .to.equal(expectedTimetableEntryCol.location);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.workingArrivalTime],
        'Timetable entry Working Arrival Time is not correct')
        .to.equal(expectedTimetableEntryCol.workingArrivalTime);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.workingDeptTime], 'Timetable entry Working Departure Time is not correct')
        .to.equal(expectedTimetableEntryCol.workingDeptTime);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.publicArrivalTime], 'Timetable entry Public Arrival Time is not correct')
        .to.equal(expectedTimetableEntryCol.publicArrivalTime);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.publicDeptTime], 'Timetable entry Public Departure Time is not correct')
        .to.equal(expectedTimetableEntryCol.publicDeptTime);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.originalAssetCode], 'Timetable entry Original Asset Code is not correct')
        .to.equal(expectedTimetableEntryCol.originalAssetCode);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.originalPathCode], 'Timetable entry Original Path Code is not correct')
        .to.equal(expectedTimetableEntryCol.originalPathCode);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.originalLineCode], 'Timetable entry Original Line Code is not correct')
        .to.equal(expectedTimetableEntryCol.originalLineCode);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.allowances], 'Timetable entry Allowances is not correct')
        .to.equal(expectedTimetableEntryCol.allowances);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.activities], 'Timetable entry Activities is not correct')
        .to.equal(expectedTimetableEntryCol.activities);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.arrivalDateTime], 'Timetable entry Arrival Date Time is not correct')
        .to.equal(expectedTimetableEntryCol.arrivalDateTime);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.deptDateTime], 'Timetable entry Departure Date Time is not correct')
        .to.equal(expectedTimetableEntryCol.deptDateTime);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.assetCode], 'Timetable entry Asset Code is not correct')
        .to.equal(expectedTimetableEntryCol.assetCode);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.pathCode], 'Timetable entry Path Code is not correct')
        .to.equal(expectedTimetableEntryCol.pathCode);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.lineCode], 'Timetable entry Line Code is not correct')
        .to.equal(expectedTimetableEntryCol.lineCode);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.punctuality], 'Timetable entry Punctuality is not correct')
        .to.equal(expectedTimetableEntryCol.punctuality);
    }
  });

Then('The live timetable entries are populated as follows:', async (timetableEntryDataTable: any) => {
  const expectedTimetableEntryColValues: any[] = timetableEntryDataTable.hashes();
  for (const expectedTimetableEntryCol of expectedTimetableEntryColValues) {
    const actualTimetableEntryColValues: string[] = await timetablePage.getTimetableEntryColValues(expectedTimetableEntryCol.location);
    const colIndex = timetableColumnIndexes[expectedTimetableEntryCol.column];
    if (expectedTimetableEntryCol.value === 'actual') {
      expect(actualTimetableEntryColValues[colIndex],
        `${expectedTimetableEntryCol.column} at ${expectedTimetableEntryCol.location} showing predicted time when should be actual`)
        .to.not.contain('[');
      expect(actualTimetableEntryColValues[colIndex],
        `${expectedTimetableEntryCol.column} at ${expectedTimetableEntryCol.location} showing predicted time when should be actual`)
        .to.not.contain(']');
    }
    if (expectedTimetableEntryCol.value === 'predicted') {
      expect(actualTimetableEntryColValues[colIndex],
        `${expectedTimetableEntryCol.column} at ${expectedTimetableEntryCol.location} showing actual time when should be predicted`)
        .to.contain('[');
      expect(actualTimetableEntryColValues[colIndex],
        `${expectedTimetableEntryCol.column} at ${expectedTimetableEntryCol.location} showing actual time when should be predicted`)
        .to.contain(']');
    }
    if (expectedTimetableEntryCol.value === 'absent') {
      expect(actualTimetableEntryColValues[colIndex],
        `${expectedTimetableEntryCol.column} at ${expectedTimetableEntryCol.location} showing time when should be nothing`)
        .to.equal('');
      expect(actualTimetableEntryColValues[colIndex],
        `${expectedTimetableEntryCol.column} at ${expectedTimetableEntryCol.location} showing time when should be nothing`)
        .to.equal('');
    } else {
      expect(actualTimetableEntryColValues[colIndex],
        `${expectedTimetableEntryCol.column} at ${expectedTimetableEntryCol.location} not as expected`)
        .to.equal(expectedTimetableEntryCol.value);
    }
  }
});

Then('The timetable entries contains the following data, with timings having {word} offset from {string} at {string}', {timeout: 2 * 20000},
  async (liveOrRecorded: string, referenceScenario: string, referenceTime: string, timetableEntryDataTable: any) => {
    let offsetMs = 0;
    if (liveOrRecorded === 'live') {
      offsetMs = browser.timeAdjustMs;
    } else if (liveOrRecorded === 'recorded') {
      const replayScenario: ReplayScenario = new ReplayScenario(referenceScenario);
      offsetMs = calculateOriginalTimeAdjustment(replayScenario.startTime, referenceTime);
    }
    const expectedTimetableEntryColValues: any[] = timetableEntryDataTable.hashes();
    for (const expectedTimetableEntryCol of expectedTimetableEntryColValues) {
      const actualTimetableEntryColValues: string[] = await timetablePage.getTimetableEntryValsForLoc(expectedTimetableEntryCol.location);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.location],
        `${expectedTimetableEntryCol.location} entry not present`).to.equal(expectedTimetableEntryCol.location);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.workingArrivalTime],
        `workingArrivalTime for ${expectedTimetableEntryCol.location} not as expected`)
        .to.equal(applyTimeAdjustment(expectedTimetableEntryCol.workingArrivalTime, offsetMs));
      expect(actualTimetableEntryColValues[timetableColumnIndexes.workingDeptTime],
        `workingDeptTime for ${expectedTimetableEntryCol.location} not as expected`)
        .to.equal(applyTimeAdjustment(expectedTimetableEntryCol.workingDeptTime, offsetMs));
      expect(actualTimetableEntryColValues[timetableColumnIndexes.publicArrivalTime],
        `publicArrivalTime for ${expectedTimetableEntryCol.location} not as expected`)
        .to.equal(applyTimeAdjustment(expectedTimetableEntryCol.publicArrivalTime, offsetMs));
      expect(actualTimetableEntryColValues[timetableColumnIndexes.publicDeptTime],
        `publicDeptTime for ${expectedTimetableEntryCol.location} not as expected`)
        .to.equal(applyTimeAdjustment(expectedTimetableEntryCol.publicDeptTime, offsetMs));
      expect(actualTimetableEntryColValues[timetableColumnIndexes.originalAssetCode],
        `Platform for ${expectedTimetableEntryCol.location} not as expected`).to.equal(expectedTimetableEntryCol.originalAssetCode);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.originalPathCode],
        `pathCode for ${expectedTimetableEntryCol.location} not as expected`).to.equal(expectedTimetableEntryCol.originalPathCode);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.originalLineCode],
        `lineCode for ${expectedTimetableEntryCol.location} not as expected`).to.equal(expectedTimetableEntryCol.originalLineCode);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.allowances],
        `allowances for ${expectedTimetableEntryCol.location} not as expected`).to.equal(expectedTimetableEntryCol.allowances);
      expect(actualTimetableEntryColValues[timetableColumnIndexes.activities],
        `activities for ${expectedTimetableEntryCol.location} not as expected`).to.equal(expectedTimetableEntryCol.activities);
    }
  });

Then('the navbar punctuality indicator is displayed as {string}', async (expectedColor: string) => {
  const actualColorHex: string = await timetablePage.getNavBarIndicatorColorHex();
  const expectedColourHex = punctualityColourHex[expectedColor];
  expect(actualColorHex, 'Punctuality indicator is not the correct colour')
    .to.equal(expectedColourHex);
});

Then('the punctuality is displayed as {string}', async (expectedText: string) => {
  const actualText: string = await timetablePage.getNavBarIndicatorText();
  expect(actualText, 'Punctuality value is not correct')
    .to.equal(expectedText);
});

Then('The timetable details table contains the following data in each row', async (detailsDataTable: any) => {
  const expectedDetailsRowValues: any = detailsDataTable.hashes()[0];

  expect(await timetablePage.getTimetableDetailsRowValueDaysRun(), 'Timetable Details entry Days Run is not correct')
    .to.equal(expectedDetailsRowValues.daysRun);
  expect(await timetablePage.getTimetableDetailsRowValueRuns(), 'Timetable Details entry Runs is not correct')
    .to.equal(expectedDetailsRowValues.runs);
  expect(await timetablePage.getTimetableDetailsRowValueBankHoliday(), 'Timetable Details entry Bank Holiday is not correct')
    .to.equal(expectedDetailsRowValues.bankHoliday);
  expect(await timetablePage.getTimetableDetailsRowValueBerthId(), 'Timetable Details entry Berth ID is not correct')
    .to.equal(expectedDetailsRowValues.berthId);
  expect(await timetablePage.getTimetableDetailsRowValueOperator(), 'Timetable Details entry Operator is not correct')
    .to.equal(expectedDetailsRowValues.operator);
  expect(await timetablePage.getTimetableDetailsRowValueTrainServiceCode(), 'Timetable Details entry Train Service Code is not correct')
    .to.equal(expectedDetailsRowValues.trainServiceCode);
  expect(await timetablePage.getTimetableDetailsRowValueTrainCategory(), 'Timetable Details entry Train Category is not correct')
    .to.equal(expectedDetailsRowValues.trainCategory);
  expect(await timetablePage.getTimetableDetailsRowValueDirection(), 'Timetable Details entry Direction is not correct')
    .to.equal(expectedDetailsRowValues.direction);
  expect(await timetablePage.getTimetableDetailsRowValueCateringCode(), 'Timetable Details entry Catering Code is not correct')
    .to.equal(expectedDetailsRowValues.cateringCode);
  expect(await timetablePage.getTimetableDetailsRowValueClass(), 'Timetable Details entry Class is not correct')
    .to.equal(expectedDetailsRowValues.class);
  expect(await timetablePage.getTimetableDetailsRowValueReservations(), 'Timetable Details entry Reservations is not correct')
    .to.equal(expectedDetailsRowValues.reservations);
  expect(await timetablePage.getTimetableDetailsRowValueTimingLoad(), 'Timetable Details entry Timing Load is not correct')
    .to.equal(expectedDetailsRowValues.timingLoad);
  expect(await timetablePage.getTimetableDetailsRowValuePowerType(), 'Timetable Details entry Power Type is not correct')
    .to.equal(expectedDetailsRowValues.powerType);
  expect(await timetablePage.getTimetableDetailsRowValueSpeed(), 'Timetable Details entry Speed is not correct')
    .to.equal(expectedDetailsRowValues.speed);
  expect(await timetablePage.getTimetableDetailsRowValuePortionId(), 'Timetable Details entry Portion ID is not correct')
    .to.equal(expectedDetailsRowValues.portionId);
  expect(await timetablePage.getTimetableDetailsRowValueTrainLength(), 'Timetable Details entry Train Length is not correct')
    .to.equal(expectedDetailsRowValues.trainLength);
  expect(await timetablePage.getTimetableDetailsRowValueTrainOperatingCharacteristcs(), 'Timetable Details entry Operating Characteristics is not correct')
    .to.equal(expectedDetailsRowValues.trainOperatingCharacteristcs);
  expect(await timetablePage.getTimetableDetailsRowValueServiceBranding(), 'Timetable Details entry Service Branding is not correct')
    .to.equal(expectedDetailsRowValues.serviceBranding);
});

When('I am on the timetable view for service {string}', {timeout: 40 * 1000}, async (service: string) => {
  await appPage.navigateTo(`/tmv/live-timetable/${service}:${LocalDate.now().format(DateTimeFormatter.ofPattern('yyyy-MM-dd'))}`);
  await browser.wait(ExpectedConditions.presenceOf(timetablePage.timetableTab), 20000, 'Timetable page loading timed out');
});

When(/^the Inserted toggle is '(on|off)'$/, async (state: string) => {
  await timetablePage.toggleInserted(state);
});

Then(/^no inserted locations are displayed$/, async () => {
  const locations = await timetablePage.getLocations();
  for (const location of locations) {
    expect(location, 'Expect no additional locations. found ' + location)
      .not.to.contain('[');
    expect(location, 'Expect no additional locations. found ' + location)
      .not.to.contain(']');
  }
});

Then('the inserted location {string} is displayed in square brackets', async (location: string) => {
  const locations = await timetablePage.getLocations()
    .then(allLocations => allLocations.filter(loc => loc.includes(location)));
  expect(locations, 'Inserted location not wrapped in square brackets')
    .to.contain('[' + location + ']');
});

Then(/^the inserted location (.*) is (before|after) (.*)$/,
  async (insertedLocation: string, beforeAfter: string, otherLocation: string) => {
    const locations = await timetablePage.getLocations();
    const rowOfInserted = await timetablePage.getLocationRowIndex(timetablePage.ensureInsertedLocationFormat(insertedLocation), 1);
    (beforeAfter === 'before') ?
      expect(locations[rowOfInserted + 1], `Inserted location ${insertedLocation} is not ${beforeAfter} ${otherLocation}`)
        .to.equal(otherLocation) :
      expect(locations[rowOfInserted - 1], `Inserted location ${insertedLocation} is not ${beforeAfter} ${otherLocation}`)
        .to.equal(otherLocation);
  });

Then(/^the expected arrival time for inserted location (.*) is (.*) percent between (.*) and (.*)$/, async (
  location: string, percentage: number, departure: string, arrival: string) => {
  const startingDepartureTime = LocalTime.parse(departure);
  const destinationArrivalTime = LocalTime.parse(arrival);
  const difference = Duration.between(startingDepartureTime, destinationArrivalTime).seconds();
  const expectedArrivalTime = startingDepartureTime.plusSeconds(difference * (percentage / 1000));
  const row = await timetablePage.getRowByLocation(timetablePage.ensureInsertedLocationFormat(location), 1);
  const actual = await row.plannedArr.getText();
  expect(actual, 'Expected arrival time of inserted location is not correct')
    .to.equal(expectedArrivalTime.toString());
});

Then('the actual {string} time displayed for that location {string} matches that provided in the TRI message', async (
  location: string, expected: string) => {
  const expectedTime = TRITrainLocationReport.locationDateTime;
  const row = await timetablePage.getRowByLocation(location, 1);

  if (expected.toUpperCase() === 'ARRIVAL') {
    const actualArrivalTime = await row.actualArr.getText();
    expect(actualArrivalTime, 'Expected arrival time of inserted location is not correct')
      .to.equal(expectedTime.toString());
  }

  if (expected.toUpperCase() === 'DEPARTURE') {
    const actualDepartureTime = await row.actualDep.getText();
    expect(actualDepartureTime, 'Expected arrival time of inserted location is not correct')
      .to.equal(expectedTime.toString());
  }
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

Given('I see todays schedule for {string} has loaded by looking at the timetable page', async (scheduleId: string) => {
  await appPage.navigateTo(`/tmv/live-timetable/${scheduleId}:`
    + LocalDate.now().format(DateTimeFormatter.ofPattern('yyyy-MM-dd')));
  await CommonActions.waitForElementToBeVisible(timetablePage.headerHeadcode);
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
    .withLocation(new LocationBuilder().withTiploc('PADTON').build())
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
  const tomorrow = DateAndTimeUtils.dayOfWeekPlusDays(1);
  schedule.noRunDay(tomorrow, schedule);
});


Given(/^the following basic schedules? (?:is|are) received from LINX$/, async (table: any) => {
  const messages: any = table.hashes();
  for (const message of messages) {
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
    await CucumberLog.addJson(accessPlan);
    const response = await new LinxRestClient().writeAccessPlan(accessPlan);
    expect(response.statusCode, `Error whilst writing access plan: ${response.statusCode}`).to.equal(200);
  }
});

function applyTimeAdjustment(colonSeparatedTimeStringHhMmSs: string, adjustmentMs: number): string {
  if ((colonSeparatedTimeStringHhMmSs === '') || (colonSeparatedTimeStringHhMmSs === '00:00:00') || adjustmentMs === 0) {
    return colonSeparatedTimeStringHhMmSs;
  }
  return LocalTime.parse(colonSeparatedTimeStringHhMmSs).plusNanos(adjustmentMs * 1000000)
    .format(DateTimeFormatter.ofPattern('HH:mm:ss'));
}

function calculateOriginalTimeAdjustment(scenarioStart: string, originalTime: string): number {
  return LocalTime.parse(scenarioStart).until(LocalTime.parse(originalTime), ChronoUnit.MILLIS);
}

Then(/^the actual\/predicted (Arrival|Departure) time for location "(.*)" instance (.*) is correctly calculated based on "(.*)"$/,
  async (arrivalOrDeparture, location, instance, expected) => {
    await timetablePage.getRowByLocation(location, instance).then(async row => {
      let field;
      if (arrivalOrDeparture === 'Arrival') {
        field = row.actualArr;
      } else {
        field = row.actualDep;
      }
      expected = `${actualsTimeRounding(expected, arrivalOrDeparture)} c`;
      expect(await field.getText(), `Actual ${arrivalOrDeparture} not correct for location ${location}`).to.equal(expected);
    });
  });

function actualsTimeRounding(timestamp: string, arrivalOrDeparture: string): string {
  let ltTimestamp = LocalTime.parse(timestamp);
  if (arrivalOrDeparture === 'Arrival') {
    ltTimestamp = ltTimestamp.second() < 30 ? ltTimestamp.withSecond(30) : ltTimestamp.plusMinutes(1).withSecond(0);
  } else {
    ltTimestamp = ltTimestamp.second() < 30 ? ltTimestamp.withSecond(0) : ltTimestamp.withSecond(30);
  }
  return ltTimestamp.format(DateTimeFormatter.ofPattern('HH:mm:ss'));
}

Then(/^the actual\/predicted (Arrival|Departure) time for location "(.*)" instance (.*) is predicted$/,
  async (arrivalOrDeparture, location, instance) => {
    await timetablePage.getRowByLocation(location, instance).then(async row => {
      let field;
      if (arrivalOrDeparture === 'Arrival') {
        field = row.actualArr;
      } else {
        field = row.actualDep;
      }
      const text = await field.getText();
      expect(/\(.*\)/.test(text), `expected ${location} ${arrivalOrDeparture} time to be predicted, but was ${text}`).to.equal(true);
    });
  });

function getExpectedPunctuality(arrival, actualTime, expectedTime): string {
  const minutes = ChronoUnit.MINUTES.between(LocalTime.parse(expectedTime), LocalTime.parse(actualTime));
  let seconds = ChronoUnit.SECONDS.between(LocalTime.parse(expectedTime), LocalTime.parse(actualTime));
  const isLate = (seconds >= 0);
  if (arrival) {
    // round up nearest 30s
    seconds = Math.ceil(seconds / 30) * 30;
  } else {
    // round down nearest 30s
    seconds = Math.floor(seconds / 30) * 30;
  }
  const plusMinus = (isLate) ? `+` : `-`;
  return (Math.abs(seconds) % 60 === 0) ? `${plusMinus}${Math.abs(minutes)}m` : `${plusMinus}${Math.abs(minutes)}m ${Math.abs(seconds % 60)}s`;
}

Then(/^the (Arrival|Departure) punctuality for location "(.*)" instance (\d+) is correctly calculated based on expected time "(.*)" & actual time "(.*)"$/,
  async (arrivalDeparture, location, instance, expectedTime, actualTime) => {
    await timetablePage.getRowByLocation(location, instance).then(async row => {
      const field = row.punctuality;
      const expectedPunctuality = getExpectedPunctuality(arrivalDeparture === 'Arrival', actualTime, expectedTime);
      expect(await field.getText(), `Actual punctuality not correct for location ${location}`).to.equal(expectedPunctuality);
    });
  });
