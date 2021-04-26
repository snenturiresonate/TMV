import {fragment} from 'xmlbuilder2';

export class TrainActivationLocationSubsidiaryIdentificationBuilder {
  public static locationSubsidiaryIdentification = (locationSubsidiaryCode: string, allocationCompany: string = '0070') => {
    const locationSubsidiaryIdentification = fragment().ele('ns0:LocationSubsidiaryIdentification')
      .ele('ns0:LocationSubsidiaryCode').att('ns0:LocationSubsidiaryTypeCode', '0').txt(locationSubsidiaryCode).up()
      .ele('ns0:AllocationCompany').txt(allocationCompany)
      .doc();
    return locationSubsidiaryIdentification.end({prettyPrint: true});
  }
}
