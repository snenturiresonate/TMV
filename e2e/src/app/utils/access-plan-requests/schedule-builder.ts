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
import {DaysBuilder} from './days-builder';
import {ScheduleIdentifierBuilder} from './schedule-identifier-builder';
import {ServiceCharacteristicsBuilder} from './service-characteristics-builder';
import {StockCharacteristicsBuilder} from './stock-characteristics-builder';
import {DateAndTimeUtils} from '../../pages/common/utilities/DateAndTimeUtils';

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

  constructor() {
    this.intermediateLocations = new Array<IntermediateLocation>();
    this.trainSpecificNotes = new Array<TrainSpecificNote>();

    this.new();
    this.withApplicableTimetableCode('Y');
    this.withAtocCode('ZZ');
    this.withDateRunsTo('2050-01-01');
    this.withDaysRun(new DaysBuilder().allDays().build());
    this.withScheduleIdentifier(new ScheduleIdentifierBuilder().build());
    this.withServiceCharacteristics(new ServiceCharacteristicsBuilder().build());
    this.withStockCharacteristics(new StockCharacteristicsBuilder().build());
    this.withTrainStatus('F');
  }

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
    this.dateRunsTo = DateAndTimeUtils.convertToDesiredDateAndFormat(dateRunsTo, 'yyyy-MM-dd');
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

  new() {
    this.transactionType = 'N';
    return this;
  }
  delete() {
    this.transactionType = 'D';
    return this;
  }
  revise() {
    this.transactionType = 'R';
    return this;
  }

  monday(isRunning: boolean) {
    this.daysRun.monday = isRunning;
  }
  tuesday(isRunning: boolean) {
    this.daysRun.tuesday = isRunning;
  }
  wednesday(isRunning: boolean) {
    this.daysRun.wednesday = isRunning;
  }
  thursday(isRunning: boolean) {
    this.daysRun.thursday = isRunning;
  }
  friday(isRunning: boolean) {
    this.daysRun.friday = isRunning;
  }
  saturday(isRunning: boolean) {
    this.daysRun.saturday = isRunning;
  }
  sunday(isRunning: boolean) {
    this.daysRun.sunday = isRunning;
  }

noRunDay(day: string, schedule: ScheduleBuilder){

      switch (day.toLowerCase()) {
        case 'monday':
          schedule.monday(false);
          break;
        case 'tuesday':
          schedule.tuesday(false);
          break;
        case 'wednesday':
          schedule.wednesday(false);
          break;
        case 'thursday':
          schedule.thursday(false);
          break;
        case 'friday':
          schedule.friday(false);
          break;
        case 'saturday':
          schedule.saturday(false);
          break;
        case 'sunday':
          schedule.sunday(false);
          break;
      }
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
