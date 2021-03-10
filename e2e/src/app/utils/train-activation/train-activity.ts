import {fragment} from 'xmlbuilder2';

export class TrainActivationTrainActivityBuilder {


  public static trainActivity = (trainActivityType: string = 'GBTB') => {
    const trainActivity = fragment().ele('TrainActivity')
      .ele('TrainActivityType').txt(trainActivityType).up()
      .doc();
    console.log('trainActivity: ' + trainActivity.end({prettyPrint: true}));
    return trainActivity.end({prettyPrint: true});
  }
}
