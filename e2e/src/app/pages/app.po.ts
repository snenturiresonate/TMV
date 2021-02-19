import {browser, by, element, ElementArrayFinder, ElementFinder, protractor} from 'protractor';
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
    const URL = browser.baseUrl + url;
    try {
      await browser.waitForAngularEnabled(false);
      await browser.get(URL);
      await browser.waitForAngularEnabled(true);
      await this.waitForAppLoad();
    } catch (e) {
        try {
        if (role) {
          await this.roleBasedAuthentication(URL, role);
          await browser.get(URL);
        } else {
          await this.defaultAuthentication(URL);
          await browser.get(URL);
        }
      } catch (ex) {
          try {
            await this.authenticateOnCurrentRole();
            await browser.get(URL);
          } catch (reason) {
            throw new Error('Unable to signin: ' + reason);
          }
        }
    }
  }

  /**
   *  To Be used when re-login dialogue is expected. Typically then session storage is cleared and navigating to a page
   */
  public async navigateToAndSignIn(url: string, role?: string): Promise<any> {
    const URL = browser.baseUrl + url;
    const authPage: AuthenticationModalDialoguePage = new AuthenticationModalDialoguePage();
    if (role) {
        await browser.waitForAngularEnabled(false);
        await browser.get(URL);
        await authPage.clickSignInAsDifferentUser();
        await this.roleBasedAuthentication(URL, role);
        await browser.waitForAngularEnabled(true);
        await browser.get(URL);
      } else {
        await browser.waitForAngularEnabled(false);
        await browser.get(URL);
        await this.authenticateOnCurrentRole();
        await browser.waitForAngularEnabled(true);
        await browser.get(URL);
      }

  }

  public async roleBasedAuthentication(url, role): Promise<any> {
    await browser.waitForAngularEnabled(false);
    await browser.get(url);
    await this.authenticationRouter(role);
    await browser.waitForAngularEnabled(true);
    await this.waitForAppLoad();
  }

  private async authenticationRouter(role: string): Promise<any> {
    let authentication;
    switch (role.toLowerCase()) {
      case('admin'):
        authentication = this.authenticateAsAdminUser();
        break;
      case('restriction'):
        authentication = this.authenticateAsRestrictionUser();
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
    await browser.get(url);
    await this.authenticateAsAdminUser();
    await this.waitForAppLoad();
    await browser.waitForAngularEnabled(true);
  }

  public async authenticateOnCurrentRole(): Promise<any> {
    const authPage: AuthenticationModalDialoguePage = new AuthenticationModalDialoguePage();
    await browser.waitForAngularEnabled(false);
    await authPage.signBackIntoCurrentRole();
    await this.waitForAppLoad();
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

  public async authenticateAsRestrictionUser(): Promise<void> {
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
    await browser.waitForAngularEnabled(true);
  }

  public async waitForAppLoad(): Promise<void> {
    await CommonActions.waitForElementToBeVisible(this.navBarLogo);
  }

}
