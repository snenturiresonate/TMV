import {TransportOperationalIdentifiers} from './train-operational-identifiers';

export class TrainOperationalIdentification {
  public TransportOperationalIdentifiers?: TransportOperationalIdentifiers;
}

export class TrainOperationalIdentificationBuilder {
  private TransportOperationalIdentifiers?: TransportOperationalIdentifiers;
  constructor() {
    this.TransportOperationalIdentifiers = new TransportOperationalIdentifiers();
  }
  withTransportOperationalIdentifiers(value: TransportOperationalIdentifiers): TrainOperationalIdentificationBuilder {
    this.TransportOperationalIdentifiers = value;
    return this;
  }
  build(): TrainOperationalIdentification {
    const trainOperationalIdentification = new TrainOperationalIdentification();
    trainOperationalIdentification.TransportOperationalIdentifiers = this.TransportOperationalIdentifiers;
    return trainOperationalIdentification;
  }
}
