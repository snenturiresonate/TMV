import {Given, Then, When} from 'cucumber';
import {assert, expect} from 'chai';
import {TimeTablePageObject} from '../../pages/timetable/timetable.page';
import {Locale} from '@js-joda/locale_en';
import {
  ChronoUnit,
  DateTimeFormatter,
  Duration,
  LocalDate,
  LocalDateTime,
  LocalTime,
  OffsetDateTime,
} from '@js-joda/core';
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
import {SenderReferenceCalculator} from '../../utils/sender-reference-calculator';
import {TimetableTableRowPageObject} from '../../pages/sections/timetable.tablerow.page';

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
  blue: '#0000ff',
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
  expect(trainUID, 'Timetable header train UID was not as expected')
    .to.equal(expectedTrainUID);
});

Then('The live timetable tab will be titled {string}', async (expectedTabName: string) => {
  const actualTimetableTabName: string = await timetablePage.getLiveTimetableTabName();

  expect(actualTimetableTabName, `Live timetable tab is not titled ${expectedTabName}`)
    .to.equal(expectedTabName);

});

When('I wait for the last Signal to populate', async () => {
  return browser.wait(async () => {
    try {
      {
        if (await timetablePage.headerSignal.getText() !== '') {
          return true;
        }
      }
      return false;
    } catch (error) {
      return false;
    }
  }, browser.params.general_timeout, 'Last Signal not populated');
});

When('I wait for the last Signal to be {string}', async (sigName) => {
  return browser.wait(async () => {
    try {
      {
        if (await timetablePage.headerSignal.getText() !== 'sigName') {
          return true;
        }
      }
      return false;
    } catch (error) {
      return false;
    }
  }, browser.params.general_timeout, `Last Signal was not ${sigName}`);
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
    let expectedUid = expectedHeaderPropertyValues.trainUid;
    let expectedTrainDescription = expectedHeaderPropertyValues.headCode;
    const expectedTJM = expectedHeaderPropertyValues.lastTJM;
    if (expectedUid === 'generatedTrainUId' || expectedUid === 'generated') {
      expectedUid = browser.referenceTrainUid;
    }
    if (expectedTrainDescription.includes('generated')) {
      expectedTrainDescription = browser.referenceTrainDescription;
    }
    expectedTJM.replace('today', DateAndTimeUtils.getCurrentDateTimeString('dd-MM-yyyy'));

    expect(actualHeaderHeadcode, 'Headcode is not as expected')
      .to.equal(expectedTrainDescription);
    expect(actualHeaderScheduleType, 'Schedule type is not as expected')
      .to.equal(expectedHeaderPropertyValues.schedType);
    expect(actualHeaderSignal, 'Last Signal is not as expected')
      .to.equal(expectedHeaderPropertyValues.lastSignal);
    expect(actualHeaderLastReported, 'Last Reported is not as expected')
      .to.equal(expectedHeaderPropertyValues.lastReport);
    expect(actualHeaderTrainUid, 'Train UID is not as expected')
      .to.equal(expectedUid);
    expect(actualHeaderTrustId, 'Trust ID is not as expected')
      .to.equal(expectedHeaderPropertyValues.trustId);
    expect(actualHeaderTJM, 'Last TJM is not as expected')
      .to.equal(expectedHeaderPropertyValues.lastTJM);
  });

Then('the last reported information reflects the TRI message {string} for {string}',
  async (message: string, locName: string) => {
    const expectedTime = OffsetDateTime
      .parse(TRITrainLocationReport.locationDateTime)
      .format(DateTimeFormatter.ofPattern('HH:mm'));
    await timetablePage.waitUntilLastReportLocNameHasLoaded(locName);
    const actualHeaderLastReported: string = await timetablePage.headerLastReported.getText();
    expect(actualHeaderLastReported, 'Last Reported is not as expected')
      .to.equal(expectedTime + ' ' + message);
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

Then(/^the current headcode in the header row is '(.*)'$/, async (header: string) => {
  const headerHeadcode = await timetablePage.headerHeadcode.getText();
  expect(headerHeadcode, 'Current Headcode in the header row is not as expected')
    .to.equal(header);
});

Then(/^the old headcode in the header row is '(.*)'$/, async (header: string) => {
  const headerHeadcode = await timetablePage.headerOldHeadcode.getText();
  expect(headerHeadcode, 'Old Headcode in the header row is not as expected')
    .to.equal(header);
});

Then(/^there is a record in the modifications table$/, async (table: any) => {
  const modificationsTable = await timetablePage.getModificationsTableRows();
  const expectedRecords = table.hashes();
  for (const expectedRecord of expectedRecords) {
    let found = false;
    let modification = '';
    let modLocation = '';
    let modTime = '';
    let modType = '';
    for (const row of modificationsTable) {
      modification = await row.getTypeOfModification();
      modLocation = await row.getLocation();
      modTime = await row.getTime();
      modTime = modTime.replace('today', DateAndTimeUtils.getCurrentDateTimeString('dd-MM-yyyy'));
      modType = await row.getModificationReason();
      found = ((modification === expectedRecord.description)
        && (modLocation === expectedRecord.location)
        && (modTime === expectedRecord.time)
        && (modType === expectedRecord.type));
      if (found) {
        break;
      }
    }
    expect(found, `Record found in modifications table was ${modification} at ${modLocation} ${modTime} type ${modType} instead of
    ${expectedRecord.description} at ${expectedRecord.location} ${expectedRecord.time} type ${expectedRecord.type}`)
      .to.equal(true);
  }
});

Then(/^the sent TJMs are in the modifications table$/, async () => {
  const scheduleID = (await browser.getCurrentUrl()).split('/').pop();
  const plannedDate = LocalDate.parse(scheduleID.split(':')[1]);

  const filteredTJMs = TestData.getTJMs().filter(tjm => {
    return LocalDate.parse(SenderReferenceCalculator.reverseSenderReference(tjm.MessageHeader.SenderReference).date).equals(plannedDate);
  });
  for (const expectedRecord of filteredTJMs) {
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
    await browser.wait(ExpectedConditions.presenceOf(row), 30000, `No record found in the modifications table with ${expectedTypeOfModification}, ${expectedLocation}, ${expectedTime}, ${expectedReason}`);
  }
});

Then(/^the sent TJMs in the modifications table are in time order$/, async () => {
  const modificationsTable = await timetablePage.getModificationsTableRows();
  const times = await Promise.all(modificationsTable.map(async (row) => row.getTime()));
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

  const expectedMessages = [];
  expectedMessages.push(expectedTypeOfModification);
  if (Boolean(expectedLocation)) {
    expectedMessages.push(expectedLocation);
  }
  if (Boolean(expectedReason)) {
    expectedMessages.push(expectedReason);
  }
  expectedMessages.push(expectedTime);
  const expectedLastTjm = expectedMessages.join(', ');
  const errorMessage = `Last TJM is not ${expectedLastTjm}`;
  await browser.wait(ExpectedConditions.textToBePresentInElement(timetablePage.headerTJM, expectedLastTjm), 10000, errorMessage);
  expect(await timetablePage.headerTJM.getText(), errorMessage).to.equal(expectedLastTjm);
}

When('I toggle the inserted locations on and wait for them to be displayed', async () => {
  await timetablePage.toggleInsertedLocationsOn();

  // wait until the inserted locations are visible
  await browser.wait(async () => {
      let insertedVisible = false;
      const locations = await timetablePage.getLocations();
      locations.forEach(location => {
        if (location.includes('[') && location.includes(']')) {
          insertedVisible = true;
        }
      });
      return insertedVisible;
    },
    30000, 'Waiting for square brackets');
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

Then('The timetable associations table contains the following entries',
  async (timetableAssociationsDataTable: any) => {
    const expectedTimetableAssociationsColValues: any[] = timetableAssociationsDataTable.hashes();
    const actualTimetableAssociationsColValues: string[][] = await timetablePage.getAssociationEntries();
    let found = false;
    const numActualAssocs = actualTimetableAssociationsColValues.length;
    let i = 0;

    for (const expectedTimetableAssociation of expectedTimetableAssociationsColValues) {
      i = 0;
      while (i < numActualAssocs && !found) {
        found = ((actualTimetableAssociationsColValues[i][0] === expectedTimetableAssociation.location)
          && (actualTimetableAssociationsColValues[i][1] === expectedTimetableAssociation.type)
          && (actualTimetableAssociationsColValues[i][2] === expectedTimetableAssociation.trainDescription));
        i++;
      }
      expect(found, `Associations table doesn't contain ${expectedTimetableAssociation.type}
          association with ${expectedTimetableAssociation.trainDescription} at ${expectedTimetableAssociation.location}`).to.equal(true);
    }
  });

Then('The entry of the change en route table contains the following data', async (changeEnRouteDataTable: any) => {
  const expectedChangeEnRouteColValues = changeEnRouteDataTable.hashes();
  const actualChangeEnRouteColValues = await timetablePage.getChangeEnRouteValues();
  expectedChangeEnRouteColValues.forEach((expectedChangeEnRouteColValue: any) => {
    expect(actualChangeEnRouteColValues, `Change en route does not contain ${expectedChangeEnRouteColValue.columnName}`)
      .to.contain(expectedChangeEnRouteColValue.columnName);
  });
});

Then(/^the actual\/predicted values are$/, {timeout: 5 * 60 * 1000}, async (dataTable: any) => {
  await browser.sleep(2000);
  const expectedValues: any[] = dataTable.hashes();
  let index = 0;
  for (const value of expectedValues) {
    const row = (await timetablePage.getTableRows())[index++];
    await row.refreshRowLocator();
    expect(await row.getValue('actualArr'), 'Actual arrival not as expected').to.equal(value.arrival);
    expect(await row.getValue('actualDep'), 'Actual departure not as expected').to.equal(value.departure);
    expect(await row.getValue('actualPlt'), 'Actual platform not as expected').to.equal(value.platform);
    expect(await row.getValue('actualPath'), 'Actual path not as expected').to.equal(value.path);
    expect(await row.getValue('actualLn'), 'Actual line not as expected').to.equal(value.line);
  }
});

Then('The timetable entries contains the following data',
  async (timetableEntryDataTable: any) => {
    const expectedTimetableEntryColValues: any[] = timetableEntryDataTable.hashes();
    const actualTimetableEntries = await timetablePage.getTableEntries();
    for (const expectedTimetableEntryCol of expectedTimetableEntryColValues) {
      expect(actualTimetableEntries[expectedTimetableEntryCol.rowNum - 1][0], 'Timetable entry Location is not correct')
        .to.equal(expectedTimetableEntryCol.location);
      expect(actualTimetableEntries[expectedTimetableEntryCol.rowNum - 1][1], 'Timetable entry Working Arrival Time is not correct')
        .to.equal(expectedTimetableEntryCol.workingArrivalTime);
      expect(actualTimetableEntries[expectedTimetableEntryCol.rowNum - 1][2], 'Timetable entry Working Departure Time is not correct')
        .to.equal(expectedTimetableEntryCol.workingDeptTime);
      expect(actualTimetableEntries[expectedTimetableEntryCol.rowNum - 1][3], 'Timetable entry Public Arrival Time is not correct')
        .to.equal(expectedTimetableEntryCol.publicArrivalTime);
      expect(actualTimetableEntries[expectedTimetableEntryCol.rowNum - 1][4], 'Timetable entry Public Departure Time is not correct')
        .to.equal(expectedTimetableEntryCol.publicDeptTime);
      expect(actualTimetableEntries[expectedTimetableEntryCol.rowNum - 1][5], 'Timetable entry Original Asset Code is not correct')
        .to.equal(expectedTimetableEntryCol.originalAssetCode);
      expect(actualTimetableEntries[expectedTimetableEntryCol.rowNum - 1][6], 'Timetable entry Original Path Code is not correct')
        .to.equal(expectedTimetableEntryCol.originalPathCode);
      expect(actualTimetableEntries[expectedTimetableEntryCol.rowNum - 1][7], 'Timetable entry Original Line Code is not correct')
        .to.equal(expectedTimetableEntryCol.originalLineCode);
      expect(actualTimetableEntries[expectedTimetableEntryCol.rowNum - 1][8], 'Timetable entry Allowances is not correct')
        .to.equal(expectedTimetableEntryCol.allowances);
      expect(actualTimetableEntries[expectedTimetableEntryCol.rowNum - 1][9], 'Timetable entry Activities is not correct')
        .to.equal(expectedTimetableEntryCol.activities);
      expect(actualTimetableEntries[expectedTimetableEntryCol.rowNum - 1][10], 'Timetable entry Arrival Date Time is not correct')
        .to.equal(expectedTimetableEntryCol.arrivalDateTime);
      expect(actualTimetableEntries[expectedTimetableEntryCol.rowNum - 1][11], 'Timetable entry Departure Date Time is not correct')
        .to.equal(expectedTimetableEntryCol.deptDateTime);
      expect(actualTimetableEntries[expectedTimetableEntryCol.rowNum - 1][12], 'Timetable entry Asset Code is not correct')
        .to.equal(expectedTimetableEntryCol.assetCode);
      expect(actualTimetableEntries[expectedTimetableEntryCol.rowNum - 1][13], 'Timetable entry Path Code is not correct')
        .to.equal(expectedTimetableEntryCol.pathCode);
      expect(actualTimetableEntries[expectedTimetableEntryCol.rowNum - 1][14], 'Timetable entry Line Code is not correct')
        .to.equal(expectedTimetableEntryCol.lineCode);
      expect(actualTimetableEntries[expectedTimetableEntryCol.rowNum - 1][15], 'Timetable entry Punctuality is not correct')
        .to.equal(expectedTimetableEntryCol.punctuality);
    }
  });

Then('The live timetable actual time entries are populated as follows:', async (timetableEntryDataTable: any) => {
  const expectedTimetableEntryColValues: any[] = timetableEntryDataTable.hashes();

  const timetableRowPromises = [];
  for (const expectedTimetableEntryCol of expectedTimetableEntryColValues) {
    timetableRowPromises.push(timetablePage.getRowByLocation(expectedTimetableEntryCol.location, expectedTimetableEntryCol.instance));
  }
  const timetableRows = await Promise.all(timetableRowPromises);

  for (const expectedTimetableEntryCol of expectedTimetableEntryColValues) {
    const possibleRows = timetableRows.filter(async possibleRow => {
      return (await possibleRow.location.getText() === expectedTimetableEntryCol.location);
    });
    expect(possibleRows.length, `Did not find the correct instances of ${expectedTimetableEntryCol.location}`)
      .to.be.greaterThan(expectedTimetableEntryCol.instance - 1);
    const row = possibleRows[expectedTimetableEntryCol.instance - 1];

    let actualTimetableEntryElement;
    let actualTimetableEntryElementValue = 'UNKNOWN';
    if (expectedTimetableEntryCol.column === 'actualArr') {
      actualTimetableEntryElement = row.actualArr;
      actualTimetableEntryElementValue = await row.actualArr.getText();
    } else if (expectedTimetableEntryCol.column === 'actualDep') {
      actualTimetableEntryElement = row.actualDep;
      actualTimetableEntryElementValue = await row.actualDep.getText();
    }
    if (expectedTimetableEntryCol.valType === 'predicted') {
      await browser.wait(ExpectedConditions.and(
        ExpectedConditions.textToBePresentInElement(actualTimetableEntryElement, '('),
        ExpectedConditions.textToBePresentInElement(actualTimetableEntryElement, ')')),
        20 * 1000)
        .catch(() => assert.fail(`${expectedTimetableEntryCol.column} is not showing as predicted - there should be brackets`));
    } else if (expectedTimetableEntryCol.valType === 'actual') {
      await browser.wait(ExpectedConditions.and(
        ExpectedConditions.not(ExpectedConditions.textToBePresentInElement(actualTimetableEntryElement, '(')),
        ExpectedConditions.not(ExpectedConditions.textToBePresentInElement(actualTimetableEntryElement, ')'))),
        20 * 1000)
        .catch(() => assert.fail(`${expectedTimetableEntryCol.column} is showing as predicted - there should be no brackets`));
    } else if (expectedTimetableEntryCol.valType === 'absent') {
      expect(actualTimetableEntryElementValue,
        `${expectedTimetableEntryCol.column} at ${expectedTimetableEntryCol.location} showing time when should be nothing`)
        .to.equal('');
    } else {
      expect(actualTimetableEntryElementValue,
        `${expectedTimetableEntryCol.column} at ${expectedTimetableEntryCol.location} not as expected`)
        .to.equal(expectedTimetableEntryCol.value);
    }
  }
});

Then('The timetable entries contains the following data, with timings having {word} offset from {string} at {string}',
  async (liveOrRecorded: string, referenceScenario: string, referenceTime: string, timetableEntryDataTable: any) => {
    let offsetMs = 0;
    if (liveOrRecorded === 'live') {
      offsetMs = browser.timeAdjustMs;
    } else if (liveOrRecorded === 'recorded') {
      const replayScenario: ReplayScenario = new ReplayScenario(referenceScenario);
      offsetMs = calculateOriginalTimeAdjustment(replayScenario.startTime, referenceTime);
    }
    const expectedTimetableEntryColValues: any[] = timetableEntryDataTable.hashes();
    const timetableEntryValuePromises = [];
    for (const expectedTimetableEntryCol of expectedTimetableEntryColValues) {
      timetableEntryValuePromises.push(timetablePage.getTimetableEntryValsForLoc(expectedTimetableEntryCol.location));
    }
    const actualTimetableEntryValues = await Promise.all(timetableEntryValuePromises);

    let actualTimetableRow = [];
    for (const expectedTimetableEntryCol of expectedTimetableEntryColValues) {
      actualTimetableRow = actualTimetableEntryValues.filter(timetableRow => {
        return (timetableRow[timetableColumnIndexes.location] === expectedTimetableEntryCol.location);
      });
      expect(actualTimetableRow.length, `Could not find ${expectedTimetableEntryCol.location}`).to.be.greaterThan(0);
      actualTimetableRow = actualTimetableRow[0];
      if (actualTimetableRow !== undefined) {
        expect(actualTimetableRow[timetableColumnIndexes.location],
          `${expectedTimetableEntryCol.location} entry not present`).to.equal(expectedTimetableEntryCol.location);
        expect(actualTimetableRow[timetableColumnIndexes.workingArrivalTime],
          `adjusted workingArrivalTime for ${expectedTimetableEntryCol.location} not as expected`)
          .to.equal(applyTimeAdjustment(expectedTimetableEntryCol.workingArrivalTime, offsetMs));
        expect(actualTimetableRow[timetableColumnIndexes.workingDeptTime],
          `adjusted workingDeptTime for ${expectedTimetableEntryCol.location} not as expected`)
          .to.equal(applyTimeAdjustment(expectedTimetableEntryCol.workingDeptTime, offsetMs));
        expect(actualTimetableRow[timetableColumnIndexes.publicArrivalTime],
          `adjusted publicArrivalTime for ${expectedTimetableEntryCol.location} not as expected`)
          .to.equal(applyTimeAdjustment(expectedTimetableEntryCol.publicArrivalTime, offsetMs));
        expect(actualTimetableRow[timetableColumnIndexes.publicDeptTime],
          `adjusted publicDeptTime for ${expectedTimetableEntryCol.location} not as expected`)
          .to.equal(applyTimeAdjustment(expectedTimetableEntryCol.publicDeptTime, offsetMs));
        expect(actualTimetableRow[timetableColumnIndexes.originalAssetCode],
          `Platform for ${expectedTimetableEntryCol.location} not as expected`).to.equal(expectedTimetableEntryCol.originalAssetCode);
        expect(actualTimetableRow[timetableColumnIndexes.originalPathCode],
          `pathCode for ${expectedTimetableEntryCol.location} not as expected`).to.equal(expectedTimetableEntryCol.originalPathCode);
        expect(actualTimetableRow[timetableColumnIndexes.originalLineCode],
          `lineCode for ${expectedTimetableEntryCol.location} not as expected`).to.equal(expectedTimetableEntryCol.originalLineCode);
        expect(actualTimetableRow[timetableColumnIndexes.allowances],
          `allowances for ${expectedTimetableEntryCol.location} not as expected`).to.equal(expectedTimetableEntryCol.allowances);
        expect(actualTimetableRow[timetableColumnIndexes.activities],
          `activities for ${expectedTimetableEntryCol.location} not as expected`).to.equal(expectedTimetableEntryCol.activities);
      }
    }
  });

Then('the navbar punctuality indicator is displayed as {string}', async (expectedColor: string) => {
  const actualColorHex: string = await timetablePage.getNavBarIndicatorColorHex();
  const expectedColourHex = punctualityColourHex[expectedColor];
  expect(actualColorHex, 'Punctuality indicator is not the correct colour')
    .to.equal(expectedColourHex);
});

Then('the navbar punctuality indicator is displayed as {string} or {string}', async (expectedColor1: string, expectedColor2: string) => {
  const actualColorHex: string = await timetablePage.getNavBarIndicatorColorHex();
  const expectedColourHex1 = punctualityColourHex[expectedColor1];
  const expectedColourHex2 = punctualityColourHex[expectedColor2];
  expect(actualColorHex, 'Punctuality indicator is not the correct colour')
    .to.be.oneOf([expectedColourHex1, expectedColourHex2]);
});

Then('the punctuality is displayed as {string}', async (expectedText: string) => {
  // long timeout for punctuality recalculation cycle
  await browser.wait(ExpectedConditions.textToBePresentInElement(timetablePage.navBarIndicatorText, expectedText),
    60 * 1000,
    `Punctuality value is not '${expectedText}'`);
});

Then('the punctuality is correct based on {string}', {timeout: 65 * 1000}, async (expectedTime: string) => {
  const expectedPunctuality = () => getExpectedPunctuality(true,
    DateAndTimeUtils.getCurrentTime()
      .plusMinutes(1)
      .format(DateTimeFormatter.ofPattern('HH:mm'))
    , expectedTime);
  // long timeout for punctuality recalculation cycle
  await browser.wait(ExpectedConditions.textToBePresentInElement(timetablePage.navBarIndicatorText, expectedPunctuality()),
    60 * 1000,
    `Punctuality value is not '${expectedPunctuality()}'`);
});

Then('the punctuality increases when the train is not moving', async () => {
  const actualText: string = await timetablePage.getNavBarIndicatorText();
  await browser.wait(async () => {
    const currentText = await timetablePage.navBarIndicatorText.getText();
    return currentText !== actualText;
  }, 65 * 1000, `Punctuality was not updated after 60 seconds as the service incurs lateness, was still '${actualText}'`);
});

Then(/^the punctuality is displayed as one of (.*)$/, async (expectedList: string) => {
  const possibleValues = expectedList.split(',');
  const actualText: string = await timetablePage.getNavBarIndicatorText();
  expect(actualText, 'Punctuality value is not correct')
    .to.be.oneOf(possibleValues);
});

Then('the punctuality for {string} location {string} is displayed as {string}',
  async (locationType: string, location: string, expectedText: string) => {
    const row = await timetablePage.getRowByLocation(timetablePage.ensureInsertedLocationFormat(locationType, location), 1);
    const actualLocPunctuality = await row.getValue('punctuality');
    expect(actualLocPunctuality, 'Punctuality value is not correct')
      .to.equal(expectedText);
  });

Then('The timetable details table contains the following data in each row', async (detailsDataTable: any) => {
  const expectedDetailsRowValues: any = detailsDataTable.hashes()[0];
  const dateString = expectedDetailsRowValues.daysRun.replace
  ('today', DateAndTimeUtils.convertToDesiredDateAndFormat('today', 'dd/MM/yyyy'));
  const daysString = convertDaysStringIfNecessary(expectedDetailsRowValues.runs);
  expect(await timetablePage.getTimetableDetailsRowValueDaysRun(), 'Timetable Details entry Days Run is not correct')
    .to.equal(dateString);
  expect(await timetablePage.getTimetableDetailsRowValueRuns(), 'Timetable Details entry Runs is not correct')
    .to.equal(daysString);
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

When('I am on the timetable view for service {string}', {timeout: browser.params.general_timeout}, async (service: string) => {
  // try for today's service and if not try for tomorrow's
  if (service === 'generatedTrainUId' || service === 'generated') {
    service = browser.referenceTrainUid;
  }
  await browser.wait(async () => {
    await appPage.navigateTo(`/tmv/live-timetable/${service}:${DateAndTimeUtils.getCurrentDateTimeString('yyyy-MM-dd')}`);
    if (await timetablePage.timetableTab.isPresent()) {
      if (await element(TimetableTableRowPageObject.locationBy).isPresent()) {
        return true;
      }
    }
    await appPage.navigateTo(`/tmv/live-timetable/${service}:${DateAndTimeUtils.getCurrentDateTime().plusDays(1).format(DateTimeFormatter.ofPattern('yyyy-MM-dd'))}`);
    return timetablePage.timetableTab.isPresent();
  }, 50000, `Timetable page loading timed out`);
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
  let locations: string[];

  await browser.wait(async () => {
      locations = await timetablePage.getLocations().then(allLocations => allLocations.filter(loc => loc.includes(location)));
      return locations.includes('[' + location + ']');
    },
    30000, 'Waiting for square brackets');

  expect(locations, 'Inserted location not wrapped in square brackets')
    .to.contain('[' + location + ']');
});

Then(/^the inserted location (.*) is (before|after) (.*)$/,
  async (insertedLocation: string, beforeAfter: string, otherLocation: string) => {
    const locations = await timetablePage.getLocations();
    const rowOfInserted = await timetablePage.getLocationRowIndex
    (timetablePage.ensureInsertedLocationFormat('inserted', insertedLocation), 1);
    (beforeAfter === 'before') ?
      expect(locations[rowOfInserted + 1], `Inserted location ${insertedLocation} is not ${beforeAfter} ${otherLocation}`)
        .to.equal(otherLocation) :
      expect(locations[rowOfInserted - 1], `Inserted location ${insertedLocation} is not ${beforeAfter} ${otherLocation}`)
        .to.equal(otherLocation);
  });

Then(/^the expected departure time for inserted location (.*) is proportionally (.*) thousandths between (.*) and (.*)$/, async (
  location: string, propOutOfThousand: number, departure: string, arrival: string) => {
  const startingDepartureTime = LocalTime.parse(departure);
  const destinationArrivalTime = LocalTime.parse(arrival);
  const difference = Duration.between(startingDepartureTime, destinationArrivalTime).seconds();
  const expectedDepartureTime = startingDepartureTime.plusSeconds(difference * (propOutOfThousand / 1000));
  const row = await timetablePage.getRowByLocation(timetablePage.ensureInsertedLocationFormat('inserted', location), 1);
  const actual = await row.getValue('plannedDep');
  expect(actual, 'Expected departure time of inserted location is not correct')
    .to.equal(expectedDepartureTime.toString());
});

Then('the actual {string} time displayed for that location {string} matches that provided in the TRI message', async (
  expected: string, location: string) => {
  const expectedTime = OffsetDateTime
    .parse(TRITrainLocationReport.locationDateTime)
    .format(DateTimeFormatter.ofPattern('HH:mm:ss'));
  const row = await timetablePage.getRowByLocation(location, 1);

  if (expected.toUpperCase() === 'ARRIVAL') {
    const actualArrivalTime = await row.getValue('actualArr');
    expect(actualArrivalTime, 'Expected arrival time of the location is not correct')
      .to.equal(expectedTime.toString());
  }

  if (expected.toUpperCase() === 'DEPARTURE') {
    const actualDepartureTime = await row.getValue('actualDep');
    expect(actualDepartureTime, 'Expected departure time of the location is not correct')
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

Then(/^the actual\/predicted path code is correct$/, {timeout: 5 * 60 * 1000}, async (dataTable) => {
  // Give the timetable time to settle
  await browser.sleep(2000);
  const expectedValues: any = dataTable.hashes();
  for (const value of expectedValues) {
    await timetablePage.getRowByLocation(value.location, value.instance).then(async row => {
      await row.refreshRowLocator();
      expect(await row.getValue('actualPath'), 'Actual path was not correct').to.equal(value.pathCode);
    });
  }
});

Then(/^the actual\/predicted line code is correct$/, {timeout: 5 * 60 * 1000}, async (dataTable) => {
  const expectedValues: any = dataTable.hashes();
  for (const value of expectedValues) {
    await timetablePage.getRowByLocation(value.location, value.instance).then(async row => {
      await row.refreshRowLocator();
      expect(
        await row.getValue('actualLn'),
        `Actual/Predicted path code was not ${value.lineCode}, was ${await row.getValue('actualLn')}`)
        .to.equal(value.lineCode);
    });
  }
});

Then(/^the actual\/predicted platform is correct$/, {timeout: 5 * 60 * 1000}, async (dataTable) => {
  const expectedValues: any = dataTable.hashes();
  for (const value of expectedValues) {
    await timetablePage.getRowByLocation(value.location, value.instance).then(async row => {
      const actualPlatform = await row.getValue('actualPlt');
      expect(
        actualPlatform,
        `Actual/Predicted platform code was not ${value.platform}, was ${actualPlatform}`)
        .to.equal(value.platform);
    });
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
    + DateAndTimeUtils.getCurrentDateTimeString('yyyy-MM-dd'));
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
      .withLine(location.line)
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

Then(/^the actual\/predicted (Arrival|Departure) time for location "(.*)" instance (.*) is correctly calculated based on (Internal|External) timing "(.*)"$/,
  async (arrivalOrDeparture, location, instance, internalExternal, expected) => {
    if (expected == null) {
      expected = '';
    }
    const row = await timetablePage.getRowByLocation(location, instance);
    await row.refreshRowLocator();
    let field;
    if (arrivalOrDeparture === 'Arrival') {
      field = await row.getValue('actualArr');
    } else {
      field = await row.getValue('actualDep');
    }
    if (expected !== '') {
      expected = DateAndTimeUtils.parseTimeEquation(expected, 'HH:mm:ss');
      if (internalExternal === 'Internal') {
        expected = actualsTimeRounding(expected, arrivalOrDeparture);
      }
      const error = `Actual ${arrivalOrDeparture} not correct for location ${location}`;
      expect(
        await DateAndTimeUtils.formulateTime(
          stripBrackets(field).substr(0, 8)), error)
        .to.be.closeToTime(await DateAndTimeUtils.formulateTime(expected), 180);
    }
    else {
      expect(field, `The time was not empty, it was ${field}`).to.equal(expected);
    }
  });

Then(/^the actual\/predicted departure time for location "(.*)" instance (.*) matches the planned departure time$/,
  async (location, instance) => {
    const row = await timetablePage.getRowByLocation(location, instance);
    await row.refreshRowLocator();
    const plannedDeparture = await row.getValue('plannedDep');
    const actualDeparture = await row.getValue('actualDep');
    expect(stripBrackets(actualDeparture),
      `The actual departure ${actualDeparture} did not equal the planned departure ${plannedDeparture}`)
      .to.equal(plannedDeparture);
  });

Then(/^the actual\/predicted departure time for location "(.*)" instance (.*) is \+ (.*) mins after the actual\/predicted arrival time$/,
  async (location, instance, minutes) => {
    const row = await timetablePage.getRowByLocation(location, instance);
    await row.refreshRowLocator();
    const actualArrival = stripBrackets(await row.getValue('actualArr'));
    const actualDeparture = stripBrackets(await row.getValue('actualDep'));

    const arrivalTimeAdjusted: string = (await DateAndTimeUtils
      .addMinsToDateTime((await DateAndTimeUtils.formulateTime(actualArrival)).toString(), minutes))
      .toLocaleTimeString('en-GB', { hour12: false });

    expect(arrivalTimeAdjusted,
      `The act/pred departure ${actualDeparture} was not ${minutes} minutes after the act/pred arrival ${actualArrival}`)
      .to.equal(actualDeparture);
  });

Then(/^the predicted (arrival|departure) time displayed for location "(.*)" instance (.*) is the current punctuality \+ the planned location (?:arrival|departure) time$/,
  async (timingType, location, instance) => {
    const row = await timetablePage.getRowByLocation(location, instance);
    await row.refreshRowLocator();

    let planned: string;
    let predicted: string;
    if (timingType === 'arrival') {
      planned = stripBrackets(await row.getValue('plannedArr'));
      predicted = stripBrackets(await row.getValue('actualArr'));
    }
    else {
      planned = stripBrackets(await row.getValue('plannedDep'));
      predicted = stripBrackets(await row.getValue('actualDep'));
    }
    const punctuality: string = stripBrackets(await row.getValue('punctuality'));
    await CucumberLog.addText(`Planned: ${planned}, Predicted: ${predicted}, Punctuality: ${punctuality}`);

    const punctualityMins: string = punctuality.split(' ')[0].replace('+', '').replace('-', '').replace('m', '');
    let punctualitySecs = '0';
    if (punctuality.split(' ').length > 1) {
      punctualitySecs = punctuality.split(' ')[1].replace('s', '');
    }
    await CucumberLog.addText(`Punct Mins: ${punctualityMins}, Punct Secs: ${punctualitySecs}`);

    const plannedDateTime: Date = await DateAndTimeUtils.formulateTime(planned);
    const predictedDateTime: Date = await DateAndTimeUtils.formulateTime(predicted);

    const errorMessage = `The predicted time: ${predicted} was not the current punctuality: ${punctuality} + the planned time: ${planned}`;
    expect(predictedDateTime, errorMessage)
      .to.be.closeToTime(plannedDateTime, ((parseInt(punctualityMins, 10) * 60) + parseInt(punctualitySecs, 10) + 180));
  });

Then(/^the (Arrival|Departure) time for location "(.*)" instance (.*) is "(.*)"$/,
  async (arrivalOrDeparture, location, instance, expected) => {
    if (expected == null) {
      expected = '';
    }
    if (expected.includes('now')) {
      expected = DateAndTimeUtils.parseTimeEquation(expected, 'HH:mm:ss');
    }
    await timetablePage.getRowByLocation(location, instance).then(async row => {
      let field;
      if (arrivalOrDeparture === 'Arrival') {
        field = await row.getValue('actualArr');
      } else {
        field = await row.getValue('actualDep');
      }
      const error = `${arrivalOrDeparture} not correct for location ${location}`;
      if (expected === '') {
        expect(field, error).to.equal(expected);
      }
      else {
        expect(
          await DateAndTimeUtils.formulateTime(
            stripBrackets(field).substr(0, 8)), error)
          .to.be.closeToTime(await DateAndTimeUtils.formulateTime(expected), 120);
      }
    });
  });


Then(/^the actual\/predicted (Arrival|Departure) time for location "(.*)" instance (.*) is predicted$/,
  {timeout: 5 * 60 * 1000},
  async (arrivalOrDeparture, location, instance) => {
    await timetablePage.getRowByLocation(location, instance).then(async row => {
      await row.refreshRowLocator();
      let text;
      if (arrivalOrDeparture === 'Arrival') {
        text = await row.getValue('actualArr');
      } else {
        text = await row.getValue('actualDep');
      }
      expect(/\(.*\)/.test(text), `expected ${location} ${arrivalOrDeparture} time to be predicted, but was ${text}`).to.equal(true);
    });
  });

Then(/^the (Arrival|Departure) punctuality for location "(.*)" instance (\d+) is correctly calculated based on expected time "(.*)" & actual time "(.*)"$/,
  async (arrivalDeparture, location, instance, expTime, actTime) => {
    const expectedTime = DateAndTimeUtils.parseTimeEquation(expTime, 'HH:mm:ss');
    const actualTime = DateAndTimeUtils.parseTimeEquation(actTime, 'HH:mm:ss');
    await timetablePage.getRowByLocation(location, instance).then(async row => {
      const actualPunctuality = await row.getValue('punctuality');
      const expectedPunctuality = getExpectedPunctuality(arrivalDeparture === 'Arrival', actualTime, expectedTime);
      const actualPunctualityMins = parseInt(actualPunctuality.split('m')[0], 10);
      const expectedPunctualityMins = parseInt(expectedPunctuality.split('m')[0], 10);
      expect(actualPunctualityMins, `Expected punctuality: ${expectedPunctuality}, actual punctuality: ${actualPunctuality} for location ${location}`).is.approximately(expectedPunctualityMins, 2);
    });
  });

Then(/^the (Arrival|Departure) punctuality for location "(.*)" instance (\d+) is "(.*)"$/,
  async (arrivalDeparture, location, instance, expectedPunctualities) => {
    await browser.wait(async () => {
      const row = await timetablePage.getRowByLocation(location, instance);
      await row.refreshRowLocator();
      const field: string = stripBrackets(await row.getValue('punctuality')).split(' ')[0];
      await CucumberLog.addText(`Actual punctuality: ${field}`);
      return expectedPunctualities.includes(field);
    }, browser.params.quick_timeout, `Punctuality not ${expectedPunctualities} for location ${location}`);
  });

Then(/^the predicted Departure punctuality for location "(.*)" instance (\d+) is correctly calculated based on the planned time of '(.*)' or the current time$/,
  async (location, instance, expectedTime) => {
    const expectedDepartureTime = LocalTime.parse(expectedTime);
    const currentTime = DateAndTimeUtils.getCurrentTime();
    await timetablePage.getRowByLocation(location, instance).then(async row => {
      const field = await row.getValue('punctuality');
      const expectedPunctuality = (currentTime.isAfter(expectedDepartureTime)) ?
        getExpectedPunctuality('Departure', currentTime.format(DateTimeFormatter.ofPattern('HH:mm:ss')), expectedTime) : '0m';
      expect(field, `Actual punctuality not correct for location ${location}`).to.equal(expectedPunctuality);
    });
  });

function convertDaysStringIfNecessary(daysString: string): string {
  if (daysString.length !== 7) {
    return daysString;
  }
  const weekday = new Array(7);
  let newString = '';
  weekday[0] = 'Monday';
  weekday[1] = 'Tuesday';
  weekday[2] = 'Wednesday';
  weekday[3] = 'Thursday';
  weekday[4] = 'Friday';
  weekday[5] = 'Saturday';
  weekday[6] = 'Sunday';

  for (let i = 0; i < 7; i++) {
    if ((daysString.charAt(i) !== '1') && (daysString.charAt(i) !== '0')) {
      return daysString;
    }
    if (daysString.charAt(i) === '1') {
      newString = newString + weekday[i] + ', ';
    }
  }
  newString = newString.substr(0, newString.lastIndexOf(','));
  if (newString.indexOf(',') === -1) {
    return newString;
  } else {
    return newString.substr(0, newString.lastIndexOf(',')) + ' &' + newString.substr(newString.lastIndexOf(',') + 1);
  }
}

function getExpectedPunctuality(arrival, actualTime, expectedTime): string {
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

  const minutes = ((seconds - (seconds % 60)) / 60) % 60;
  const hours = (seconds - (seconds % 3600)) / 3600;
  const punctualityArray = [];
  if (hours > 0) {
    punctualityArray.push(`${Math.abs(hours)}h`);
  }
  if (minutes > 0 || hours === 0) {
    punctualityArray.push(`${Math.abs(minutes)}m`);
  }
  if (Math.abs(seconds) % 60 !== 0) {
    punctualityArray.push(`${Math.abs(seconds % 60)}s`);
  }
  return `${plusMinus}${punctualityArray.join(' ')}`;
}

function actualsTimeRounding(timestamp: string, arrivalOrDeparture: string): string {
  let ltTimestamp = LocalTime.parse(timestamp);
  if (arrivalOrDeparture === 'Arrival') {
    ltTimestamp = ltTimestamp.second() < 30 ? ltTimestamp.withSecond(30) : ltTimestamp.plusMinutes(1).withSecond(0);
  } else {
    ltTimestamp = ltTimestamp.second() < 30 ? ltTimestamp.withSecond(0) : ltTimestamp.withSecond(30);
  }
  return ltTimestamp.format(DateTimeFormatter.ofPattern('HH:mm:ss'));
}

function stripBrackets(toBeStripped: string): string {
  return toBeStripped
    .replace('(', '')
    .replace(')', '')
    .replace('[', '')
    .replace(']', '');
}
