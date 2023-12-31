import {AdministrationLineSettingsTab} from '../../pages/administration/administration-lineStatusSettings.page';
import { expect } from 'chai';
import {Then, When} from 'cucumber';
import {ElementFinder, protractor} from 'protractor';
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

    results.push(expect(actualSettingName).to.contain(tableData[i].name));
    results.push(expect(actualSettingColour).to.contain(tableData[i].colour));
  }
  return protractor.promise.all(results);
});

Then('the following can be seen on the Line Status route type settings table', async (table: any) => {
  const results: any[] = [];
  const tableData: any = table.hashes();
  for (let i = 0; i < tableData.length; i++) {
    const actualRouteTypeName = await adminLineSettings.getRouteTypeName(i);
    const actualRouteTypeColour = await adminLineSettings.getRouteTypeColour(i);
    const actualRouteTypeLineWidth = await adminLineSettings.getRouteTypeLineWidth(i);
    const actualRouteTypeLineStyle = await adminLineSettings.getRouteTypeLineStyle(i);

    results.push(expect(actualRouteTypeName).to.contain(tableData[i].name));
    results.push(expect(actualRouteTypeColour).to.contain(tableData[i].colour));
    results.push(expect(actualRouteTypeLineWidth).to.contain(tableData[i].lineWidth));
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
    const actualPathTypeLineWidth = await adminLineSettings.getPathTypeLineWidth(i);
    const actualPathTypeLineStyle = await adminLineSettings.getPathTypeLineStyle(i);

    results.push(expect(actualPathTypeName).to.contain(tableData[i].name));
    results.push(expect(actualPathTypeColour).to.contain(tableData[i].colour));
    results.push(expect(actualPathTypeLineWidth).to.contain(tableData[i].lineWidth));
    results.push(expect(actualPathTypeLineStyle).to.contain(tableData[i].lineStyle));
  }
  return protractor.promise.all(results);
});

Then('the following can be seen on the Line Status note settings table', async (table: any) => {
  const results: any[] = [];
  const tableData: any = table.hashes();
  for (let i = 0; i < tableData.length; i++) {
    const actualNoteTypeName = await adminLineSettings.getNoteTypeName(i);
    const actualNoteTypeColour = await adminLineSettings.getNoteTypeColour(i);
    const actualNoteTypeLineWidth = await adminLineSettings.getNoteTypeLineWidth(i);
    const actualNoteTypeLineStyle = await adminLineSettings.getNoteTypeLineStyle(i);

    results.push(expect(actualNoteTypeName).to.contain(tableData[i].name));
    results.push(expect(actualNoteTypeColour).to.contain(tableData[i].colour));
    results.push(expect(actualNoteTypeLineWidth).to.contain(tableData[i].lineWidth));
    results.push(expect(actualNoteTypeLineStyle).to.contain(tableData[i].lineStyle));
  }
  return protractor.promise.all(results);
});

When('I update the Line Status restriction type settings table as', async (table: any) => {
  const tableData = table.hashes();
  for (let i = 0; i < tableData.length; i++) {
    const restrictionTypeColour: ElementFinder = adminLineSettings.restrictionTypeColour(i);
    await InputBox.updateColourPickerBox(restrictionTypeColour, tableData[i].colour);
  }
});

When('I update the Line Status path type settings table as', async (table: any) => {
  const tableData = table.hashes();
  for (let i = 0; i < tableData.length; i++) {
    const pathTypeColour: ElementFinder = adminLineSettings.pathTypeColour(i);
    const pathTypeLineStyle: ElementFinder = adminLineSettings.pathTypeLineStyle(i);

    await InputBox.updateColourPickerBox(pathTypeColour, tableData[i].colour);
    await adminLineSettings.updatePathTypeLineWidth(i, tableData[i].lineWidth);
    await SelectBox.selectByVisibleText(pathTypeLineStyle, tableData[i].lineStyle);
  }
});

When('I update the Line Status route type settings table as', async (table: any) => {
  const tableData = table.hashes();
  for (let i = 0; i < tableData.length; i++) {
    const routeTypeColour: ElementFinder = adminLineSettings.routeTypeColour(i);
    const routeTypeLineStyle: ElementFinder = adminLineSettings.routeTypeLineStyle(i);

    await InputBox.updateColourPickerBox(routeTypeColour, tableData[i].colour);
    await adminLineSettings.updateRouteTypeLineWidth(i, tableData[i].lineWidth);
    await SelectBox.selectByVisibleText(routeTypeLineStyle, tableData[i].lineStyle);
  }
});

When('I update the Line Status note settings table as', async (table: any) => {
  const tableData = table.hashes();
  for (let i = 0; i < tableData.length; i++) {
    const noteTypeColour: ElementFinder = adminLineSettings.noteTypeColour(i);
    const noteTypeLineStyle: ElementFinder = adminLineSettings.noteTypeLineStyle(i);

    await InputBox.updateColourPickerBox(noteTypeColour, tableData[i].colour);
    await adminLineSettings.updateNoteTypeLineWidth(i, tableData[i].lineWidth);
    await SelectBox.selectByVisibleText(noteTypeLineStyle, tableData[i].lineStyle);
  }
});
