import {ReplayPageObject} from '../pages/replay.page';
import {Given, When} from 'cucumber';
import * as fs from 'fs';
import {InputBox} from '../pages/common/ui-element-handlers/inputBox';
import {ReplayScenario} from '../utils/replay/replay-scenario';
import {ReplayActionType} from '../utils/replay/replay-action-type';
import {ReplayRecordings} from '../utils/replay/replay-recordings';
import {ReplayStep} from '../utils/replay/replay-step';

const replayPage: ReplayPageObject = new ReplayPageObject();
let replayScenario: ReplayScenario;

When('I expand the replay group of maps with name {string}', async (mapName: string) => {
  await replayPage.expandMapGroupingForName(mapName);
});

When('I select the map {string}', async (location: string) => {
  await replayPage.openMapsList(location);
});

When('I select Start', async () => {
  await replayPage.selectStart();
});

Given(/^I load the replay data from scenario '(.*)'$/, (filepath) => {
  const file = '.tmp/replay-recordings/' + filepath.replace(/ /g, '_') + '.json';
  if (!fs.existsSync(file)) {
    return 'skipped';
  }
  const data = fs.readFileSync(file, 'utf8');
  replayScenario = JSON.parse(data);
});

Given(/^I have set replay time and date from the recorded session$/, async () => {
  await InputBox.ctrlADeleteClear(replayPage.startDate);
  await replayPage.startDate.sendKeys(replayScenario.date);
  await InputBox.ctrlADeleteClear(replayPage.startTime);
  await replayPage.startTime.sendKeys(replayScenario.startTime);
});

When(/^I capture a (INTERPOSE|CANCEL|STEP|SIGNAL_UPDATE|HEARTBEAT|MODIFY_TRAIN_JOURNEY|CHANGE_ID|ACTIVATE_TRAIN|VSTP|TRAIN_RUNNING_INFORMATION) action for replay$/,
  (replayActionType: string, table: any) => {
    ReplayRecordings.addStep(new ReplayStep(ReplayActionType[replayActionType], table.hashes()[0].actionData));
});
