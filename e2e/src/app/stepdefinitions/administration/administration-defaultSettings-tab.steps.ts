import {Then, When} from 'cucumber';
import {expect} from 'chai';
import {AdministrationDefaultSettingsTab} from '../../pages/administration/administration-defaultSettings-tab.page';
import {browser, protractor} from 'protractor';

const adminSystemDefaults: AdministrationDefaultSettingsTab = new AdministrationDefaultSettingsTab();


Then('the default settings header is displayed as {string}', async (expectedText: string) => {
  const actualText: string = await adminSystemDefaults.getUserTabValue();
  expect(actualText, 'Settings header is not as expected')
    .to.equal(expectedText);
});

Then('the following can be seen on the system default settings', async (replayEntryDataTable: any) => {
  const expectedReplayTableEntries = replayEntryDataTable.hashes();
  const actualValue = await adminSystemDefaults.getReplayColumn();
  expectedReplayTableEntries.forEach((expectedReplayTableEntry: any) => {
    expect(actualValue, `${expectedReplayTableEntry.replayEntry}, is not present in default settings`)
      .to.contain(expectedReplayTableEntry.replayEntry);
  });
});

Then('I should see the system default settings as', async (table: any) => {
  const tableValues = table.hashes()[0];
  const actualBackgroundColour: string = await adminSystemDefaults.getReplayBackgroundColour();
  const actualNoOfReplays: string = await adminSystemDefaults.getNoOfReplays();
  const actualSchematicMapInstance: string = await adminSystemDefaults.getSchematicMapInstance();
  const actualMaxNoOfMapsPerReplay: string = await adminSystemDefaults.getMaxNoOfMapsPerReplay();
  const results = [
    expect(actualBackgroundColour, `Replay background colour is not ${tableValues.ReplayBackgroundColour}`)
      .to.contain(tableValues.ReplayBackgroundColour),
    expect(actualSchematicMapInstance, `Schematic map instance is not ${tableValues.MaxNoofSchematicMapDisplayInstances}`)
      .to.contain(tableValues.MaxNoofSchematicMapDisplayInstances),
    expect(actualNoOfReplays, `No of replays is not ${tableValues.MaxNoofReplays}`)
      .to.contain(tableValues.MaxNoofReplays),
    expect(actualMaxNoOfMapsPerReplay, `Max no of maps per replay is not ${tableValues.MaxNoOfMapsPerReplay}`)
      .to.contain(tableValues.MaxNoOfMapsPerReplay)
  ];
  return protractor.promise.all(results);
});

When('I make a note of the replay background colour', async () => {
  browser.referenceReplayBackgroundColour = await adminSystemDefaults.getReplayBackgroundColour();
});

When('I update the system default settings as', async (table: any) => {
  const tableValues = table.hashes()[0];
  await adminSystemDefaults.updateReplayBackgroundColour(tableValues.ReplayBackgroundColour);
  await adminSystemDefaults.updateNoOfReplays(tableValues.MaxNoofReplays);
  await adminSystemDefaults.updateSchematicMapInstance(tableValues.MaxNoofSchematicMapDisplayInstances);
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
 expect(isFieldEditable, `${fieldName} is editable when it shouldn't be`)
   .to.equal(false);
});
