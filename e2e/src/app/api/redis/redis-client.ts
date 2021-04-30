import {promisify} from 'util';

const redis = require('redis');
// import {redis} from 'redis';
import {browser} from 'protractor';

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
}
