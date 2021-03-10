import {fragment} from 'xmlbuilder2';

export class TrainActivationNetworkSpecificParameter {
  public static networkSpecificParameter = (name: string = 'UID', value: string) => {
    const networkSpecificParameter = fragment().ele('NetworkSpecificParameter')
      .ele('Name').txt(name).up()
      .ele('Value').txt(value)
      .doc();
    return networkSpecificParameter.end({prettyPrint: true});
  }
}
