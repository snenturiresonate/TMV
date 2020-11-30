import {browser, by, element, ElementArrayFinder, ElementFinder, ExpectedConditions} from 'protractor';
import {TimetableTableRowPageObject} from './sections/timetable.tablerow.page';
import * as assert from 'assert';

export class TimetablePageObject {

  public rows: ElementArrayFinder;
  public insertedToggle: ElementFinder;
  public insertedToggleState: ElementFinder;
  constructor() {
    this.rows = element.all(by.css('[id^=tmv-timetable-row]'));
    this.insertedToggle = element(by.css('#live-timetable-toggle-menu .toggle-switch'));
    this.insertedToggleState = element(by.css('#live-timetable-toggle-menu [class^=absolute]'));
  }

  navigateTo(service: string): Promise<unknown> {
    return browser.get(browser.baseUrl + '/tmv/live-timetable/' + service) as Promise<unknown>;
  }

  async getTableRows(): Promise<TimetableTableRowPageObject[]> {
    await browser.wait(ExpectedConditions.visibilityOf(this.rows.first()), 4000, 'wait for timetable to load');
    return this.rows.map(row => row.getAttribute('id'))
      .then(list => list.map(id => new TimetableTableRowPageObject(id.toString())));
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

  async getRowByLocation(location: string): Promise<TimetableTableRowPageObject> {
    const rowIndex = await this.getLocationRowIndex(location);
    if (rowIndex === -1)
    {
      assert.fail('no row for location ' + location);
    }
    const rows = await this.getTableRows();
    return rows[rowIndex];
  }
}
