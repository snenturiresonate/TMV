import {by, element, ElementArrayFinder, ElementFinder} from 'protractor';

export class TrainsListConfigCommonPage {
  public trainListConfigSaveBtn: ElementArrayFinder;
  public trainListConfigResetBtn: ElementArrayFinder;
  public unsavedIndicators: ElementArrayFinder;
  public trainListConfigTitle: ElementFinder;
  constructor() {
    this.trainListConfigSaveBtn = element.all(by.cssContainingText('span', 'Save'));
    this.trainListConfigResetBtn = element.all(by.cssContainingText('Span', 'Reset'));
    this.unsavedIndicators = element.all(by.css('.unsaved'));
    this.trainListConfigTitle = element(by.css('.trains-list-userprefs-title'));
  }

  public async saveTrainListConfig(): Promise<void> {
    return this.findVisibleBtn(this.trainListConfigSaveBtn).click();
  }

  public async resetTrainListConfig(): Promise<void> {
    return this.findVisibleBtn(this.trainListConfigResetBtn).click();
  }
  public async isUnsaved(): Promise<boolean> {
    return (await this.unsavedIndicators.count() > 0);
  }

  public findVisibleBtn(btnLocator: ElementArrayFinder): ElementFinder {
    const filteredElmArray = btnLocator.filter(elm => {
      return elm.isDisplayed();
    });
    return filteredElmArray.first();
  }

  public async getConfigTitle(): Promise<string> {
    return this.trainListConfigTitle.getText();
  }
}
