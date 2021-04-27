import {ModificationsTablerowPage} from './modifications.tablerow.page';
import {of} from 'rxjs';
import {browser, by, element, ElementArrayFinder, ElementFinder, ExpectedConditions} from 'protractor';
import {TimetableTableRowPageObject} from '../sections/timetable.tablerow.page';
import * as assert from 'assert';
import {CssColorConverterService} from '../../services/css-color-converter.service';

export class TimeTablePageObject {
  public timetableTab: ElementFinder;
  public detailsTab: ElementFinder;
  public headerLabels: ElementArrayFinder;
  public headerScheduleType: ElementFinder;
  public headerSignal: ElementFinder;
  public headerLastReported: ElementFinder;
  public headerTrainUid: ElementFinder;
  public headerTrustId: ElementFinder;
  public headerTJM: ElementFinder;
  public changeEnRoute: ElementArrayFinder;
  public modification: ElementArrayFinder;
  public headerHeadcode: ElementFinder;
  public headerOldHeadcode: ElementFinder;
  public navBarIndicatorColor: ElementFinder;
  public navBarIndicatorText: ElementFinder;
  public rows: ElementArrayFinder;
  public insertedToggle: ElementFinder;
  public insertedToggleState: ElementFinder;
  public timetableHeaderThElements: ElementArrayFinder;
  constructor() {
    this.headerLabels = element.all(by.css('.tmv-header-content [id$=Label]'));
    this.timetableTab = element(by.id('timetable-table-tab'));
    this.detailsTab = element(by.id('timetable-details-tab'));
    this.headerScheduleType = element(by.id('timetableHeaderScheduleType'));
    this.headerHeadcode = element(by.id('timetable-header-service-information-current-train-description'));
    this.headerOldHeadcode = element(by.id('timetable-header-service-information-planned-train-description'));
    this.headerSignal = element(by.id('timetableHeaderSignalPlatedName'));
    this.headerLastReported = element(by.id('timetableHeaderTrainRunningInformation'));
    this.headerTrainUid = element(by.id('timetableHeaderPlanningUid'));
    this.headerTrustId = element(by.id('timetableHeaderTrustTrainId'));
    this.headerTJM = element(by.id('timetableHeaderTrainJourneyModification'));
    this.changeEnRoute = element.all(by.css('.change-en-route-table >tbody >div >tr>td'));
    this.modification = element.all(by.css('.modification-table >tbody >div >tr>td'));
    this.navBarIndicatorColor = element(by.css('.dot-punctuality-text:nth-child(1)'));
    this.navBarIndicatorText = element(by.css('.punctuality-text:nth-child(2)'));
    this.rows = element.all(by.css('[id^=tmv-timetable-row]'));
    this.insertedToggle = element(by.css('#live-timetable-toggle-menu .toggle-switch'));
    this.insertedToggleState = element(by.css('#live-timetable-toggle-menu [class^=absolute]'));
    this.timetableHeaderThElements = element.all(by.css('[id^=tmv-timetable-header-row] th'));
  }

  async getTableRows(): Promise<TimetableTableRowPageObject[]> {
    await browser.wait(ExpectedConditions.visibilityOf(this.rows.first()), 4000, 'wait for timetable to load');
    return this.rows.map(row => row.getAttribute('id'))
      .then(list => list.map(id => new TimetableTableRowPageObject(element(by.id(id.toString())))));
  }

  async getHeaderColours(): Promise<string[]> {
    return this.timetableHeaderThElements.map(elem => elem.getCssValue('background-colour'));
  }
  async toggleInserted(status: string): Promise<void> {
    const state = await this.insertedToggleState.getText();
    if (status.toLowerCase() !== state) {
      this.insertedToggle.click();
    }
  }
  async getLocations(): Promise<string[]> {
    const rows = await this.getTableRows();
    return Promise.all(rows.map(row => row.getLocation()));
  }

  async getLocationRowIndex(location: string): Promise<number> {
    const locations = await this.getLocations();
    return locations.indexOf(location);
  }

  ensureInsertedLocationFormat(location: string): string {
    if (! location.startsWith('[')) {
      location = '[' + location + ']';
    }
    return location;
  }

  async pathTextToEqual(location: string, expectPathText: string): Promise<void> {
    const row = await this.getRowByLocation(location);
    const actualPathText = await row.path.getText();
    assert(expectPathText === actualPathText,
      `location ${location} should have path code ${expectPathText}, was ${actualPathText}`);
  }

  async lineTextToEqual(location: string, expectLineText: string): Promise<void> {
    const row = await this.getRowByLocation(location);
    const actualLineText = await row.path.getText();
    assert(expectLineText === actualLineText,
      `location ${location} should have path code ${expectLineText}, was ${actualLineText}`);
  }

  async getRowByLocation(location: string): Promise<TimetableTableRowPageObject> {
    const rowIndex = await this.getLocationRowIndex(location);
    if (rowIndex === -1)
    {
      assert.fail('no row for location ' + location);
    }
    const rows = await this.getTableRows();
    return rows[rowIndex];
  }
  public async isTimetableTableTabVisible(): Promise<boolean> {
    const timetableTabClasses: string = await element(by.id('timetable-table-tab')).getAttribute('class');
    return timetableTabClasses.indexOf('tmv-tab-timetable-active') > -1;
  }
  public async isTimetableServiceDescriptionVisible(): Promise<boolean> {
    browser.wait(async () => {
      return this.headerHeadcode.isPresent();
    }, browser.displayTimeout, 'The timetable service information description should be displayed');

    return this.headerHeadcode.isPresent();
  }

  public async getHeaderTrainDescription(): Promise<string> {
    await browser.wait(async () => {
      return this.headerHeadcode.isPresent();
    }, browser.displayTimeout, 'The timetable header train description should be displayed');

    const currentDescription: string = await this.headerHeadcode.getText();
    const plannedDescription: string = await this.headerOldHeadcode.isPresent()
      ? ' ' + await this.headerOldHeadcode.getText() : '';

    return of(currentDescription + plannedDescription).toPromise();
  }

  public async getTimetableEntryColValues(timetableEntryId: string): Promise<string[]> {
    await browser.wait(async () => {
      return element(by.id('tmv-timetable-row-' + timetableEntryId)).isPresent();
    }, browser.displayTimeout, 'The timetable entry row should be displayed');

    const entryColValues: ElementArrayFinder = element.all(by.css('#tmv-timetable-row-' + timetableEntryId + ' td'));
    return entryColValues.map((colValue: ElementFinder) => {
      return colValue.getText();
    });
  }
  public async getTimetableEntryValsForLoc(LocId: string): Promise<string[]> {

    const locStrings = LocId.split('\n');
    const locString = locStrings[0] + ' ';
    await browser.wait(async () => {
      return element.all(by.xpath('//*[child::*[text()=\'' + locString + '\']]')).isPresent();
    }, browser.displayTimeout, 'The timetable entry row should be displayed');

    const entryColValues: ElementArrayFinder = element.all(by.xpath('//*[child::*[text()=\'' + locString + '\']]/td'));
    return entryColValues.map((colValue: ElementFinder) => {
      return colValue.getText();
    });
  }

  public async toggleInsertedLocationsOn(): Promise<void> {
    await element(by.css('#live-timetable-toggle-menu .toggle-switch .absolute-off')).click();
  }

  public async toggleInsertedLocationsOff(): Promise<void> {
    await element(by.css('#live-timetable-toggle-menu .toggle-switch .absolute-on')).click();
  }

  public async getLiveTimetableTabName(): Promise<string> {
    return this.timetableTab.getText();
  }

  public async openDetailsTab(): Promise<void> {
    await this.detailsTab.click();
    await element(by.css('.tmv-tab-timetable-active')).getText()
      .then(async text => {
        if (text !== 'Details') {
          await this.detailsTab.click();
        }
      });
  }

  public async getModificationsTableRows(): Promise<ModificationsTablerowPage[]> {
    const rowLocator = by.css('table.modification-table tbody tr');
    await browser.wait(ExpectedConditions.visibilityOf(element(rowLocator)), 15000, 'Modifications table is not shown');
    const array = new Array<ModificationsTablerowPage>();
    await element.all(rowLocator)
      .each((row, index) => {
        array.push(new ModificationsTablerowPage(element(by.css(`table.modification-table tbody tr:nth-child(${index + 1})`))));
      });
    return array;
  }

  public async getTimetableHeaderPropertyLabels(): Promise<string[]> {
    return this.headerLabels.map((labelValue: ElementFinder) => {
      return labelValue.getText();
    });
  }

  public async isTimetableDetailsTabVisible(): Promise<boolean> {
    browser.wait(async () => {
      return element(by.id('timetable-details-table')).isPresent();
    }, browser.displayTimeout, 'The timetable details table should be displayed');

    const timetableTabClasses: string = await element(by.id('timetable-details-tab')).getAttribute('class');
    return timetableTabClasses.indexOf('tmv-tab-timetable-active') > -1;
  }

  public async getTimetableModificationColValues(index: number): Promise<string[]> {
    const entryColValues: ElementArrayFinder = element.all(by.css('#timetable-modifications-' + (index - 1).toString() + ' td'));
    return entryColValues.map((colValue: ElementFinder) => {
      return colValue.getText();
    });
  }
  public async getTimetableAssociationsColValues(index: number): Promise<string[]> {
    const entryColValues: ElementArrayFinder = element.all(by.css('#timetable-associations-' + (index - 1).toString() + ' td'));
    return entryColValues.map((colValue: ElementFinder) => {
      return colValue.getText();
    });
  }

  public async getChangeEnRouteValues(): Promise<string> {
    return this.changeEnRoute.getText();
  }

  public async getNavBarIndicatorColorHex(): Promise<string> {
    const navIndicatorColourRgb = await this.navBarIndicatorColor.getCssValue('background-color');
    return CssColorConverterService.rgb2Hex(navIndicatorColourRgb);
  }

  public async getNavBarIndicatorText(): Promise<string> {
    return this.navBarIndicatorText.getText();
  }


  public async getTimetableDetailsRowValueDaysRun(): Promise<string> {
    return this.getTimetableDetailsRowValue('daysRun');
  }
  public async getTimetableDetailsRowValueRuns(): Promise<string> {
    return this.getTimetableDetailsRowValue('runs');
  }
  public async getTimetableDetailsRowValueBankHoliday(): Promise<string> {
    return this.getTimetableDetailsRowValue('bankHoliday');
  }
  public async getTimetableDetailsRowValueBerthId(): Promise<string> {
    return this.getTimetableDetailsRowValue('berthId');
  }
  public async getTimetableDetailsRowValueOperator(): Promise<string> {
    return this.getTimetableDetailsRowValue('operator');
  }
  public async getTimetableDetailsRowValueTrainServiceCode(): Promise<string> {
    return this.getTimetableDetailsRowValue('trainServiceCode');
  }
  public async getTimetableDetailsRowValueTrainCategory(): Promise<string> {
    return this.getTimetableDetailsRowValue('trainCategory');
  }
  public async getTimetableDetailsRowValueDirection(): Promise<string> {
    return this.getTimetableDetailsRowValue('direction');
  }
  public async getTimetableDetailsRowValueCateringCode(): Promise<string> {
    return this.getTimetableDetailsRowValue('cateringCode');
  }
  public async getTimetableDetailsRowValueClass(): Promise<string> {
    return this.getTimetableDetailsRowValue('class');
  }
  public async getTimetableDetailsRowValueReservations(): Promise<string> {
    return this.getTimetableDetailsRowValue('reservations');
  }
  public async getTimetableDetailsRowValueTimingLoad(): Promise<string> {
    return this.getTimetableDetailsRowValue('timingLoad');
  }
  public async getTimetableDetailsRowValuePowerType(): Promise<string> {
    return this.getTimetableDetailsRowValue('powerType');
  }
  public async getTimetableDetailsRowValueSpeed(): Promise<string> {
    return this.getTimetableDetailsRowValue('speed');
  }
  public async getTimetableDetailsRowValuePortionId(): Promise<string> {
    return this.getTimetableDetailsRowValue('portionId');
  }
  public async getTimetableDetailsRowValueTrainLength(): Promise<string> {
    return this.getTimetableDetailsRowValue('trainLength');
  }
  public async getTimetableDetailsRowValueTrainOperatingCharacteristcs(): Promise<string> {
    return this.getTimetableDetailsRowValue('trainOperatingCharacteristcs');
  }
  public async getTimetableDetailsRowValueServiceBranding(): Promise<string> {
    return this.getTimetableDetailsRowValue('serviceBranding');
  }

  private async getTimetableDetailsRowValue(attrId: string): Promise<string> {
    return element(by.id(attrId)).getText();
  }

  public async waitUntilPropertyValueIs(propertyName: string, expectedString: string): Promise<void> {
    browser.wait(ExpectedConditions.textToBePresentInElement(element(by.id(propertyName)), expectedString));
  }
}
