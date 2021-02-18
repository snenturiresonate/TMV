import {browser} from 'protractor';

export class LocalStorage {

  public static async reset(): Promise<void> {
    await browser.get('');
    await browser.executeScript('window.localStorage.clear();')
      .catch(reason => console.log('Cannot clear browser Local Storage\n' + reason));
    await browser.executeScript('window.sessionStorage.clear();')
      .catch(reason => console.log('Cannot clear browser session Storage\n' + reason));
  }
}
