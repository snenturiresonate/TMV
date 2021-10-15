import {browser, ElementFinder, ExpectedConditions, protractor} from 'protractor';
import {GeneralUtils} from '../utilities/generalUtils';
import {CucumberLog} from '../../../logging/cucumber-log';

export class CommonActions {
  /**
   * Waits for the element to be ready for interaction and then clicks it.
   * Input: ElementFinder of the UI element to be clicked
   */
  public static async waitAndClick(elm: ElementFinder): Promise<void> {
    await this.waitForElementInteraction(elm);
    await GeneralUtils.scrollToElement(elm);
    await elm.click();
  }

  /**
   * Waits for the element to be ready for interaction and then gets the text.
   * Input: ElementFinder of the UI element to get text from
   * Not to be used for input box
   */
  public static async waitAndGetText(elm: ElementFinder): Promise<string> {
    await this.waitForElementInteraction(elm);
    await GeneralUtils.scrollToElement(elm);
    return elm.getText();
  }

  /**
   * Waits for the element to be ready for interaction.
   * Input: ElementFinder of the UI element to be interacted
   */
  public static async waitForElementInteraction(elm: ElementFinder): Promise<void> {
    const EC = protractor.ExpectedConditions;
    const elementVisible = EC.visibilityOf(elm);
    const elementIntractable = EC.elementToBeClickable(elm);
    await browser.wait(EC.and(elementVisible, elementIntractable));
  }

  /**
   * Waits for the element to be visible.
   * Input: ElementFinder of the UI element to be visible
   */
  public static async waitForElementToBeVisible(elm: ElementFinder, timeout = browser.displayTimeout): Promise<void> {
    const EC = protractor.ExpectedConditions;
    await browser.wait(EC.visibilityOf(elm), timeout);
  }

  /**
   * Waits for the element to be present.
   * Input: ElementFinder of the UI element to be present
   */
  public static async waitForElementToBePresent(elm: ElementFinder, timeout?: number, message?: string): Promise<void> {
    await browser.wait(ExpectedConditions.presenceOf(elm), timeout, message);
  }

  /**
   * Waits for the element to disappear.
   * Input: ElementFinder of the UI element to wait for disappearance
   */
  public static async waitForElementToDisappear(elm: ElementFinder): Promise<void> {
    const EC = protractor.ExpectedConditions;
    await browser.wait(EC.invisibilityOf(elm));
  }

  /**
   * Waits for the result of a function to equal an expected condition
   * passed in function cannot contain a this. reference or it will end up with a undefined error
   */
  public static async waitForFunctionalStringResult(func, argument, result: string): Promise<string> {
    browser.wait(async (): Promise<boolean> => {
      let actual: string;
      if (argument === null) {
        actual = await func();
      }
      else {
        actual = await func(argument);
      }
      return actual === result;
    }, 30 * 1000, 'The functional result was not achieved within the given timeout')
      .catch(reason => CucumberLog.addText(reason.message));
    return func(argument);
  }
}
