import {browser, by, element, ElementArrayFinder, ElementFinder } from 'protractor';
import {AuthenticationModalDialoguePage} from './authentication-modal-dialogue.page';
import {CommonActions} from './common/ui-event-handlers/actionsAndWaits';

export class AppPage {
  public modalWindow: ElementFinder;
  public modalWindowButtons: ElementArrayFinder;
  public navBarLogo: ElementFinder;

  constructor() {
    this.modalWindow = element(by.css('.modalpopup'));
    this.modalWindowButtons = element.all(by.css('.modalpopup .tmv-btn'));
    this.navBarLogo = element(by.css('.navbar-brand [alt=logo]'));
  }

  public async navigateTo(url: string, role?: string): Promise<any> {
    try {
      await browser.waitForAngularEnabled(false);
      await browser.get(browser.baseUrl + url);
      await browser.waitForAngularEnabled(true);
      await CommonActions.waitForElementToBeVisible(this.navBarLogo);
    } catch (e) {
      if (role) {
        await this.roleBasedAuthentication(url, role);
      } else {
        await this.defaultAuthentication(url);
      }
    }

  }

  public async roleBasedAuthentication(url, role): Promise<any> {
    await browser.waitForAngularEnabled(false);
    await browser.get(browser.baseUrl + url);
    await this.authenticationRouter(role);
    await browser.waitForAngularEnabled(true);
    await CommonActions.waitForElementToBeVisible(this.navBarLogo);
  }

  private async authenticationRouter(role: string): Promise<any> {
    let authentication;
    switch (role.toLowerCase()) {
      case('admin'):
        authentication = this.authenticateAsAdminUser();
        break;
      case('restricted'):
        authentication = this.authenticateAsRestrictedUser();
        break;
      case('standard'):
        authentication = this.authenticateAsStandardUser();
        break;
      case('schedulematching'):
        authentication = this.authenticateAsScheduleMatchingUser();
        break;
      default:
        throw new Error('Please verify the authentication role used');
    }
    return authentication;
  }

  public async getModalWindowTitle(): Promise<string> {
    const modalTitle = this.modalWindow.element(by.css('.modaltitle'));
    return modalTitle.getText();
  }

  public async getModalButtons(): Promise<string> {
    return this.modalWindowButtons.getText();
  }

  public async defaultAuthentication(url): Promise<any> {
    await browser.waitForAngularEnabled(false);
    await browser.get(browser.baseUrl + url);
    await this.authenticateAsAdminUser();
    await CommonActions.waitForElementToBeVisible(this.navBarLogo);
    await browser.waitForAngularEnabled(true);
  }

  public async authenticateAsAdminUser(): Promise<void> {
    const userName = 'userAdmin';
    const Password = 'password';
    await this.performLoginSteps(userName, Password);
  }

  public async authenticateAsStandardUser(): Promise<void> {
    const userName = 'userStandard';
    const Password = 'password';
    await this.performLoginSteps(userName, Password);
  }

  public async authenticateAsRestrictedUser(): Promise<void> {
    const userName = 'userRestrictions';
    const Password = 'password';
    await this.performLoginSteps(userName, Password);
  }

  public async authenticateAsScheduleMatchingUser(): Promise<void> {
    const userName = 'userScheduleMatching';
    const Password = 'password';
    await this.performLoginSteps(userName, Password);
  }

  public async performLoginSteps(userName: string, Password: string): Promise<void> {
    const authPage: AuthenticationModalDialoguePage = new AuthenticationModalDialoguePage();
    await browser.waitForAngularEnabled(false);
    await authPage.authenticate(userName, Password);
  }

}
