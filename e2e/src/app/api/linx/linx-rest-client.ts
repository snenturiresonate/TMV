import {HttpClient} from 'protractor-http-client';
import {browser} from 'protractor';
import {ResponsePromise} from 'protractor-http-client/dist/promisewrappers';
import {BerthInterpose} from '../../../../../src/app/api/linx/models/berth-interpose';
import {BerthCancel} from '../../../../../src/app/api/linx/models/berth-cancel';
import {BerthStep} from '../../../../../src/app/api/linx/models/berth-step';
import {Heartbeat} from '../../../../../src/app/api/linx/models/heartbeat';
import {AccessPlanRequest} from '../../../../../src/app/api/linx/models/access-plan-request';
import {NFRConfig} from '../../config/nfr-config';
import {SignallingUpdate} from '../../../../../src/app/api/linx/models/signalling-update';
import {ReplayRecordings} from '../../utils/replay/replay-recordings';
import {ReplayStep} from '../../utils/replay/replay-step';
import {ReplayActionType} from '../../utils/replay/replay-action-type';
import {CucumberLog} from '../../logging/cucumber-log';

export class LinxRestClient {
  public httpClient: HttpClient;

  constructor() {
    this.httpClient = new HttpClient(browser.params.test_harness_ci_ip + ':8480');
  }

  public async postBerthInterpose(body: BerthInterpose): Promise<ResponsePromise> {
    this.replayRecord(ReplayActionType.INTERPOSE, JSON.stringify(body));
    const response = await this.httpClient.post('/traindescriberupdates/berthinterpose', body);
    await this.waitMaxTransmissionTime();
    return response;
  }

  public async postInterpose(timestamp: string, toBerth: string, trainDescriber: string, trainDescription: string): Promise<any> {
    const berthInterpose: BerthInterpose = new BerthInterpose(
      timestamp,
      toBerth,
      trainDescriber,
      trainDescription
    );
    await CucumberLog.addJson(berthInterpose);
    await this.postBerthInterpose(berthInterpose);
    return this.waitMaxTransmissionTime();
  }

  public async postBerthCancel(body: BerthCancel): Promise<ResponsePromise> {
    this.replayRecord(ReplayActionType.CANCEL, JSON.stringify(body));
    const response = await this.httpClient.post('/traindescriberupdates/berthcancel', body);
    await this.waitMaxTransmissionTime();
    return response;
  }

  public async postBerthStep(body: BerthStep): Promise<ResponsePromise> {
    this.replayRecord(ReplayActionType.STEP, JSON.stringify(body));
    const response = await this.httpClient.post('/traindescriberupdates/berthstep', body);
    await this.waitMaxTransmissionTime();
    return response;
  }

  public async postSignallingUpdate(body: SignallingUpdate): Promise<ResponsePromise> {
    this.replayRecord(ReplayActionType.SIGNAL_UPDATE, JSON.stringify(body));
    const response = await this.httpClient.post('/traindescriberupdates/signallingupdate', body);
    await this.waitMaxTransmissionTime();
    return response;
  }

  public async postHeartbeat(body: Heartbeat): Promise<ResponsePromise> {
    this.replayRecord(ReplayActionType.HEARTBEAT, JSON.stringify(body));
    const response = await this.httpClient.post('/traindescriberupdates/heartbeat', body);
    await this.waitMaxTransmissionTime();
    return response;
  }

  public async postTrainJourneyModification(body: string): Promise<ResponsePromise> {
    this.replayRecord(ReplayActionType.MODIFY_TRAIN_JOURNEY, body);
    const response = await this.httpClient.post('/trainjourneymodification/modifytrainjourney', body, {'Content-Type': 'text/plain'});
    await this.waitMaxTransmissionTime();
    return response;
  }

  public async postTrainJourneyModificationIdChange(body: string): Promise<ResponsePromise> {
    this.replayRecord(ReplayActionType.CHANGE_ID, body);
    const response = await this.httpClient.post('/trainjourneymodification/changeid', body, {'Content-Type': 'text/plain'});
    await this.waitMaxTransmissionTime();
    return response;
  }

  public async postTrainActivation(body: string): Promise<ResponsePromise> {
    this.replayRecord(ReplayActionType.ACTIVATE_TRAIN, body);
    const response = await this.httpClient.post('/trainactivation/activatetrain', body, {'Content-Type': 'text/plain'});
    await this.waitMaxTransmissionTime();
    return response;
  }

  public async postVstp(body: string): Promise<ResponsePromise> {
    this.replayRecord(ReplayActionType.VSTP, body);
    const response = await this.httpClient.post('/vstp/vstp', body, {'Content-Type': 'text/plain'});
    await this.waitMaxTransmissionTime();
    return response;
  }

  public async postTrainRunningInformation(body: string): Promise<ResponsePromise> {
    this.replayRecord(ReplayActionType.TRAIN_RUNNING_INFORMATION, body);
    const response = await this.httpClient.post('/trainrunninginformation/trainrunninginformation', body, {'Content-Type': 'text/plain'});
    await this.waitMaxTransmissionTime();
    return response;
  }

  public async addAccessPlan(fileName: string, body: string): Promise<ResponsePromise> {
    return this.httpClient.post('/add-access-plan', body,
      {'file-name': fileName, 'Content-Type': 'text/plain'});
  }

  public async clearCIFs(): Promise<ResponsePromise> {
    return this.httpClient.post('/clear-access-plans');
  }

  public async writeAccessPlan(body: AccessPlanRequest): Promise<ResponsePromise> {
    return this.httpClient.post('/write-access-plan', body);
  }

  public async waitMaxTransmissionTime(): Promise<void> {
    await browser.sleep(NFRConfig.E2E_TRANSMISSION_TIME_MS);
  }

  public replayRecord(action: ReplayActionType, message: string): void {
    if (ReplayRecordings.isRecording()) {
      ReplayRecordings.addStep(new ReplayStep(action, message));
    }
  }
}
