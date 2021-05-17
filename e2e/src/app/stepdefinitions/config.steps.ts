import {When} from 'cucumber';
import {RedisClient} from '../api/redis/redis-client';

const redisClient: RedisClient = new RedisClient();

When('I find berths that have configuration data for Berth translation and Step Translation', async () => {
  const stepTranslationConfigResult: string[][][] = await redisClient.geAllFromStream('step-translation');
  const stepTranslationConfig = JSON.parse(stepTranslationConfigResult[0][1][1]);

  const berthTranslationConfigResult: string[][][] = await redisClient.geAllFromStream('berth-translation');
  const berthTranslationConfig = JSON.parse(berthTranslationConfigResult[0][1][1]);

  stepTranslationConfig.list.forEach(stepTranslationEntry => {
    const stepTranslationOldToTD: string = stepTranslationEntry.oldToBerth.trainDescriberCode;
    const stepTranslationOldToBerth: string = stepTranslationEntry.oldToBerth.berthName;
    berthTranslationConfig.list.forEach(berthTranslationEntry => {
      const berthTranslationTD: string = berthTranslationEntry.newBerth.trainDescriberCode;
      const berthTranslationBerth: string = berthTranslationEntry.newBerth.berthName;
      if (stepTranslationOldToTD === berthTranslationTD &&
          stepTranslationOldToTD !== '**' &&
          stepTranslationOldToBerth === berthTranslationBerth &&
          stepTranslationOldToBerth !== '****'
      ) {
        console.log('*******************');
        console.log('*** Match found ***');
        console.log('*******************');
        console.log('Step Translation - Old From Berth:');
        console.log(stepTranslationEntry.oldFromBerth);
        console.log('Step Translation - Old To Berth:');
        console.log(stepTranslationEntry.oldToBerth);
        console.log('Step Translation - New From Berth:');
        console.log(stepTranslationEntry.newFromBerth);
        console.log('Step Translation - New To Berth:');
        console.log(stepTranslationEntry.newToBerth);
        console.log('Berth Translation - Old Berth:');
        console.log(berthTranslationEntry.oldBerth);
        console.log('Berth Translation - New Berth:');
        console.log(berthTranslationEntry.newBerth);
      }
    });
  });

});
