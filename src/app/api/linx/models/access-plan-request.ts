/* tslint:disable */

import {Association} from './association';
import {Schedule} from './schedule';
import {Header} from './header';

export class AccessPlanRequest {
  associations?: Array<Association>;
  schedules?: Array<Schedule>;
  header?: Header;

  constructor(associations: Array<Association>, schedules: Array<Schedule>, header: Header) {
    this.associations = associations;
    this.schedules = schedules;
    this.header = header;
  }
}
