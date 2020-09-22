import {HttpClient} from 'protractor-http-client';
import {browser} from 'protractor';
import {ResponsePromise} from 'protractor-http-client/dist/promisewrappers';
import {BerthInterpose} from '../../../../../src/app/api/linx/models/berth-interpose';
import {BerthCancel} from '../../../../../src/app/api/linx/models/berth-cancel';
import {BerthStep} from '../../../../../src/app/api/linx/models/berth-step';
import {Heartbeat} from '../../../../../src/app/api/linx/models/heartbeat';
import {AccessPlanRequest} from '../../../../../src/app/api/linx/models/access-plan-request';

export class LinxRestClient {
  public httpClient: HttpClient;

  constructor() {
    this.httpClient = new HttpClient(browser.baseUrl + ':8480');
  }

  public postBerthInterpose(body: BerthInterpose): ResponsePromise {
    return this.httpClient.post('/traindescriberupdates/berthinterpose', body);
  }

  public postBerthCancel(body: BerthCancel): ResponsePromise {
    return this.httpClient.post('/traindescriberupdates/berthcancel', body);
  }

  public postBerthStep(body: BerthStep): ResponsePromise {
    return this.httpClient.post('/traindescriberupdates/berthstep', body);
  }

  public postHeartbeat(body: Heartbeat): ResponsePromise {
    return this.httpClient.post('/traindescriberupdates/heartbeat', body);
  }

  public postTrainJourneyModification(body: string): ResponsePromise {
    return this.httpClient.post('/trainjourneymodification/modifytrainjourney', body, {'Content-Type': 'text/plain'});
  }

  public postTrainJourneyModificationIdChange(body: string): ResponsePromise {
    return this.httpClient.post('/trainjourneymodification/changeid', body, {'Content-Type': 'text/plain'});
  }

  public postTrainActivation(body: string): ResponsePromise {
    return this.httpClient.post('/trainactivation/activatetrain', body, {'Content-Type': 'text/plain'});
  }

  public postVstp(body: string): ResponsePromise {
    return this.httpClient.post('/vstp/vstp', body, {'Content-Type': 'text/plain'});
  }

  public postTrainRunningInformation(body: string): ResponsePromise {
    return this.httpClient.post('/trainrunninginformation/trainrunninginformation', body, {'Content-Type': 'text/plain'});
  }

  public addAccessPlan(fileName: string, body: string): ResponsePromise {
    return this.httpClient.post('/add-access-plan', body,
      {'file-name': fileName, 'Content-Type': 'text/plain'});
  }

  public writeAccessPlan(body: AccessPlanRequest): ResponsePromise {
    return this.httpClient.post('/write-access-plan', body);
  }

}
