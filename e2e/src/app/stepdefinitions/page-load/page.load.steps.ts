import {Before, When, Then} from 'cucumber';
import {StopWatch} from '../../utils/stopwatch';
import {expect} from 'chai';
import {CucumberLog} from '../../logging/cucumber-log';

let stopWatch: StopWatch;

Before(() => {
  stopWatch = new StopWatch();
});

When('I start the stopwatch', async () => {
  stopWatch.start();
});

When('I stop the stopwatch', async () => {
  stopWatch.stop();
});

When('I reset the stopwatch', async () => {
  stopWatch.reset();
});

Then('the stopwatch reads less than {string} milliseconds, within a tolerance of {string} milliseconds',
  async (expectedDurationMillis: string, tolerance: string) => {
  const actualResult = stopWatch.readElapsedTimeMS();
  CucumberLog.addText(`The stopwatch read ${actualResult}ms`);
  expect(actualResult, `The stopwatch did not read less than ${expectedDurationMillis} milliseconds`)
    .to.be.lessThan(parseInt(expectedDurationMillis, 10) + parseInt(tolerance, 10));
});
