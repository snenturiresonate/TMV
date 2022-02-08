import {browser, by, element, ElementArrayFinder, ElementFinder, protractor} from 'protractor';
import {InputBox} from '../common/ui-element-handlers/inputBox';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';

export class AdminPunctualityConfigTab {
  public punctualityConfig: ElementFinder;
  public punctualityRow: ElementArrayFinder;
  public punctualityColor: ElementArrayFinder;
  public punctualityText: ElementArrayFinder;
  public trainIndicationHeader: ElementFinder;
  public saveButton: ElementFinder;
  public resetButton: ElementFinder;
  public addTimeBand: ElementFinder;
  public deleteTimeBand: ElementArrayFinder;
  public fromTime: ElementArrayFinder;
  public toTime: ElementArrayFinder;
  public incrementButtons: ElementArrayFinder;
  public decrementButtons: ElementArrayFinder;

  public rowName: ElementArrayFinder;
  public classToggle: ElementArrayFinder;
  public colourText: ElementArrayFinder;
  public minutesText: ElementArrayFinder;

  constructor() {
    this.punctualityConfig = element(by.css('#punctualityConfiguration'));
    this.punctualityRow = element.all(by.css('#punctualityConfiguration .row.col-grid'));
    this.punctualityColor = element.all(by.css('.punctuality-colour'));
    this.trainIndicationHeader = element(by.css('#indication-div-container >div:nth-child(1)>div'));
    this.punctualityText = element.all(by.css('input[class*=punctuality-name]'));
    this.addTimeBand = element(by.css('#add-punctuality-btn'));
    this.deleteTimeBand = element.all(by.css('.remove-punctuality-btn'));
    this.fromTime = element.all(by.css('[id*=fromPunctuality]'));
    this.toTime = element.all(by.css('[id*=toPunctuality]'));
    this.saveButton = element(by.css('#saveDisplayConfig'));
    this.resetButton = element(by.css('#resetDisplayConfig'));
    this.incrementButtons = element.all(by.xpath('//*[@id=\'punctualityConfiguration\']//button[text()[contains(.,\'+\')]]'));
    this.decrementButtons = element.all(by.xpath('//*[@id=\'punctualityConfiguration\']//button[text()[contains(.,\'-\')]]'));
    this.rowName = element.all(by.css('#indication-div-container .row .col-md-4.punctuality-name'));
    this.classToggle = element.all(by.css('#indication-div-container .toggle-switch'));
    this.colourText = element.all(by.css('#indication-div-container .row .punctuality-colour'));
    this.minutesText = element.all(by.css('#indication-div-container .row .punctuality-input'));

  }
  public async pageLoad(): Promise<void> {
    const EC = protractor.ExpectedConditions;
    await browser.wait(EC.presenceOf(this.punctualityConfig));
  }
  public async getTrainIndicationHeader(): Promise<string> {
    return this.trainIndicationHeader.getText();
  }
  public async openTab(tabId: string): Promise<void> {
    return element(by.id(tabId)).click();
  }

  public async getAdminPunctualityColor(index: number): Promise<string> {
    // Implemented using Xpath to avoid multiple element warnings thrown for Locator chaining method
    const indexForXpath = index + 1;
    const xpathForElm: ElementFinder =
      element(by.xpath(`//*[@id='punctualityConfiguration']//*[@class = 'row col-grid']
          [${indexForXpath}]//*[@class='punctuality-colour']`));
    return InputBox.waitAndGetTextOfInputBox(xpathForElm);
  }

  public async updateAdminPunctualityColour(index: number, text: string): Promise<void> {
    // Implemented using Xpath to avoid multiple element warnings thrown for Locator chaining method
    const indexForXpath = index + 1;
    const xpathForElm: ElementFinder =
      element(by.xpath(`//*[@id='punctualityConfiguration']//*[@class = 'row col-grid']
          [${indexForXpath}]//*[@class='punctuality-colour']`));
    return InputBox.updateColourPickerBox(xpathForElm, text);
  }

  public async getAdminPunctualityText(index: number): Promise<string> {
    return browser.executeScript(`return arguments[0].value`, this.punctualityText.get(index));
  }

  public async updateAdminPunctualityText(index: number, text: string): Promise<void> {
    const elm: ElementFinder = this.punctualityText.get(index);
    return InputBox.updateInputBox(elm, text);
  }

  public async getAdminPunctualityFromTime(index: number): Promise<string> {
    return browser.executeScript(`return arguments[0].value`, this.fromTime.get(index));
  }

  public async updateAdminPunctualityFromTime(index: number, text: string): Promise<void> {
    const id = `fromPunctuality-${index}`;
    return InputBox.updateNumberInputById(id, text);
  }

  public async getAdminPunctualityToTime(index: number): Promise<string> {
    return browser.executeScript(`return arguments[0].value`, this.toTime.get(index));
  }

  public async updateAdminPunctualityToTime(index: number, text: string): Promise<void> {
    const id = `toPunctuality-${index}`;
    return InputBox.updateNumberInputById(id, text);
  }

  public async clickAddTimeBand(): Promise<void> {
    return this.addTimeBand.click();
  }

  public async deleteFirstTimeBand(): Promise<void> {
    return CommonActions.waitAndClick(this.deleteTimeBand.first());
  }

  public async getCountOfPunctualityBands(): Promise<number> {
    return this.punctualityText.count();
  }

  public async addTimeBandsButtonIsVisible(): Promise<boolean> {
    return this.addTimeBand.isPresent();
  }

  public async arePunctualityAdjustmentsAvailable(): Promise<boolean> {
    const numIncrementButtons = await this.incrementButtons.count();
    const numDecrementButtons = await this.decrementButtons.count();
    return ((numDecrementButtons > 0) && (numIncrementButtons > 0));
  }

  public async getPuncAdjustButton(bandNum: number, upperOrLower: string, incOrDec: string): Promise<ElementFinder> {
    let operator = '+';
    let buttonNum = 1;
    if (incOrDec === 'decrease') {
      operator = '-';
    }
    if (upperOrLower === 'upper') {
      buttonNum = 2;
    }
    const xPathLocator = `(//*[@id=\'punctualityConfiguration\']//div[contains(@class,\'col-grid\')][${bandNum}]//button[text()[contains(.,\'${operator}\')]])[${buttonNum}]`;
    return element(by.xpath(xPathLocator));
  }

  public async updateDisplayName(displayName: string): Promise<void> {
    const elmToUpdate: ElementFinder = this.punctualityText.get(0);
    await elmToUpdate.clear();
    await elmToUpdate.sendKeys(displayName);
  }

  public async clickSaveButton(): Promise<void> {
    await this.saveButton.click();
  }

  public async clickResetButton(): Promise<void> {
    await this.resetButton.click();
  }

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
    await InputBox.updateColourPickerBox(elm, text);
  }

  public async updateTrainIndicationColourMinutes(index: number, text: string): Promise<void> {
    // Not the preferred element selection method. To be refactored if possible.
    const indexForSelector = index + 2;
    const selector = `#indication-div-container > div:nth-child(${indexForSelector}) > div:nth-child(4) > input`;
    return InputBox.updateNumberInputByCss(selector, text);
  }

  public async getTrainIndicationColourMinutes(index: number): Promise<string> {
    return this.minutesText.get(index) ? browser.executeScript(`return arguments[0].value`, this.minutesText.get(index)) : null;
  }

  public async isClassToggleSelected(index: number): Promise<boolean> {
    return this.classToggle.get(index).element(by.css(`[type='checkbox']`)).isSelected();
  }

  public async scrollToElement(elm: ElementFinder): Promise<void> {
    return browser.actions().mouseMove(elm).perform();
  }

  public async headerTextIsDisplayed(header: string): Promise<boolean> {
    const elm: ElementFinder = element(by.cssContainingText(`.header.section-name`, `${header}`));
    return elm.isDisplayed();
  }
}
