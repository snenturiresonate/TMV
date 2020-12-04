import {browser} from 'protractor';

export class LocalStorage {

  public static reset(): void {
      browser.executeScript('window.localStorage.clear();')
        .catch(reason => console.log('Cannot clear browser Local Storage\nCheck baseURL is set and the application is available'));
  }
}
