import {browser, ElementFinder, protractor} from 'protractor';
import {CommonActions} from '../ui-event-handlers/actionsAndWaits';
import {GeneralUtils} from '../utilities/generalUtils';

export class InputBox {

  /**
   * Updates an input box when the locator and update text are passed in.
   * Input: Location of <input> tag, Text to input
   */
  public static async updateInputBox(elm: ElementFinder, text: string): Promise<void> {
    await CommonActions.waitForElementInteraction(elm);
    await GeneralUtils.scrollToElement(elm);
    await elm.clear();
    await elm.sendKeys(text);
  }

  /**
   * Updates an input box of type number (ones with increment and decrement arrows) when the 'id' and update text are passed in.
   * Input: Id attribute of <input> tag, Text to input
   */
  public static async updateNumberInputById(id: string, text: string): Promise<void> {
    const script = `document.getElementById('${id}').value = '${text}'`;
    return browser.executeScript(script);
  }

  /**
   * Updates an input box of type number (ones with increment and decrement arrows) when the 'css' and update text are passed in.
   * Input: CSS of <input> tag, Text to input
   */
  public static async updateNumberInputByCss(CSS: string, text: string): Promise<void> {
    return browser.executeScript(`document.querySelector('${CSS}').value = '${text}'`);
  }

  /**
   * Waits for the Input Box to be ready for interaction and then gets the text.
   * Input: ElementFinder of the UI element to be clicked
   * Not to be used for elements other than input box
   */
  public static async waitAndGetTextOfInputBox(elm: ElementFinder): Promise<string> {
    await CommonActions.waitForElementInteraction(elm);
    return browser.executeScript(`return arguments[0].value`, elm);
  }

  /**
   * Updates a colour input box when the locator and update text are passed in.
   * To be used wherever the open colour-picker shadows over other web-element interactions
   * Input: Location of <input> tag, Text to input
   */
  public static async updateColourPickerBox(elm: ElementFinder, text: string): Promise<void> {
    await CommonActions.waitForElementInteraction(elm);
    await GeneralUtils.scrollToElement(elm);
    await elm.clear();
    await elm.sendKeys(text);
    await elm.sendKeys(protractor.Key.TAB);
    await elm.sendKeys(protractor.Key.ENTER);
  }

  /**
   * Returns a boolean if an input box is enabled.
   * Input: Location of <input> tag, Text to input
   * Return: true (if Enabled), False (if Disabled)
   */
  public static async isInputBoxEnabled(elm: ElementFinder): Promise<boolean> {
    await CommonActions.waitForElementInteraction(elm);
    await GeneralUtils.scrollToElement(elm);
    return elm.isEnabled();
  }

  /**
   * Returns the background colour of a colour picker input box.
   * Input: Location of <input> tag, Text to input
   * Return: Background colour CSS property
   */
  public static async getBackgroundColour(elm: ElementFinder): Promise<any> {
    await CommonActions.waitForElementInteraction(elm);
    await GeneralUtils.scrollToElement(elm);
    return elm.getCssValue('background-color');
  }
  /**
   * for when .clear() just isn't working
   * This can be when the <input> tag has an onBlur event associated with it (i.e. JS validation)
   * https://stackoverflow.com/questions/19966240/protractor-clear-not-working
   * Input: Location of <input> tag
   */
  public static async ctrlADeleteClear(elm: ElementFinder): Promise<void> {
    const platformControlKey = await this.getControlKeyForPlatform();
    await elm.sendKeys(protractor.Key.chord(platformControlKey, 'a'));
    await elm.sendKeys(protractor.Key.DELETE);
  }
  /**
   * Determine the control key for the platform
   */
  public static async getControlKeyForPlatform(): Promise<string> {
    const caps = await browser.getCapabilities();
    const platform = caps.get('platform');
    const isMac = /^mac/.test(platform.toLowerCase());
    return isMac ? protractor.Key.COMMAND : protractor.Key.CONTROL;
  }
}
