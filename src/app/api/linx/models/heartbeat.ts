/* tslint:disable */
export class Heartbeat {
  timestamp?: string;
  trainDescriber?: string;
  trainDescriberTimestamp?: string;

  constructor(timestamp: string, trainDescriber: string, trainDescriberTimestamp: string) {
    this.timestamp = timestamp;
    this.trainDescriber = trainDescriber;
    this.trainDescriberTimestamp = trainDescriberTimestamp;
  }
}
