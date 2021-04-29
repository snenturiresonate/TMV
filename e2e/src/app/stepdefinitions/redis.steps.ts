import {When} from 'cucumber';
import {RedisClient} from '../api/redis/redis-client';
import {DateAndTimeUtils} from '../pages/common/utilities/DateAndTimeUtils';

const redisClient: RedisClient = new RedisClient();

When('I delete {string} from hash {string}', async (field: string, hash: string) => {
  const dateFormat = 'yyyy-MM-dd';
  redisClient.hashDelete(
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

When('I remove schedule {string} from the trains list', async (scheduleId: string) => {
  const dateFormat = 'yyyy-MM-dd';
  redisClient.keyDelete('trainlist:' + scheduleId + ':' + DateAndTimeUtils.convertToDesiredDateAndFormat(('today'), dateFormat));
  redisClient.keyDelete('trainlist:' + scheduleId + ':' + DateAndTimeUtils.convertToDesiredDateAndFormat(('tomorrow'), dateFormat));
});
