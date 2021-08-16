import {DateAndTimeUtils} from '../pages/common/utilities/DateAndTimeUtils';
import {ChronoUnit, ZonedDateTime} from '@js-joda/core';

export class StopWatch {
  private startTime: ZonedDateTime;
  private stopTime: ZonedDateTime;

  constructor() {
    this.startTime = null;
    this.stopTime = null;
  }

  public start = () => {
    this.startTime = DateAndTimeUtils.getCurrentDateTime();
  }

  public stop = () => {
    this.stopTime = DateAndTimeUtils.getCurrentDateTime();
  }

  public readElapsedTimeMS = (): number => {
    if (this.startTime === null) {
      return 0;
    }
    if (this.stopTime === null) {
      this.stop();
    }
    return ChronoUnit.MILLIS.between(this.startTime, this.stopTime);
  }

  public reset = () => {
    this.startTime = null;
    this.stopTime = null;
  }
}
