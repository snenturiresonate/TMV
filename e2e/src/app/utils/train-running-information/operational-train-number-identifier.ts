import {fragment} from 'xmlbuilder2';

export class TRIOperationalTrainNumberIdentifier {
  public static operationalTrainNumberIdentifier = (operationalTrainNumber: string) => {
    const operationalTrainNumberIdentification = fragment().ele('OperationalTrainNumberIdentifier')
      .ele('OperationalTrainNumber').txt(operationalTrainNumber)
      .doc();
    return operationalTrainNumberIdentification.end({prettyPrint: true});
  }
}
