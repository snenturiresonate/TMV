import {fragment} from 'xmlbuilder2';
import {TrainActivationPlannedJourneyLocationBuilder} from './planned-journey-location';
import {TrainActivationPlannedCalendarBuilder} from './planned-calendar';

export class TrainActivationPathInformationBuilder {

  public static pathInformation = (locationPrimaryCode: string, locationSubsidiaryCode: string,
                                   time: string, operationalTrainNumber: string, trainUID: string) => {
    const pathInformation = fragment().ele('PathInformation')
      .ele(TrainActivationPlannedJourneyLocationBuilder.plannedJourneyLocation(locationPrimaryCode, locationSubsidiaryCode,
        time, operationalTrainNumber, trainUID)).up()
      .ele(TrainActivationPlannedCalendarBuilder.plannedCalendar())
      .doc();
    console.log('pathInformation: ' + pathInformation.end({prettyPrint: true}));
    return pathInformation.end({prettyPrint: true});
  }
}
