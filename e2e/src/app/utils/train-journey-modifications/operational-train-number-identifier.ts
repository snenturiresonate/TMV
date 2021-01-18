export class OperationalTrainNumberIdentifier {
  public OperationalTrainNumber?: string;
}

export class OperationalTrainNumberIdentifierBuilder {
  private OperationalTrainNumber?: string;
  constructor() {
  }
  withOperationalTrainNumber(value: string): OperationalTrainNumberIdentifierBuilder {
    this.OperationalTrainNumber = value;
    return this;
  }
  build(): OperationalTrainNumberIdentifier {
    const operationalTrainNumberIdentifier = new OperationalTrainNumberIdentifier();
    operationalTrainNumberIdentifier.OperationalTrainNumber = this.OperationalTrainNumber;
    return operationalTrainNumberIdentifier;
  }
}
