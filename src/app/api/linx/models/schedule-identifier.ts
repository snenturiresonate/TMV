/* tslint:disable */
export class ScheduleIdentifier {
  dateRunsFrom?: string;
  stpIndicator?: string;
  trainUid?: string;

  constructor(dateRunsFrom: string, stpIndicator: string, trainUid: string) {
    this.dateRunsFrom = dateRunsFrom;
    this.stpIndicator = stpIndicator;
    this.trainUid = trainUid;
  }
}
