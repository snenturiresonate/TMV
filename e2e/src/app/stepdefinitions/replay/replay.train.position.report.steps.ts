import {Then, When} from 'cucumber';
import { expect } from 'chai';
import {by, element, protractor} from 'protractor';
import {ReplayTrainPositionReportPage} from '../../pages/replay/replay.train.position.report.page';


const tprPage: ReplayTrainPositionReportPage = new ReplayTrainPositionReportPage();


When('I Click on the TPR link', async () => {
  await tprPage.clickTprLink();
});

Then('the following can be seen on the tpr settings table', async (table: any) => {
  const results: any[] = [];
  const tableData: any = table.hashes();
  for (let i = 0; i < tableData.length; i++) {
    const actualTrainDescription = await tprPage.getTrainDescription(i);
    const actualOperator = await tprPage.getOperator(i);
    const actualBerth = await tprPage.getBerth(i);
    const actualPunctuality = await tprPage.getPunctuality(i);
    const actualTime = await tprPage.getTime(i);
    results.push(expect(actualTrainDescription).to.contain(tableData[i].trainDescription));
    results.push(expect(actualOperator).to.contain(tableData[i].operator));
    results.push(expect(actualBerth).to.contain(tableData[i].berth));
    results.push(expect(actualPunctuality).to.contain(tableData[i].punctuality));
    results.push(expect(actualTime).to.contain(tableData[i].time));
  }
  return protractor.promise.all(results);
});

When('I am sorting the train report table based on {string}', async (sortId: string) => {
  await tprPage.sortTprTable(sortId);
});

Then('the admin tpr filter placeholder is displayed as {string}', async (expectedPlaceholder: string) => {
  const actualPlaceholder: string = await tprPage.getTprFilterPlaceHolder();
  expect(actualPlaceholder).to.equal(expectedPlaceholder);
});

Then('the user enter the filter value {string} for tpr', async (searchValue: string) => {
  await tprPage.enterReportFilterSearch(searchValue);
});
