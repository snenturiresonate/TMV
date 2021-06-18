import {browser, ElementArrayFinder, ElementFinder} from 'protractor';

export class GeneralUtils {
  public static async convertToggleToBoolean(toggleUpdate: string): Promise<boolean> {
    return (toggleUpdate === 'on' || toggleUpdate === 'On');
  }

  public static async convertCheckboxSelectionToBoolean(selection: string): Promise<boolean> {
    return (selection === 'Checked' || selection === 'checked');
  }

  public static async scrollToElement(elm: ElementFinder): Promise<void> {
    return browser.actions().mouseMove(elm).perform();
  }

  public static async filterItemUsingMatchingText(elmArray: ElementArrayFinder, text: string): Promise<ElementFinder> {
    const matchingElmArray = elmArray.filter(elm => {
      return elm.getText().then(elmText => {
        return elmText === text;
      });
    });
    return matchingElmArray.first();
  }

}
