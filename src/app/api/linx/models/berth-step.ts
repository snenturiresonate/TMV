/* tslint:disable */
export class BerthStep {
  fromBerth?: string;
  timestamp?: string;
  toBerth?: string;
  trainDescriber?: string;
  trainDescription?: string;

  constructor(fromBerth: string, timestamp: string, toBerth: string, trainDescriber: string, trainDescription: string) {
    this.fromBerth = fromBerth;
    this.timestamp = timestamp;
    this.toBerth = toBerth;
    this.trainDescriber = trainDescriber;
    this.trainDescription = trainDescription;
  }
}
