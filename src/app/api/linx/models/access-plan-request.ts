/* tslint:disable */

import {Association} from "./association";
import {Schedule} from "./schedule";

export class AccessPlanRequest {
  associations?: Array<Association>;
  schedules?: Array<Schedule>;

  constructor(associations: Array<Association>, schedules: Array<Schedule>) {
    this.associations = associations;
    this.schedules = schedules;
  }
}
