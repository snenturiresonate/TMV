import {by, ElementFinder} from 'protractor';

export class SelectBox {

  /**
   *  Returns selected value from a dropdown. Input: Location of <select> tag
   */
  public static async getSelectedOption(elm: ElementFinder): Promise<string> {
    return elm.getAttribute('value');
  }

  /**
   *  Selects value from a dropdown by visible text.
   *  Input: Location of <select> tag, option to be selected
   */
  public static async selectByVisibleText(elm: ElementFinder, selection: string): Promise<string> {
    return elm.element(by.cssContainingText('option', `${selection}`));
  }
}
