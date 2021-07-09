import {browser, by, element, ElementArrayFinder, ElementFinder, protractor} from 'protractor';
import {DateAndTimeUtils} from '../common/utilities/DateAndTimeUtils';

export class TrainsListManualMatchPageObject {
  public trainService: ElementArrayFinder;
  public trustId: ElementArrayFinder;
  public planUid: ElementArrayFinder;
  public status: ElementArrayFinder;
  public schedule: ElementArrayFinder;
  public scheduleDate: ElementArrayFinder;
  public origin: ElementArrayFinder;
  public time: ElementArrayFinder;
  public destination: ElementArrayFinder;
  public serviceFilter: ElementFinder;
  public matchedTable: ElementFinder;
  public matchedTrainDesc: ElementFinder;
  public matchedTrainUID: ElementFinder;
  public matchedColumn: ElementArrayFinder;
  public matchedValue: ElementArrayFinder;
  public saveButton: ElementFinder;
  public closeButton: ElementFinder;
  public matchButton: ElementFinder;
  public unMatchButton: ElementFinder;
  public confirmMessage: ElementFinder;

  constructor() {
    this.trainService = element.all(by.css('#trainSearchResults-tbody >tr >span >td:nth-child(1)'));
    this.trustId = element.all(by.css('#trainSearchResults-tbody >tr >span >td:nth-child(2)'));
    this.planUid = element.all(by.css('#trainSearchResults-tbody >tr >span >td:nth-child(3)'));
    this.status = element.all(by.css('#trainSearchResults-tbody >tr >span >td:nth-child(4)'));
    this.schedule = element.all(by.css('#trainSearchResults-tbody >tr >span >td:nth-child(5)'));
    this.scheduleDate = element.all(by.css('#trainSearchResults-tbody >tr >span >td:nth-child(6)'));
    this.origin = element.all(by.css('#trainSearchResults-tbody >tr >span >td:nth-child(7)'));
    this.time = element.all(by.css('#trainSearchResults-tbody >tr >span >td:nth-child(8)'));
    this.destination = element.all(by.css('#trainSearchResults-tbody >tr >span >td:nth-child(9)'));
    this.serviceFilter = element(by.id('services-filter-box'));
    this.matchedTable = element(by.css('.div-container.tmv-matched-margin'));
    this.matchedTrainDesc = element(by.css('#trainDesc'));
    this.matchedTrainUID = element(by.css('#planningUid'));
    this.matchedColumn = element.all(by.css('.tmv-matched-margin .col-md-5'));
    this.matchedValue = element.all(by.css('.tmv-matched-margin .col-md-6'));
    this.saveButton = element(by.id('saveManualMatching'));
    this.closeButton = element(by.css('.tmv-btn-cancel:nth-child(1)'));
    this.matchButton = element(by.css('.confirm-btn-container #confirmManualMatching'));
    this.unMatchButton = element(by.css('.unmatch-btn-container #confirmManualMatching'));
    this.confirmMessage = element(by.css('.confirm-text-area:nth-child(2)'));
  }
  public async componentLoad(): Promise<void> {
    const EC = protractor.ExpectedConditions;
    return browser.wait(EC.presenceOf(this.serviceFilter));
  }
  public async isMatchedServiceVisible(): Promise<boolean> {
    await this.componentLoad();
    return this.matchedTable.isPresent();
  }

  public async getNumServicesListed(): Promise<number> {
    await this.componentLoad();
    return this.trainService.count();
  }

  public async isServiceListed(planningUID: string): Promise<boolean> {
    await this.componentLoad();
    const numServices = await this.getNumServicesListed();
    let i = 0;
    for (i; i < numServices; i++) {
      if (await this.getPlanUid(i) === planningUID) {
        return true;
      }
    }
    return false;
  }

  public async getSearchEntryValues(planningUID: string, scheduleDate = DateAndTimeUtils.convertToDesiredDateAndFormat('today', 'dd/MM/yy')): Promise<string[]> {
    await this.componentLoad();
    const numServices = await this.getNumServicesListed();
    let i = 0;
    for (i; i < numServices; i++) {
      if (await this.getPlanUid(i) === planningUID && await this.getScheduleDate(i) === scheduleDate) {
        i++;
        break;
      }
    }
    const entryColValues: ElementArrayFinder = element.all(by.css
      ('#trainSearchResults-tbody >tr:nth-child(' + i.toString() + ') >span >td'));
    return entryColValues.map((colValue: ElementFinder) => {
      return colValue.getText();
    });
  }

  public async selectService(planningUID: string): Promise<void> {
    await this.componentLoad();
    const numServices = await this.getNumServicesListed();
    let i = 0;
    for (i; i < numServices; i++) {
      if (await this.getPlanUid(i) === planningUID) {
        break;
      }
    }
    const requiredRowEntry: ElementFinder = element(by.css ('#trainSearchResults-tbody >tr:nth-child(' + i.toString() + ')'));
    return requiredRowEntry.click();
  }

  public async getService(index: number): Promise<string> {
    await this.componentLoad();
    return this.trainService.get(index).getText();
  }
  public async getTrustId(index: number): Promise<string> {
    return this.trustId.get(index).getText();
  }
  public async getPlanUid(index: number): Promise<string> {
    return this.planUid.get(index).getText();
  }
  public async getStatus(index: number): Promise<string> {
    return this.status.get(index).getText();
  }
  public async getSchedule(index: number): Promise<string> {
    return this.schedule.get(index).getText();
  }
  public async getScheduleDate(index: number): Promise<string> {
    return this.scheduleDate.get(index).getText();
  }
  public async getOrigin(index: number): Promise<string> {
    return this.origin.get(index).getText();
  }
  public async getTime(index: number): Promise<string> {
    return this.time.get(index).getText();
  }
  public async getDestination(index: number): Promise<string> {
    return this.destination.get(index).getText();
  }
  public async getMatchedColumn(index: number): Promise<string> {
    return this.matchedColumn.get(index).getText();
  }
  public async getMatchedValue(index: number): Promise<string> {
    return this.matchedValue.get(index).getText();
  }
  public async clickService(serviceId: string): Promise<void> {
    return element(by.id(serviceId)).click();
  }
  public async getMatchServicesPlaceHolder(): Promise<string> {
    return this.serviceFilter.getAttribute('placeholder');
  }
  public async enterServiceFilterSearch(searchValue: string): Promise<void> {
    await this.serviceFilter.sendKeys(searchValue);
  }
  public async enterConfirmMessage(message: string): Promise<void> {
    await this.serviceFilter.sendKeys(message);
  }
  public async clickServiceResult(position: number): Promise<void> {
    const rows = this.trainService;
    await rows.get(position - 1).click();
  }
  public async clickMatch(): Promise<void> {
    return this.matchButton.click();
  }
  public async clickSaveMessage(): Promise<void> {
    return this.saveButton.click();
  }
  public async clickClose(): Promise<void> {
    return this.closeButton.click();
  }
  public async clickUnMatch(): Promise<void> {
    return this.unMatchButton.click();
  }
}
