import {TimingAtLocation} from './timing-at-location';
import {Location} from './location';

export class LocationModified {
  public ModificationStatusIndicator?: string;
  public TimingAtLocation?: TimingAtLocation;
  public Location?: Location;
}

export class LocationModifiedBuilder {
  private ModificationStatusIndicator?: string;
  private TimingAtLocation?: TimingAtLocation;
  private Location?: Location;
  constructor() {
    this.Location = new Location();
  }
  withModificationStatusIndicator(value: string): LocationModifiedBuilder {
    this.ModificationStatusIndicator = value;
    return this;
  }
  withTimingAtLocation(value: TimingAtLocation): LocationModifiedBuilder {
    this.TimingAtLocation = value;
    return this;
  }
  withLocation(value: Location): LocationModifiedBuilder {
    this.Location = value;
    return this;
  }
  build(): LocationModified {
    const locationModified = new LocationModified();
    locationModified.ModificationStatusIndicator = this.ModificationStatusIndicator;
    locationModified.TimingAtLocation = this.TimingAtLocation;
    locationModified.Location = this.Location;
    return locationModified;
  }
}
