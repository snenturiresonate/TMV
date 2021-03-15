import {fragment} from 'xmlbuilder2';

export class TRITrainDelay {
  public static trainDelayAgainstBooked = (delay: number, hoursOrMins: string) => {
    const trainLocation = fragment().ele('TrainDelay')
      .ele('AgainstBooked').txt(`--${delay}${hoursOrMins}`)
      .doc();
    return trainLocation.end({prettyPrint: true});
  }
}
