import {ReplayMapConfigurationClient} from '../../api/replay/replay-map-configuration-client';
import {When} from 'cucumber';
import {CucumberLog} from '../../logging/cucumber-log';
import {expect} from 'chai';

const replayMapConfigurationClient: ReplayMapConfigurationClient = new ReplayMapConfigurationClient();

When('I get the replay map configuration map groupings', async () => {
  const response: any = await replayMapConfigurationClient.getReplayMapGroupings();
  await CucumberLog.addText(`Replay map groupings response: ${JSON.stringify(response.data)}`);
  expect(response.status).to.equal(200);
});
