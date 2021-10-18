import {browser} from 'protractor';
import {RedisType} from './redis-type.model';
import {RedisTypeToKeyMatcher} from './redis-type-to-key-matcher';
import {StopWatch} from '../../utils/stopwatch';

const Redis = require('ioredis');
require('events').EventEmitter.defaultMaxListeners = 15;

export class RedisClient {
  private static readonly slotsRefreshTimeout = 5000;
  private static constructed = false;
  public static operationsClient = new Redis.Cluster([
    {
      port: browser.params.operations_redis_port,
      host: browser.params.operations_redis_host.replace('http://', '').replace('https://', ''),
    }
  ], {slotsRefreshTimeout: RedisClient.slotsRefreshTimeout});
  public static schedulesClient = new Redis.Cluster([
    {
      port: browser.params.schedules_redis_port,
      host: browser.params.schedules_redis_host.replace('http://', '').replace('https://', ''),
    }
  ], {slotsRefreshTimeout: RedisClient.slotsRefreshTimeout});
  public static replayClient = new Redis.Cluster([
    {
      port: browser.params.replay_redis_port,
      host: browser.params.replay_redis_host.replace('http://', '').replace('https://', ''),
    }
  ], {slotsRefreshTimeout: RedisClient.slotsRefreshTimeout});
  public static trainsListClient = new Redis(
    {
      port: browser.params.trainslist_redis_port,
      host: browser.params.replay_redis_host.replace('http://', '').replace('https://', ''),
    }
  );

  private readonly redisKeyMatcher = new RedisTypeToKeyMatcher();
  private stopWatch = new StopWatch();

  constructor() {
    if (!RedisClient.constructed) {
      RedisClient.operationsClient.on('connect', event => {
        console.log('Redis operationsClient Connected');
        this.stopWatch.start();
      });
      RedisClient.operationsClient.on('ready', event => {
        console.log('Redis operationsClient Ready');
        this.stopWatch.stop();
        console.log(`It took ${this.stopWatch.readElapsedTimeMS()}ms for the Redis connection to be ready`);
      });
      RedisClient.operationsClient.on('close', event => {
        console.log('Redis operationsClient Close');
      });
      RedisClient.operationsClient.on('reconnecting', event => {
        console.log('Redis operationsClient Reconnecting');
      });
      RedisClient.operationsClient.on('end', event => {
        console.log('Redis operationsClient End');
      });
      RedisClient.operationsClient.on('wait', event => {
        console.log('Redis operationsClient Wait');
      });
      RedisClient.operationsClient.on('error', error => {
        console.log('Redis operationsClient Error');
        console.error(error);
      });
      RedisClient.schedulesClient.on('error', error => {
        console.error(error);
      });
      RedisClient.replayClient.on('error', error => {
        console.error(error);
      });
      RedisClient.trainsListClient.on('error', error => {
        console.error(error);
      });
      RedisClient.constructed = true;
    }
  }

  public async hashDelete(hash: string, field: string, type?: RedisType): Promise<void> {
    if (!type) {
      type = this.redisKeyMatcher.match(hash);
    }
    await this.getClient(type).hdel(hash, field);
    return Promise.resolve();
  }

  public async keyDelete(key: string, type?: RedisType): Promise<void> {
    if (!type) {
      type = this.redisKeyMatcher.match(key);
    }
    await this.getClient(type).del(key);
    return Promise.resolve();
  }

  public async deleteKey(key: string, type?: RedisType): Promise<any> {
    if (type) {
      const client = this.getClient(type);
      await client.del(key);
    } else {
      await RedisClient.operationsClient.del(key);
      await RedisClient.schedulesClient.del(key);
      await RedisClient.replayClient.del(key);
      await RedisClient.trainsListClient.del(key);
    }
    return Promise.resolve();
  }

  public async deleteKeys(keys: string[], type?: RedisType): Promise<any> {
    if (type) {
      const client = this.getClient(type);
      for (const key of keys) {
        await client.del(key);
      }
    } else {
      for (const key of keys) {
        await RedisClient.operationsClient.del(key);
        await RedisClient.schedulesClient.del(key);
        await RedisClient.replayClient.del(key);
        await RedisClient.trainsListClient.del(key);
      }
    }
    return Promise.resolve();
  }

  public async listKeys(fuzzyKey: string): Promise<string[]> {
    return Promise.all([
      await this.listKeysByRedisType(fuzzyKey, RedisType.OPERATIONS),
      await this.listKeysByRedisType(fuzzyKey, RedisType.SCHEDULES),
      await this.listKeysByRedisType(fuzzyKey, RedisType.REPLAY),
      await this.listKeysByRedisType(fuzzyKey, RedisType.TRAINSLIST)
    ]).then(resultArray => {
      return Array.prototype.concat(resultArray[0], resultArray[1], resultArray[2], resultArray[3]);
    });
  }

  public async listKeysByRedisType(fuzzyKey: string, type: RedisType): Promise<string[]> {
    const client = this.getClient(type);

    if (type === RedisType.TRAINSLIST) {
      return client.keys(fuzzyKey);
    }

    // Get keys of all the nodes
    const nodes = client.nodes();
    let keys = [];
    for (const node of nodes) {
      const nodeKeys = await node.keys(fuzzyKey);
      keys = Array.prototype.concat(keys, nodeKeys);
    }
    return Promise.resolve(keys);
  }

  public async geAllFromStream(stream: string): Promise<string[][][]> {
    return RedisClient.operationsClient.xrevrange(stream, '+', '-');
  }

  public async hgetall(hashName: string): Promise<any> {
    const client = this.getClient(this.redisKeyMatcher.match(hashName));
    return client.hgetall(hashName);
  }

  public async hgetParseJSON(hashName: string, key: string): Promise<any> {
    const client = this.getClient(this.redisKeyMatcher.match(hashName));
    return new Promise((resolve, reject) => {
      client.hget(hashName, key, (error, value) => {
        if (error) {
          reject(error);
        } else {
          resolve(JSON.parse(value) || {});
        }
      });
    });
  }

  public async hgetString(hashName: string, key: string): Promise<any> {
    const client = this.getClient(this.redisKeyMatcher.match(hashName));
    return new Promise((resolve, reject) => {
      client.hget(hashName, key, (error, value) => {
        if (error) {
          reject(error);
        } else {
          resolve(value || {});
        }
      });
    });
  }

  public async hkeys(hashName: string): Promise<any> {
    const client = this.getClient(this.redisKeyMatcher.match(hashName));
    return new Promise((resolve, reject) => {
      client.hkeys(hashName, (error, value) => {
        if (error) {
          reject(error);
        } else {
          resolve(value || {});
        }
      });
    });
  }

  private getClient(type: RedisType): any {
    switch (type) {
      case RedisType.OPERATIONS:
        return RedisClient.operationsClient;
      case RedisType.REPLAY:
        return RedisClient.replayClient;
      case RedisType.SCHEDULES:
        return RedisClient.schedulesClient;
      case RedisType.TRAINSLIST:
        return RedisClient.trainsListClient;
      default:
        throw new Error('Unsupported Redis type');
    }
  }

  public getKeyMatcher(): RedisTypeToKeyMatcher {
    return this.redisKeyMatcher;
  }
}
