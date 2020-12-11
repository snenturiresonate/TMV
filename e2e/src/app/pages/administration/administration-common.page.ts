import { by, element } from 'protractor';

export class AdminPageCommon {
  public async openTab(tabId: string): Promise<void> {
    return element(by.id(tabId)).click();
  }
}
