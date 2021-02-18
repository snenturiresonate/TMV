import {browser, by, element, ElementFinder, protractor} from 'protractor';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';
import {InputBox} from '../common/ui-element-handlers/inputBox';

export class AdministrationLoginMessageTab {
  public loginSettingsContainer: ElementFinder;
  public saveBtn: ElementFinder;
  public resetBtn: ElementFinder;
  public unsavedIndicator: ElementFinder;

  constructor() {
    this.loginSettingsContainer = element(by.css('app-login-settings login-settings-container'));
    this.saveBtn = element(by.css('#saveLoginConfig'));
    this.resetBtn = element(by.css('#resetLoginConfig'));
    this.unsavedIndicator = element(by.xpath('//*[@id="Login Message"]/span'));
  }

  public async componentLoad(): Promise<void> {
    const EC = protractor.ExpectedConditions;
    await browser.wait(EC.presenceOf(this.loginSettingsContainer));
  }

  public async updateLoginMessage(field: string, update: string): Promise<void> {
    const elm: ElementFinder = this.loginPageElement(field);
    await elm.clear();
    await elm.sendKeys(`${update}`);
  }

  public async getLoginMessage(field: string): Promise<string> {
    const elm: ElementFinder = this.loginPageElement(field);
    return InputBox.waitAndGetTextOfInputBox(elm);
  }

  public loginPageElement(field: string): ElementFinder {
    const elm: ElementFinder = element(by.xpath(`//div[contains(@class,'login-label') and contains(.,"${field}")]/..//textarea`));
    return elm;
  }

  public async clickSaveButton(): Promise<void> {
    await CommonActions.waitAndClick(this.saveBtn);
  }

  public async clickResetButton(): Promise<void> {
    await CommonActions.waitAndClick(this.resetBtn);
  }

  public async isUnsavedIndicatorPresent(): Promise<boolean> {
    return browser.isElementPresent(this.unsavedIndicator);
  }
}
