/* tslint:disable */
import {Location} from '../../../../../src/app/api/linx/models/location';
import {LocationSpecificNote} from '../../../../../src/app/api/linx/models/location-specific-note';
import {OriginLocation} from '../../../../../src/app/api/linx/models/origin-location';

export class OriginLocationBuilder {
  private activity?: Array<string>;
  private engineeringAllowance?: number;
  private line?: string;
  private location?: Location;
  private locationSpecificNotes?: Array<LocationSpecificNote>;
  private pathingAllowance?: number;
  private performanceAllowance?: number;
  private platform?: string;
  private publicDeparture?: string;
  private scheduledDeparture?: string;

  constructor() {
    this.activity = new Array<string>();
    this.locationSpecificNotes = new Array<LocationSpecificNote>();
    this.withScheduledDeparture('00:00');
    this.withPublicDeparture('00:00');
    this.withActivity('TB');
  }

  withLocation(location: Location) {
    this.location = location;
    return this;
  }
  withLocationSpecificNote(locationSpecificNote: LocationSpecificNote) {
    this.locationSpecificNotes.push(locationSpecificNote);
    return this;
  }
  withActivity (activity: string) {
    this.activity.push(activity);
    return this;
  }
  withEngineeringAllowance(engineeringAllowance: number) {
    this.engineeringAllowance = engineeringAllowance;
    return this;
  }
  withLine(line: string) {
    this.line = line;
    return this;
  }
  withPathingAllowance(pathingAllowance: number) {
    this.pathingAllowance = pathingAllowance;
    return this;
  }
  withPerformanceAllowance(performanceAllowance: number) {
    this.performanceAllowance = performanceAllowance;
    return this;
  }
  withPlatform(platform: string) {
    this.platform = platform;
    return this;
  }
  withPublicDeparture(publicDeparture: string) {
    this.publicDeparture = publicDeparture;
    return this;
  }
  withScheduledDeparture(scheduledDeparture: string) {
    this.scheduledDeparture = scheduledDeparture;
    return this;
  }

  build(): OriginLocation {
    return new OriginLocation(
      this.activity,
      this.engineeringAllowance,
      this.line,
      this.location,
      this.locationSpecificNotes,
      this.pathingAllowance,
      this.performanceAllowance,
      this.platform,
      this.publicDeparture,
      this.scheduledDeparture
    )
  }
}
