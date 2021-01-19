export class TransportOperationalIdentifiers {
  public ObjectType?: string;
  public Company?: string;
  public Core?: string;
  public Variant?: string;
  public TimetableYear?: string;
  public StartDate?: string;
}
export class TransportOperationalIdentifiersBuilder {
  private ObjectType?: string;
  private Company?: string;
  private Core?: string;
  private Variant?: string;
  private TimetableYear?: string;
  private StartDate?: string;
  constructor() {
    this.ObjectType = 'TR';
    this.Company = '0070';
    this.Core = '--045A41M024';
    this.Variant = '01';
    this.TimetableYear = '2020';
    this.StartDate = '2020-02-24';
  }
  withObjectType(value: string): TransportOperationalIdentifiersBuilder {
    this.ObjectType = value;
    return this;
  }
  withCompany(value: string): TransportOperationalIdentifiersBuilder {
    this.Company = value;
    return this;
  }
  withCore(value: string): TransportOperationalIdentifiersBuilder {
    this.Core = value;
    return this;
  }
  withVariant(value: string): TransportOperationalIdentifiersBuilder {
    this.Variant = value;
    return this;
  }
  withTimetableYear(value: string): TransportOperationalIdentifiersBuilder {
    this.TimetableYear = value;
    return this;
  }
  withStartDate(value: string): TransportOperationalIdentifiersBuilder {
    this.StartDate = value;
    return this;
  }
  build(): TransportOperationalIdentifiers {
    const transportOperationalIdentifiers = new TransportOperationalIdentifiers();
    transportOperationalIdentifiers.ObjectType = this.ObjectType;
    transportOperationalIdentifiers.Company = this.Company;
    transportOperationalIdentifiers.Core = this.Core;
    transportOperationalIdentifiers.Variant = this.Variant;
    transportOperationalIdentifiers.TimetableYear = this.TimetableYear;
    transportOperationalIdentifiers.StartDate = this.StartDate;
    return transportOperationalIdentifiers;
  }
}
