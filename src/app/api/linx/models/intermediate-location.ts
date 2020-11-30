/* tslint:disable */

import {ChangesEnRoute} from './changes-en-route';
import {LocationSpecificNote} from './location-specific-note';
import {Location} from './location';

export class IntermediateLocation {
  activity?: Array<string>;
  changesEnRoute?: ChangesEnRoute;
  engineeringAllowance?: number;
  line?: string;
  location?: Location;
  locationSpecificNotes?: Array<LocationSpecificNote>;
  path?: string;
  pathingAllowance?: number;
  performanceAllowance?: number;
  platform?: string;
  publicArrival?: string;
  publicDeparture?: string;
  scheduledArrival?: string;
  scheduledDeparture?: string;
  scheduledPass?: string;

  constructor(activity: Array<string>,
              changesEnRoute: ChangesEnRoute,
              engineeringAllowance: number,
              line: string,
              location: Location,
              locationSpecificNotes: Array<LocationSpecificNote>,
              path: string,
              pathingAllowance: number,
              performanceAllowance: number,
              platform: string,
              publicArrival: string,
              publicDeparture: string,
              scheduledArrival: string,
              scheduledDeparture: string,
              scheduledPass: string) {
    this.activity = activity;
    this.changesEnRoute = changesEnRoute;
    this.engineeringAllowance = engineeringAllowance;
    this.line = line;
    this.location = location;
    this.locationSpecificNotes = locationSpecificNotes;
    this.path = path;
    this.pathingAllowance = pathingAllowance;
    this.performanceAllowance = performanceAllowance;
    this.platform = platform;
    this.publicArrival = publicArrival;
    this.publicDeparture = publicDeparture;
    this.scheduledArrival = scheduledArrival;
    this.scheduledDeparture = scheduledDeparture;
    this.scheduledPass = scheduledPass;

  }


}
