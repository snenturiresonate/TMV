import {Before, When} from 'cucumber';
import {LinxRestClient} from '../api/linx/linx-rest-client';
import {AppPage} from '../pages/app.po';
import * as fs from 'fs';
import {AccessPlanRequest} from '../../../../src/app/api/linx/models/access-plan-request';

let page: AppPage;
let linxRestClient: LinxRestClient;

Before(() => {
  page = new AppPage();
  linxRestClient = new LinxRestClient();
});

When('the access plan located in JSON file {string} is received from LINX', async (jsonFilePath: string) => {
  const rawData: Buffer = fs.readFileSync(jsonFilePath);
  const accessPlanRequest: AccessPlanRequest = JSON.parse(rawData.toString());
  linxRestClient.writeAccessPlan(accessPlanRequest);
});
