import {by, element, ElementArrayFinder, ElementFinder} from 'protractor';
import {InputBox} from '../common/ui-element-handlers/inputBox';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';
import {CheckBox} from '../common/ui-element-handlers/checkBox';

export class TrainsListPunctualityConfigTab {
  public punctualityHeader: ElementFinder;
  public punctualityColor: ElementArrayFinder;
  public punctualityText: ElementArrayFinder;
  public fromTime: ElementFinder;
  public toTime: ElementFinder;
  public punctualityColourPicker: ElementFinder;
  public punctualityToggle: ElementArrayFinder;
  public incrementButtons: ElementArrayFinder;
  public decrementButtons: ElementArrayFinder;
  public includeExcludeToggle: ElementFinder;
  constructor() {
    this.punctualityHeader = element(by.css('#punctualityConfiguation .punctuality-header'));
    this.punctualityColor = element.all(by.css('#punctualityConfiguation [class=punctuality-colour][style]'));
    this.punctualityText = element.all(by.css('input[class*=punctuality-name]'));
    this.fromTime = element.all(by.css('section-name')).get(1).element(by.css('input'));
    this.toTime = element.all(by.css('section-name')).get(2).element(by.css('input'));
    this.punctualityColourPicker = element(by.css('div.color-picker.open .hex-text input'));
    this.punctualityToggle = element.all(by.css('#punctualityConfiguation app-toggle-menu label'));
    this.incrementButtons = element.all(by.css('.plus'));
    this.decrementButtons = element.all(by.css('.minus'));
    this.includeExcludeToggle = element(by.css('#punctuality-global-toggle-menu label'));
  }
  public async getTrainPunctualityHeader(): Promise<string> {
    return CommonActions.waitAndGetText(this.punctualityHeader);
  }
  public async clickPunctualityColourElement(index: number): Promise<void> {
    return CommonActions.waitAndClick(this.punctualityColor.get(index));
  }
  public async getTrainPunctualityColor(index): Promise<string> {
    return InputBox.waitAndGetTextOfInputBox(this.punctualityColor.get(index));
  }
  public async getTrainPunctualityColorFrmColourPicker(): Promise<string> {
    return InputBox.waitAndGetTextOfInputBox(this.punctualityColourPicker);
  }
  public async getTrainPunctualityText(index): Promise<string> {
    return InputBox.waitAndGetTextOfInputBox(this.punctualityText.get(index));
  }
  public async getPunctualityFromTime(index): Promise<string> {
    return InputBox.waitAndGetTextOfInputBox(this.punctualityFromTime(index));
  }
  public async getPunctualityToTime(index): Promise<string> {
    return InputBox.waitAndGetTextOfInputBox(this.punctualityToTime(index));
  }
  public async getPunctualityToggle(index: number): Promise<boolean> {
    const elm = this.punctualityToggle.get(index);
    return CheckBox.getToggleCurrentState(elm);
  }
  public async updatePunctualityColor(index: number, text: string): Promise<void> {
    return InputBox.updateColourPickerBox(this.punctualityColor.get(index), text);
  }
  public async updatePunctualityText(index: number, text: string): Promise<void> {
    await CommonActions.waitAndClick(this.punctualityText.get(index));
    return InputBox.updateInputBox(this.punctualityText.get(index), text);
  }
  public async updatePunctualityToggle(index: number, update: string): Promise<void> {
    return CheckBox.updateToggle(this.punctualityToggle.get(index), update);
  }
  public async toggleAllPunctualityToggles(state: string): Promise<void> {
    return this.punctualityToggle.each(async toggle => await CheckBox.updateToggle(toggle, state));
  }
  public async updatePunctualityFromTime(index: number, updateFrmTime: string): Promise<void> {
    return InputBox.updateNumberInputByCss(this.punctualityFromTimeCssText(index), updateFrmTime);
  }
  public async updatePunctualityToTime(index: number, updateFrmTime: string): Promise<void> {
    return InputBox.updateNumberInputByCss(this.punctualityToTimeCssText(index), updateFrmTime);
  }
  public async updatePunctualityTime(index: number, updateTime: string, fromOrTo: string): Promise<void> {
    if (updateTime !== '') {
      let currentTime = await this.getPunctualityFromTime(index);
      if (fromOrTo === 'toTime') {
        currentTime = await this.getPunctualityToTime(index);
      }
      const currentTimeVal = parseInt(currentTime, 10);
      const newTimeVal = parseInt(updateTime, 10);
      let targetAdjustButton = await this.getPuncAdjustButton(index + 1, fromOrTo, 'decrease');
      const adjustment = Math.abs(newTimeVal - currentTimeVal);
      if (newTimeVal > currentTimeVal) {
        targetAdjustButton = await this.getPuncAdjustButton(index + 1, fromOrTo, 'increase');
      }
      for (let i = 0; i < adjustment; i++) {
        await targetAdjustButton.click();
      }
    }
  }
  public async setTrainDisplayNameText(id: string, displayText: string): Promise<void> {
      await InputBox.updateInputBox(element(by.id(id)), displayText);
  }
  public async getTrainDisplayNameText(id: string): Promise<string> {
    return InputBox.waitAndGetTextOfInputBox(element(by.id(id)));
  }
  public async punctualityColourPickerIsDisplayed(): Promise<boolean> {
    return this.punctualityColourPicker.isDisplayed();
  }
  private punctualityFromTime(index: number): ElementFinder {
    const cssText: string = this.punctualityFromTimeCssText(index);
    return element(by.css(`${cssText}`));
  }
  private punctualityToTime(index: number): ElementFinder {
    const cssText: string = this.punctualityToTimeCssText(index);
    return element(by.css(`${cssText}`));
  }
  private punctualityFromTimeCssText(index: number): string {
    return `#punctuality-from-time-${index}`;
  }
  private punctualityToTimeCssText(index: number): string {
    return `#punctuality-to-time-${index}`;
  }

  public async getPuncAdjustButton(bandNum: number, upperOrLower: string, incOrDec: string): Promise<ElementFinder> {
    let operator = '+';
    let buttonNum = 1;
    if (incOrDec === 'decrease') {
      operator = '-';
    }
    if (upperOrLower === 'toTime') {
      buttonNum = 2;
    }
    const xPathLocator = `(//*[@id=\'punctualityConfiguation\']//div[contains(@class,\'col-grid\')][${bandNum}]//button[contains(.,\'${operator}\')])[${buttonNum}]`;
    return element(by.xpath(xPathLocator));
  }

  public async makeChange(change: any): Promise<void> {
    // expect change type to be edit - assert this
    if (change.type === 'edit') {
      const bandNumString: string = change.dataItem.replace('Band', '');
      const bandNum = parseInt(bandNumString, 10);
      if ((change.parameter === 'fromTime') || (change.parameter === 'toTime')) {
        const adjustmentString: string = change.newSetting;
        const operator = adjustmentString.substr(0, 1);
        const adjustment = parseInt(adjustmentString.substr(1), 10);
        let incOrDec = 'increase';
        if (operator === '-') {
          incOrDec = 'decrease';
        }
        const targetAdjustButton = await this.getPuncAdjustButton(bandNum, change.parameter, incOrDec);
        for (let i = 0; i < adjustment; i++) {
          await targetAdjustButton.click();
        }
      }
      else if (change.parameter === 'colour') {
        await this.updatePunctualityColor(bandNum, change.newSetting);
      }
      else if (change.parameter === 'name') {
        await this.updatePunctualityText(bandNum, change.newSetting);
      }
      else if (change.parameter === 'toggle') {
        await this.updatePunctualityToggle(bandNum, change.newSetting);
      }
      else {
        throw new Error(`Please check the parameter value in feature file`);
      }
    } else {
      throw new Error(`Please check the type value in feature file`);
    }
  }

  public async arePunctualityAdjustmentsAvailable(): Promise<boolean> {
    const numIncrementButtons = await this.incrementButtons.count();
    const numDecrementButtons = await this.decrementButtons.count();
    return ((numDecrementButtons > 0) && (numIncrementButtons > 0));
  }

  public async toggleIncludeExcludeAll(state: string): Promise<void> {
    await CheckBox.updateToggle(this.includeExcludeToggle, state);
  }
}
