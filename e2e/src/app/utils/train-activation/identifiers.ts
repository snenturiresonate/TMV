import {fragment} from 'xmlbuilder2';

export class Identifiers {
  public static identifiers = (operationalTrainNumber: string, trainUID: string, departureDate: string, actualDepartureHour: string) => {
    const timeTableYear = departureDate.split('-')[0];
    const identifiers = fragment().ele('Identifiers')
      .ele('PlannedTransportIdentifiers')
      .ele('ObjectType').txt('TR').up()
      .ele('Company').txt('0070').up()
      .ele('Core').txt(`--${operationalTrainNumber}${trainUID}`).up()
      .ele('Variant').txt('01').up()
      .ele('TimetableYear').txt(timeTableYear).up()
      .ele('StartDate').txt(departureDate).up()
      .up()
      .ele('PlannedTransportIdentifiers')
      .ele('ObjectType').txt('PA').up()
      .ele('Company').txt('0070').up()
      .ele('Core').txt(`${operationalTrainNumber}${trainUID}${actualDepartureHour}`).up()
      .ele('Variant').txt('01').up()
      .ele('TimetableYear').txt(timeTableYear).up()
      .ele('StartDate').txt(departureDate).up()
      .doc();
    return identifiers.end({prettyPrint: true});
  }
}
