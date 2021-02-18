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

When('the access plan located in CIF file {string} is amended so that all services start within the next hour and then received from LINX',
  async (cifFilePath: string) => {
    const rawData: Buffer = fs.readFileSync(path.join(ProjectDirectoryUtil.testDataFolderPath(), cifFilePath));
    const initialString = rawData.toString();
    const cifLines: string[] = initialString.split(/\r?\n/, 1000);
    const now = new Date();
    const startHours = Number(now.getHours());
    const startMins = Number(now.getMinutes());
    let setHours = startHours;
    let trainWTTStartHours = 0;
    let trainWTTStartMins = 0;
    for (let i = 0; i < cifLines.length; i++) {
      if (cifLines[i].indexOf('LO') === 0) {
        // for each LO record, set up the trainWTTStartHours, setHours values which are then used for subsequest LI and LT records
        trainWTTStartHours = Number(cifLines[i].substr(10, 2));
        trainWTTStartMins = Number(cifLines[i].substr(12, 2));
        if (trainWTTStartMins < startMins) {
          setHours = startHours + 1;
        }
        else {
          setHours = startHours;
        }
        cifLines[i] = dealWithLOOrLTRecord(cifLines[i], trainWTTStartHours, setHours);
      }
      else if (cifLines[i].indexOf('LI') === 0) {
        cifLines[i] = dealWithLIRecord(cifLines[i], trainWTTStartHours, setHours);
      }
      else if (cifLines[i].indexOf('LT') === 0) {
        cifLines[i] = dealWithLOOrLTRecord(cifLines[i], trainWTTStartHours, setHours);
      }
      else {
        cifLines[i] = cifLines[i] + ' '.repeat(80 - cifLines[i].length) + '\r\n';
      }
    }
    // put it all back together and load
    const newData = cifLines.join('');
    linxRestClient.addAccessPlan('', newData);
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

When(/^the access (?:plan is|plans are) received from LINX$/, async (cifFilePaths: any) => {
    const cifFiles: any = cifFilePaths.hashes();
    cifFiles.forEach((cifFile: any) => {
      const rawData: Buffer = fs.readFileSync(path.join(ProjectDirectoryUtil.testDataFolderPath(), cifFile.path));
      linxRestClient.addAccessPlan('', rawData.toString());
    });
  });

function dealWithLOOrLTRecord(cifLine: string, trainStartHours, hoursVal: number): string {
  // replace positions 11-12 and 16-17
  const padToEighty = ' '.repeat(80 - cifLine.length);
  const LO1 = cifLine.substr(0, 10);
  const LO2DepWTTHours = cifLine.substr(10, 2);
  const LO2 = pickCorrectHoursString(LO2DepWTTHours, trainStartHours, hoursVal);
  const LO3 = cifLine.substr(12, 3);
  const LO4DepPTHours = cifLine.substr(15, 2);
  const LO4 = pickCorrectHoursString(LO4DepPTHours, trainStartHours, hoursVal);
  const LO5 = cifLine.substr(17, 63);
  const LO6 = '\r\n';
  return LO1 + LO2 + LO3 + LO4 + LO5 + padToEighty + LO6;
}

function dealWithLIRecord(cifLine: string, trainStartHours, hoursVal: number): string {
  // replace positions (11-12 and 16-17 and 26-27 and 30-31) or 21-22
  const LI1 = cifLine.substr(0, 10);
  const padToEighty = ' '.repeat(80 - cifLine.length);

  // case of a pass
  if (cifLine.substr(10, 2) === '  ') {
    const LI2 = cifLine.substr(10, 10);
    const LI3PassPTHours = cifLine.substr(20, 2);
    const LI3 = pickCorrectHoursString(LI3PassPTHours, trainStartHours, hoursVal);
    const LI4 = cifLine.substr(22, 58);
    const LI5 = '\r\n';
    return LI1 + LI2 + LI3 + LI4 + padToEighty + LI5;
    }

  // case of a stop
  else {
    const LI2ArrWTTHours = cifLine.substr(10, 2);
    const LI2 = pickCorrectHoursString(LI2ArrWTTHours, trainStartHours, hoursVal);
    const LI3 = cifLine.substr(12, 3);
    const LI4DepWTTHours = cifLine.substr(15, 2);
    const LI4 = pickCorrectHoursString(LI4DepWTTHours, trainStartHours, hoursVal);
    const LI5 = cifLine.substr(17, 8);
    const LI6ArrPTHours = cifLine.substr(25, 2);
    const LI6 = pickCorrectHoursString(LI6ArrPTHours, trainStartHours, hoursVal);
    const LI7 = cifLine.substr(27, 2);
    const LI8DepPTHours = cifLine.substr(29, 2);
    const LI8 = pickCorrectHoursString(LI8DepPTHours, trainStartHours, hoursVal);
    const LI9 = cifLine.substr(31, 49);
    const LI10 = '\r\n';
    return LI1 + LI2 + LI3 + LI4 + LI5 + LI6 + LI7 + LI8 + LI9 + padToEighty + LI10;
  }
}

function pickCorrectHoursString(initialString: string, trainStartHours, hoursVal: number): string {
  const hoursDiff = Number(initialString) - trainStartHours;
  return String(hoursVal + hoursDiff).padStart(2, '0');
}
