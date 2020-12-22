import {browser, ElementFinder} from 'protractor';

export class GeneralUtils {
  public static async convertToggleToBoolean(toggleUpdate: string): Promise<boolean> {
    return (toggleUpdate === 'on' || toggleUpdate === 'On');
  }

  public static async scrollToElement(elm: ElementFinder): Promise<void> {
    return browser.actions().mouseMove(elm).perform();
  }
}
