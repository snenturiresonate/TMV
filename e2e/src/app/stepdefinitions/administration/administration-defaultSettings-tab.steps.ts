import {Then, When} from 'cucumber';
import {expect} from 'chai';
import {AdministrationDefaultSettingsTab} from '../../pages/administration/administration-defaultSettings-tab.page';
import {protractor} from 'protractor';

const adminSystemDefaults: AdministrationDefaultSettingsTab = new AdministrationDefaultSettingsTab();


Then('the default settings header is displayed as {string}', async (expectedText: string) => {
  const actualText: string = await adminSystemDefaults.getUserTabValue();
  expect(actualText).to.equal(expectedText);
});

Then('the following can be seen on the system default settings', async (replayEntryDataTable: any) => {
  const expectedReplayTableEntries = replayEntryDataTable.hashes();
  const actualValue = await adminSystemDefaults.getReplayColumn();
  expectedReplayTableEntries.forEach((expectedReplayTableEntry: any) => {
    expect(actualValue).to.contain(expectedReplayTableEntry.replayEntry);
  });
});

Then('I should see the system default settings as', async (table: any) => {
  const tableValues = table.hashes()[0];
  const actualBackgroundColour: string = await adminSystemDefaults.getReplayBackgroundColour();
  const actualNoOfReplays: string = await adminSystemDefaults.getNoOfReplays();
  const actualSchematicMapInstance: string = await adminSystemDefaults.getSchematicMapInstance();
  const actualTrainListInstance: string = await adminSystemDefaults.getTrainListInstance();
  const actualMaxNoOfMapsPerReplay: string = await adminSystemDefaults.getMaxNoOfMapsPerReplay();
  const results = [
    expect(actualBackgroundColour).to.contain(tableValues.ReplayBackgroundColour),
    expect(actualSchematicMapInstance).to.contain(tableValues.MaxNoofSchematicMapDisplayInstances),
    expect(actualNoOfReplays).to.contain(tableValues.MaxNoofReplays),
    expect(actualTrainListInstance).to.contain(tableValues.MaxNoofTrainsListViewInstances),
    expect(actualMaxNoOfMapsPerReplay).to.contain(tableValues.MaxNoOfMapsPerReplay)
  ];
  return protractor.promise.all(results);
});

When('I update the system default settings as', async (table: any) => {
  const tableValues = table.hashes()[0];
  await adminSystemDefaults.updateReplayBackgroundColour(tableValues.ReplayBackgroundColour);
  await adminSystemDefaults.updateNoOfReplays(tableValues.MaxNoofReplays);
  await adminSystemDefaults.updateSchematicMapInstance(tableValues.MaxNoofSchematicMapDisplayInstances);
  await adminSystemDefaults.updateTrainListInstance(tableValues.MaxNoofTrainsListViewInstances);
  await adminSystemDefaults.updateMaxNoOfMapsPerReplay(tableValues.MaxNoOfMapsPerReplay);
});

When('I save the system default settings', async () => {
  await adminSystemDefaults.clickSaveButton();
});

When('I reset the system default settings', async () => {
  await adminSystemDefaults.clickResetButton();
});

Then('I should not be able to edit {string}', async (fieldName: string) => {
 const isFieldEditable: boolean = await adminSystemDefaults.fieldIsEditable(fieldName);
 expect(isFieldEditable).to.equal(false);
});
