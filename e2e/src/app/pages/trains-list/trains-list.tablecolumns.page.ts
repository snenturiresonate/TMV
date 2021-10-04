import {by, element, ElementArrayFinder, ElementFinder} from 'protractor';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';
import {InputBox} from '../common/ui-element-handlers/inputBox';

export class TrainsListTableColumnsPage {
  public tableLocator: ElementFinder;
  public scheduleType: ElementArrayFinder;
  public trainDescription: ElementArrayFinder;
  public entryTime: ElementArrayFinder;
  public entryReport: ElementArrayFinder;
  public punctuality: ElementArrayFinder;
  public origin: ElementArrayFinder;
  public plannedOriginTime: ElementArrayFinder;
  public actualOriginTime: ElementArrayFinder;
  public destination: ElementArrayFinder;
  public plannedDestinationTime: ElementArrayFinder;
  public actualDestinationTime: ElementArrayFinder;
  public nextLocation: ElementArrayFinder;
  public toc: ElementArrayFinder;
  constructor() {
    this.tableLocator = element(by.css('app-train-list-table-results'));
    this.scheduleType = element.all(by.css('td[class=trains-list-row-entry-schedule-type]'));
    this.trainDescription = element.all(by.css('td.trains-list-row-entry-train-description'));
    this.entryTime = element.all(by.css('td.trains-list-row-entry-time'));
    this.entryReport = element.all(by.css('td.trains-list-row-entry-report'));
    this.punctuality = element.all(by.css('td.trains-list-row-entry-punctuality'));
    this.origin = element.all(by.css('td.trains-list-row-entry-origin-location-id'));
    this.plannedOriginTime = element.all(by.css('td.trains-list-row-entry-origin-current-time'));
    this.actualOriginTime = element.all(by.css('td.trains-list-row-entry-origin-actual-predicted-time'));
    this.destination = element.all(by.css('td.trains-list-row-entry-destination-location-id'));
    this.plannedDestinationTime = element.all(by.css('td.trains-list-row-entry-destination-current-time'));
    this.actualDestinationTime = element.all(by.css('td.trains-list-row-entry-destination-actual-predicted-time'));
    this.nextLocation = element.all(by.css('td.trains-list-row-entry-next-location'));
    this.toc = element.all(by.css('td.trains-list-row-entry-operator'));
  }
  public async waitForTableToLoad(): Promise<void> {
    await CommonActions.waitForElementToBeVisible(element.all(by.css('app-train-list-table-results tr')).first());
  }
  public async valuesWithinRange(tableCol: ElementArrayFinder, max: number, min: number): Promise<ElementArrayFinder> {
    await this.waitForTableToLoad();
    return tableCol.filter((elm) => {
      return elm.getText().then(val => {
        // tslint:disable-next-line:radix
        return (parseInt(val) >= min && parseInt(val) <= max);
      });
    });
  }
  public async getBackgroundColourOfValuesWithinRange(tableCol: ElementArrayFinder, fromTime: number, toTime: number): Promise<string[]> {
    const colourOfEachElementArray: any[] = [];
    await this.waitForTableToLoad();
    const valuesInRange = await this.valuesWithinRange(tableCol, fromTime, toTime);
    valuesInRange.forEach((elm: ElementFinder) => {
      const trainDescriptionCell = elm.element(by.xpath(`/..`)).element(by.css('td.trains-list-row-entry-train-description'));
      colourOfEachElementArray.push(InputBox.getBackgroundColour(trainDescriptionCell));
    });
    return colourOfEachElementArray;
  }

  public async getTocValues(): Promise<string[]> {
    const valueArr: any[] = [];
    await CommonActions.waitForElementToBeVisible(this.toc.first());
    await this.toc.each(elm => elm.getText().then(text => valueArr.push(text.toString())));
    return valueArr;
  }

  public async isFirstTocVisible(): Promise<boolean> {
    return this.toc.first().isPresent();
  }

  public async getBackgroundColourOfRow(trainDescriberId: string): Promise<string> {
    await this.waitForTableToLoad();
    const elm = element.all(by.css(`[id^=trains-list-row-${trainDescriberId}]`)).first();
    return elm.getCssValue('background-color');
  }
}
