import {expect} from 'chai';
import {TrainsListConfigRestClient} from '../../api/trains-list-config/trains-list-config-rest-client';
import {Given} from 'cucumber';

const trainListConfigRestClient: TrainsListConfigRestClient = new TrainsListConfigRestClient();
Given('I restore to default train list config {string}', async (configId: string) => {
  expect(await trainListConfigRestClient.deleteConfiguration(configId)).to.equal(200);
});

Given('I restore all train list configs for current user to the default', async () => {
  expect(await trainListConfigRestClient.deleteConfiguration( '1')).to.equal(200);
  expect(await trainListConfigRestClient.deleteConfiguration( '2')).to.equal(200);
  expect(await trainListConfigRestClient.deleteConfiguration( '3')).to.equal(200);
});
