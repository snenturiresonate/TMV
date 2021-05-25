import {fragment} from 'xmlbuilder2';

export class TrainActivationTrainActivityBuilder {


  public static trainActivity = (trainActivityType: string = 'GBTB') => {
    const trainActivity = fragment().ele('ns0:TrainActivity')
      .ele('ns0:TrainActivityType').txt(trainActivityType).up()
      .doc();
    return trainActivity.end({prettyPrint: true});
  }
}
