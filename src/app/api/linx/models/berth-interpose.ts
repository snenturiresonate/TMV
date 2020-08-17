/* tslint:disable */
export class BerthInterpose {
  private timestamp?: string;
  private toBerth?: string;
  private trainDescriber?: string;
  private trainDescription?: string;

  constructor(timestamp: string, toBerth: string, trainDescriber: string, trainDescription: string) {
    this.timestamp = timestamp;
    this.toBerth = toBerth;
    this.trainDescriber = trainDescriber;
    this.trainDescription = trainDescription;
  }
}
