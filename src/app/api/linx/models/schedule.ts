/* tslint:disable */
import { Days } from './days';
import { IntermediateLocation } from './intermediate-location';
import { OriginLocation } from './origin-location';
import { ScheduleIdentifier } from './schedule-identifier';
import { ServiceCharacteristics } from './service-characteristics';
import {StockCharacteristics} from "./stock-characteristics";
import {TerminatingLocation} from "./terminating-location";
import {TrainSpecificNote} from "./train-specific-note";

export class Schedule {
  applicableTimetableCode?: string;
  atocCode?: string;
  bankHolidayRunning?: string;
  dateRunsTo?: string;
  daysRun?: Days;
  intermediateLocations?: Array<IntermediateLocation>;
  originLocation?: OriginLocation;
  scheduleIdentifier?: ScheduleIdentifier;
  serviceCharacteristics?: ServiceCharacteristics;
  stockCharacteristics?: StockCharacteristics;
  terminatingLocation?: TerminatingLocation;
  trainSpecificNotes?: Array<TrainSpecificNote>;
  trainStatus?: string;
  transactionType?: string;

  constructor(applicableTimetableCode: string, atocCode: string, bankHolidayRunning: string, dateRunsTo: string, daysRun: Days, intermediateLocations: Array<IntermediateLocation>, originLocation: OriginLocation, scheduleIdentifier: ScheduleIdentifier, serviceCharacteristics: ServiceCharacteristics, stockCharacteristics: StockCharacteristics, terminatingLocation: TerminatingLocation, trainSpecificNotes: Array<TrainSpecificNote>, trainStatus: string, transactionType: string) {
    this.applicableTimetableCode = applicableTimetableCode;
    this.atocCode = atocCode;
    this.bankHolidayRunning = bankHolidayRunning;
    this.dateRunsTo = dateRunsTo;
    this.daysRun = daysRun;
    this.intermediateLocations = intermediateLocations;
    this.originLocation = originLocation;
    this.scheduleIdentifier = scheduleIdentifier;
    this.serviceCharacteristics = serviceCharacteristics;
    this.stockCharacteristics = stockCharacteristics;
    this.terminatingLocation = terminatingLocation;
    this.trainSpecificNotes = trainSpecificNotes;
    this.trainStatus = trainStatus;
    this.transactionType = transactionType;
  }
}
