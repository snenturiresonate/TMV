import {fragment} from 'xmlbuilder2';
import {DateAndTimeUtils} from '../../pages/common/utilities/DateAndTimeUtils';

export class TRITrainOperationalIdentification {
  public static trainOperationalIdentification = (
    trainUID: string,
    trainNumber: string,
    scheduledStartDate: string,
    stanox: string = '70',
    scheduleType: string = 'M',
    hourOfDeparture: string = 'H') => {
    const startDate = DateAndTimeUtils.convertToDesiredDateAndFormat(scheduledStartDate.toLowerCase(), 'yyyy-MM-dd');
    const trainOperationalIdentification = fragment().ele('TrainOperationalIdentification')
      .ele('TransportOperationalIdentifiers')
      .ele('ObjectType').txt('TR').up()
      .ele('Company').txt('0070').up()
      .ele('Core').txt(`--${stanox}${trainNumber}${scheduleType}${hourOfDeparture}${scheduledStartDate.substring(8)}`).up()
      .ele('TimetableYear').txt((startDate.split('-')[0])).up()
      .ele('StartDate').txt(startDate).up()
      .doc();
    return trainOperationalIdentification.end({prettyPrint: true});
  }
}
