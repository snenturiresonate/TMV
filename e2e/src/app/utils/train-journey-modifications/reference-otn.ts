import {OperationalTrainNumberIdentifier} from './operational-train-number-identifier';

export class ReferenceOTN {
  public OperationalTrainNumberIdentifier?: OperationalTrainNumberIdentifier;
}

export class ReferenceOTNBuilder {
  private OperationalTrainNumberIdentifier?: OperationalTrainNumberIdentifier;
  constructor() {
    this.OperationalTrainNumberIdentifier = new OperationalTrainNumberIdentifier();
  }
  withOperationalTrainNumberIdentifier(value: OperationalTrainNumberIdentifier):
  ReferenceOTNBuilder {
    this.OperationalTrainNumberIdentifier = value;
    return this;
  }
  build(): ReferenceOTN {
    const referenceOTN = new ReferenceOTN();
    referenceOTN.OperationalTrainNumberIdentifier = this.OperationalTrainNumberIdentifier;
    return referenceOTN;
  }
}
