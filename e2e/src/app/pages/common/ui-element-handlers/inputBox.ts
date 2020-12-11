import {ElementFinder} from 'protractor';
import {CommonActions} from '../ui-event-handlers/actionsAndWaits';

export class InputBox {

  /**
   * Updates an input box when the locator and update text are passed in.
   * Input: Location of <input> tag, Text to input
   */
  public static async updateInputBox(elm: ElementFinder, text: string): Promise <void> {
    await CommonActions.waitForElementInteraction(elm);
    await elm.clear();
    await elm.sendKeys(text);
  }

  /**
   * Waits for the Input Box to be ready for interaction and then gets the text.
   * Input: ElementFinder of the UI element to be clicked
   * Not to be used for elements other than input box
   */
  public static async waitAndGetTextOfInputBox(elm: ElementFinder): Promise<string> {
    await CommonActions.waitForElementInteraction(elm);
    return elm.getAttribute('value');
  }
}
