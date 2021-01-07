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

Then('The timetable table tab is visible', async () => {
  const isTimetableTableTabVisible: boolean = await timetablePage.isTimetableTableTabVisible();
  expect(isTimetableTableTabVisible).to.equal(true);
});

Then('The timetable service description is visible', async () => {
  const isTimetableServiceDescriptionVisible: boolean = await timetablePage.isTimetableServiceDescriptionVisible();
  expect(isTimetableServiceDescriptionVisible).to.equal(true);
});


Then('The live timetable tab will be titled {string}', async (expectedTabName: string) => {
  const actualTimetableTabName: string = await timetablePage.getLiveTimetableTabName();

  expect(actualTimetableTabName).to.equal(expectedTabName);

});

Then('The timetable entries contains the following data',
  async (timetableEntryDataTable: any) => {
    const expectedTimetableEntryColValues: any[] = timetableEntryDataTable.hashes();
    for (const expectedTimetableEntryCol of expectedTimetableEntryColValues) {
      const actualTimetableEntryValues: string[] = await timetablePage.getTimetableEntryColValues(expectedTimetableEntryCol.entryId);
      expect(actualTimetableEntryValues[timetableColumnIndexes.location]).to.equal(expectedTimetableEntryCol.location);
      expect(actualTimetableEntryValues[timetableColumnIndexes.workingArrivalTime]).to.equal(expectedTimetableEntryCol.workingArrivalTime);
      expect(actualTimetableEntryValues[timetableColumnIndexes.workingDeptTime]).to.equal(expectedTimetableEntryCol.workingDeptTime);
      expect(actualTimetableEntryValues[timetableColumnIndexes.publicArrivalTime]).to.equal(expectedTimetableEntryCol.publicArrivalTime);
      expect(actualTimetableEntryValues[timetableColumnIndexes.publicDeptTime]).to.equal(expectedTimetableEntryCol.publicDeptTime);
      expect(actualTimetableEntryValues[timetableColumnIndexes.originalAssetCode]).to.equal(expectedTimetableEntryCol.originalAssetCode);
      expect(actualTimetableEntryValues[timetableColumnIndexes.originalPathCode]).to.equal(expectedTimetableEntryCol.originalPathCode);
      expect(actualTimetableEntryValues[timetableColumnIndexes.originalLineCode]).to.equal(expectedTimetableEntryCol.originalLineCode);
      expect(actualTimetableEntryValues[timetableColumnIndexes.allowances]).to.equal(expectedTimetableEntryCol.allowances);
      expect(actualTimetableEntryValues[timetableColumnIndexes.activities]).to.equal(expectedTimetableEntryCol.activities);
      expect(actualTimetableEntryValues[timetableColumnIndexes.arrivalDateTime]).to.equal(expectedTimetableEntryCol.arrivalDateTime);
      expect(actualTimetableEntryValues[timetableColumnIndexes.deptDateTime]).to.equal(expectedTimetableEntryCol.deptDateTime);
      expect(actualTimetableEntryValues[timetableColumnIndexes.assetCode]).to.equal(expectedTimetableEntryCol.assetCode);
      expect(actualTimetableEntryValues[timetableColumnIndexes.pathCode]).to.equal(expectedTimetableEntryCol.pathCode);
      expect(actualTimetableEntryValues[timetableColumnIndexes.lineCode]).to.equal(expectedTimetableEntryCol.lineCode);
      expect(actualTimetableEntryValues[timetableColumnIndexes.punctuality]).to.equal(expectedTimetableEntryCol.punctuality);
    }
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
