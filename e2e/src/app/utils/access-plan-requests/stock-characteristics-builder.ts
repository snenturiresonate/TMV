/* tslint:disable */

import {StockCharacteristics} from '../../../../../src/app/api/linx/models/stock-characteristics';

export class StockCharacteristicsBuilder {
  private cateringCode?: Array<string>;
  private operatingCharacteristics?: Array<string>;
  private portionId?: string;
  private powerType?: string;
  private reservations?: string;
  private seatingClass?: string;
  private serviceBranding?: Array<string>;
  private sleepers?: string;
  private speed?: number;
  private timingLoad?: string;

  constructor() {
    this.operatingCharacteristics = new Array<string>();
    this.withOperatingCharacteristics('Q');
    this.withPowerType('');
    this.withTimingLoad('');
    this.withSpeed(60);
  }

  withCateringCode(cateringCode: Array<string>) {
    this.cateringCode = cateringCode;
    return this;
  }

  withOperatingCharacteristics(operatingCharacteristics: string) {
    this.operatingCharacteristics.push(operatingCharacteristics);
    return this;
  }

  withPortionId(portionId: string) {
    this.portionId = portionId;
    return this;
  }

  withPowerType(powerType: string) {
    this.powerType = powerType;
    return this;
  }

  withReservations(reservations: string) {
    this.reservations = reservations;
    return this;
  }

  withSeatingClass(seatingClass: string) {
    this.seatingClass = seatingClass;
    return this;
  }

  withServiceBranding(serviceBranding: string) {
    this.serviceBranding.push(serviceBranding);
    return this;
  }

  withSleepers(sleepers: string) {
    this.sleepers = sleepers;
    return this;
  }

  withSpeed(speed: number) {
    this.speed = speed;
    return this;
  }

  withTimingLoad(timingLoad: string) {
    this.timingLoad = timingLoad;
    return this;
  }

  build(): StockCharacteristics {
    return new StockCharacteristics(
      this.cateringCode,
      this.operatingCharacteristics,
      this.portionId,
      this.powerType,
      this.reservations,
      this.seatingClass,
      this.serviceBranding,
      this.sleepers,
      this.speed,
      this.timingLoad
  )
    ;
  }
}
