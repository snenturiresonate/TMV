/* tslint:disable */
export class BerthCancel {
  fromBerth?: string;
  timestamp?: string;
  trainDescriber?: string;
  trainDescription?: string;

  constructor(fromBerth: string, timestamp: string, trainDescriber: string, trainDescription: string) {
    this.fromBerth = fromBerth;
    this.timestamp = timestamp;
    this.trainDescriber = trainDescriber;
    this.trainDescription = trainDescription;
  }
}
