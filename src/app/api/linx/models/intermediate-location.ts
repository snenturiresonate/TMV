/* tslint:disable */

import {ChangesEnRoute} from "./changes-en-route";
import {LocationSpecificNote} from "./location-specific-note";

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


}
