import {AdministrationBerthSettingsTab} from '../../pages/administration/administration-berthSettings-tab.page';
import {Then} from 'cucumber';
import {expect} from 'chai';
import {protractor} from 'protractor';
import {AdminPunctualityConfigTab} from '../../pages/administration/administration-displaySettings-tab.page';

const adminBerthSettings: AdministrationBerthSettingsTab = new AdministrationBerthSettingsTab();
const adminPunctuality: AdminPunctualityConfigTab = new AdminPunctualityConfigTab();

Then('the berth settings header is displayed as {string}', async (expectedHeader: string) => {
  const actualHeader: boolean = await adminPunctuality.headerTextIsDisplayed(expectedHeader);
  expect(actualHeader).to.equal(true);
});

Then('the following can be seen on the berth color settings table', async (table: any) => {
  const results: any[] = [];
  const tableData = table.hashes();
  for (let i = 0; i < tableData.length; i++) {
    const actualName = await adminBerthSettings.getPunctualityName(i);
    const actualColour = await adminBerthSettings.getPunctualityColour(i);

    results.push(expect(actualName).to.contain(tableData[i].name));
    results.push(expect(actualColour).to.contain(tableData[i].colour));
  }
  return protractor.promise.all(results);
});

Then('I update the Berth settings table as', async (table: any) => {
  const results: any[] = [];
  const tableData = table.hashes();
  for (let i = 0; i < tableData.length; i++) {
    const updateColour = await adminBerthSettings.updatePunctualityColour(i, tableData[i].colour);

    results.push(updateColour);
  }
  return protractor.promise.all(results);
});
