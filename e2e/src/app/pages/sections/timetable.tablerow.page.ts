import {browser, by, ElementFinder} from 'protractor';
import {TimeTablePageObject} from '../timetable/timetable.page';
import {CucumberLog} from '../../logging/cucumber-log';

export class TimetableTableRowPageObject {
  public static locationBy = by.css('td:nth-child(1)');
  private valueRetry = 5;

  private location: ElementFinder;
  private changeEnRoute: ElementFinder;
  private plannedArr: ElementFinder;
  private plannedDep: ElementFinder;
  private publicArr: ElementFinder;
  private publicDep: ElementFinder;
  private plt: ElementFinder;
  private path: ElementFinder;
  private ln: ElementFinder;
  private allowances: ElementFinder;
  private activity: ElementFinder;
  public actualArr: ElementFinder;
  public actualDep: ElementFinder;
  private actualPlt: ElementFinder;
  private actualPath: ElementFinder;
  private actualLn: ElementFinder;
  private punctuality: ElementFinder;
  private rowLocator: ElementFinder;

  private readonly index: number;

  constructor(rowLocator: ElementFinder, index: number) {
    this.rowLocator = rowLocator;
    this.index = index;
    this.location = rowLocator.element(TimetableTableRowPageObject.locationBy);
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

  async getValue(valueName: string): Promise<string> {
    try {
      switch (valueName) {
        case 'location':
          let loc = await this.location.getText();
          if (await this.changeEnRoute.isPresent()) {
            loc = loc.replace(await this.changeEnRoute.getText(), '').replace('\n', '');
          }
          return loc;
        case 'changeEnRoute':
          return this.changeEnRoute.getText();
        case 'plannedArr':
          return this.plannedArr.getText();
        case 'plannedDep':
          return this.plannedDep.getText();
        case 'publicArr':
          return this.publicArr.getText();
        case 'publicDep':
          return this.publicDep.getText();
        case 'plt':
          return this.plt.getText();
        case 'path':
          return this.path.getText();
        case 'ln':
          return this.ln.getText();
        case 'allowances':
          return this.allowances.getText();
        case 'activity':
          return this.activity.getText();
        case 'actualArr':
          return this.actualArr.getText();
        case 'actualDep':
          return this.actualDep.getText();
        case 'actualPlt':
          return this.actualPlt.getText();
        case 'actualPath':
          return this.actualPath.getText();
        case 'actualLn':
          return this.actualLn.getText();
        case 'punctuality':
          return this.punctuality.getText();
      }
    }
    catch (issue) {
      console.log(issue.toString());
      await CucumberLog.addText(issue.toString());
      let value = '';
      if (this.valueRetry-- > 0) {
        const logMsg = `Refreshing the row locator for ${valueName}, ${this.valueRetry} attempts remaining`;
        console.log(logMsg);
        await CucumberLog.addText(logMsg);
        await this.refreshRowLocator();
        await browser.sleep(1000);
        value = await this.getValue(valueName);
      }
      this.valueRetry = 5;
      return value;
    }
  }

  async refreshRowLocator(): Promise<void> {
    this.rowLocator = await TimeTablePageObject.getRowAtIndex(this.index);
  }

}
