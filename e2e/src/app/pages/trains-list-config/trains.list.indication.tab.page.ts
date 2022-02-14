import {browser, by, element, ElementFinder} from 'protractor';
import {TrainsListIndicationTable} from '../tables/trains-list-indication-table.page';
import {InputBox} from '../common/ui-element-handlers/inputBox';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';

export class TrainsListIndicationTabPage extends TrainsListIndicationTable {
public trainIndicationTabHeader: ElementFinder;
  constructor() {
    super(
    element.all(by.css('.indication-div-container .col-md-4:nth-child(1)')),
    element.all(by.css('.indication-div-container .toggle-switch >span:nth-child(3)')),
    element.all(by.css('.indication-div-container input[class*=punctuality-colour]')),
    element.all(by.css('.indication-div-container input[class*=punctuality-input]')),
      element(by.css('div.color-picker.open .hex-text input'))
  );
    this.trainIndicationTabHeader = element(by.css('#indication-div-container .punctuality-header'));
  }

  public async waitForIndicationData(): Promise<boolean> {
    await browser.wait(async () => {
      return element(by.id('indication-div-container')).isPresent();
    }, browser.params.general_timeout, 'The indication table should be displayed');
    return element(by.id('indication-div-container')).isPresent();
  }

  public async updateTrainIndicationColourMinutes(index: number, text: string): Promise<void> {
    const indexForSelector = index + 1;
    const selector = `.indication-div-container div:nth-child(${indexForSelector})[class*=row-background] input[class*=punctuality-input]`;
    return InputBox.updateNumberInputByCss(selector, text);
  }

  public async getTrainIndicationHeader(): Promise<string> {
    return CommonActions.waitAndGetText(this.trainIndicationTabHeader);
  }

  public async getValueAdjustButton(index: number, incOrDec: string): Promise<ElementFinder> {
    let operator = '+';
    if (incOrDec === 'decrease') {
      operator = '-';
    }
    const xPathLocator = `//div[contains(@class,'indication-div-container')] //div [${index}]//button[text()[contains(.,\'${operator}\')]]`;
    return element(by.xpath(xPathLocator));
  }

  public async makeChange(change: any): Promise<void> {
    if (change.type === 'edit') {
      const dataItemString: string = change.dataItem;
      if (!dataItemString.includes('Indicator')) {
        throw new Error(`Please check the dataItem value in feature file`);
      }
      const rowNumString: string = change.dataItem.replace('Indicator', '');
      const rowNum = parseInt(rowNumString, 10);
      if (change.parameter === 'colour') {
        await this.updateTrainIndicationColourText(rowNum, change.newSetting);
      }
      else if (change.parameter === 'toggle') {
        await this.updateTrainIndicationToggle(rowNum, change.newSetting);
      }
      else if (change.parameter === 'value') {
        const adjustmentString = change.newSetting;
        const operator = adjustmentString.substr(0, 1);
        const adjustment = parseInt(adjustmentString.substr(1), 10);
        let incOrDec = 'increase';
        if (operator === '-') {
          incOrDec = 'decrease';
        }
        const targetAdjustButton = await this.getValueAdjustButton(rowNum, incOrDec);
        for (let i = 0; i < adjustment; i++) {
          await targetAdjustButton.click();
        }
      } else {
        throw new Error(`Please check the parameter value in feature file`);
      }
    }
    else {
      throw new Error(`Please check the type value in feature file`);
    }
  }
}
