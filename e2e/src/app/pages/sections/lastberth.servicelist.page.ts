import {browser, by, element, ElementArrayFinder, ElementFinder, ExpectedConditions} from 'protractor';
import {LastBerthServiceListTableRowPageObject} from './lastberth.servicelist.tablerow.page';

export class LastberthServicelistPageObject {
  public lastBerthServiceList: ElementFinder;
  public services: ElementArrayFinder;

  constructor() {
    this.lastBerthServiceList = element(by.id('something'));
    this.services = element.all(by.xpath('something'));
  }

  public async isDisplayed(): Promise<boolean> {
    return this.lastBerthServiceList.isPresent();
  }

  public async getServices(): Promise<string> {
    return this.services.getText();
  }

  public async getServiceListRows(): Promise<LastBerthServiceListTableRowPageObject[]> {
    const rowLocator = by.css('table.modification-table tbody tr');
    await browser.wait(ExpectedConditions.visibilityOf(element(rowLocator)), 15000, 'Service list is not shown');
    const array = new Array<LastBerthServiceListTableRowPageObject>();
    await element.all(rowLocator)
      .each((row, index) => {array.push(
        new LastBerthServiceListTableRowPageObject(element(by.css(`table.modification-table tbody tr:nth-child(${index + 1})`))));
      });
    return array;
  }

  async getRowByService(service: string): Promise<LastBerthServiceListTableRowPageObject> {
    return new LastBerthServiceListTableRowPageObject
    (this.lastBerthServiceList.element(by.xpath(`//tr[descendant::td[text()='${service}']]`)));
  }

}
