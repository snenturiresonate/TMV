/* tslint:disable */
import {Location} from '../../../../../src/app/api/linx/models/location';
import {LocationSpecificNote} from '../../../../../src/app/api/linx/models/location-specific-note';
import {TerminatingLocation} from '../../../../../src/app/api/linx/models/terminating-location';

export class TerminatingLocationBuilder {
  private activity?: Array<string>;
  private location?: Location;
  private locationSpecificNotes?: Array<LocationSpecificNote>;
  private path?: string;
  private platform?: string;
  private publicArrival?: string;
  private scheduledArrival?: string;

  constructor() {
    this.activity = new Array<string>();
    this.locationSpecificNotes = new Array<LocationSpecificNote>();

    this.withScheduledArrival('00:00');
    this.withPublicArrival('00:00');
    this.withActivity('TF');
  }

  withActivity(activity: string) {
    this.activity.push(activity);
    return this;
  }

  withLocation(location: Location) {
    this.location = location;
    return this;
  }

  withLocationSpecificNote(locationSpecificNote: LocationSpecificNote) {
    this.locationSpecificNotes.push(locationSpecificNote);
    return this;
  }

  withPath(path: string) {
    this.path = path;
    return this;
  }

  withPlatform(platform: string) {
    this.platform = platform;
    return this;
  }

  withPublicArrival(publicArrival: string) {
    this.publicArrival = publicArrival;
    return this;
  }

  withScheduledArrival(scheduledArrival: string) {
    this.scheduledArrival = scheduledArrival;
    return this;
  }

  build(): TerminatingLocation {
    return new TerminatingLocation(
      this.activity,
      this.location,
      this.locationSpecificNotes,
      this.path,
      this.platform,
      this.publicArrival,
      this.scheduledArrival
    );
  }
}
