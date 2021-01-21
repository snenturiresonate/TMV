import { When, Then} from 'cucumber';
import {expect} from 'chai';
import {TimeTablePageObject} from '../../pages/timetable/timetable.page';

const timetablePage: TimeTablePageObject = new TimeTablePageObject();

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
      expect(actualTimetableEntryColValues[timetableColumnIndexes.workingArrivalTime]).to.equal(expectedTimetableEntryCol.workingArrivalTime);
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
  const actualColor: string = await timetablePage.getNavBarIndicatorColor();
  expect(actualColor).to.equal(expectedColor);
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
  expect(await timetablePage.getTimetableDetailsRowValueTrainOperatingCharacteristcs()).to.equal(expectedDetailsRowValues.trainOperatingCharacteristcs);
  expect(await timetablePage.getTimetableDetailsRowValueServiceBranding()).to.equal(expectedDetailsRowValues.serviceBranding);
});
