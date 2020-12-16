import {by, element, ElementArrayFinder} from 'protractor';

export abstract class TrainsListConfigMultiSelectListPageObject {

  constructor(public trainListConfigTabs: ElementArrayFinder,
              public trainListConfig: ElementArrayFinder,
              public trainListConfigUnselected: ElementArrayFinder,
              public trainListConfigSelectedSecondElements: ElementArrayFinder,
              public arrowsUpDown: ElementArrayFinder,
              public configUnSelectedArrow: ElementArrayFinder,
              public trainListConfigSelectedFirstElements: ElementArrayFinder) {
  }

  public async getTrainListConfigTab(): Promise<string> {
    return this.trainListConfigTabs.getText();
  }
  public async getTrainListConfigColumn(): Promise<string> {
    return this.trainListConfig.getText();
  }
  public async getTrainConfigUnselected(): Promise<string> {
    return this.trainListConfigUnselected.getText();
  }
  public async getConfigUnselectedArrow(): Promise<string> {
    return this.configUnSelectedArrow.getText();
  }
  public async getFirstElementsInSelectedGrid(): Promise<string> {
    return this.trainListConfigSelectedFirstElements.getText();
  }
  public async getSecondElementsInSelectedGrid(): Promise<string> {
    return this.trainListConfigSelectedSecondElements.getText();
  }

  public async openTab(tabId: string): Promise<void> {
    return element(by.id(tabId)).click();
  }

  public async clickArrowUpDown(position: number): Promise<void> {
    const arrows = this.arrowsUpDown;
    await arrows.get(position - 1).click();
  }

  public async clickArrowRight(position: number): Promise<void> {
    const arrows = this.configUnSelectedArrow;
    await arrows.get(position - 1).click();
  }

  public async clickArrowLeft(position: number): Promise<void> {
    const arrows = this.trainListConfigSelectedFirstElements;
    await arrows.get(position - 1).click();
  }
}
