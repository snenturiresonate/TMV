import {by, element, ElementFinder} from 'protractor';
import {CommonActions} from './common/ui-event-handlers/actionsAndWaits';

export class WelcomeModalPage {
  public welcomeModal: ElementFinder;
  public modalDismiss: ElementFinder;
  constructor() {
    this.welcomeModal = element(by.css('app-modal-popup .welcome-modal-body'));
    this.modalDismiss = element(by.css('app-modal-popup .tmv-btn-cancel'));
  }
  public async welcomeModalIsVisible(): Promise<boolean> {
    await CommonActions.waitForElementToBeVisible(this.welcomeModal);
    return this.welcomeModal.isDisplayed();
  }

  public async dismissModal(): Promise<void> {
    await CommonActions.waitAndClick(this.modalDismiss);
  }
}
