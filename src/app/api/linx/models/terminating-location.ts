/* tslint:disable */
import { Location } from './location';
import { LocationSpecificNote } from './location-specific-note';

export class TerminatingLocation {
  activity?: Array<string>;
  location?: Location;
  locationSpecificNotes?: Array<LocationSpecificNote>;
  path?: string;
  platform?: string;
  publicArrival?: string;
  scheduledArrival?: string;

  constructor(activity: Array<string>, location: Location, locationSpecificNotes: Array<LocationSpecificNote>, path: string, platform: string, publicArrival: string, scheduledArrival: string) {
    this.activity = activity;
    this.location = location;
    this.locationSpecificNotes = locationSpecificNotes;
    this.path = path;
    this.platform = platform;
    this.publicArrival = publicArrival;
    this.scheduledArrival = scheduledArrival;
  }
}
