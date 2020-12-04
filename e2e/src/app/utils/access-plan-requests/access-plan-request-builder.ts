/* tslint:disable */
import {Schedule} from '../../../../../src/app/api/linx/models/schedule';
import {Association} from '../../../../../src/app/api/linx/models/association';
import {AccessPlanRequest} from '../../../../../src/app/api/linx/models/access-plan-request';
import {Header} from '../../../../../src/app/api/linx/models/header';
import {HeaderBuilder} from './header-builder';

export class AccessPlanRequestBuilder {
  private associations?: Array<Association>;
  private schedules?: Array<Schedule>;
  private header?: Header;

  constructor() {
    this.associations = new Array<Association>();
    this.schedules = new Array<Schedule>();
  }


  withAssociation(association: Association) {
    this.associations.push(association);
    return this;
  }

  withSchedule(schedule: Schedule) {
    this.schedules.push(schedule);
    return this;
  }

  update() {
    this.header = new HeaderBuilder().update().build();
    return this;
  }

  full() {
    this.header = new HeaderBuilder().new().build();
    return this;
  }

  build() {
    return new AccessPlanRequest(
      this.associations,
      this.schedules,
      this.header
    );
  }
}
