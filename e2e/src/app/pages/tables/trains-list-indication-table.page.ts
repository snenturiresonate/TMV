import {InputBox} from '../common/ui-element-handlers/inputBox';
import {browser, by, element, ElementArrayFinder, ElementFinder} from 'protractor';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';

export abstract class TrainsListIndicationTable {
  constructor(
    public rowName: ElementArrayFinder,
    public classToggle: ElementArrayFinder,
    public colourText: ElementArrayFinder,
    public minutesText: ElementArrayFinder,
    public colourPicker: ElementFinder
  ){}
  public async getTrainIndicationRowName(index: number): Promise<string> {
    return this.rowName.get(index).getText();
  }

  public async getTrainIndicationClassToggle(index: number): Promise<string> {
    return this.classToggle.get(index).getText();
  }

  public async toggleTrainIndicationClassToggle(index: number): Promise<void> {
    await this.scrollToElement(this.classToggle.get(index));
    return this.classToggle.get(index).click();
  }

  public async getTrainIndicationColourText(index: number): Promise<string> {
    const elm = this.colourText.get(index);
    return InputBox.waitAndGetTextOfInputBox(elm);
  }

  public async updateTrainIndicationColourText(index: number, text: string): Promise<void> {
    const elm: ElementFinder = this.colourText.get(index);
    await this.scrollToElement(elm);
    await InputBox.updateColourPickerBoxViaPicker(elm, text);
  }

  public async updateTrainIndicationColourTextOfSetting(name: string, text: string): Promise<void> {
    const elm: ElementFinder = this.getSettingRow(name).element(by.css('.punctuality-colour'));
    await this.scrollToElement(elm);
    await InputBox.updateColourPickerBoxViaPicker(elm, text);
  }

  public getSettingRow(name: string): ElementFinder {
    return element(by.cssContainingText('#indication-div-container div.row', `${name}`));
  }

  public async getTrainIndicationColourMinutes(index: number): Promise<string> {
    return this.minutesText.get(index) ? browser.executeScript(`return arguments[0].value`, this.minutesText.get(index)) : null;
  }
  public async scrollToElement(elm: ElementFinder): Promise<void> {
    return browser.actions().mouseMove(elm).perform();
  }

  public async updateTrainIndicationToggle(index: number, update: string): Promise<void> {
    const selectUpdate: boolean = await this.convertToggleToBoolean(update);
    const currentSelection: string = await this.getTrainIndicationClassToggle(index);
    const currentSelectionToBoolean: boolean = await this.convertToggleToBoolean(currentSelection);

    if (selectUpdate !== currentSelectionToBoolean) {
      return this.toggleTrainIndicationClassToggle(index);
    } else {
      return;
    }
  }

  public async updateTrainIndicationToggleOfSetting(name: string, update: string): Promise<void> {
    const toggleElm = this.getSettingRow(name).element(by.css('.toggle-switch span:nth-child(3)'));
    const selectUpdate: boolean = await this.convertToggleToBoolean(update);
    const currentSelection: string = await toggleElm.getText();
    const currentSelectionToBoolean: boolean = await this.convertToggleToBoolean(currentSelection);

    if (selectUpdate !== currentSelectionToBoolean) {
      return toggleElm.click();
    } else {
      return;
    }
  }

  public async convertToggleToBoolean(toggleUpdate: string): Promise<boolean> {
    return (toggleUpdate === 'on' || toggleUpdate === 'On');
  }

  public async clickTrainIndicationColourElement(index): Promise<void> {
    return CommonActions.waitAndClick(this.colourText.get(index));
  }

  public async colourPickerIsDisplayed(): Promise<boolean> {
    return this.colourPicker.isDisplayed();
  }

}
