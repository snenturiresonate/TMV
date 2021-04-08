import {fragment} from 'xmlbuilder2';
import {TRILocationSubsidiaryIdentificationBuilder} from './location-subsidiary-identification';

export class TRILocation {
  public static trainLocation = (locationPrimaryCode: string, locationSubsidiaryCode: string) => {
    const trainLocation = fragment().ele('Location')
      .ele('CountryCodeISO').txt('GB').up()
      .ele('LocationPrimaryCode').txt(locationPrimaryCode).up()
      .ele(TRILocationSubsidiaryIdentificationBuilder.locationSubsidiaryIdentification(locationSubsidiaryCode))
      .doc();
    return trainLocation.end({prettyPrint: true});
  }
}
