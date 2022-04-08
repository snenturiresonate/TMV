import {Given} from 'cucumber';
import {ReplayMapDataService} from '../../services/replay/replay-map-data.service';
import {ReplayTimetableDataService} from '../../services/replay/replay-timetable-data.service';
const replayMapDataService = new ReplayMapDataService();
const replayTimetableDataService = new ReplayTimetableDataService();

Given(/I add the following berth interpose to the old replay snapshot data, modified to be (.*) days old plus (.*) minutes/,
  async (daysOld: number, plusMinutesOffset: number, dataTable: any) => {
    const snapshot = dataTable.hashes()[0];
    await replayMapDataService.injectBerthStateIntoOldSnapshot(
      daysOld, plusMinutesOffset, snapshot.trainDescriber, snapshot.berthName, snapshot.trainDescription,
      snapshot.signalName, snapshot.punctuality);
  });

Given(/I add the following berth interpose to the old replay object state data, modified to be (.*) days old plus (.*) minutes/,
  async (daysOld: number, plusMinutesOffset: number, dataTable: any) => {
    const snapshot = dataTable.hashes()[0];
    await replayMapDataService.injectBerthStateIntoOldObjectState(
      daysOld, plusMinutesOffset, snapshot.trainDescriber, snapshot.berthName, snapshot.trainDescription,
      snapshot.signalName, snapshot.punctuality);
  });

Given(/I add the following train running info message to the old replay snapshot data, modified to be (.*) days old plus (.*) minutes/,
  async (daysOld: number, plusMinutesOffset: number, dataTable: any) => {
    const snapshot = dataTable.hashes()[0];
    await replayMapDataService.injectManualTrustBerthSnapshotAudit(
      daysOld, plusMinutesOffset, snapshot.mapId, snapshot.trainUID, snapshot.trainNumber,
      snapshot.locationSubsidiaryCode, snapshot.manualTrustBerthId);
  });


Given(/I add the following train running info message to the old replay object state data, modified to be (.*) days old plus (.*) minutes/,
  async (daysOld: number, plusMinutesOffset: number, dataTable: any) => {
    const snapshot = dataTable.hashes()[0];
    await replayMapDataService.injectManualTrustBerthObjectStateAudit(
      daysOld, plusMinutesOffset, snapshot.trainDescriber, snapshot.trainUID, snapshot.trainNumber,
      snapshot.locationSubsidiaryCode, snapshot.manualTrustBerthId);
  });

Given(/I add map grouping configuration to the old replay data, modified to be (.*) days old/,
  async (daysOld: number) => {
    await replayMapDataService.injectMapGroupingConfigurationIntoOldData(daysOld);
  });

Given(/I add the following active service to the replay schedule data with planningUid (.*) and headcode (.*), modified to be (.*) days old plus (.*) minutes/,
  async (planningUid: string, trainDescription: string, daysOld: number, plusMinutesOffset: number, dataTable: any) => {
    const snapshot = dataTable.hashes();
    await replayTimetableDataService.injectIntoActiveService(
      daysOld, plusMinutesOffset, trainDescription, planningUid, snapshot);
  });

Given(/I add the following punctuality to the replay schedule data, modified to be (.*) days old plus (.*) minutes/,
  async (daysOld: number, plusMinutesOffset: number, dataTable: any) => {
    const snapshot = dataTable.hashes()[0];
    await replayTimetableDataService.injectIntoPunctuality(
      daysOld, plusMinutesOffset, snapshot.planningUid, snapshot.punctuality);
  });

Given(/I add the following planned schedule to the replay schedule data, modified to be (.*) days old plus (.*) minutes/,
  async (daysOld: number, plusMinutesOffset: number, dataTable: any) => {
    const snapshot = dataTable.hashes()[0];
    await replayTimetableDataService.injectIntoPlanned(
      daysOld, plusMinutesOffset, snapshot.trainDescription, snapshot.planningUid, snapshot.numberOfEntries);
  });

Given(/I add the following predicted schedule to the replay schedule data, modified to be (.*) days old plus (.*) minutes/,
  async (daysOld: number, plusMinutesOffset: number, dataTable: any) => {
    const snapshot = dataTable.hashes()[0];
    await replayTimetableDataService.injectIntoPredicted(
      daysOld, plusMinutesOffset, snapshot.trainDescription, snapshot.planningUid);
  });

Given(/I add the following actual schedule to the replay schedule data, modified to be (.*) days old plus (.*) minutes/,
  async (daysOld: number, plusMinutesOffset: number, dataTable: any) => {
    const snapshot = dataTable.hashes()[0];
    await replayTimetableDataService.injectIntoActuals(
      daysOld, plusMinutesOffset, snapshot.trainDescription, snapshot.planningUid);
  });

Given(/I add the following associations to the replay schedule data with planningUid (.*), modified to be (.*) days old plus (.*) minutes/,
  async (planningUid: string, daysOld: number, plusMinutesOffset: number, dataTable: any) => {
    const snapshot = dataTable.hashes();
    await replayTimetableDataService.injectIntoAssociations(
      daysOld, plusMinutesOffset, snapshot, planningUid);
  });
