import {Then, When} from 'cucumber';
import { expect } from 'chai';
import {TrainsListPunctualityConfigTab} from '../../pages/trains-list-config/trains.list.punctuality.config.tab';
import {protractor} from 'protractor';

const trainsListPunctuality: TrainsListPunctualityConfigTab = new TrainsListPunctualityConfigTab();

Then('the punctuality header is displayed as {string}', async (expectedHeader: string) => {
  const actualHeader: string = await trainsListPunctuality.getTrainPunctualityHeader();
  expect(actualHeader).to.equal(expectedHeader);
});

Then('the following can be seen on the punctuality table', {timeout: 6 * 5000}, async (table: any) => {
  const results: any[] = [];
  const expectedValues = table.hashes();
  for (let i = 0; i < table.hashes().length; i++) {
    const actualPunctualityColors: string = await trainsListPunctuality.getTrainPunctualityColor(i);
    const actualPunctualityEntries: string = await trainsListPunctuality.getTrainPunctualityText(i);
    const actualFromPunctualityTime: string = await trainsListPunctuality.getPunctualityFromTime(i);
    const actualToPunctualityTime: string = await trainsListPunctuality.getPunctualityToTime(i);

    results.push(expect(actualPunctualityColors).to.contain(expectedValues[i].punctualityColorText));
    results.push(expect(actualPunctualityEntries).to.contain(expectedValues[i].entryValue));
    results.push(expect(actualFromPunctualityTime).to.contain(expectedValues[i].fromTime));
    results.push(expect(actualToPunctualityTime).to.contain(expectedValues[i].toTime));
  }
  return protractor.promise.all(results);

});

When('I update the punctuality settings to new values', async (editedEntries: any) => {
  let i = 0;
  editedEntries.hashes().forEach((editedEntry: any) => {
    i = i + 1;
    trainsListPunctuality.setTrainDisplayNameText('display-name-' + i.toString(), editedEntry.displayName);
  });
});

Then('the following settings are displayed', async (newEntries: any) => {
  let i = 0;
  for (const newEntry of newEntries.hashes()) {
    i = i + 1;
    const actualDisplayName = await trainsListPunctuality.getTrainDisplayNameText('display-name-' + i.toString());
    expect(actualDisplayName).to.contain(newEntry.displayName);
  }
});
