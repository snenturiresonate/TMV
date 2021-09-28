import {promisify} from 'util';

const redis = require('redis');
import {browser} from 'protractor';
import {RedisType} from './redis-type.model';
import {RedisTypeToKeyMatcher} from './redis-type-to-key-matcher';

export class RedisClient {
  private readonly redisKeyMatcher = new RedisTypeToKeyMatcher();

  public operationsClient = redis.createClient(browser.params.operations_redis_port,
    browser.params.operations_redis_host.replace('http://', '').replace('https://', ''));
  public schedulesClient = redis.createClient(browser.params.schedules_redis_port,
    browser.params.schedules_redis_host.replace('http://', '').replace('https://', ''));
  public replayClient = redis.createClient(browser.params.replay_redis_port,
    browser.params.replay_redis_host.replace('http://', '').replace('https://', ''));

  constructor() {
    this.operationsClient.on('error', error => {
      console.error(error);
    });
    this.schedulesClient.on('error', error => {
      console.error(error);
    });
    this.replayClient.on('error', error => {
      console.error(error);
    });
  }

  public hashDelete(hash: string, field: string, type?: RedisType): void {
    if (!type) {
      type = this.redisKeyMatcher.match(hash);
    }
    this.getClient(type).hdel(hash, field);
  }

  public keyDelete(key: string, type?: RedisType): void {
    if (!type) {
      type = this.redisKeyMatcher.match(key);
    }
    this.getClient(type).del(key);
  }

  public async deleteKey(key: string|string[], type?: RedisType): Promise<any> {
    if (type) {
      const client = this.getClient(type);
      const deleteAsync = promisify(client.del).bind(client);
      return await deleteAsync(key);
    } else {
      const operationsDeleteAsync = promisify(this.operationsClient.del).bind(this.operationsClient);
      const replayDeleteAsync = promisify(this.replayClient.del).bind(this.replayClient);
      const schedulesDeleteAsync = promisify(this.schedulesClient.del).bind(this.schedulesClient);
      return await Promise.all([operationsDeleteAsync(key), replayDeleteAsync(key), schedulesDeleteAsync(key)]);
    }
  }

  public async listKeys(fuzzyKey: string): Promise<any> {
    const operationsKeysAsync = promisify(this.operationsClient.keys).bind(this.operationsClient);
    const replayKeysAsync = promisify(this.replayClient.keys).bind(this.replayClient);
    const schedulesKeysAsync = promisify(this.schedulesClient.keys).bind(this.schedulesClient);
    return await Promise.all([operationsKeysAsync(fuzzyKey), replayKeysAsync(fuzzyKey), schedulesKeysAsync(fuzzyKey)])
      .then(value => {
        return value[0].addAll(value[1]).addAll(value[2]);
      });
  }

  public async listKeysByRedisType(fuzzyKey: string, type: RedisType): Promise<any> {
    const client = this.getClient(type);
    const keysAsync = promisify(client.keys).bind(client);
    return await keysAsync(fuzzyKey);
  }

  public async geAllFromStream(stream: string): Promise<string[][][]> {
    const xrevrangeAsync = promisify(this.operationsClient.xrevrange).bind(this.operationsClient);
    return await xrevrangeAsync(stream, '+', '-');
  }

  public async hgetall(hashName: string): Promise<any> {
    const client = this.getClient(this.redisKeyMatcher.match(hashName));
    const hgetAllAsync = promisify(client.hgetall).bind(client);
    return await hgetAllAsync(hashName);
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
        return this.operationsClient;
      case RedisType.REPLAY:
        return this.replayClient;
      case RedisType.SCHEDULES:
        return this.schedulesClient;
      default:
        throw new Error('Unsupported Redis type');
    }
  }
}
