import {browser} from 'protractor';
import {CucumberLog} from '../src/app/logging/cucumber-log';

export class LocalStorage {

  public static async reset(): Promise<void> {
    await browser.waitForAngularEnabled(false);
    await browser.get('');
    await browser.executeScript('window.localStorage.clear();')
      .catch(reason => console.log('Cannot clear browser Local Storage\n' + reason));
    await browser.executeScript('window.sessionStorage.clear();')
      .catch(reason => console.log('Cannot clear browser session Storage\n' + reason));
    await browser.waitForAngularEnabled(true);
  }

  public static async getLocalStorage(): Promise<any> {
    const storageString: string = await browser.executeScript('return JSON.stringify(window.localStorage);');
    await CucumberLog.addText(`Local Storage:\n${storageString}`);
    return JSON.parse(storageString);
  }

  public static async getLocalStorageValueFromRegexKey(regexKey: string): Promise<string> {
    const localStorage = await this.getLocalStorage();
    for (const key in localStorage) {
      if (key.match(regexKey)) {
        return localStorage[key];
      }
    }
    return '';
  }
}
