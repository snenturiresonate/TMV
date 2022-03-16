import {AdminPageCommon} from '../../pages/administration/administration-common.page';
import {Then, When} from 'cucumber';
import {expect} from 'chai';

const adminCommonPage: AdminPageCommon = new AdminPageCommon();

When('I navigate to the {string} admin tab', async (tabId: string) => {
  await adminCommonPage.openTab(tabId);
});

Then('the following tabs can be seen on the administration', async (adminTabNameDataTable: any) => {
  const expectedTabNames = adminTabNameDataTable.hashes();
  const actualTabNames = await adminCommonPage.getAdministrationTab();
  expectedTabNames.forEach((expectedAdminTabName: any) => {
    expect(actualTabNames, `${expectedAdminTabName.tabName} tab not present`)
      .to.contain(expectedAdminTabName.tabName);
  });
});

Then('there is an unsaved indicator on the Admin Settings', async () => {
  expect(await adminCommonPage.isUnsaved()).to.equal(true);
});
