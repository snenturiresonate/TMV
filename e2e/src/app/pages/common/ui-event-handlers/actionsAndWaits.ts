import {browser, ElementFinder, protractor} from 'protractor';
import {GeneralUtils} from '../utilities/generalUtils';

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
  public static async waitForElementToBeVisible(elm: ElementFinder): Promise<void> {
    const EC = protractor.ExpectedConditions;
    await browser.wait(EC.visibilityOf(elm));
  }

  /**
   * Waits for the element to disappear.
   * Input: ElementFinder of the UI element to wait for disappearance
   */
  public static async waitForElementToDisappear(elm: ElementFinder): Promise<void> {
    const EC = protractor.ExpectedConditions;
    await browser.wait(EC.invisibilityOf(elm));
  }
}
