import {fragment} from 'xmlbuilder2';

export class TRITrainDelay {
  public static trainDelayAgainstBooked = (delay: string) => {
    let negDelayIndicator = '';
    if (delay.substr(0, 1) === '-') {
      delay = delay.substr(1, 5);
      negDelayIndicator = '-';
    }
    const absDelayMins: number = (parseInt(delay.split(':')[0], 10) * 60) + parseInt(delay.split(':')[1], 10);
    const trainLocation = fragment().ele('TrainDelay')
      .ele('AgainstBooked').txt(negDelayIndicator + absDelayMins.toString().padStart(4, '0'))
      .doc();
    return trainLocation.end({prettyPrint: true});
  }
}
