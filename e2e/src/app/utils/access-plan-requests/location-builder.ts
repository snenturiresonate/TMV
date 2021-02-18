/* tslint:disable */
import {Location} from '../../../../../src/app/api/linx/models/location';

export class LocationBuilder {
  private suffix?: number;
  private tiploc?: string;

  withSuffix(suffix: number) {
    this.suffix = suffix;
    return this;
  }

  withTiploc(tiploc: string) {
    this.tiploc = tiploc;
    return this;
  }

  build(): Location {
    return new Location(
      this.suffix,
      this.tiploc
    )
  }
}
