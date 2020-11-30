/* tslint:disable */
import {Days} from '../../../../../src/app/api/linx/models/days';
import {IntermediateLocation} from '../../../../../src/app/api/linx/models/intermediate-location';
import {OriginLocation} from '../../../../../src/app/api/linx/models/origin-location';
import {ScheduleIdentifier} from '../../../../../src/app/api/linx/models/schedule-identifier';
import {ServiceCharacteristics} from '../../../../../src/app/api/linx/models/service-characteristics';
import {StockCharacteristics} from '../../../../../src/app/api/linx/models/stock-characteristics';
import {TerminatingLocation} from '../../../../../src/app/api/linx/models/terminating-location';
import {TrainSpecificNote} from '../../../../../src/app/api/linx/models/train-specific-note';
import {Schedule} from '../../../../../src/app/api/linx/models/schedule';

export class ScheduleBuilder {
  private applicableTimetableCode?: string;
  private atocCode?: string;
  private bankHolidayRunning?: string;
  private dateRunsTo?: string;
  private daysRun?: Days;
  private intermediateLocations?: Array<IntermediateLocation>;
  private originLocation?: OriginLocation;
  private scheduleIdentifier?: ScheduleIdentifier;
  private serviceCharacteristics?: ServiceCharacteristics;
  private stockCharacteristics?: StockCharacteristics;
  private terminatingLocation?: TerminatingLocation;
  private trainSpecificNotes?: Array<TrainSpecificNote>;
  private trainStatus?: string;
  private transactionType?: string;


  withApplicableTimetableCode(applicableTimetableCode: string) {
    this.applicableTimetableCode = applicableTimetableCode;
    return this;
  }

  withAtocCode(atocCode: string) {
    this.atocCode = atocCode;
    return this;
  }

  withBankHolidayRunning(bankHolidayRunning: string) {
    this.bankHolidayRunning = bankHolidayRunning;
    return this;
  }

  withDateRunsTo(dateRunsTo: string) {
    this.dateRunsTo = dateRunsTo;
    return this;
  }

  withDaysRun(daysRun: Days) {
    this.daysRun = daysRun;
    return this;
  }

  public withIntermediateLocation(intermediateLocation: IntermediateLocation) {
    if (this.intermediateLocations == null) {
      this.intermediateLocations = new Array<IntermediateLocation>(intermediateLocation);
    } else {
      this.intermediateLocations.push(intermediateLocation);
    }
    return this;
  }

  public withOriginLocation(originLocation: OriginLocation) {
    this.originLocation = originLocation;
    return this;
  }

  withScheduleIdentifier(scheduleIdentifier: ScheduleIdentifier) {
    this.scheduleIdentifier = scheduleIdentifier;
    return this;
  }

  withServiceCharacteristics(serviceCharacteristics: ServiceCharacteristics) {
    this.serviceCharacteristics = serviceCharacteristics;
    return this;
  }

  withStockCharacteristics(stockCharacteristics: StockCharacteristics) {
    this.stockCharacteristics = stockCharacteristics;
    return this;
  }

  public withTerminatingLocation(terminatingLocation: TerminatingLocation) {
    this.terminatingLocation = terminatingLocation;
    return this;
  }

  withTrainSpecificNotes(trainSpecificNote: TrainSpecificNote) {
    this.trainSpecificNotes.push(trainSpecificNote);
    return this;
  }

  withTrainStatus(trainStatus: string) {
    this.trainStatus = trainStatus;
    return this;
  }

  withTransactionType(transactionType: string) {
    this.transactionType = transactionType;
    return this;
  }

  public build(): Schedule {
    return new Schedule(
      this.applicableTimetableCode,
      this.atocCode,
      this.bankHolidayRunning,
      this.dateRunsTo,
      this.daysRun,
      this.intermediateLocations,
      this.originLocation,
      this.scheduleIdentifier,
      this.serviceCharacteristics,
      this.stockCharacteristics,
      this.terminatingLocation,
      this.trainSpecificNotes,
      this.trainStatus,
      this.transactionType
    );
  }
}
