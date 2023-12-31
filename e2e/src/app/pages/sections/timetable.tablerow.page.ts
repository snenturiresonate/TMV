import {by, ElementFinder} from 'protractor';

export class TimetableTableRowPageObject {

  public location: ElementFinder;
  public changeEnRoute: ElementFinder;
  public plannedArr: ElementFinder;
  public plannedDep: ElementFinder;
  public publicArr: ElementFinder;
  public publicDep: ElementFinder;
  public plt: ElementFinder;
  public path: ElementFinder;
  public ln: ElementFinder;
  public allowances: ElementFinder;
  public activity: ElementFinder;
  public actualArr: ElementFinder;
  public actualDep: ElementFinder;
  public actualPlt: ElementFinder;
  public actualPath: ElementFinder;
  public actualLn: ElementFinder;
  public punctuality: ElementFinder;
  private rowLocator: ElementFinder;

  constructor(rowLocator: ElementFinder) {
    this.rowLocator = rowLocator;
    this.location = rowLocator.element(by.css('td:nth-child(1)'));
    this.changeEnRoute = rowLocator.element(by.css('.change-en-route'));
    this.plannedArr = rowLocator.element(by.css('td:nth-child(2)'));
    this.plannedDep = rowLocator.element(by.css('td:nth-child(3)'));
    this.publicArr = rowLocator.element(by.css('td:nth-child(4)'));
    this.publicDep = rowLocator.element(by.css('td:nth-child(5)'));
    this.plt = rowLocator.element(by.css('td:nth-child(6)'));
    this.path = rowLocator.element(by.css('td:nth-child(7)'));
    this.ln = rowLocator.element(by.css('td:nth-child(8)'));
    this.allowances = rowLocator.element(by.css('td:nth-child(9)'));
    this.activity = rowLocator.element(by.css('td:nth-child(10)'));
    this.actualArr = rowLocator.element(by.css('td:nth-child(11)'));
    this.actualDep = rowLocator.element(by.css('td:nth-child(12)'));
    this.actualPlt = rowLocator.element(by.css('td:nth-child(13)'));
    this.actualPath = rowLocator.element(by.css('td:nth-child(14)'));
    this.actualLn = rowLocator.element(by.css('td:nth-child(15)'));
    this.punctuality = rowLocator.element(by.css('td:nth-child(16)'));
  }

  async getLocation(): Promise<string>  {
    let loc = await this.location.getText();
    if (await this.changeEnRoute.isPresent()) {
      loc = loc.replace(await this.changeEnRoute.getText(), '').replace('\n', '');
    }
    return loc;
  }

}
