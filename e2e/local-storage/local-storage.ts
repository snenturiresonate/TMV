import {browser} from 'protractor';

export class LocalStorage {

  public static reset(): void {
    browser.executeScript('window.localStorage.clear();');
  }
}
