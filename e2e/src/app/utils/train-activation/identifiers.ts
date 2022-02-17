import {fragment} from 'xmlbuilder2';

export class Identifiers {
  public static identifiers = (
    operationalTrainNumber: string,
    trainUID: string,
    departureDate: string,
    actualDepartureHour: string,
    stanox: string = '70',
    scheduleType: string = 'M',
    hourOfDeparture: string = 'H') => {
    const timeTableYear = departureDate.split('-')[0];
    const identifiers = fragment().ele('ns0:Identifiers')
      .ele('ns0:PlannedTransportIdentifiers')
      .ele('ns0:ObjectType').txt('TR').up()
      .ele('ns0:Company').txt('0070').up()
      .ele('ns0:Core').txt(`--${stanox}${operationalTrainNumber}${scheduleType}${hourOfDeparture}${departureDate.substring(8)}`).up()
      .ele('ns0:Variant').txt('01').up()
      .ele('ns0:TimetableYear').txt(timeTableYear).up()
      .ele('ns0:StartDate').txt(departureDate).up()
      .up()
      .ele('ns0:PlannedTransportIdentifiers')
      .ele('ns0:ObjectType').txt('PA').up()
      .ele('ns0:Company').txt('0070').up()
      .ele('ns0:Core').txt(`${operationalTrainNumber}${trainUID}${actualDepartureHour}`).up()
      .ele('ns0:Variant').txt('01').up()
      .ele('ns0:TimetableYear').txt(timeTableYear).up()
      .ele('ns0:StartDate').txt(departureDate).up()
      .doc();
    return identifiers.end({prettyPrint: true});
  }
}
