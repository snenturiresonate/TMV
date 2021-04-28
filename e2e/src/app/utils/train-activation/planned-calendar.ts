import {fragment} from 'xmlbuilder2';
import {TrainActivationValidityPeriodBuilder} from './validity-period';

export class TrainActivationPlannedCalendarBuilder {

  public static plannedCalendar = (bitmapDays: string = '1') => {
    const plannedCalendar = fragment().ele('ns0:PlannedCalendar')
      .ele('ns0:BitmapDays').txt(bitmapDays).up()
      .ele(TrainActivationValidityPeriodBuilder.validityPeriod())
      .doc();
    return plannedCalendar.end({prettyPrint: true});
  }
}
