import {HttpClient} from 'protractor-http-client';
import {browser} from 'protractor';
import {ResponsePromise} from 'protractor-http-client/dist/promisewrappers';
import {CucumberLog} from '../../logging/cucumber-log';

export class ElasticSearchClient {
  public httpClient: HttpClient;

  constructor() {
    this.httpClient = new HttpClient(`http://${browser.params.redis_host}:8210`);
    this.httpClient.failOnHttpError = true;
  }

  public async refreshIndices(): Promise<number> {
    const response: ResponsePromise = this.httpClient.post('/_refresh');
    await CucumberLog.addText(await response.stringBody);
    return response.statusCode;
  }
}
