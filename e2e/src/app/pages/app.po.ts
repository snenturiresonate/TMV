import {browser, by, element, ElementArrayFinder, ElementFinder } from 'protractor';

export class AppPage {
  public modalWindow: ElementFinder;
  public modalWindowButtons: ElementArrayFinder;

  public navigateTo(url: string): Promise<unknown> {
    return browser.get(browser.baseUrl + url) as Promise<unknown>;
  }

  constructor() {
    this.modalWindow = element(by.css('.modalpopup'));
    this.modalWindowButtons = element.all(by.css('.modalpopup .tmv-btn'));
  }

  public async getModalWindowTitle(): Promise<string> {
    const modalTitle = this.modalWindow.element(by.css('.modaltitle'));
    return modalTitle.getText();
  }

  public async getModalButtons(): Promise<string> {
    return this.modalWindowButtons.getText();
  }

}
