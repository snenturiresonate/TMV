import {browser, by, element, ElementFinder} from 'protractor';
import {InputBox} from './common/ui-element-handlers/inputBox';
import {CommonActions} from './common/ui-event-handlers/actionsAndWaits';

export class AuthenticationModalDialoguePage {
  public visibleModalElement: ElementFinder;
  public userNameElement: ElementFinder;
  public passwordElement: ElementFinder;
  public signInBtnElement: ElementFinder;
  public forgotPasswordLinkElement: ElementFinder;
  public signUpLinkElement: ElementFinder;
  public signInAsAdminUserBtn: ElementFinder;
  public signInAsDiffUser: ElementFinder;
  public signIntoCurrentRoleBtn: ElementFinder;
  constructor() {
    this.visibleModalElement = element(by.css('.modal-content.visible-md.visible-lg'));
    this.userNameElement = element(by.css('.modal-content.visible-md.visible-lg')).element(by.id('signInFormUsername'));
    this.passwordElement = element(by.css('.modal-content.visible-md.visible-lg')).element(by.id('signInFormPassword'));
    this.signInBtnElement = element(by.css('.modal-content.visible-md.visible-lg')).element(by.css(`input[name='signInSubmitButton']`));
    this.forgotPasswordLinkElement = element(by.css('.modal-content.visible-md.visible-lg')).element(by.cssContainingText('a.redirect-customizable', 'Forgot your password?'));
    this.signUpLinkElement = element(by.css('.modal-content.visible-md.visible-lg')).element(by.cssContainingText('a', 'Sign up'));
    this.signInAsAdminUserBtn = element(by.css('.modal-content.visible-md.visible-lg')).element(by.cssContainingText('button', 'Sign In as userAdmin'));
    this.signInAsDiffUser = element(by.css('.modal-content.visible-md.visible-lg')).element(by.cssContainingText('a', 'Sign in as a different user'));
    // tslint:disable-next-line:max-line-length
    this.signIntoCurrentRoleBtn = element(by.css('.modal-content.visible-md.visible-lg')).element(by.cssContainingText('button', 'Sign In'));
  }

  public async inputUserName(userName: string): Promise<void> {
    return InputBox.updateInputBox(this.userNameElement, userName);
  }

  public async inputPassword(password: string): Promise<void> {
    return InputBox.updateInputBox(this.passwordElement, password);
  }

  public async clickSignInBtn(): Promise<void> {
    return CommonActions.waitAndClick(this.signInBtnElement);
  }

  public async authenticate(userName: string, password: string): Promise<void> {
    await this.inputUserName(userName);
    await this.inputPassword(password);
    return this.clickSignInBtn();
  }

  public async authenticateAsAdminUser(): Promise<void> {
    const userName = 'userAdmin';
    const Password = 'password';
    return this.authenticate(userName, Password);
  }

  public async signBackIntoCurrentRole(): Promise<void> {
    await CommonActions.waitAndClick(this.signIntoCurrentRoleBtn);
  }

  public async clickSignInAsDifferentUser(): Promise<void> {
    await CommonActions.waitAndClick(this.signInAsDiffUser);
  }

}
