import {browser, by, ElementFinder} from 'protractor';
import {GeneralUtils} from '../utilities/generalUtils';
import {CommonActions} from '../ui-event-handlers/actionsAndWaits';

export class SelectBox {

  /**
   *  Returns selected value from a dropdown. Input: Location of <select> tag
   */
  public static async getSelectedOption(elm: ElementFinder): Promise<string> {
    await CommonActions.waitForElementToBeVisible(elm);
    await GeneralUtils.scrollToElement(elm);
    return browser.executeScript(`return arguments[0].value`, elm);
  }

  /**
   *  Selects value from a dropdown by visible text.
   *  Input: Location of <select> tag, option to be selected
   */
  public static async selectByVisibleText(elm: ElementFinder, selection: string): Promise<void> {
    await CommonActions.waitForElementToBeVisible(elm);
    await GeneralUtils.scrollToElement(elm);
    return elm.element(by.css(`option[label='${selection}']`)).click();
  }
}
