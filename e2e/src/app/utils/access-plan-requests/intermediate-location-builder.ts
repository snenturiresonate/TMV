/* tslint:disable */
import {ChangesEnRoute} from '../../../../../src/app/api/linx/models/changes-en-route';
import {Location} from '../../../../../src/app/api/linx/models/location';
import {LocationSpecificNote} from '../../../../../src/app/api/linx/models/location-specific-note';
import {IntermediateLocation} from '../../../../../src/app/api/linx/models/intermediate-location';

export class IntermediateLocationBuilder {
  private activity?: Array<string>;
  private changesEnRoute?: ChangesEnRoute;
  private engineeringAllowance?: number;
  private line?: string;
  private location?: Location;
  private locationSpecificNotes?: Array<LocationSpecificNote>;
  private path?: string;
  private pathingAllowance?: number;
  private performanceAllowance?: number;
  private platform?: string;
  private publicArrival?: string;
  private publicDeparture?: string;
  private scheduledArrival?: string;
  private scheduledDeparture?: string;
  private scheduledPass?: string;

  withActivity(activity: string) {
    this.activity.push(activity);
    return this;
  }
  withChangesEnRoute(changesEnRoute: ChangesEnRoute) {
    this.changesEnRoute = changesEnRoute;
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
  withLocation(location: Location) {
    this.location = location;
    return this;
  }
  withLocationSpecificNotes(locationSpecificNote: LocationSpecificNote) {
    this.locationSpecificNotes.push(locationSpecificNote);
    return this;
  }
  withPath(path: string) {
    this.path = path;
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
  withPublicArrival(publicArrival: string) {
    this.publicArrival = publicArrival;
    return this;
  }
  withPublicDeparture(publicDeparture: string) {
    this.publicDeparture = publicDeparture;
    return this;
  }
  withScheduledArrival(scheduledArrival: string) {
    this.scheduledArrival = scheduledArrival;
    return this;
  }
  withScheduledDeparture(scheduledDeparture: string) {
    this.scheduledDeparture = scheduledDeparture;
    return this;
  }
  withScheduledPass(scheduledPass: string) {
    this.scheduledPass = scheduledPass;
    return this;
  }

  build(): IntermediateLocation {
    return new IntermediateLocation(
      this.activity,
      this.changesEnRoute,
      this.engineeringAllowance,
      this.line,
      this.location,
      this.locationSpecificNotes,
      this.path,
      this.pathingAllowance,
      this.performanceAllowance,
      this.platform,
      this.publicArrival,
      this.publicDeparture,
      this.scheduledArrival,
      this.scheduledDeparture,
      this.scheduledPass
    );
  }


}
