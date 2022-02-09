import {HttpClient} from 'protractor-http-client';
import {browser} from 'protractor';
import {ResponsePromise} from 'protractor-http-client/dist/promisewrappers';
import {CucumberLog} from '../../logging/cucumber-log';

export class ElasticSearchClient {
  public httpClient: HttpClient;
  private elasticHost: string;

  constructor() {
    this.elasticHost = browser.params.test_harness_ci_ip.replace('http://', '').replace('https://', '');
    this.httpClient = new HttpClient(`http://${this.elasticHost}:8210`);
    this.httpClient.failOnHttpError = true;
  }

  public async refreshIndices(): Promise<number> {
    const response: ResponsePromise = this.httpClient.post('/_refresh');
    await CucumberLog.addText(await response.stringBody);
    return response.statusCode;
  }

  public async clearIndex(indexName: string): Promise<number> {
    const response: ResponsePromise = this.httpClient.post(
      '/' + indexName + '/_delete_by_query',
      `{
        "query": {
          "match_all":{}
        }
      }`,
      {
        'Content-Type': 'application/json'
      });
    await CucumberLog.addText(await response.stringBody);
    return response.statusCode;
  }
}
