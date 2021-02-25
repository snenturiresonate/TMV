import {by, ElementFinder} from 'protractor';
import {CommonActions} from '../ui-event-handlers/actionsAndWaits';

export class CheckBox{
  /**
   * Updates an check box when the locator and updated state are passed in as checked/unchecked.
   * Method determines the update based on current selection state
   * Input: Location of <input> tag, Text to input
   */
  public static async updateCheckBox(elm: ElementFinder, update: string): Promise<void> {
    const selectUpdate: boolean = await this.convertUpdateToBoolean(update);
    const currentState: boolean = await elm.isSelected();
    await CommonActions.waitForElementInteraction(elm);
    if (selectUpdate !== currentState) {
      return elm.click();
    } else {
      return;
    }
  }

  /**
   * Updates a toggle input when the locator and required state are passed in as on/off.
   * Method determines the update based on current selection state
   * Input: Location of <label> tag, Expected on/off state as string
   */
  public static async updateToggle(elm: ElementFinder, update: string): Promise<void> {
    const selectUpdate: boolean = await this.convertToggleToBoolean(update);
    const currentState: boolean = await this.toggleIsSelected(elm);
    await CommonActions.waitForElementInteraction(elm);
    if (selectUpdate !== currentState) {
      return elm.element(by.css('span:nth-child(3)')).click();
    } else {
      return;
    }
  }

  /**
   * Returns the current selection state of a toggle button as a boolean. True: On, False: Off
   * Input: Location of <label> tag
   */
  public static async getToggleCurrentState(elm: ElementFinder): Promise<boolean> {
    await CommonActions.waitForElementInteraction(elm);
    return this.toggleIsSelected(elm);
  }

  /**
   * Determines the current state of toggle selection and returns a boolean response.
   * Input: Location of <label> tag
   */
  public static async toggleIsSelected(elm: ElementFinder): Promise<boolean> {
    await CommonActions.waitForElementInteraction(elm);
    return elm.element(by.css('input')).isSelected();
  }

  public static async convertUpdateToBoolean(selection: string): Promise<boolean> {
    return (selection.toLowerCase() === 'checked');
  }

  public static async convertToggleToBoolean(selection: string): Promise<boolean> {
    return (selection.toLowerCase() === 'on');
  }
}
