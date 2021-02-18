import {LocationSubsidiaryIdentification} from './location-subsidiary-identification';

export class Location {
  public CountryCodeISO?: string;
  public LocationPrimaryCode?: string;
  public LocationSubsidiaryIdentification?: LocationSubsidiaryIdentification;
}

export class LocationBuilder {
  private CountryCodeISO?: string;
  private LocationPrimaryCode?: string;
  private LocationSubsidiaryIdentification?: LocationSubsidiaryIdentification;

  constructor() {
    this.CountryCodeISO = 'GB';
  }
  withCountryCodeISO(value: string): LocationBuilder {
    this.CountryCodeISO = value;
    return this;
  }
  withLocationPrimaryCode(value: string): LocationBuilder {
    this.LocationPrimaryCode = value;
    return this;
  }
  withLocationSubsidiaryIdentification(value: LocationSubsidiaryIdentification): LocationBuilder {
    this.LocationSubsidiaryIdentification = value;
    return this;
  }

  build(): Location {
    const location = new Location();
    location.CountryCodeISO = this.CountryCodeISO;
    location.LocationPrimaryCode = this.LocationPrimaryCode;
    location.LocationSubsidiaryIdentification = this.LocationSubsidiaryIdentification;
    return location;
  }

}
