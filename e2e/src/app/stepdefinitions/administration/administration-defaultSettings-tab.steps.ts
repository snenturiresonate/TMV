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

Then('the following can be seen on the system default settings', async (systemDefaultsDataTable: any) => {
  const expectedDefaultsTableEntries = systemDefaultsDataTable.hashes();
  const actualValue = await adminSystemDefaults.getColumns();
  expectedDefaultsTableEntries.forEach((expectedDefaultsTableEntry: any) => {
    expect(actualValue, `${expectedDefaultsTableEntry.setting}, is not present in default settings`)
      .to.contain(expectedDefaultsTableEntry.setting);
  });
});

Then('the system default settings display as follows', async (systemDefaultsDataTable: any) => {
  const expectedSystemDefaultsTableEntries = systemDefaultsDataTable.hashes();
  const actualCols = await adminSystemDefaults.getColumns();
  const actualNumCols = await adminSystemDefaults.getSettingCount();
  const expectedNumCols = expectedSystemDefaultsTableEntries.length;
  expect(actualNumCols, `Number of settings not as expected`).to.equal(expectedNumCols);
  for (let i = 0; i < expectedNumCols; i++) {
    const setting = expectedSystemDefaultsTableEntries[i].setting;
    expect(actualCols, `${setting}, is not present in default settings`).to.contain(setting);
    const actualValue = await adminSystemDefaults.getSettingValue(setting);
    expect(actualValue, `Default value for ${setting} not as expected`).to.equal(expectedSystemDefaultsTableEntries[i].value);
  }
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

When('I update the following system default settings', async (table: any) =>  {
  const newSettings = table.hashes();
  newSettings.forEach((newSetting: any) => {
    const newValue: number = parseInt(newSetting.value, 10);
    adminSystemDefaults.setValue(newSetting.setting, newValue);
  });
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

When (/^I make a note of the value for setting (.*)$/, async (setting: string) => {
  browser.maxTabValue = await adminSystemDefaults.getSettingValue(setting);
});

When (/^I (increase|decrease) the value for setting (.*) by (.*)$/,
  async (incOrDec: string, setting: string, adjustment: number) => {
    const targetAdjustButton = await adminSystemDefaults.getValueAdjustButton(setting, incOrDec);
    for (let i = 0; i < adjustment; i++) {
      await targetAdjustButton.click();
    }
  });

Then (/^the value shown for setting (.*) is (.*) (more|less) than before$/,
  async (setting: string, expectedChange: string, adjustment: string) => {
    let expectedChangeVal = parseInt(expectedChange, 10);
    let actualChange;
    const currentValue = await adminSystemDefaults.getSettingValue(setting);
    actualChange = parseInt(currentValue, 10) - browser.maxTabValue;
    if (adjustment === 'less') {
      expectedChangeVal = expectedChangeVal * -1;
    }
    expect(actualChange, `Change in value for setting ${setting} is not observed`).to.equal(expectedChangeVal);
  });

