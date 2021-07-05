import {RedisClient} from '../api/redis/redis-client';

export class TMVRedisUtils {
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
      'line-to-path-code-rules'];
    const redisClient = new RedisClient();
    await redisClient.listKeys('*')
      .then(output => output.filter(key => !configKeys.includes(key))
        .forEach(async key => {
          await redisClient.deleteKey(key);
        }));
  }

}


