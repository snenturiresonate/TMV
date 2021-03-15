import {fragment} from 'xmlbuilder2';

export class TRITrainDelay {
  public static trainDelayAgainstBooked = (delay: string) => {
    const trainLocation = fragment().ele('TrainDelay')
      .ele('AgainstBooked').txt(delay.replace(':', ''))
      .doc();
    return trainLocation.end({prettyPrint: true});
  }
}
