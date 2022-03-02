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

When(/^I click to edit the restriction with comment (.*)$/, async (targetComment: string) => {
  const targetRow = await restrictionsPageObject.getRowForRestrictionWithComment(targetComment);
  await restrictionsPageObject.amendRestriction(targetRow);
});

When('I add the following restrictions', {timeout: 8 * 5000}, async (table: any) => {

/*  takes a data table that is dynamic,
    column headers should match the relevant part of the edit input element ids for Restrictions table namely:

    type                    id="track-restriction-table-edit-type-0"
    start-distance-miles    id="track-restriction-table-edit-start-distance-miles-input-0"
    start-distance-chains   id="track-restriction-table-edit-start-distance-chains-input-0"
    end-distance-miles      id="track-restriction-table-edit-end-distance-miles-input-0"
    end-distance-chains     id="track-restriction-table-edit-end-distance-chains-input-0"
    start-date              id="track-restriction-table-edit-start-date-0"
    end-date                id="track-restriction-table-edit-end-date-0"
    delay-penalty           id="track-restriction-table-edit-delay-penalty-0"
    comment                 id="track-restriction-table-edit-comment-and-buttons-0"

    example below to add restriction with given type, end-date and comment
    note end-date and start-date can include 'now' with optional offset in minutes e.g. 'now + 2' or 'now - 120'

  When I add the following restrictions
      | type              | comment       | start-date | end-date  |
      | POSS (Possession) | POSS - Team 1 | now - 30   |           |
      | POSS (Possession) | POSS - Team 2 | now - 60   | now + 60  |
*/

  const values = table.hashes();
  const numRows = values.length;
  for (let i = 0; i < numRows; i++) {
    await restrictionsPageObject.addRestriction();
    for (const [key, value] of Object.entries(table.hashes()[i])) {
      let val = String(value);
      if (val.includes('now')) {
        val = getFormattedDateTimeByEquation(val);
      }
      await restrictionsPageObject.setValue(key, val);
    }
    await restrictionsPageObject.saveOpenRestriction();
  }
});

When('I add the following restrictions starting now', {timeout: 8 * 5000}, async (table: any) => {
  // variant on the step 'I add the following restrictions' above with all having the same start-date

  const values = table.hashes();
  const now = DateAndTimeUtils.getCurrentDateTimeString('dd/MM/yyyy HH:mm:ss');
  const numRows = values.length;
  for (let i = 0; i < numRows; i++) {
    await restrictionsPageObject.addRestriction();
    await restrictionsPageObject.setValue('start-date', now);
    for (const [key, value] of Object.entries(table.hashes()[i])) {
      let val = String(value);
      if (val.includes('now')) {
        val = getFormattedDateTimeByEquation(val);
      }
      await restrictionsPageObject.setValue(key, val);
    }
    await restrictionsPageObject.saveOpenRestriction();
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

Then('only the following restrictions are shown in order', {timeout: 8 * 5000}, async (table: any) => {

  /*  takes a data table that is dynamic,
      column headers should match the relevant part of the edit input element ids for Restrictions table namely:

      type                    id="track-restriction-table-edit-type-0"
      start-distance-miles    id="track-restriction-table-edit-start-distance-miles-input-0"
      start-distance-chains   id="track-restriction-table-edit-start-distance-chains-input-0"
      end-distance-miles      id="track-restriction-table-edit-end-distance-miles-input-0"
      end-distance-chains     id="track-restriction-table-edit-end-distance-chains-input-0"
      start-date              id="track-restriction-table-edit-start-date-0"
      end-date                id="track-restriction-table-edit-end-date-0"
      delay-penalty           id="track-restriction-table-edit-delay-penalty-0"
      comment                 id="track-restriction-table-edit-comment-and-buttons-0"

      example below to add restriction with given type, end-date and comment
      note end-date and start-date can include 'now' with optional offset in minutes e.g. 'now + 2' or 'now - 120'

    Then the following restrictions are shown in order
        | type              | comment       | start-date | end-date  |
        | POSS (Possession) | POSS - Team 1 | now - 30   |           |
        | POSS (Possession) | POSS - Team 2 | now - 60   | now + 60  |
  */

  const values = table.hashes();
  const expectedNumRows = values.length;
  const actualNumRows = await restrictionsPageObject.getRestrictionsCount();
  expect(actualNumRows,
    `Actual for number of restrictions should be ${expectedNumRows} but was ${actualNumRows}`)
    .to.equal(expectedNumRows);
  for (let index = 0; index < expectedNumRows; index++) {
    for (const [key, value] of Object.entries(table.hashes()[index])) {
      const val = String(value);
      if (val === 'blank') {
        const isBlank = await restrictionsPageObject.isValueInRowBlank(index, key);
        expect(isBlank, `Actual for ${key} should be ${true}`).to.equal(true);
      } else {
        let derivedExpectedValue = '';
        if (isValidDateTimeLabel(val) || val.includes('now')) {
          derivedExpectedValue = getAllocatedFormattedDateTime(val);
        } else {
          derivedExpectedValue = val;
        }
        const actualValue: string = await restrictionsPageObject.getDisplayedValueInRow(index, key);
        expect(actualValue.trim(), `Actual for ${key} should be ${derivedExpectedValue}`).to.equal(derivedExpectedValue);
      }
    }
  }
});

Then('no add restriction button is present', async () => {
  const addRestrictionButtonPresent = await restrictionsPageObject.isAddRestrictionButtonPresent();
  expect(addRestrictionButtonPresent, 'Expecting no Add Restriction button to be present').to.equal(false);
});

Then('no edit restriction buttons are present', async () => {
  const editButtonsPresent = await restrictionsPageObject.areEditButtonsPresent();
  expect(editButtonsPresent, 'Expecting no Edit Restriction buttons to be present').to.equal(false);
});

Then('no delete restriction buttons are present', async () => {
  const deleteButtonsPresent = await restrictionsPageObject.areDeleteButtonsPresent();
  expect(deleteButtonsPresent, 'Expecting no Delete Restriction buttons to be present').to.equal(false);
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
  const dateTime = DateAndTimeUtils.parseTimeEquation(dateTimeLabel, 'dd/MM/yyyy HH:mm:ss');
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
