import {by, element, ElementArrayFinder, ElementFinder} from 'protractor';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';

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
  public async getFirstElementInSelectedGridByIndex(index): Promise<string> {
    const indexForCss = index + 2;
    const elm: ElementFinder = element(by.css(`app-column-config .column-container-selected div:nth-child(${indexForCss}).col-grid div[class*=section-name]>span:nth-child(1)`));
    return CommonActions.waitAndGetText(elm);
  }
  public async getSecondElementsInSelectedGrid(): Promise<string> {
    return this.trainListConfigSelectedSecondElements.getText();
  }
  public async getSecondElementInSelectedByIndex(index): Promise<string> {
    const indexForCss = index + 2;
    const elm: ElementFinder = element(by.css(`app-column-config .column-container-selected div:nth-child(${indexForCss}).col-grid div[class*=section-name]>span:nth-child(2)`));
    return CommonActions.waitAndGetText(elm);
  }

  public async openTab(tabId: string): Promise<void> {
    return element(by.id(tabId)).click();
  }

  public async clickArrowUpDown(position: number): Promise<void> {
    const arrows = this.arrowsUpDown;
    await arrows.get(position - 1).click();
  }

  public async clickArrow(arrowDir: string, itemName: string): Promise<void> {
    let arrowDirForLocator;
    if (arrowDir.toLowerCase() === 'up') {
      arrowDirForLocator = 'keyboard_arrow_up';
    } else if (arrowDir.toLowerCase() === 'down' || arrowDir === 'dn') {
      arrowDirForLocator = 'keyboard_arrow_down';
    }
    const elm: ElementFinder = element(by.xpath(`//*[contains(@class,'column-container-selected')]
    //div[@class='row col-grid' and contains(.,'${itemName}')]//div[contains(@class,'col-sm-6')]
    //span[contains(.,'${arrowDirForLocator}')]`));
    await CommonActions.waitAndClick(elm);
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
