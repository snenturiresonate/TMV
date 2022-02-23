import {Then, When, Given} from 'cucumber';
import {browser} from 'protractor';
import {expect} from 'chai';
import {RestrictionsPageObject} from '../../pages/restrictions/restrictions-page';
import {DateAndTimeUtils} from '../../pages/common/utilities/DateAndTimeUtils';
import {StringUtils} from '../../pages/common/utilities/StringUtils';

const restrictionsPageObject: RestrictionsPageObject = new RestrictionsPageObject();


When('I click to add a new restriction', async () => {
  await restrictionsPageObject.addRestriction();
});

When('I click on done on the open restriction', async () => {
  await restrictionsPageObject.saveOpenRestriction();
});

When('I click apply changes', async () => {
  await restrictionsPageObject.applyChanges();
});

When('I click reset', async () => {
  await restrictionsPageObject.clearChanges();
});

Then('the restriction header contains the id {string}', async (trackDivisionId: string) => {
  const actualRestrictionHeader = await restrictionsPageObject.getRestrictionsHeaderValue();
  expect(actualRestrictionHeader, `${trackDivisionId} is not displayed`).to.contain(trackDivisionId);
});

When('I make a note of the number of existing restrictions', async () => {
  browser.numRestrictions = await restrictionsPageObject.getRestrictionsCount();
});

Then('there is a new editable restriction in the list', async () => {
  const currentRestrictionsNum = await restrictionsPageObject.getRestrictionsCount();
  const newRestrictions = currentRestrictionsNum - browser.numRestrictions;
  const editableRestrictionsNum = await restrictionsPageObject.getEditableRestrictionRowCount();
  expect(newRestrictions, 'Expecting 1 new row to have been added').to.equal(1);
  expect(editableRestrictionsNum, 'Expecting new row to be editable').to.equal(1);
});

Then('no new restriction has been added to the list', async () => {
  const currentRestrictionsNum = await restrictionsPageObject.getRestrictionsCount();
  expect(currentRestrictionsNum, 'Expecting no new row to have been added').to.equal(browser.numRestrictions);
});

Then('the restriction row contains the following editable fields and defaults', {timeout: 8 * 5000}, async (table: any) => {
  const expectedValues = table.hashes();
  for (const expectedValue of expectedValues) {
    const expectedField = (expectedValue.field).toLowerCase();
    const isPresent: boolean = await restrictionsPageObject.isEditableFieldPresent(expectedField);
    expect(isPresent, `No field for ${expectedField}`).to.equal(true);
    let expectedDefaultValue = '';
    if (expectedValue.default === 'now') {
      expectedDefaultValue = DateAndTimeUtils.getCurrentDateTimeString('dd/MM/yyyy HH:mm:ss');
      expectedDefaultValue = expectedDefaultValue.substr(0, 17) + '00';
    }
    else if (expectedValue.default !== 'blank') {
      expectedDefaultValue = expectedValue.default;
    }
    const actualDefaultValue: string = await restrictionsPageObject.getDisplayedValueInEditRecord(expectedField);
    expect(actualDefaultValue.trim(), `Default for ${expectedField} should be ${expectedDefaultValue}`).to.equal(expectedDefaultValue);
  }
});

Then('the restriction fields have the following input limits', {timeout: 8 * 5000}, async (table: any) => {
  const expectedValues = table.hashes();
  for (const expectedValue of expectedValues) {
    const expectedField = (expectedValue.field).toLowerCase();
    browser.testInputMax =
      await StringUtils.createTestInputStringOfTypeAndLength(expectedValue.inputType, parseInt(expectedValue.limit, 10));
    browser.testInputExcessive =
      await StringUtils.createTestInputStringOfTypeAndLength(expectedValue.inputType, parseInt(expectedValue.limit, 10) + 1);

    await restrictionsPageObject.setValue(expectedField, browser.testInputMax);
    const displayedValue1: string = await restrictionsPageObject.getDisplayedValueInEditRecord(expectedField);
    expect(displayedValue1, `${expectedField} should show ${browser.testInputMax}`).to.equal(browser.testInputMax);

    await restrictionsPageObject.setValue(expectedField, browser.testInputExcessive);
    const displayedValue2: string = await restrictionsPageObject.getDisplayedValueInEditRecord(expectedField);
    expect(displayedValue2, `${expectedField} should still show ${browser.testInputMax}
        after ${expectedValue.limit} limit is applied`).to.equal(browser.testInputMax);
  }
});


Then('the editable type drop down contains the following options', {timeout: 8 * 5000}, async (table: any) => {
  const expectedValues = table.hashes();
  let i = 0;
  for (const expectedValue of expectedValues) {
    const expectedTypeName = (expectedValue.type).toLowerCase();
    const actualTypeName: string = await restrictionsPageObject.getEditableRestrictionType(i);
    expect(actualTypeName.toLowerCase(), `Could not find ${expectedTypeName} in expected position`).to.equal(expectedTypeName);
    i = i + 1;
  }
});

Then(/^the selected restriction type is (.*)$/, async (expectedSelection: string) => {
  const actualSelection = await restrictionsPageObject.getSelectedType();
  expect(actualSelection, `${expectedSelection} is not selected`).to.equal(expectedSelection);
});

Given('the following restriction values are entered', {timeout: 8 * 5000}, async (table: any) => {
  const values = table.hashes();
  for (const row of values) {
    const field = (row.field).toLowerCase();
    let value = '';
    if (row.value === 'now') {
      value = DateAndTimeUtils.getCurrentDateTimeString('dd/MM/yyyy HH:mm:ss');
      value = value.substr(0, 17) + '00';
    }
    else if (row.value !== 'blank') {
      value = row.value;
    }
    await restrictionsPageObject.setValue(field, value);
  }
});

Then(/^the new restriction row contains the following fields$/, {timeout: 8 * 5000}, async (table: any) => {
  const index = browser.numRestrictions;
  await checkRestrictionValues(index, table);
});

Then(/^the restriction row index (\d+) contains the following fields$/, {timeout: 8 * 5000}, async (index: number, table: any) => {
  await checkRestrictionValues(index, table);
});

async function checkRestrictionValues(index: number, table: any): Promise<void> {
  const expectedValues = table.hashes();
  for (const expectedValue of expectedValues) {
    const expectedField = (expectedValue.field).toLowerCase();
    let derivedExpectedValue = '';
    if (expectedValue.value === 'now') {
      derivedExpectedValue = DateAndTimeUtils.getCurrentDateTimeString('dd/MM/yyyy HH:mm:ss');
      derivedExpectedValue = derivedExpectedValue.substr(0, 17) + '00';
    } else if (expectedValue.value !== 'blank') {
      derivedExpectedValue = expectedValue.value;
    }
    const actualValue: string = await restrictionsPageObject.getDisplayedValueInRow(index, expectedField);
    expect(actualValue.trim(), `Actual for ${expectedField} should be ${derivedExpectedValue}`).to.equal(derivedExpectedValue);
  }
}


