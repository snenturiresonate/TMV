import { When, Then} from 'cucumber';
import {expect} from 'chai';
import {TimeTablePageObject} from '../../pages/timetable/timetable.page';

const timetablePage: TimeTablePageObject = new TimeTablePageObject();


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
