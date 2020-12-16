import {browser, by, element, ElementArrayFinder} from 'protractor';

export class TrainsListIndicationTabPage {

  public rowName: ElementArrayFinder;
  public classToggle: ElementArrayFinder;
  public colourText: ElementArrayFinder;
  public minutesText: ElementArrayFinder;

  constructor() {
    this.rowName = element.all(by.css('.indication-div-container .col-md-5:nth-child(1)'));
    this.classToggle = element.all(by.css('.indication-div-container .toggle-switch >span:nth-child(3)'));
    this.colourText = element.all(by.css('.indication-div-container input[class*=punctuality-colour]'));
    this.minutesText = element.all(by.css('.indication-div-container input[class*=punctuality-input]'));
  }

  public async waitForIndicationData(): Promise<boolean> {
    browser.wait(async () => {
      return element(by.id('indication-div-container')).isPresent();
    }, browser.displayTimeout, 'The indication table should be displayed');
    return element(by.id('indication-div-container')).isPresent();
  }

  public async getTrainIndicationRowName(index: number): Promise<string> {
    return this.rowName.get(index).getText();
  }

  public async getTrainIndicationClassToggle(index: number): Promise<string> {
    return this.classToggle.get(index).getText();
  }

  public async toggleTrainIndicationClassToggle(index: number): Promise<void> {
    return this.classToggle.get(index).click();
  }

  public async getTrainIndicationColourText(index: number): Promise<string> {
    return this.colourText.get(index).getAttribute('value');
  }

  public async getTrainIndicationColourMinutes(index: number): Promise<string> {
    return this.minutesText.get(index) ? this.minutesText.get(index).getAttribute('value') : null;
  }
}
