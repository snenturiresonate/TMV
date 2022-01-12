import {expect} from 'chai';
import {TrainsListConfigRestClient} from '../../api/trains-list-config/trains-list-config-rest-client';
import {Given} from 'cucumber';

const trainListConfigRestClient: TrainsListConfigRestClient = new TrainsListConfigRestClient();
Given('I restore to default train list config {string}', async (configId: string) => {
  expect(await trainListConfigRestClient.deleteConfiguration(configId)).to.equal(200);
});
