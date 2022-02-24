import {HttpClient} from 'protractor-http-client';
import {browser} from 'protractor';
import {ResponsePromise} from 'protractor-http-client/dist/promisewrappers';
import {LocalStorage} from '../../../../local-storage/local-storage';
import {CucumberLog} from '../../logging/cucumber-log';
import * as fs from 'fs';
import * as path from 'path';
import {ProjectDirectoryUtil} from '../../utils/project-directory.util';

export class RestrictionsRestClient {
  public httpClient: HttpClient;

  constructor() {
    this.httpClient = new HttpClient(browser.params.test_harness_ci_ip);
    this.httpClient.failOnHttpError = true;
  }

  public async deleteRestriction(body: string): Promise<ResponsePromise> {
    const accessToken: string = await LocalStorage.getLocalStorageValueFromRegexKey('CognitoIdentityServiceProvider\..*\.accessToken');
    await CucumberLog.addText(`Using Access Token: ${accessToken}`);
    return this.httpClient.post('/infrastructure-restrictions-service/restrictions', JSON.stringify(JSON.parse(body)),
      {security: 'b66d6c7c-7072-11eb-9439-0242ac130002', 'Content-Type': 'application/json',
        Authorization: `Bearer ${accessToken}`}).statusCode;
  }

  public async getRestrictions(trackDivisionId: string): Promise<ResponsePromise> {
    const accessToken: string = await LocalStorage.getLocalStorageValueFromRegexKey('CognitoIdentityServiceProvider\..*\.accessToken');
    await CucumberLog.addText(`Using Access Token: ${accessToken}`);
    return this.httpClient.get('/infrastructure-restrictions-service/restrictions/' + trackDivisionId,
      {security: 'b66d6c7c-7072-11eb-9439-0242ac130002', 'Content-Type': 'application/json',
        Authorization: `Bearer ${accessToken}`}).jsonBody;
  }

  public async deleteRestrictionsForTrack(trackDivisionId: string): Promise<void>{
    const restrictionsRetrieved = await this.getRestrictions(trackDivisionId);
    const dataTemplate: Buffer = fs.readFileSync(path.join(ProjectDirectoryUtil.testDataFolderPath(), 'admin/post-restrictions-template.json'));
    const numRestrictions = restrictionsRetrieved.restrictions.length;
    for (let i = 0; i < numRestrictions; i++) {
      const dataToDelete = dataTemplate.toString()
        .replace('restrictionIdData', restrictionsRetrieved.restrictions[i].restrictionId)
        .replace('trackDivisionIdData', restrictionsRetrieved.restrictions[i].trackDivisionIds[0]);
      await this.deleteRestriction(dataToDelete);
    }
  }

}
