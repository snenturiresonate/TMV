import {HttpClient} from 'protractor-http-client';
import {browser} from 'protractor';
import {ResponsePromise} from 'protractor-http-client/dist/promisewrappers';
import {NFRConfig} from '../../config/nfr-config';

export class AdminRestClient {
  public httpClient: HttpClient;

  constructor() {
    this.httpClient = new HttpClient(browser.params.test_harness_ci_ip);
  }

  public postAdminConfiguration(body: string): ResponsePromise {
    return this.httpClient.put('/user-preferences-service/admin/configuration', body,
      {security: 'b66d6c7c-7072-11eb-9439-0242ac130002', 'Content-Type': 'application/json'});
  }

  public async waitMaxTransmissionTime(): Promise<void> {
    await browser.sleep(NFRConfig.E2E_TRANSMISSION_TIME_MS);
  }
}
