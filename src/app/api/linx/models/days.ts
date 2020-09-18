/* tslint:disable */
export class Days {
  friday?: boolean;
  monday?: boolean;
  saturday?: boolean;
  sunday?: boolean;
  thursday?: boolean;
  tuesday?: boolean;
  wednesday?: boolean;

  constructor(friday: boolean, monday: boolean, saturday: boolean, sunday: boolean, thursday: boolean,
              tuesday: boolean, wednesday: boolean) {
    this.friday = friday;
    this.monday = monday;
    this.saturday = saturday;
    this.sunday = sunday;
    this.thursday = thursday;
    this.tuesday = tuesday;
    this.wednesday = wednesday;
  }
}
