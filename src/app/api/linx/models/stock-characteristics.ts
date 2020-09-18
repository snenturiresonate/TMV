/* tslint:disable */
export class StockCharacteristics {
  cateringCode?: Array<string>;
  operatingCharacteristics?: Array<string>;
  portionId?: string;
  powerType?: string;
  reservations?: string;
  seatingClass?: string;
  serviceBranding?: Array<string>;
  sleepers?: string;
  speed?: number;
  timingLoad?: string;

  constructor(cateringCode: Array<string>, operatingCharacteristics: Array<string>, portionId: string, powerType: string, reservations: string, seatingClass: string, serviceBranding: Array<string>, sleepers: string, speed: number, timingLoad: string) {
    this.cateringCode = cateringCode;
    this.operatingCharacteristics = operatingCharacteristics;
    this.portionId = portionId;
    this.powerType = powerType;
    this.reservations = reservations;
    this.seatingClass = seatingClass;
    this.serviceBranding = serviceBranding;
    this.sleepers = sleepers;
    this.speed = speed;
    this.timingLoad = timingLoad;
  }
}
