export class LocationSubsidiaryIdentification {
  public LocationSubsidiaryCode?: string;
  public AllocationCompany?: string;
}

export class LocationSubsidiaryIdentificationBuilder {
  private LocationSubsidiaryCode?: string;
  private AllocationCompany?: string;
  constructor() {
    this.AllocationCompany = '0070';
  }
  withLocationSubsidiaryCode(value: string): LocationSubsidiaryIdentificationBuilder {
    this.LocationSubsidiaryCode = value;
    return this;
  }
  withAllocationCompany(value: string): LocationSubsidiaryIdentificationBuilder {
    this.AllocationCompany = value;
    return this;
  }
  build(): LocationSubsidiaryIdentification {
    const locationSubsidiaryIdentification = new LocationSubsidiaryIdentification();
    locationSubsidiaryIdentification.LocationSubsidiaryCode = this.LocationSubsidiaryCode;
    locationSubsidiaryIdentification.AllocationCompany = this.AllocationCompany;
    return locationSubsidiaryIdentification;
  }
}
