import {by, element, ElementArrayFinder, ElementFinder} from 'protractor';
import {InputBox} from '../common/ui-element-handlers/inputBox';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';
import {CheckBox} from '../common/ui-element-handlers/checkBox';
import {of} from 'rxjs';

export class TrainsListPunctualityConfigTab {
  public punctualityHeader: ElementFinder;
  public punctualityColor: ElementArrayFinder;
  public punctualityText: ElementArrayFinder;
  public fromTime: ElementFinder;
  public toTime: ElementFinder;
  public punctualityColourPicker: ElementFinder;
  public punctualityToggle: ElementArrayFinder;
  constructor() {
    this.punctualityHeader = element(by.css('#punctualityConfiguation .punctuality-header'));
    this.punctualityColor = element.all(by.css('#punctualityConfiguation [class=punctuality-colour][style]'));
    this.punctualityText = element.all(by.css('input[class*=punctuality-name]'));
    this.fromTime = element.all(by.css('section-name')).get(1).element(by.css('input'));
    this.toTime = element.all(by.css('section-name')).get(2).element(by.css('input'));
    this.punctualityColourPicker = element(by.css('div.color-picker.open .hex-text input'));
    this.punctualityToggle = element.all(by.css('#punctualityConfiguation app-toggle-menu label'));
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
    return InputBox.updateInputBox(this.punctualityColor.get(index), text);
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
}
