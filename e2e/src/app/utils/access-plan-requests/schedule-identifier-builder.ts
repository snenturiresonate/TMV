/* tslint:disable */
import {ScheduleIdentifier} from '../../../../../src/app/api/linx/models/schedule-identifier';

export class ScheduleIdentifierBuilder {
  private dateRunsFrom?: string;
  private stpIndicator?: string;
  private trainUid?: string;

  withDateRunsFrom(dateRunsFrom: string) {
    this.dateRunsFrom = dateRunsFrom;
    return this;
  }

  withStpIndicator(stpIndicator?: string) {
    this.stpIndicator = stpIndicator;
    return this;
  }

  withTrainUid(trainUid?: string) {
    this.trainUid = trainUid;
    return this;
  }

  build(): ScheduleIdentifier {
    return new ScheduleIdentifier(
      this.dateRunsFrom,
      this.stpIndicator,
      this.trainUid
    );
  }
}
