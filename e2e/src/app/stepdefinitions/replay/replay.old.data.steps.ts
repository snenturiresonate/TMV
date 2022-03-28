import {Given} from 'cucumber';
import {ReplayDataService} from '../../services/replay-data.service';
const replayDataService = new ReplayDataService();

Given(/I add the following berth interpose to the old replay snapshot data, modified to be (.*) days old plus (.*) minutes/,
  async (daysOld: number, plusMinutesOffset: number, dataTable: any) => {
    const snapshot = dataTable.hashes()[0];
    await replayDataService.injectBerthStateIntoOldSnapshot(
      daysOld, plusMinutesOffset, snapshot.trainDescriber, snapshot.berthName, snapshot.trainDescription,
      snapshot.signalName, snapshot.punctuality);
  });

Given(/I add the following berth interpose to the old replay object state data, modified to be (.*) days old plus (.*) minutes/,
  async (daysOld: number, plusMinutesOffset: number, dataTable: any) => {
    const snapshot = dataTable.hashes()[0];
    await replayDataService.injectBerthStateIntoOldObjectState(
      daysOld, plusMinutesOffset, snapshot.trainDescriber, snapshot.berthName, snapshot.trainDescription,
      snapshot.signalName, snapshot.punctuality);
  });

Given(/I add map grouping configuration to the old replay data, modified to be (.*) days old/,
  async (daysOld: number) => {
    await replayDataService.injectMapGroupingConfigurationIntoOldData(daysOld);
  });
