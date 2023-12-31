import {browser, by, element, ElementArrayFinder, ElementFinder} from 'protractor';
import {InputBox} from '../common/ui-element-handlers/inputBox';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';

export class TrainsListServiceFilterTabPage {

  public addTrustIdBtn: ElementFinder;
  public clearAllBtn: ElementFinder;
  public trustIdInput: ElementFinder;
  public trustIdHeader: ElementFinder;
  public selectedServicesTableElm: ElementFinder;
  public selectedServicesTableHeader: ElementFinder;
  public selectedServicesTableItems: ElementArrayFinder;
  constructor() {
    this.addTrustIdBtn = element(by.id('addTrustId'));
    this.clearAllBtn = element(by.id('clearAllTrustIds'));
    this.trustIdInput = element(by.id('trustIdInput'));
    this.trustIdHeader = element(by.css('#servicesFilterConfiguation .punctuality-header'));
    this.selectedServicesTableElm = element((by.css('table.services-filter-table')));
    this.selectedServicesTableHeader = element(by.css('table.services-filter-table th'));
    this.selectedServicesTableItems = element.all(by.css('table.services-filter-table td.services-filter-table-trust-id'));
  }

  public async waitForTrustIds(): Promise<boolean> {
    browser.wait(async () => {
      return element(by.id('services-filter-table-body')).isPresent();
    }, browser.displayTimeout, 'The trust ID table should be displayed');
    return element(by.id('services-filter-table-body')).isPresent();
  }

  public async clickTrustIdsClearAll(): Promise<void> {
    return this.clearAllBtn.click();
  }

  public async clickTrustIdsAdd(): Promise<void> {
    return this.addTrustIdBtn.click();
  }

  public async inputTrustId(trustId: string): Promise<void> {
    await InputBox.updateInputBox(this.trustIdInput, trustId);
  }

  public async getSelectedTrustIds(): Promise<string> {
    return this.selectedServicesTableItems.getText();
  }

  public async getTrustIdHeader(): Promise<string> {
    return CommonActions.waitAndGetText(this.trustIdHeader);
  }

  public async getSelectedTrustIdsTableHeader(): Promise<string> {
    return CommonActions.waitAndGetText(this.selectedServicesTableHeader);
  }

  public async tableDataIsPresent(): Promise<boolean> {
    return this.selectedServicesTableItems.isPresent();
  }

  public async removeItem(itemName: string): Promise<void> {
    const tableRow = this.filterTableRowByItemName(itemName);
    const cancelBtn = tableRow.element(by.cssContainingText('td span', 'cancel'));
    return cancelBtn.click();
  }

  public filterTableRowByItemName(item: string): ElementFinder {
    const tableElm = this.selectedServicesTableItems.filter(elm => {
      return elm.getText().then(text => {
        return text === item;
      });
    }).first();
    return tableElm.element(by.xpath('..'));
  }
}
