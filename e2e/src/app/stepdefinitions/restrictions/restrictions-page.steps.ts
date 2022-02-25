import {Then, When, Given} from 'cucumber';
import {browser} from 'protractor';
import {expect} from 'chai';
import {RestrictionsRestClient} from '../../api/restrictions/restrictions-rest-client';
import {AdminRestClient} from '../../api/admin/admin-rest-client';
import {RestrictionsPageObject} from '../../pages/restrictions/restrictions-page';
import {DateAndTimeUtils} from '../../pages/common/utilities/DateAndTimeUtils';
import {StringUtils} from '../../pages/common/utilities/StringUtils';

const restrictionsPageObject: RestrictionsPageObject = new RestrictionsPageObject();
const adminRestClient: AdminRestClient = new AdminRestClient();
const restrictionsRestClient: RestrictionsRestClient = new RestrictionsRestClient();

Given(/^I remove all restrictions for track division (.*)$/, async (trackDivisionId: string) => {
  await restrictionsRestClient.deleteRestrictionsForTrack(trackDivisionId);
  await adminRestClient.waitMaxTransmissionTime();
});

When('I switch to the new restriction tab', async () => {
  const windowHandles: string[] = await browser.getAllWindowHandles();
  const finalTab: number = windowHandles.length - 1;
  await browser.driver.switchTo().window(windowHandles[finalTab]);
  await restrictionsPageObject.waitForClock();
  await restrictionsPageObject.waitForSpinner();
});

When('I click to add a new restriction', async () => {
  await restrictionsPageObject.addRestriction();
});

When('I click on done on the open restriction', async () => {
  await restrictionsPageObject.saveOpenRestriction();
});

When('I click on edit on the restriction in the last row', async () => {
  await restrictionsPageObject.editLastRestriction();
});

When('I click on delete on the restriction in the last row', async () => {
  await restrictionsPageObject.deleteLastRestriction();
});

When('I click apply changes', async () => {
  await restrictionsPageObject.applyChanges();
});

When('I refresh the restrictions page', async () => {
  await browser.driver.navigate().refresh();
  await restrictionsPageObject.waitForClock();
  await restrictionsPageObject.waitForSpinner();
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

    await restrictionsPageObject.sendKeys(expectedField, browser.testInputMax);
    const displayedValue1: string = await restrictionsPageObject.getDisplayedValueInEditRecord(expectedField);
    expect(displayedValue1, `${expectedField} should show ${browser.testInputMax}`).to.equal(browser.testInputMax);

    await restrictionsPageObject.sendKeys(expectedField, browser.testInputExcessive);
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
    if (isValidDateTimeLabel(row.value)) {
      value = getFormattedDateTime(row.value);
    } else if (row.value.includes('now')) {
      value = getFormattedDateTimeByEquation(row.value);
    } else if (row.value !== 'blank') {
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

Then('the done button is disabled on the open restriction', async () => {
  const editButtonDisabled = await restrictionsPageObject.isEditableDoneButtonDisabled();
  expect(editButtonDisabled, `Actual for editButtonDisabled should be ${true}`).to.equal(true);
});

Then(/there (?:is|are) (\d+) restriction[s]? in the restrictions table/, async (expectedRestrictionCount: number) => {
  const restrictionsCount = await restrictionsPageObject.getRestrictionsCount();
  expect(restrictionsCount, `Could not find ${expectedRestrictionCount} in restrictions table`).to.equal(expectedRestrictionCount);
});

Then('the delete button is disabled on the last restriction', async () => {
  const deleteButtonDisabled = await restrictionsPageObject.isLastRowDeleteButtonDisabled();
  expect(deleteButtonDisabled, `Actual for deleteButtonDisabled should be ${true}`).to.equal(true);
});



async function checkRestrictionValues(index: number, table: any): Promise<void> {
  const expectedValues = table.hashes();
  for (const expectedValue of expectedValues) {
    const expectedField = (expectedValue.field).toLowerCase();
    if (expectedValue.value === 'blank') {
      const isBlank = await restrictionsPageObject.isValueInRowBlank(index, expectedField);
      expect(isBlank, `Actual for ${expectedField} should be ${true}`).to.equal(true);
    } else {
      let derivedExpectedValue = '';
      if (isValidDateTimeLabel(expectedValue.value) || expectedValue.value.includes('now')) {
        derivedExpectedValue = getAllocatedFormattedDateTime(expectedValue.value);
      } else {
        derivedExpectedValue = expectedValue.value;
      }
      const actualValue: string = await restrictionsPageObject.getDisplayedValueInRow(index, expectedField);
      expect(actualValue.trim(), `Actual for ${expectedField} should be ${derivedExpectedValue}`).to.equal(derivedExpectedValue);
    }
  }
}

function isValidDateTimeLabel(label: string): boolean {
  return label === 'today' || label === 'tomorrow' || label === 'yesterday';
}

function getFormattedDateTime(dateTimeLabel: string): string {
  const dateTime = DateAndTimeUtils.convertToDesiredDateAndFormat(dateTimeLabel, 'dd/MM/yyyy HH:mm:ss');
  browser[dateTimeLabel] = dateTime;
  return dateTime;
}

function getFormattedDateTimeByEquation(dateTimeLabel: string): string {
  const date = DateAndTimeUtils.getCurrentDateTimeString('dd/MM/yyyy');
  const time = DateAndTimeUtils.parseTimeEquation(dateTimeLabel, 'HH:mm:ss');
  const dateTime = `${date} ${time}`;
  browser[dateTimeLabel] = dateTime;
  return dateTime;
}

function getAllocatedFormattedDateTime(dateTimeLabel: string): string {
  if (!!browser[dateTimeLabel]) {
    return browser[dateTimeLabel];
  } else {
    return 'label not found';
  }
}
