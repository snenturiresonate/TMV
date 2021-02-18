import {browser, by, ElementFinder, protractor} from 'protractor';

export class SearchResultsTableRowPage {

  public service: ElementFinder;
  public trustId: ElementFinder;
  public planUID: ElementFinder;
  public status: ElementFinder;
  public sched: ElementFinder;
  public schedDate: ElementFinder;
  public origin: ElementFinder;
  public time: ElementFinder;
  public dest: ElementFinder;
  private rowLocator: ElementFinder;

  constructor(rowLocator: ElementFinder) {
    this.rowLocator = rowLocator;
    this.service = rowLocator.element(by.id('trainSearchTrainDesc'));
    this.trustId = rowLocator.element(by.id('trainSearchTrainTrustId'));
    this.planUID = rowLocator.element(by.id('trainSearchPlanningUid'));
    this.status = rowLocator.element(by.id('trainSearchStatus'));
    this.sched = rowLocator.element(by.id('trainSearchScheduleType'));
    this.schedDate = rowLocator.element(by.id('trainSearchStartDate'));
    this.origin = rowLocator.element(by.id('trainSearchOrigin'));
    this.time = rowLocator.element(by.id('trainSearchWorkingDeptTime'));
    this.dest = rowLocator.element(by.id('trainSearchDestination'));
  }
  async isPresent(): Promise<boolean> {
    return this.rowLocator.isPresent();
  }

  async performRightClick(): Promise<void> {
    browser.actions().click(this.rowLocator, protractor.Button.RIGHT).perform();
  }
}
