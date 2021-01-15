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

  withDayBits(daysRun: any) {
    const dayBits = daysRun.split('');
    this.monday = Boolean(Number(dayBits[0]));
    this.tuesday = Boolean(Number(dayBits[1]));
    this.wednesday = Boolean(Number(dayBits[2]));
    this.thursday = Boolean(Number(dayBits[3]));
    this.friday = Boolean(Number(dayBits[4]));
    this.saturday = Boolean(Number(dayBits[5]));
    this.sunday = Boolean(Number(dayBits[6]));
    return this;
  }

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
