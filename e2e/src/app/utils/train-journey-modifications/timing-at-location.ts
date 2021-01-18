import {Timing} from './timing';

export class TimingAtLocation {
  public Timing?: Timing;
}
export class TimingAtLocationBuilder {
  private Timing?: Timing;
  constructor() {
  }
  withTiming(value: Timing): TimingAtLocationBuilder {
    this.Timing = value;
    return this;
  }
  build(): TimingAtLocation {
    const timingAtLocation = new TimingAtLocation();
    timingAtLocation.Timing = this.Timing;
    return timingAtLocation;
  }
}
