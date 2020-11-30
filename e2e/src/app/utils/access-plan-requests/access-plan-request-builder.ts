/* tslint:disable */
import {Schedule} from '../../../../../src/app/api/linx/models/schedule';
import {Association} from '../../../../../src/app/api/linx/models/association';
import {AccessPlanRequest} from '../../../../../src/app/api/linx/models/access-plan-request';

export class AccessPlanRequestBuilder {
  private associations?: Array<Association>;
  private schedules?: Array<Schedule>;

  withAssociation(association: Association) {
    if (this.associations == null) {
      this.associations = new Array<Association>(association);
    } else {
      this.associations.push(association);
    }
    return this;
  }

  withSchedule(schedule: Schedule) {
    if (this.schedules == null) {
      this.schedules = new Array<Schedule>(schedule);
    } else {
      this.schedules.push(schedule);
    }
    return this;
  }

  build() {
    return new AccessPlanRequest(
      this.associations,
      this.schedules
    );
  }
}
