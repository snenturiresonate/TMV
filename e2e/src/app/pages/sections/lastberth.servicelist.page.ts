import {browser, by, element, ElementArrayFinder, ElementFinder, ExpectedConditions} from 'protractor';
import {LastBerthServiceListTableRowPageObject} from './lastberth.servicelist.tablerow.page';
import {By} from '@angular/platform-browser';

export class LastberthServicelistPageObject {
  public lastBerthServiceList: ElementFinder;
  public services: ElementArrayFinder;

  constructor() {
    this.lastBerthServiceList = element(by.id('lastBerthContextMenu'));
    this.services = element.all(by.xpath('something'));
  }

  public async isDisplayed(): Promise<boolean> {
    return this.lastBerthServiceList.isPresent();
  }

  public async getServices(): Promise<string> {
    return this.services.getText();
  }

  public async getServiceListRows(): Promise<LastBerthServiceListTableRowPageObject[]> {
    const rowLocator: By = by.css('li.last-berth-list-item.dropdown-item .row');
    await browser.wait(ExpectedConditions.visibilityOf(element.all(rowLocator).first()), 15000, 'Service list is not shown');
    const array = new Array<LastBerthServiceListTableRowPageObject>();
    await element.all(rowLocator)
      .each(row => {array.push(
        new LastBerthServiceListTableRowPageObject(row));
      });
    return array;
  }

  async getRowByService(service: string): Promise<LastBerthServiceListTableRowPageObject> {
    return new LastBerthServiceListTableRowPageObject
    (this.lastBerthServiceList.element(by.xpath(`//span[contains(text(),'${service}')]`)));
  }

}
