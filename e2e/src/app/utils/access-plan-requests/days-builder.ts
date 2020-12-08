/* tslint:disable */
import {Days} from '../../../../../src/app/api/linx/models/days';

export class DaysBuilder {
  private friday?: boolean;
  private monday?: boolean;
  private saturday?: boolean;
  private sunday?: boolean;
  private thursday?: boolean;
  private tuesday?: boolean;
  private wednesday?: boolean;

  weekdays() {
    this.monday = true;
    this.tuesday = true;
    this.wednesday = true;
    this.thursday = true;
    this.friday = true;
    return this;
  }

  weekends() {
    this.saturday = true;
    this.sunday = true;
    return this;
  }

  allDays() {
    this.weekdays().weekends();
    return this;
  }

  build() {
    return new Days(
      this.friday,
      this.monday,
      this.saturday,
      this.sunday,
      this.thursday,
      this.tuesday,
      this.wednesday
    );
  }
}