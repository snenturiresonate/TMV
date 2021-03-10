import {fragment} from 'xmlbuilder2';
import {TrainActivationValidityPeriodBuilder} from './validity-period';

export class TrainActivationPlannedCalendarBuilder {

  public static plannedCalendar = (bitmapDays: string = '1') => {
    const plannedCalendar = fragment().ele('PlannedCalendar')
      .ele('BitmapDays').txt(bitmapDays).up()
      .ele(TrainActivationValidityPeriodBuilder.validityPeriod())
      .doc();
    console.log('plannedCalendar: ' + plannedCalendar.end({prettyPrint: true}));
    return plannedCalendar.end({prettyPrint: true});
  }
}
