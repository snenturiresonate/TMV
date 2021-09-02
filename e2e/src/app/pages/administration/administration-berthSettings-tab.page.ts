import {browser, by, element, ElementArrayFinder, ElementFinder, protractor} from 'protractor';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';
import {InputBox} from '../common/ui-element-handlers/inputBox';

export class AdministrationBerthSettingsTab {
  public berthSettingsContainer: ElementFinder;
  public berthSettingsRow: ElementArrayFinder;
  constructor() {
    this.berthSettingsContainer = element(by.css('app-berth-settings #berth-settings-continer'));
    this.berthSettingsRow = element.all(by.css('#berth-settings-continer .row.col-grid'));
  }

  public async berthSettingsAppLoad(): Promise<void> {
    const EC = protractor.ExpectedConditions;
    await browser.wait(EC.presenceOf(this.berthSettingsContainer));
  }

  public async getPunctualityName(index: number): Promise<string> {
    const elm: ElementFinder = this.berthSettingsRow.get(index).element(by.css('.col-md-4.punctuality-name'));
    await this.berthSettingsAppLoad();
    return CommonActions.waitAndGetText(elm);
  }

  public async getPunctualityColour(index: number): Promise<string> {
    const elm: ElementFinder = this.berthSettingsRow.get(index).element(by.css('.punctuality-colour'));
    await this.berthSettingsAppLoad();
    return InputBox.waitAndGetTextOfInputBox(elm);
  }

  public async updatePunctualityColour(index: number, text: string): Promise<void> {
    const elm: ElementFinder = this.berthSettingsRow.get(index).element(by.css('.punctuality-colour'));
    await this.berthSettingsAppLoad();
    return InputBox.updateColourPickerBox(elm, text);
  }
}
