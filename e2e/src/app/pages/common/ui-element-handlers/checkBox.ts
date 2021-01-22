import {ElementFinder} from 'protractor';
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

  public static async convertUpdateToBoolean(selection: string): Promise<boolean> {
    return (selection === 'Checked' || selection === 'checked');
  }
}
