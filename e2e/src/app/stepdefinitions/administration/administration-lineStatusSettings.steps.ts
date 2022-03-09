import {AdministrationLineSettingsTab} from '../../pages/administration/administration-lineStatusSettings.page';
import { expect } from 'chai';
import {Then, When} from 'cucumber';
import {browser, ElementFinder, protractor} from 'protractor';
import {InputBox} from '../../pages/common/ui-element-handlers/inputBox';
import {SelectBox} from '../../pages/common/ui-element-handlers/selectBox';

const adminLineSettings: AdministrationLineSettingsTab = new AdministrationLineSettingsTab();

Then('the line settings header is displayed as {string}', async (expectedHeader: string) => {
  const actualHeader: string = await adminLineSettings.getLineStatusHeader();
  expect(actualHeader).to.equal(expectedHeader);
});

Then('the following can be seen on the Line Status restriction type settings table', async (table: any) => {
  const results: any[] = [];
  const tableData: any = table.hashes();
  for (let i = 0; i < tableData.length; i++) {
    const actualSettingName = await adminLineSettings.getRestrictionTypeName(i);
    const actualSettingColour = await adminLineSettings.getRestrictionTypeColour(i);
    const actualSettingLineStyle = await adminLineSettings.getRestrictionTypeLineStyle(i);

    results.push(expect(actualSettingName).to.contain(tableData[i].name));
    results.push(expect(actualSettingColour).to.contain(tableData[i].colour));
    results.push(expect(actualSettingLineStyle).to.contain(tableData[i].lineStyle));
  }
  return protractor.promise.all(results);
});

Then('I make a note of the restriction type settings', async () => {
  const restrictionTypeSettings: any = {};
  const numberOfRestrictionTypes = await adminLineSettings.getNumberOfRestrictionTypes();
  for (let i = 0; i < numberOfRestrictionTypes; i++) {
    const name = await adminLineSettings.getRestrictionTypeName(i);
    const restrictionTypeColour = await adminLineSettings.getRestrictionTypeColour(i);
    const restrictionTypeLineStyle = await adminLineSettings.getRestrictionTypeLineStyle(i);
    restrictionTypeSettings[name] = {
        type: name,
        colour: restrictionTypeColour,
        lineStyle: restrictionTypeLineStyle
      };
  }
  browser.restrictionTypeSettings = restrictionTypeSettings;
});

Then('the following can be seen on the Line Status route type settings table', async (table: any) => {
  const results: any[] = [];
  const tableData: any = table.hashes();
  for (let i = 0; i < tableData.length; i++) {
    const actualRouteTypeName = await adminLineSettings.getRouteTypeName(i);
    const actualRouteTypeColour = await adminLineSettings.getRouteTypeColour(i);
    const actualRouteTypeLineStyle = await adminLineSettings.getRouteTypeLineStyle(i);

    results.push(expect(actualRouteTypeName).to.contain(tableData[i].name));
    results.push(expect(actualRouteTypeColour).to.contain(tableData[i].colour));
    results.push(expect(actualRouteTypeLineStyle).to.contain(tableData[i].lineStyle));
  }
  return protractor.promise.all(results);
});

Then('the following can be seen on the Line Status path type settings table', async (table: any) => {
  const results: any[] = [];
  const tableData: any = table.hashes();
  for (let i = 0; i < tableData.length; i++) {
    const actualPathTypeName = await adminLineSettings.getPathTypeName(i);
    const actualPathTypeColour = await adminLineSettings.getPathTypeColour(i);
    const actualPathTypeLineStyle = await adminLineSettings.getPathTypeLineStyle(i);

    results.push(expect(actualPathTypeName).to.contain(tableData[i].name));
    results.push(expect(actualPathTypeColour).to.contain(tableData[i].colour));
    results.push(expect(actualPathTypeLineStyle).to.contain(tableData[i].lineStyle));
  }
  return protractor.promise.all(results);
});

When('I update the Line Status restriction type settings table as', async (table: any) => {
  const tableData = table.hashes();
  for (let i = 0; i < tableData.length; i++) {
    const restrictionTypeColour: ElementFinder = adminLineSettings.restrictionTypeColour(i);
    const restrictionTypeLineStyle: ElementFinder = adminLineSettings.restrictionTypeLineStyle(i);
    await InputBox.updateColourPickerBoxViaPicker(restrictionTypeColour, tableData[i].colour);
    await SelectBox.selectByVisibleText(restrictionTypeLineStyle, tableData[i].lineStyle);
  }
});

When('I update the Line Status path type settings table as', async (table: any) => {
  const tableData = table.hashes();
  for (let i = 0; i < tableData.length; i++) {
    const pathTypeColour: ElementFinder = adminLineSettings.pathTypeColour(i);
    const pathTypeLineStyle: ElementFinder = adminLineSettings.pathTypeLineStyle(i);

    await InputBox.updateColourPickerBoxViaPicker(pathTypeColour, tableData[i].colour);
    await SelectBox.selectByVisibleText(pathTypeLineStyle, tableData[i].lineStyle);
  }
});

When('I update the Line Status route type settings table as', async (table: any) => {
  const tableData = table.hashes();
  for (let i = 0; i < tableData.length; i++) {
    const routeTypeColour: ElementFinder = adminLineSettings.routeTypeColour(i);
    const routeTypeLineStyle: ElementFinder = adminLineSettings.routeTypeLineStyle(i);

    await InputBox.updateColourPickerBoxViaPicker(routeTypeColour, tableData[i].colour);
    await SelectBox.selectByVisibleText(routeTypeLineStyle, tableData[i].lineStyle);
  }
});

When('I update the Line Status note settings table as', async (table: any) => {
  const tableData = table.hashes();
  for (let i = 0; i < tableData.length; i++) {
    const noteTypeColour: ElementFinder = adminLineSettings.noteTypeColour(i);
    const noteTypeLineStyle: ElementFinder = adminLineSettings.noteTypeLineStyle(i);

    await InputBox.updateColourPickerBoxViaPicker(noteTypeColour, tableData[i].colour);
    await SelectBox.selectByVisibleText(noteTypeLineStyle, tableData[i].lineStyle);
  }
});
