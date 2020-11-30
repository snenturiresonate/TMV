import {by, element, ElementFinder} from 'protractor';

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
  public activities: ElementFinder;
  public actualArr: ElementFinder;
  public actualDep: ElementFinder;
  public actualPlt: ElementFinder;
  public actualPath: ElementFinder;
  public actualLn: ElementFinder;
  public punctuality: ElementFinder;

  constructor(rowId: string) {
    this.location = element(by.id(rowId)).element(by.css('td:nth-child(1)'));
    this.changeEnRoute = element(by.id(rowId)).element(by.css('.change-en-route'));
    this.plannedArr = element(by.id(rowId)).element(by.css('td:nth-child(2)'));
    this.plannedDep = element(by.id(rowId)).element(by.css('td:nth-child(3)'));
    this.publicArr = element(by.id(rowId)).element(by.css('td:nth-child(4)'));
    this.publicDep = element(by.id(rowId)).element(by.css('td:nth-child(5)'));
    this.plt = element(by.id(rowId)).element(by.css('td:nth-child(6)'));
    this.path = element(by.id(rowId)).element(by.css('td:nth-child(7)'));
    this.ln = element(by.id(rowId)).element(by.css('td:nth-child(8)'));
    this.allowances = element(by.id(rowId)).element(by.css('td:nth-child(9)'));
    this.activities = element(by.id(rowId)).element(by.css('td:nth-child(10)'));
    this.actualArr = element(by.id(rowId)).element(by.css('td:nth-child(11)'));
    this.actualDep = element(by.id(rowId)).element(by.css('td:nth-child(12)'));
    this.actualPlt = element(by.id(rowId)).element(by.css('td:nth-child(13)'));
    this.actualPath = element(by.id(rowId)).element(by.css('td:nth-child(14)'));
    this.actualLn = element(by.id(rowId)).element(by.css('td:nth-child(15)'));
    this.punctuality = element(by.id(rowId)).element(by.css('td:nth-child(16)'));
  }
  async getLocation(): Promise<string>  {
    let loc = await this.location.getText();
    if (await this.changeEnRoute.isPresent()) {
      loc = loc.replace(await this.changeEnRoute.getText(), '').replace('\n', '');
    }
    return loc;
  }

}
