import {browser} from 'protractor';
import {RedisClient} from '../api/redis/redis-client';

export class BackEndChecksService {

  public static async waitForTrainUid(uid: string, firstDate: string, secondDate: string = ''): Promise<boolean> {
    if (uid === 'generatedTrainUId' || uid === 'generated') {
      uid = browser.referenceTrainUid;
    }
    return browser.wait(async () => {
      return await this.waitForTrainUidInTrainslist(uid, firstDate, secondDate) &&
        await this.waitForTrainUidInPathExtrap(uid, firstDate, secondDate);
    }, browser.params.general_timeout, `${uid} for dates ${firstDate}/${secondDate} not found in Redis`);
  }

  public static async waitForTrainUidInTrainslist(uid: string, firstDate: string, secondDate: string = ''): Promise<boolean> {
    const client = new RedisClient();
    const firstTrainIdentifier = this.getTrainUid(uid, firstDate);
    const secondTrainIdentifier = this.getTrainUid(uid, secondDate, firstTrainIdentifier);
    const firstHash = `trainlist:` + firstTrainIdentifier;
    const secondHash = `trainlist:` + secondTrainIdentifier;
    return browser.wait(async () => {
      let trainListData = await client.hgetString(firstHash, 'scheduleId');
      if (trainListData !== firstTrainIdentifier) {
        trainListData = await client.hgetString(secondHash, 'scheduleId');
      }
      return (trainListData === firstTrainIdentifier || trainListData === secondTrainIdentifier);
    }, browser.params.general_timeout, `${firstTrainIdentifier} not found in Redis trainlist`);
  }

  public static async waitForTrainUidInPathExtrap(uid: string, firstDate: string, secondDate: string = ''): Promise<boolean> {
    const client = new RedisClient();
    const firstTrainIdentifier = this.getTrainUid(uid, firstDate);
    const secondTrainIdentifier = this.getTrainUid(uid, secondDate, firstTrainIdentifier);
    const pathExtrapScheduleHashPrefix = `path-extrap-enriched-schedules-`;
    const firstPathExtrapHash = `${pathExtrapScheduleHashPrefix}${firstDate}`;
    const secondPathExtrapHash = `${pathExtrapScheduleHashPrefix}${secondDate}`;
    return browser.wait(async () => {
      let pathExtrapData = await client.hgetString(firstPathExtrapHash, firstTrainIdentifier);
      if (!pathExtrapData) {
        pathExtrapData = await client.hgetString(secondPathExtrapHash, secondTrainIdentifier);
      }
      return pathExtrapData;
    }, 35000, `${firstTrainIdentifier} not found in Redis Path Extrapolation enriched schedules hash`);
  }

  private static getTrainUid(uid: string, date: string = '', defaultUid: string = ''): string {
    return date === '' ? defaultUid : `${uid}:${date}`;
  }
}
