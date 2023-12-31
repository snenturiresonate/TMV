/* tslint:disable */
import {ScheduleIdentifier} from '../../../../../src/app/api/linx/models/schedule-identifier';
import {DateAndTimeUtils} from '../../pages/common/utilities/DateAndTimeUtils';

export class ScheduleIdentifierBuilder {
  private dateRunsFrom?: string;
  private stpIndicator?: string;
  private trainUid?: string;

  constructor() {
    this.withDateRunsFrom('2020-01-01');
    this.withStpIndicator('P');
    this.withTrainUid('H39407');
  }

  withDateRunsFrom(dateRunsFrom: string) {
    this.dateRunsFrom = DateAndTimeUtils.convertToDesiredDateAndFormat(dateRunsFrom, 'yyyy-MM-dd');
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
