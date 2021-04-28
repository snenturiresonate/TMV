import {fragment} from 'xmlbuilder2';

export class TrainActivationNetworkSpecificParameter {
  public static networkSpecificParameter = (name: string = 'UID', value: string) => {
    const networkSpecificParameter = fragment().ele('ns0:NetworkSpecificParameter')
      .ele('ns0:Name').txt(name).up()
      .ele('ns0:Value').txt(value)
      .doc();
    return networkSpecificParameter.end({prettyPrint: true});
  }
}
