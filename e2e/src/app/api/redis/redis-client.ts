import {browser} from 'protractor';
import {RedisType} from './redis-type.model';
import {RedisTypeToKeyMatcher} from './redis-type-to-key-matcher';
import {StopWatch} from '../../utils/stopwatch';
import * as RedisLibrary from 'ioredis';
require('events').EventEmitter.defaultMaxListeners = 15;

export class RedisClient {
  private static readonly slotsRefreshTimeout = 5000;
  private static constructed = false;
  private static redisHostIp: string = browser.params.test_harness_ci_ip.replace('http://', '').replace('https://', '');

  public static operationsClient: RedisLibrary.Cluster = new RedisLibrary.Cluster([
    {
      port: browser.params.operations_redis_port,
      host: 'redis-operations',
    }
  ], {
    slotsRefreshTimeout: RedisClient.slotsRefreshTimeout,
    natMap: {
      'redis-operations:8600': {host: RedisClient.redisHostIp, port: 8600},
      'redis-operations:8601': {host: RedisClient.redisHostIp, port: 8601},
      'redis-operations:8602': {host: RedisClient.redisHostIp, port: 8602},
      'redis-operations:8603': {host: RedisClient.redisHostIp, port: 8603},
      'redis-operations:8604': {host: RedisClient.redisHostIp, port: 8604},
      'redis-operations:8605': {host: RedisClient.redisHostIp, port: 8605},
    },
    dnsLookup(hostname: string, callback: any): void {
      if (hostname === 'redis-operations') {
        callback(null, RedisClient.redisHostIp);
      }
    }
  });
  public static schedulesClient: RedisLibrary.Cluster = new RedisLibrary.Cluster([
    {
      port: browser.params.schedules_redis_port,
      host: 'redis-schedules',
    }
  ], {
    slotsRefreshTimeout: RedisClient.slotsRefreshTimeout,
    natMap: {
      'redis-schedules:8800': {host: RedisClient.redisHostIp, port: 8800},
      'redis-schedules:8801': {host: RedisClient.redisHostIp, port: 8801},
      'redis-schedules:8802': {host: RedisClient.redisHostIp, port: 8802},
      'redis-schedules:8803': {host: RedisClient.redisHostIp, port: 8803},
      'redis-schedules:8804': {host: RedisClient.redisHostIp, port: 8804},
      'redis-schedules:8805': {host: RedisClient.redisHostIp, port: 8805},
    },
    dnsLookup(hostname: string, callback: any): void {
      if (hostname === 'redis-schedules') {
        callback(null, RedisClient.redisHostIp);
      }
    }
  });
  public static replayClient: RedisLibrary.Cluster = new RedisLibrary.Cluster([
    {
      port: browser.params.replay_redis_port,
      host: 'redis-replay',
    }
  ], {
    slotsRefreshTimeout: RedisClient.slotsRefreshTimeout,
    natMap: {
      'redis-replay:8700': {host: RedisClient.redisHostIp, port: 8700},
      'redis-replay:8701': {host: RedisClient.redisHostIp, port: 8701},
      'redis-replay:8702': {host: RedisClient.redisHostIp, port: 8702},
      'redis-replay:8703': {host: RedisClient.redisHostIp, port: 8703},
      'redis-replay:8704': {host: RedisClient.redisHostIp, port: 8704},
      'redis-replay:8705': {host: RedisClient.redisHostIp, port: 8705},
    },
    dnsLookup(hostname: string, callback: any): void {
      if (hostname === 'redis-replay') {
        callback(null, RedisClient.redisHostIp);
      }
    }
  });
  public static trainsListClient: RedisLibrary.Redis = new RedisLibrary(
    {
      port: browser.params.trainslist_redis_port,
      host: RedisClient.redisHostIp,
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

  public async trimKeys(keys: string[], type?: RedisType): Promise<any> {
    const promisesToTrim = [];
    if (type) {
      for (const key of keys) {
        promisesToTrim.push(this.trimStream(key, this.getClient(type)));
      }
    } else {
      for (const key of keys) {
        promisesToTrim.push(this.trimStream(key, RedisClient.operationsClient));
        promisesToTrim.push(this.trimStream(key, RedisClient.schedulesClient));
        promisesToTrim.push(this.trimStream(key, RedisClient.replayClient));
        promisesToTrim.push(this.trimStream(key, RedisClient.trainsListClient));
      }
    }
    return Promise.all(promisesToTrim);
  }

  public async trimStream(key: string, client: any): Promise<void> {
    const keyType = await client.type(key);
    if (keyType === 'stream') {
      await client.xtrim(key, ['MAXLEN', '0']);
    }
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

  public async geAllFromStream(stream: string): Promise<[string, string[]][]> {
    return RedisClient.operationsClient.xrevrange(stream, '+', '-');
  }

  public async getLatestFromStream(stream: string): Promise<[string, string[]][]> {
    const clientType: RedisType = this.redisKeyMatcher.match(stream);
    const redisClient = await this.getClient(clientType);
    return redisClient.xrevrange(stream, '+', '-', 'COUNT', 1);
  }

  public async hgetall(hashName: string): Promise<any> {
    const client: RedisLibrary.Redis = this.getClient(this.redisKeyMatcher.match(hashName));
    return client.hgetall(hashName);
  }

  public async hgetParseJSON(hashName: string, key: string): Promise<any> {
    const client: RedisLibrary.Redis = this.getClient(this.redisKeyMatcher.match(hashName));
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
    const client: RedisLibrary.Redis = this.getClient(this.redisKeyMatcher.match(hashName));
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
    const client: RedisLibrary.Redis = this.getClient(this.redisKeyMatcher.match(hashName));
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
