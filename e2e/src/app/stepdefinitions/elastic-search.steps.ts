import {When} from 'cucumber';
import {ElasticSearchClient} from '../api/elastic/elastic-search-client';
import {browser} from 'protractor';
import {DelayUtils} from '../utils/delayUtils';

const elasticSearchClient: ElasticSearchClient = new ElasticSearchClient();

When('I refresh the Elastic Search indices', async () => {
  await elasticSearchClient.refreshIndices();
});

When('I clear the {word} Elastic Search index', async (indexName: string) => {
  let attempts = 1;
  let httpStatus = await elasticSearchClient.clearIndex(indexName);

  while (httpStatus !== 200 || attempts <= browser.params.elasticSearch.index_clear.maxAttempts) {
    await DelayUtils.waitFor(browser.params.elasticSearch.index_clear.retry_delay_ms);
    attempts++;
    httpStatus = await elasticSearchClient.clearIndex(indexName);
  }
});
