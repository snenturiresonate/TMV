import {fragment} from 'xmlbuilder2';

export class TRILocationSubsidiaryIdentificationBuilder {
  public static locationSubsidiaryIdentification = (locationSubsidiaryCode: string, allocationCompany: string = '0070') => {
    const locationSubsidiaryIdentification = fragment().ele('LocationSubsidiaryIdentification')
      .ele('LocationSubsidiaryCode').att('n1:LocationSubsidiaryTypeCode', '0').txt(locationSubsidiaryCode).up()
      .ele('AllocationCompany').txt(allocationCompany)
      .doc();
    return locationSubsidiaryIdentification.end({prettyPrint: true});
  }
}
