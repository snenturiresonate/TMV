import {by, element, ElementArrayFinder, ElementFinder} from 'protractor';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';

export class TrainsListConfigCommonPage {
  public trainListConfigSaveBtn: ElementArrayFinder;
  public trainListConfigResetBtn: ElementArrayFinder;
  constructor() {
    this.trainListConfigSaveBtn = element.all(by.cssContainingText('span', 'Save'));
    this.trainListConfigResetBtn = element.all(by.cssContainingText('Span', 'Reset'));
  }

  public async saveTrainListConfig(): Promise<void> {
    return this.findVisibleBtn(this.trainListConfigSaveBtn).click();
  }

  public async resetTrainListConfig(): Promise<void> {
    return this.findVisibleBtn(this.trainListConfigResetBtn).click();
  }

  public findVisibleBtn(btnLocator: ElementArrayFinder): ElementFinder {
    const filteredElmArray = btnLocator.filter(elm => {
      return elm.isDisplayed();
    });
    return filteredElmArray.first();
  }
}
