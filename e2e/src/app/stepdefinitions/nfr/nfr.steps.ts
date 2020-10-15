import {When} from 'cucumber';
import {browser} from "protractor";
import {NFRConfig} from "../../config/nfr-config";

When(/^the maximum amount of time is allowed for end to end transmission$/, async () => {
  await browser.sleep(NFRConfig.E2E_TRANSMISSION_TIME_MS)
});
