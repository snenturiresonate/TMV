import {Given, When} from 'cucumber';
import {RedisClient} from '../api/redis/redis-client';
import {DateAndTimeUtils} from '../pages/common/utilities/DateAndTimeUtils';
import {browser} from 'protractor';
import {TMVRedisUtils} from '../utils/tmv-redis-utils';

const redisClient: RedisClient = new RedisClient();

When('I delete {string} from hash {string}', async (field: string, hash: string) => {
  const dateFormat = 'yyyy-MM-dd';
  if (field.includes('generatedTrainUId')) {
    field = field.replace('generatedTrainUId', browser.referenceTrainUid);
  }
  else if (field.includes('generated')) {
    field = field.replace('generated', browser.referenceTrainUid);
  }
  await redisClient.hashDelete(
    hash
      .replace('today', DateAndTimeUtils.convertToDesiredDateAndFormat(('today'), dateFormat))
      .replace('yesterday', DateAndTimeUtils.convertToDesiredDateAndFormat(('yesterday'), dateFormat))
      .replace('tomorrow', DateAndTimeUtils.convertToDesiredDateAndFormat(('tomorrow'), dateFormat)),
    field
      .replace('today', DateAndTimeUtils.convertToDesiredDateAndFormat(('today'), dateFormat))
      .replace('yesterday', DateAndTimeUtils.convertToDesiredDateAndFormat(('yesterday'), dateFormat))
      .replace('tomorrow', DateAndTimeUtils.convertToDesiredDateAndFormat(('tomorrow'), dateFormat))
  );
});

When('I delete {string} from Redis', async (streamName: string) => {
  await redisClient.deleteKey(streamName, redisClient.getKeyMatcher().match(streamName));
});

When('I remove schedule {string} from the trains list', async (scheduleId: string) => {
  if (scheduleId.includes('generated')) {
    scheduleId = browser.referenceTrainUid;
  }
  const dateFormat = 'yyyy-MM-dd';
  await redisClient.keyDelete('trainlist:' + scheduleId + ':' + DateAndTimeUtils.convertToDesiredDateAndFormat(('today'), dateFormat));
  await redisClient.keyDelete('trainlist:' + scheduleId + ':' + DateAndTimeUtils.convertToDesiredDateAndFormat(('tomorrow'), dateFormat));
});

Given(/^I clear all MTBs$/, async () => {
  await redisClient.keyDelete('manual-trust-berths-hash');
  await redisClient.keyDelete('manual-trust-berths');
  await redisClient.keyDelete('manual-trust-berth-states');
  await redisClient.keyDelete('last-manual-trust-berth');
});

Given(/^I reset redis$/, async () => {
  await new TMVRedisUtils().reset();
});
