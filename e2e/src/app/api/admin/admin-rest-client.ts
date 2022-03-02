import {HttpClient} from 'protractor-http-client';
import {browser} from 'protractor';
import {ResponsePromise} from 'protractor-http-client/dist/promisewrappers';
import {NFRConfig} from '../../config/nfr-config';
import {LocalStorage} from '../../../../local-storage/local-storage';
import {CucumberLog} from '../../logging/cucumber-log';

export class AdminRestClient {
  public httpClient: HttpClient;

  constructor() {
    this.httpClient = new HttpClient(browser.params.test_harness_ci_ip);
  }

  public async postAdminConfiguration(body: string): Promise<ResponsePromise> {
    const accessToken: string = await LocalStorage.getLocalStorageValueFromRegexKey('CognitoIdentityServiceProvider\..*\.accessToken');
    await CucumberLog.addText(`Using Access Token: ${accessToken}`);
    return this.httpClient.put('/user-preferences-service/admin/configuration', JSON.stringify(JSON.parse(body)),
      {'Content-Type': 'application/json', Authorization: `Bearer ${accessToken}`}).statusCode;
  }

  public async waitMaxTransmissionTime(): Promise<void> {
    await browser.sleep(NFRConfig.E2E_TRANSMISSION_TIME_MS);
  }
}
