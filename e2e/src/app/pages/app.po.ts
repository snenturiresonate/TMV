import {browser, by, element, ElementArrayFinder, ElementFinder, protractor} from 'protractor';
import {AuthenticationModalDialoguePage} from './authentication-modal-dialogue.page';
import {CommonActions} from './common/ui-event-handlers/actionsAndWaits';
import {UserCredentials} from "../user-credentials/user-credentials";

const authPage: AuthenticationModalDialoguePage = new AuthenticationModalDialoguePage();
const userCreds: UserCredentials = new UserCredentials();

export class AppPage {
  public modalWindow: ElementFinder;
  public modalWindowButtons: ElementArrayFinder;
  public navBarLogo: ElementFinder;

  constructor() {
    this.modalWindow = element(by.css('.modalpopup'));
    this.modalWindowButtons = element.all(by.css('.modalpopup .tmv-btn'));
    this.navBarLogo = element(by.css('.navbar-brand [alt=logo]'));
  }

  /**
   *  To Be used when authentication is to be performed and re-navigation to desired page is needed.
   */
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
          await this.defaultAuthentication();
          await browser.get(URL);
        }
      } catch (ex) {
          try {
            await this.authenticateOnCurrentRole();
            await browser.get(URL);
          } catch (reason) {
            if ((reason.toString()).includes('UnexpectedAlertOpenError') === false){
              throw new Error('Unable to signin: ' + reason);
            }
            const alert = await browser.switchTo().alert();
            await alert.accept();
          }
        }
    }
  }

  /**
   *  To Be used when only authentication is to be performed and re-navigation to desired page is not needed.
   */
  public async authenticateOnlyWithoutReNavigation(url: string, role?: string): Promise<any> {
    const URL = browser.baseUrl + url;
    await browser.waitForAngularEnabled(false);
    try {
        if (await authPage.reAuthenticationModalIsVisible()) {
          await authPage.clickSignInAsDifferentUser();
        }
        await this.roleBasedAuthentication(URL, role);
      } catch (reason) {
          if ((reason.toString()).includes('UnexpectedAlertOpenError') === false){
            throw new Error('Unable to signin: ' + reason);
          }
          const alert = await browser.switchTo().alert();
          await alert.accept();
        }
    await browser.waitForAngularEnabled(true);
  }

  /**
   *  To Be used when re-login dialogue is expected. Typically when session storage is cleared and navigating to a page
   */
  public async navigateToAndSignIn(url: string, role?: string): Promise<any> {
    const URL = browser.baseUrl + url;
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
  /**
   *  To Be used when login is not performed
   */
  public async navigateToWithoutSignIn(url: string): Promise<any> {
    const URL = browser.baseUrl + url;
    await browser.waitForAngularEnabled(false);
    await browser.get(URL);
    await browser.waitForAngularEnabled(true);
  }

  /**
   *  To Be used when invalid login is performed
   */
  public async navigateToWithInvalidLogin(url: string): Promise<any> {
    const URL = browser.baseUrl + url;
    await browser.waitForAngularEnabled(false);
    await browser.get(URL);
    await this.authenticateAsUnknownUser();
    await browser.waitForAngularEnabled(true);
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

  public async defaultAuthentication(): Promise<any> {
    await browser.waitForAngularEnabled(false);
    await this.authenticateAsAdminUser();
    await this.waitForAppLoad();
    await browser.waitForAngularEnabled(true);
  }

  public async authenticateOnCurrentRole(): Promise<any> {
    await browser.waitForAngularEnabled(false);
    await authPage.signBackIntoCurrentRole();
    await this.waitForAppLoad();
    await browser.waitForAngularEnabled(true);
  }

  public async authenticateAsAdminUser(): Promise<void> {
    const userName = userCreds.userAdmin().userName;
    const Password = userCreds.userAdmin().password;
    await authPage.authenticate(userName, Password);
  }

  public async authenticateAsStandardUser(): Promise<void> {
    const userName = userCreds.userStandard().userName;
    const Password = userCreds.userStandard().password;
    await authPage.authenticate(userName, Password);
  }

  public async authenticateAsRestrictionUser(): Promise<void> {
    const userName = userCreds.userRestrictions().userName;
    const Password = userCreds.userRestrictions().password;
    await authPage.authenticate(userName, Password);
  }

  public async authenticateAsScheduleMatchingUser(): Promise<void> {
    const userName = userCreds.userScheduleMatching().userName;
    const Password = userCreds.userScheduleMatching().password;
    await authPage.authenticate(userName, Password);
  }

  public async authenticateAsUnknownUser(): Promise<void> {
    const userName = userCreds.userUnknown().userName;
    const Password = userCreds.userUnknown().password;
    await authPage.authenticate(userName, Password);
  }

  public async waitForAppLoad(): Promise<void> {
    await CommonActions.waitForElementToBeVisible(this.navBarLogo);
  }

}
