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
    browser.wait(async () => {
      return element(by.id('indication-div-container')).isPresent();
    }, browser.displayTimeout, 'The indication table should be displayed');
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
}
