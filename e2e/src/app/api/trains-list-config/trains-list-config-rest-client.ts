import {HttpClient} from 'protractor-http-client';
import {browser} from 'protractor';
import {ResponsePromise} from 'protractor-http-client/dist/promisewrappers';
import {LocalStorage} from '../../../../local-storage/local-storage';
import {CucumberLog} from '../../logging/cucumber-log';

export class TrainsListConfigRestClient {
  public httpClient: HttpClient;

  constructor() {
    this.httpClient = new HttpClient(browser.params.test_harness_ci_ip);
    this.httpClient.failOnHttpError = true;
  }

  public async deleteConfiguration(configId: string): Promise<ResponsePromise> {
    const accessToken: string = await LocalStorage.getLocalStorageValueFromRegexKey('CognitoIdentityServiceProvider\..*\.accessToken');
    await CucumberLog.addText(`Using Access Token: ${accessToken}`);
    return this.httpClient.delete('/user-preferences-service/trains-list/configuration/' + configId,
      {security: 'b66d6c7c-7072-11eb-9439-0242ac130002', 'Content-Type': 'application/json',
        Authorization: `Bearer ${accessToken}`}).statusCode;
  }
}
