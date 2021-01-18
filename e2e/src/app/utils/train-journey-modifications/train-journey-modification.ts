import {LocationModified} from './location-modified';

export class TrainJourneyModification {
  public TrainJourneyModificationIndicator?: string;
  public LocationModified?: LocationModified;
}

export class TrainJourneyModificationBuilder {
  private TrainJourneyModificationIndicator?: string;
  private LocationModified?: LocationModified;
  constructor() {
    this.LocationModified = new LocationModified();
  }
  withTrainJourneyModificationIndicator(value: string): TrainJourneyModificationBuilder {
    this.TrainJourneyModificationIndicator = value;
    return this;
  }
  withLocationModified(value: LocationModified): TrainJourneyModificationBuilder {
    this.LocationModified = value;
    return this;
  }
  build(): TrainJourneyModification {
    const trainJourneyModification = new TrainJourneyModification();
    trainJourneyModification.TrainJourneyModificationIndicator = this.TrainJourneyModificationIndicator;
    trainJourneyModification.LocationModified = this.LocationModified;
    return trainJourneyModification;
  }
}
