import {by, element, ElementArrayFinder, ElementFinder} from 'protractor';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';
import {GeneralUtils} from '../common/utilities/generalUtils';

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
  public async selectedGridElementsDisplay(): Promise<boolean> {
    return this.trainListConfigSelectedSecondElements.first().isPresent();
  }
  public async getSecondElementInSelectedByIndex(index): Promise<string> {
    const indexForCss = index + 2;
    const elm: ElementFinder = element(by.css(`app-column-config .column-container-selected div:nth-child(${indexForCss}).col-grid div[class*=section-name]>span:nth-child(2)`));
    return CommonActions.waitAndGetText(elm);
  }

  public async openTab(tabId: string): Promise<void> {
    return CommonActions.waitAndClick(element(by.id(tabId)));
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
  } else if (arrowDir === 'left') {
    arrowDirForLocator = 'keyboard_arrow_left';
  } else if (arrowDir === 'right') {
    arrowDirForLocator = 'keyboard_arrow_right';
  }

  const elm: ElementFinder = element(by.xpath(`//div[@class='row col-grid' and .//text()='${itemName}']
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
  public async selectTrainConfigUnselectedItem(item: string): Promise<void> {
    await CommonActions.waitForElementToBeVisible(this.trainListConfigUnselected.first());
    const filteredElm: ElementFinder = await GeneralUtils.filterItemUsingMatchingText(this.trainListConfigUnselected, item);
    return filteredElm.click();
  }

  public async moveToSelectedList(entry: string, endPosition: number): Promise<void> {
  let currPosition = await this.findEntryInSelectedList(entry);

  // move to Selected list from Unselected list
  if (currPosition === -1) {
    await this.clickArrow('right', entry);
    currPosition = await this.findEntryInSelectedList(entry);
  }

  // if end position is requested move up or down the Selected list
  if (endPosition !== -1) {
    if (currPosition > endPosition) {
      const numClicks = currPosition - endPosition;
      for (let i = 0; i < numClicks; i++) {
        await this.clickArrow('up', entry);
      }
    }
    if (currPosition < endPosition) {
      const numClicks = endPosition - currPosition;
      for (let i = 0; i < numClicks; i++) {
        await this.clickArrow('down', entry);
      }
    }
  }
}

public async moveToUnSelectedList(entry: string): Promise<void> {
  await this.clickArrow('left', entry);
}

public async getSelectedEntries(): Promise<string[]> {
  const selectedEntries: ElementArrayFinder = element.all(by.xpath(`//div[contains(@class,'col-sm-9')]
    //span[not(contains(@class,'material-icons'))]`));
  return selectedEntries.map((itemValue: ElementFinder) => {
    return itemValue.getText();
});
}

public async findEntryInSelectedList(entry: string): Promise<number> {
  const selectedEntries: string[] = await this.getSelectedEntries();
  return selectedEntries.indexOf(entry, 0);
}

}
