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
    this.service = rowLocator.element(by.css('[id*=SearchTrainDesc]'));
    this.trustId = rowLocator.element(by.css('[id*=SearchTrainTrustId]'));
    this.planUID = rowLocator.element(by.css('[id*=SearchPlanningUid]'));
    this.status = rowLocator.element(by.css('[id*=SearchStatus]'));
    this.sched = rowLocator.element(by.css('[id*=SearchScheduletype]'));
    this.schedDate = rowLocator.element(by.css('[id*=SearchStartDate'));
    this.origin = rowLocator.element(by.css('[id*=SearchOrigin]'));
    this.time = rowLocator.element(by.css('[id*=SearchWorkingDeptTime]'));
    this.dest = rowLocator.element(by.css('[id*=SearchDestination]'));
  }
  async isPresent(): Promise<boolean> {
    return this.rowLocator.isPresent();
  }

  async performRightClick(): Promise<void> {
    browser.actions().click(this.rowLocator, protractor.Button.RIGHT).perform();
  }
}
