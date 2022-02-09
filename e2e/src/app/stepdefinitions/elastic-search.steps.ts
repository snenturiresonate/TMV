import {When} from 'cucumber';
import {ElasticSearchClient} from '../api/elastic/elastic-search-client';

const elasticSearchClient: ElasticSearchClient = new ElasticSearchClient();

When('I refresh the Elastic Search indices', async () => {
  await elasticSearchClient.refreshIndices();
});

When('I clear the {word} Elastic Search index', async (indexName: string) => {
  await elasticSearchClient.clearIndex(indexName);
});
