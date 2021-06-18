import {RedisClient} from '../../../api/redis/redis-client';

function generateTrainUid(): string {
  const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const randomCharacter = alphabet[Math.floor(Math.random() * alphabet.length)];
  return randomCharacter + Math.floor((Math.random() * (100000))).toString().padStart(5, '0');
}

export class TrainUIDUtils {
  public static async generateUniqueTrainUid(): Promise<string> {
    const client = new RedisClient();
    const knownScheduleKeys = await client.hkeys('schedules-hash');
    const knownTrainUids = [];
    for (const key of knownScheduleKeys) {
      knownTrainUids.push(key.substr(0, key.indexOf(':')));
    }
    let newUid = generateTrainUid();
    while (knownTrainUids.indexOf(newUid) !== -1) {
      newUid = generateTrainUid();
    }
    return newUid;
  }
}
