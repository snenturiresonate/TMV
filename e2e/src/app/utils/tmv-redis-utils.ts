import {RedisClient} from '../api/redis/redis-client';
import {RedisType} from '../api/redis/redis-type.model';
import {BerthCancel} from '../../../../src/app/api/linx/models/berth-cancel';
import {LinxRestClient} from '../api/linx/linx-rest-client';
import {DateTimeFormatter, ZonedDateTime, ZoneId} from '@js-joda/core';
import {CucumberLog} from '../logging/cucumber-log';

export class TMVRedisUtils {

  private readonly redisClient = new RedisClient();

  public async reset(): Promise<void> {
    const configKeys = ['path-extrap-rules-hash',
      'configuration-location-groups-hash',
      'railway-undertaking-hash',
      'berth-to-maps-hash',
      'configuration-berths',
      'manual-trust-berths-cache',
      'train-describers-configuration-hash',
      'berth-translation',
      'map-configurations',
      'configuration-locations-hash',
      '{signalling-states}-state-interpretations',
      'map-group-configurations-hash',
      'route-expression-config',
      'location-insertion-rules-hash',
      'configuration-signals',
      'additional-step-before',
      'qberth-translation-hash',
      'qberth-translation',
      'map-group-configurations',
      'schedule-modification-rules-hash',
      '{signalling-states}-signalling-function-names',
      'path-to-line-code-hash',
      'additional-step-before-hash',
      'signalling-function-config',
      'location-insertion-rules',
      'path-to-line-code-rules',
      'swap-description',
      'swap-description-hash',
      '{schedule-matching}-schedule-matching-berths',
      'railway-undertaking-configuration-hash',
      '{signalling-states}-track-division-state-interpretations',
      'map-configurations-hash',
      '{signalling-states}-signalling-functions',
      'railway-undertaking-configuration',
      '{signalling-states}-signalling-function-sets',
      '{schedule-matching}-schedule-matching-locations',
      'path-extrapolation-locations-cache',
      'step-translation-hash',
      'manual-trust-berth-configurations',
      'area-rules',
      '{schedule-matching}-schedule-matching-subdivisions',
      'unprocessed',
      'track-route-config',
      'step-translation',
      'configuration-locations',
      'path-rules',
      'line-code-to-path-code-rules-hash',
      'berth-translation-hash',
      'line-to-path-code-rules',
      '{last-berths-set}'];
    await Promise.all([
      await this.redisClient.listKeysByRedisType('*', RedisType.OPERATIONS)
      .then(async output => this.redisClient.trimKeys(output.filter(key => !configKeys.includes(key)), RedisType.OPERATIONS)),
      await this.redisClient.listKeysByRedisType('*', RedisType.REPLAY)
      .then(async output => this.redisClient.trimKeys(output.filter(key => !configKeys.includes(key)), RedisType.REPLAY)),
      await this.redisClient.listKeysByRedisType('*', RedisType.SCHEDULES)
        .then(async output => this.redisClient.trimKeys(output.filter(key => !configKeys.includes(key)), RedisType.SCHEDULES)),
    ]);
  }

  // pass no argument to clear all train describers
  public async clearBerths(clearFutureTimestamps = true, trainDescriber = ''): Promise<void> {
    const berths = await this.redisClient.hgetall('map-states');
    const linxRestClient = new LinxRestClient();
    if (berths) {
      for (const [key, value] of Object.entries(berths)) {
        if (key.includes(`${trainDescriber}:BERTH:`)) {
          const val = JSON.parse(value.toString());
          if (val.trainDescription) {
            const time = ZonedDateTime.parse(val.stateTime).withZoneSameInstant(ZoneId.of('Europe/London'));
            const futureHeadcode = time.isAfter(ZonedDateTime.now(ZoneId.of('Europe/London')));
            if (!futureHeadcode || clearFutureTimestamps) {
              const berthCancel: BerthCancel = new BerthCancel(
                val.berthName,
                time.format(DateTimeFormatter.ofPattern('HH:mm:ss')),
                val.trainDescriberCode,
                val.trainDescription
              );
              await CucumberLog.addJson(berthCancel);
              await linxRestClient.postBerthCancel(berthCancel);
            }
          }
        }
      }
      await linxRestClient.waitMaxTransmissionTime();
    }
  }
}


