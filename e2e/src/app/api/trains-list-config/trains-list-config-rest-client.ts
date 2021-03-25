import {HttpClient} from 'protractor-http-client';
import {browser} from 'protractor';
import {ResponsePromise} from 'protractor-http-client/dist/promisewrappers';
import {LocalStorage} from '../../../../local-storage/local-storage';

export class TrainsListConfigRestClient {
  public httpClient: HttpClient;

  constructor() {
    this.httpClient = new HttpClient(browser.params.test_harness_ci_ip);
    this.httpClient.failOnHttpError = true;
  }

  public async deleteConfiguration(): Promise<ResponsePromise> {
    const accessToken = await browser.params.access_token;
    return this.httpClient.delete('/user-preferences-service/trains-list/configuration',
      {security: 'b66d6c7c-7072-11eb-9439-0242ac130002', 'Content-Type': 'application/json',
        Authorization: `Bearer ${accessToken}`}).statusCode;
  }
}
