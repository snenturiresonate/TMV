/* tslint:disable */
export class SignallingUpdate {
  address?: string;
  data?: string;
  timestamp?: string;
  trainDescriber?: string;

  constructor(address: string, data: string, timestamp: string, trainDescriber: string) {
    this.address = address;
    this.data = data;
    this.timestamp = timestamp;
    this.trainDescriber = trainDescriber;
  }
}
