import {by, ElementFinder} from 'protractor';

export class ModificationsTablerowPage {

  public typeOfModification: ElementFinder;
  public location: ElementFinder;
  public time: ElementFinder;
  public modificationReason: ElementFinder;
  private rowLocator: ElementFinder;

  constructor(rowLocator: ElementFinder) {
    this.rowLocator = rowLocator;
    this.typeOfModification = rowLocator.element(by.css('td:nth-child(1)'));
    this.location = rowLocator.element(by.css('td:nth-child(2)'));
    this.time = rowLocator.element(by.css('td:nth-child(3)'));
    this.modificationReason = rowLocator.element(by.css('td:nth-child(4)'));
  }
  async getTypeOfModification(): Promise<string> {
    return this.typeOfModification.getText();
  }
  async getLocation(): Promise<string> {
    return this.location.getText();
  }
  async getTime(): Promise<string> {
    return this.time.getText();
  }
  async getModificationReason(): Promise<string> {
    return this.modificationReason.getText();
  }
  async isPresent(): Promise<boolean> {
    return this.rowLocator.isPresent();
  }
}
