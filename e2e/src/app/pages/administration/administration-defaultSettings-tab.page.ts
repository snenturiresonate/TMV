import {browser, by, element, ElementArrayFinder, ElementFinder, protractor} from 'protractor';
import {InputBox} from '../common/ui-element-handlers/inputBox';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';

export class AdministrationDefaultSettingsTab {
  public userSettingsTab: ElementFinder;
  public defaultCols: ElementArrayFinder;
  public replayBackgroundColor: ElementFinder;
  public noOfReplays: ElementFinder;
  public schematicMapInstance: ElementFinder;
  public trainListInstance: ElementFinder;
  public maxNoOfMapsPerReplay: ElementFinder;
  public saveBtn: ElementFinder;
  public resetBtn: ElementFinder;
  constructor() {
    this.userSettingsTab = element(by.css('#Users'));
    this.defaultCols = element.all(by.css('#linestatus-div-container .noteapplied'));
    this.replayBackgroundColor = element(by.css('#replayBackgroundColour .punctuality-colour'));
    this.noOfReplays = element(by.css('#maxNumberofReplays input'));
    this.schematicMapInstance = element(by.css('#maxNumberofSchematicMapDisplayInstances input'));
    this.trainListInstance = element(by.css('#maxNumberofTrainsListViewInstances input'));
    this.maxNoOfMapsPerReplay = element(by.css('#maxNumberofMapsPerReplaySession input'));
    this.saveBtn = element(by.css('#saveDefaultsConfig'));
    this.resetBtn = element(by.css('#resetDefaultsConfig'));
  }

  public async getColumns(): Promise<string> {
    return this.defaultCols.getText();
  }
  public async getUserTabValue(): Promise<string> {
    return this.userSettingsTab.getText();
  }

  public async getSettingCount(): Promise<number> {
    return this.defaultCols.count();
  }

  public async getReplayValue(replayType: string): Promise<string> {
    if (replayType === 'Replay Background Colour') {
      return this.replayBackgroundColor.getCssValue('background-color');
    }
    if (replayType === 'No of Replays'){
      return this.noOfReplays.getAttribute('ng-reflect-model');
    }
    if (replayType === 'Schematic Map Instance'){
      return this.schematicMapInstance.getAttribute('ng-reflect-model');
    }
    if (replayType === 'Trains List View Instances'){
      return this.trainListInstance.getAttribute('ng-reflect-model');
    }
  }

  public async getReplayBackgroundColour(): Promise<string> {
    return InputBox.waitAndGetTextOfInputBox(this.replayBackgroundColor);
  }

  public async getNoOfReplays(): Promise<string> {
    return InputBox.waitAndGetTextOfInputBox(this.noOfReplays);
  }

  public async getSchematicMapInstance(): Promise<string> {
    return InputBox.waitAndGetTextOfInputBox(this.schematicMapInstance);
  }

  public async getTrainListInstance(): Promise<string> {
    return InputBox.waitAndGetTextOfInputBox(this.trainListInstance);
  }

  public async getMaxNoOfMapsPerReplay(): Promise<string> {
    return InputBox.waitAndGetTextOfInputBox(this.maxNoOfMapsPerReplay);
  }

  public async updateReplayBackgroundColour(text: string): Promise<void> {
    await InputBox.updateColourPickerBox(this.replayBackgroundColor, text);
  }

  public async updateNoOfReplays(text: string): Promise<void> {
    await CommonActions.waitForElementInteraction(this.noOfReplays);
    await browser.executeScript(`document.querySelector('#maxNumberofReplays input').value = '${text}'`);
  }

  public async updateSchematicMapInstance(text: string): Promise<void> {
    await CommonActions.waitForElementInteraction(this.schematicMapInstance);
    await browser.executeScript(`document.querySelector('#maxNumberofSchematicMapDisplayInstances input').value = '${text}'`);
  }

  public async updateTrainListInstance(text: string): Promise<void> {
    await CommonActions.waitForElementInteraction(this.trainListInstance);
    await browser.executeScript(`document.querySelector('#maxNumberofTrainsListViewInstances input').value = '${text}'`);
  }

  public async updateMaxNoOfMapsPerReplay(text: string): Promise<void> {
    await CommonActions.waitForElementInteraction(this.maxNoOfMapsPerReplay);
    await browser.executeScript(`document.querySelector('#maxNumberofMapsPerReplaySession input').value = '${text}'`);
  }

  public async updateSetting(setting: string, value: string): Promise<void> {
    const settingInputElement: ElementFinder = element(by.xpath(`//div[text()='${setting}']/following-sibling::div/input`));
    await InputBox.updateInputBoxAndTabOut(settingInputElement, value);
  }

  public async getSettingValue(setting: string): Promise<string> {
    const settingInputElement: ElementFinder = element(by.xpath(`//div[text()='${setting}']/following-sibling::div/input`));
    return InputBox.waitAndGetTextOfInputBox(settingInputElement);
  }

  public async clickSaveButton(): Promise<void> {
    return CommonActions.waitAndClick(this.saveBtn);
  }

  public async clickResetButton(): Promise<void> {
    return CommonActions.waitAndClick(this.resetBtn);
  }

  public async fieldIsEditable(fieldName: string): Promise<boolean> {
    let returnValue;
    switch (fieldName){
      case 'Maximum Number of Maps Per Replay Session':
        returnValue = await InputBox.isInputBoxEnabled(this.maxNoOfMapsPerReplay);
        break;
      case 'Maximum Number of Replays':
        returnValue = await InputBox.isInputBoxEnabled(this.noOfReplays);
        break;
      case 'Maximum Number of Schematic Map Display Instances':
        returnValue = await InputBox.isInputBoxEnabled(this.schematicMapInstance);
        break;
      case 'Maximum Number of Trains List View Instances':
        returnValue = await InputBox.isInputBoxEnabled(this.trainListInstance);
        break;
      case 'Replay Background Colour':
        returnValue = await InputBox.isInputBoxEnabled(this.replayBackgroundColor);
        break;
    }
    return returnValue;
  }

  public async getValueAdjustButton(setting: string, incOrDec: string): Promise<ElementFinder> {
    let operator = '+';
    if (incOrDec === 'decrease') {
      operator = '-';
    }
    const xPathLocator = `//div[text()='${setting}']/following-sibling::div/button[text()[contains(.,'${operator}')]]`;
    return element(by.xpath(xPathLocator));
  }

  public async setValue(setting: string, newValue: number): Promise<void> {
    const currentValueString = await this.getSettingValue(setting);
    const currentValue = parseInt(currentValueString, 10);
    let adjustButton = await this.getValueAdjustButton(setting, 'increase');
    if (currentValue > newValue) {
      adjustButton = await this.getValueAdjustButton(setting, 'decrease');
    }
    const numAdjustments = Math.abs(currentValue - newValue);
    for (let i = 0; i < numAdjustments; i++) {
      await adjustButton.click();
    }
  }

}
