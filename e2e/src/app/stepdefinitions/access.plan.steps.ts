import {Before, When} from 'cucumber';
import {LinxRestClient} from '../api/linx/linx-rest-client';
import {AppPage} from '../pages/app.po';
import * as fs from 'fs';
import {AccessPlanRequest} from '../../../../src/app/api/linx/models/access-plan-request';
import {ProjectDirectoryUtil} from '../utils/project-directory.util';
import * as path from 'path';

let page: AppPage;
let linxRestClient: LinxRestClient;

Before(() => {
  page = new AppPage();
  linxRestClient = new LinxRestClient();
});

When('the access plan located in JSON file {string} is received from LINX', async (jsonFilePath: string) => {
  const rawData: Buffer = fs.readFileSync(path.join(ProjectDirectoryUtil.testDataFolderPath(), jsonFilePath));
  const accessPlanRequest: AccessPlanRequest = JSON.parse(rawData.toString());
  linxRestClient.writeAccessPlan(accessPlanRequest);
});

When('the access plan located in CIF file {string} is received from LINX with name {string}',
  async (cifFilePath: string, cifName: string) => {
  const rawData: Buffer = fs.readFileSync(path.join(ProjectDirectoryUtil.testDataFolderPath(), cifFilePath));
  linxRestClient.addAccessPlan(cifName, rawData.toString());
});

When('the access plan located in CIF file {string} is received from LINX',
  async (cifFilePath: string) => {
    const rawData: Buffer = fs.readFileSync(path.join(ProjectDirectoryUtil.testDataFolderPath(), cifFilePath));
    linxRestClient.addAccessPlan('', rawData.toString());
  });
