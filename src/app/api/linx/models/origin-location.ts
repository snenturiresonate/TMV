/* tslint:disable */
import { Location } from './location';
import { LocationSpecificNote } from './location-specific-note';

export class OriginLocation {
  activity?: Array<string>;
  engineeringAllowance?: number;
  line?: string;
  location?: Location;
  locationSpecificNotes?: Array<LocationSpecificNote>;
  pathingAllowance?: number;
  performanceAllowance?: number;
  platform?: string;
  publicDeparture?: string;
  scheduledDeparture?: string;

  constructor(activity: Array<string>, engineeringAllowance: number, line: string, location: Location, locationSpecificNotes: Array<LocationSpecificNote>, pathingAllowance: number, performanceAllowance: number, platform: string, publicDeparture: string, scheduledDeparture: string) {
    this.activity = activity;
    this.engineeringAllowance = engineeringAllowance;
    this.line = line;
    this.location = location;
    this.locationSpecificNotes = locationSpecificNotes;
    this.pathingAllowance = pathingAllowance;
    this.performanceAllowance = performanceAllowance;
    this.platform = platform;
    this.publicDeparture = publicDeparture;
    this.scheduledDeparture = scheduledDeparture;
  }
}
