import {AdminPageCommon} from '../../pages/administration/administration-common.page';
import { When } from 'cucumber';

const adminCommonPage: AdminPageCommon = new AdminPageCommon();

When('I navigate to the {string} admin tab', async (tabId: string) => {
  await adminCommonPage.openTab(tabId);
});
