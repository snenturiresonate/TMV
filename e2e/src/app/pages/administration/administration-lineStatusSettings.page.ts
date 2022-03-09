import {browser, by, element, ElementArrayFinder, ElementFinder, protractor} from 'protractor';
import {SelectBox} from '../common/ui-element-handlers/selectBox';
import {GeneralUtils} from '../common/utilities/generalUtils';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';
import {InputBox} from '../common/ui-element-handlers/inputBox';

export class AdministrationLineSettingsTab {
  public lineSettingsContainer: ElementFinder;
  public lineStatusHeader: ElementFinder;
  public restrictionTypeSettings: ElementArrayFinder;
  public routeTypeSettings: ElementArrayFinder;
  public pathTypeSettings: ElementArrayFinder;
  public noteSettings: ElementArrayFinder;

  constructor() {
    this.lineSettingsContainer = element(by.css('app-line-status-settings #linestatus-div-container'));
    this.lineStatusHeader = element.all((by.css('#linestatusheader .header.section-name'))).first();
    this.restrictionTypeSettings = element.all(by.css('#restrictiontypesettings'));
    this.routeTypeSettings = element.all(by.css('#routeTypeSettings'));
    this.pathTypeSettings = element.all(by.css('#pathTypeSettings'));
    this.noteSettings = element.all(by.css('#noteSettings'));
  }

  public async componentLoad(): Promise<void> {
    const EC = protractor.ExpectedConditions;
    return browser.wait(EC.presenceOf(this.lineSettingsContainer));
  }

  public async getLineStatusHeader(): Promise<string> {
    await this.componentLoad();
    return this.lineStatusHeader.getText();
  }

  public async getNumberOfRestrictionTypes(): Promise<number> {
    return this.restrictionTypeSettings.count();
  }

  public async getRestrictionTypeName(index: number): Promise<string> {
    await this.componentLoad();
    return this.restrictionTypeName(index).getText();
  }

  public restrictionTypeName(index: number): ElementFinder {
    // Xpath is used to overcome a multiple elements found warning when using chained locators
    const indexForXpath = index + 1;
    return element.all(by.xpath(`//*[@id='restrictiontypesettings'][${indexForXpath}]//*[contains(@class,'punctuality-name')]`)).first();
  }

  public async getRestrictionTypeColour(index: number): Promise<string> {
    await this.componentLoad();
    return browser.executeScript(`return arguments[0].value`, this.restrictionTypeColour(index));
  }

  public restrictionTypeColour(index: number): ElementFinder {
    return this.restrictionTypeSettings.get(index).element(by.css('.punctuality-colour'));
  }

  public async getRestrictionTypeLineStyle(index: number): Promise<string> {
    await this.componentLoad();
    return browser.executeScript(`return arguments[0].value`, this.selectedRestrictionTypeLineStyle(index));
  }

  public restrictionTypeLineStyle(index: number): ElementFinder {
    return this.restrictionTypeSettings.get(index).element(by.css('.linestyledropdown'));
  }

  public selectedRestrictionTypeLineStyle(index: number): ElementFinder {
    return this.restrictionTypeSettings.get(index).element(by.css('.linestyledropdown option:checked'));
  }

  public async getRouteTypeName(index: number): Promise<string> {
    await this.componentLoad();
    await GeneralUtils.scrollToElement(this.routeTypeName(index));
    return this.routeTypeName(index).getText();
  }

  public routeTypeName(index: number): ElementFinder {
    return this.routeTypeSettings.get(index).element(by.css('.punctuality-name'));
  }

  public async getRouteTypeColour(index: number): Promise<string> {
    await this.componentLoad();
    return InputBox.waitAndGetTextOfInputBox(this.routeTypeColour(index));
  }

  public routeTypeColour(index: number): ElementFinder {
    return this.routeTypeSettings.get(index).element(by.css('[class=punctuality-colour][style^=background-color]'));
  }

  public async getRouteTypeLineWidth(index: number): Promise<string> {
    await this.componentLoad();
    return InputBox.waitAndGetTextOfInputBox(this.routeTypeLineWidth(index));
  }

  public routeTypeLineWidth(index: number): ElementFinder {
    return this.routeTypeSettings.get(index).element(by.css('[class^=punctuality-colour][type=number]'));
  }

  public async updateRouteTypeLineWidth(index: number, text: string): Promise<any> {
    return browser.executeScript(`document.querySelectorAll("#routeTypeSettings > div:nth-child(3) > input").item(${index}).value = '${text}'`);
  }

  public async getRouteTypeLineStyle(index: number): Promise<string> {
    await this.componentLoad();
    return SelectBox.getSelectedOption(this.routeTypeLineStyle(index));
  }

  public routeTypeLineStyle(index: number): ElementFinder {
    return this.routeTypeSettings.get(index).element(by.css('.linestyledropdown select'));
  }

  public async getPathTypeName(index: number): Promise<string> {
    await this.componentLoad();
    return CommonActions.waitAndGetText(this.pathTypeName(index));
  }

  public pathTypeName(index: number): ElementFinder {
    return this.pathTypeSettings.get(index).element(by.css('.punctuality-name'));
  }

  public async getPathTypeColour(index: number): Promise<string> {
    await this.componentLoad();
    return InputBox.waitAndGetTextOfInputBox(this.pathTypeColour(index));
  }

  public pathTypeColour(index: number): ElementFinder {
    return this.pathTypeSettings.get(index).element(by.css('[class=punctuality-colour][style^=background-color]'));
  }

  public async getPathTypeLineWidth(index: number): Promise<string> {
    await this.componentLoad();
    return InputBox.waitAndGetTextOfInputBox(this.pathTypeLineWidth(index));
  }

  public pathTypeLineWidth(index: number): ElementFinder {
    return this.pathTypeSettings.get(index).element(by.css('[class^=punctuality-colour][type=number]'));
  }

  public async updatePathTypeLineWidth(index: number, text: string): Promise<any> {
    return browser.executeScript(`document.querySelectorAll("#pathTypeSettings > div:nth-child(3) > input").item(${index}).value = '${text}'`);
  }

  public async getPathTypeLineStyle(index: number): Promise<string> {
    await this.componentLoad();
    return SelectBox.getSelectedOption(this.pathTypeLineStyle(index));
  }

  public pathTypeLineStyle(index: number): ElementFinder {
    return this.pathTypeSettings.get(index).element(by.css('.linestyledropdown select'));
  }

  public async getNoteTypeName(index: number): Promise<string> {
    await this.componentLoad();
    return CommonActions.waitAndGetText(this.noteTypeName(index));
  }

  public noteTypeName(index: number): ElementFinder {
    return this.noteSettings.get(index).element(by.css('.punctuality-name'));
  }

  public async getNoteTypeColour(index: number): Promise<string> {
    await this.componentLoad();
    return browser.executeScript(`return arguments[0].value`, this.noteTypeColour(index));
  }

  public noteTypeColour(index: number): ElementFinder {
    return this.noteSettings.get(index).element(by.css('[class=punctuality-colour][style^=background-color]'));
  }

  public async getNoteTypeLineWidth(index: number): Promise<string> {
    await this.componentLoad();
    return InputBox.waitAndGetTextOfInputBox(this.noteTypeLineWidth(index));
  }

  public noteTypeLineWidth(index: number): ElementFinder {
    return this.noteSettings.get(index).element(by.css('[class^=punctuality-colour][type=number]'));
  }

  public async updateNoteTypeLineWidth(index: number, text: string): Promise<any> {
    return browser.executeScript(`document.querySelectorAll("#noteSettings > div:nth-child(3) > input").item(${index}).value = '${text}'`);
  }

  public async getNoteTypeLineStyle(index: number): Promise<string> {
    await this.componentLoad();
    return SelectBox.getSelectedOption(this.noteTypeLineStyle(index));
  }

  public noteTypeLineStyle(index: number): ElementFinder {
    return this.noteSettings.get(index).element(by.css('.linestyledropdown select'));
  }
}
