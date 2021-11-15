import {RedisClient} from '../../../api/redis/redis-client';

export class TrainUIDUtils {
  private static alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  private static generateTrainUid(): string {
    const randomCharacter = TrainUIDUtils.alphabet[Math.floor(Math.random() * TrainUIDUtils.alphabet.length)];
    return randomCharacter + Math.floor((Math.random() * (100000))).toString().padStart(5, '0');
  }

  public static async generateUniqueTrainUid(): Promise<string> {
    const client = new RedisClient();
    const knownScheduleKeys = await client.hkeys('schedules-hash');
    const knownTrainUids = [];
    for (const key of knownScheduleKeys) {
      knownTrainUids.push(key.substr(0, key.indexOf(':')));
    }
    let newUid = TrainUIDUtils.generateTrainUid();
    while (knownTrainUids.indexOf(newUid) !== -1) {
      newUid = TrainUIDUtils.generateTrainUid();
    }
    return newUid;
  }

  public static generateTrainDescription(): Promise<string> {
    const randomCharacter = TrainUIDUtils.alphabet[Math.floor(Math.random() * TrainUIDUtils.alphabet.length)];
    const randomOneDigitNumber = Math.floor((Math.random() * (10))).toString();
    const randomTwoDigitNumber = Math.floor((Math.random() * (100))).toString().padStart(1, '0');
    return Promise.resolve(`${randomOneDigitNumber}${randomCharacter}${randomTwoDigitNumber}`);
  }
}
