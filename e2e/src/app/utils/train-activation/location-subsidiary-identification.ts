import {fragment} from 'xmlbuilder2';

export class TrainActivationLocationSubsidiaryIdentificationBuilder {
  public static locationSubsidiaryIdentification = (locationSubsidiaryCode: string, allocationCompany: string = '0070') => {
    const locationSubsidiaryIdentification = fragment().ele('LocationSubsidiaryIdentification')
      .ele('LocationSubsidiaryCode').att('n1:LocationSubsidiaryTypeCode', '0').txt(locationSubsidiaryCode).up()
      .ele('AllocationCompany').txt(allocationCompany)
      .doc();
    console.log('LocationSubsidiaryIdentification: ' + locationSubsidiaryIdentification.end({prettyPrint: true}));
    return locationSubsidiaryIdentification.end({prettyPrint: true});
  }
}
