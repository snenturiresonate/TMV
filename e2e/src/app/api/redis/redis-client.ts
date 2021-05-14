import {promisify} from 'util';

const redis = require('redis');
// import {redis} from 'redis';
import {browser} from 'protractor';
import {DateTimeFormatter, LocalDate} from '@js-joda/core';

export class RedisClient {
  public client = redis.createClient(browser.params.redis_port, browser.params.redis_host.replace('http://', '').replace('https://', ''));

  constructor() {
    this.client.on('error', error => {
      console.error(error);
    });
  }

  public hashDelete(hash: string, field: string): void {
    this.client.hdel(hash, field);
  }

  public keyDelete(key: string): void {
    this.client.del(key);
  }

  public async listKeys(fuzzyKey: string): Promise<any> {
    const keysAsync = promisify(this.client.keys).bind(this.client);
    return await keysAsync(fuzzyKey);
  }

  public async getBerthLevelSchedule(trainUid: string): Promise<any> {
    const key = `${trainUid}:${LocalDate.now().format(DateTimeFormatter.ofPattern('yyyy-MM-dd'))}`;
    return new Promise((resolve, reject) => {
      this.client.hget('berth-level-schedule-pairs', key, (error, value) => {
        if (error) {
          reject(error);
        } else {
          resolve(JSON.parse(value) || {});
        }
      });
    });
  }

  public async getBerthInformation(berthId: string): Promise<any> {
    return new Promise((resolve, reject) => {
      this.client.hget('{schedule-matching}-schedule-matching-berths', berthId, (error, value) => {
        if (error) {
          reject(error);
        } else {
          resolve(JSON.parse(value) || {});
        }
      });
    });
  }
}
