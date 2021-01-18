export class Timing {
  public Time?: string;
  public Offset?: string;
}

export class TimingBuilder {
  private Time?: string;
  private Offset?: string;
  constructor() {
    this.Offset = '0';
  }
  withTime(value: string): TimingBuilder {
    this.Time = value;
    return this;
  }
  withOffset(value: string): TimingBuilder {
    this.Offset = value;
    return this;
  }
  build(): Timing {
    const timing = new Timing();
    timing.Time = this.Time;
    timing.Offset = this.Offset;
    return timing;
  }
}
