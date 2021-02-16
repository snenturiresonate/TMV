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

export class LinxRestClient {
  public httpClient: HttpClient;

  constructor() {
    this.httpClient = new HttpClient(browser.params.test_harness_ci_ip + ':8480');
  }

  public postBerthInterpose(body: BerthInterpose): ResponsePromise {
    this.replayRecord(ReplayActionType.INTERPOSE, JSON.stringify(body));
    return this.httpClient.post('/traindescriberupdates/berthinterpose', body);
  }

  public postBerthCancel(body: BerthCancel): ResponsePromise {
    this.replayRecord(ReplayActionType.CANCEL, JSON.stringify(body));
    return this.httpClient.post('/traindescriberupdates/berthcancel', body);
  }

  public postBerthStep(body: BerthStep): ResponsePromise {
    this.replayRecord(ReplayActionType.STEP, JSON.stringify(body));
    return this.httpClient.post('/traindescriberupdates/berthstep', body);
  }

  public postSignallingUpdate(body: SignallingUpdate): ResponsePromise {
    this.replayRecord(ReplayActionType.SIGNAL_UPDATE, JSON.stringify(body));
    return this.httpClient.post('/traindescriberupdates/signallingupdate', body);
  }

  public postHeartbeat(body: Heartbeat): ResponsePromise {
    this.replayRecord(ReplayActionType.HEARTBEAT, JSON.stringify(body));
    return this.httpClient.post('/traindescriberupdates/heartbeat', body);
  }

  public postTrainJourneyModification(body: string): ResponsePromise {
    this.replayRecord(ReplayActionType.MODIFY_TRAIN_JOURNEY, body);
    return this.httpClient.post('/trainjourneymodification/modifytrainjourney', body, {'Content-Type': 'text/plain'});
  }

  public postTrainJourneyModificationIdChange(body: string): ResponsePromise {
    this.replayRecord(ReplayActionType.CHANGE_ID, body);
    return this.httpClient.post('/trainjourneymodification/changeid', body, {'Content-Type': 'text/plain'});
  }

  public postTrainActivation(body: string): ResponsePromise {
    this.replayRecord(ReplayActionType.ACTIVATE_TRAIN, body);
    return this.httpClient.post('/trainactivation/activatetrain', body, {'Content-Type': 'text/plain'});
  }

  public postVstp(body: string): ResponsePromise {
    this.replayRecord(ReplayActionType.VSTP, body);
    return this.httpClient.post('/vstp/vstp', body, {'Content-Type': 'text/plain'});
  }

  public postTrainRunningInformation(body: string): ResponsePromise {
    this.replayRecord(ReplayActionType.TRAIN_RUNNING_INFORMATION, body);
    return this.httpClient.post('/trainrunninginformation/trainrunninginformation', body, {'Content-Type': 'text/plain'});
  }

  public addAccessPlan(fileName: string, body: string): ResponsePromise {
    return this.httpClient.post('/add-access-plan', body,
      {'file-name': fileName, 'Content-Type': 'text/plain'});
  }

  public writeAccessPlan(body: AccessPlanRequest): ResponsePromise {
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
