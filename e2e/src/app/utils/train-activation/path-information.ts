import {fragment} from 'xmlbuilder2';
import {TrainActivationPlannedJourneyLocationBuilder} from './planned-journey-location';
import {TrainActivationPlannedCalendarBuilder} from './planned-calendar';

export class TrainActivationPathInformationBuilder {

  public static pathInformation = (locationPrimaryCode: string, locationSubsidiaryCode: string,
                                   time: string, operationalTrainNumber: string, trainUID: string, asmVal: string) => {
    const pathInformation = fragment().ele('ns0:PathInformation')
      .ele(TrainActivationPlannedJourneyLocationBuilder.plannedJourneyLocation(locationPrimaryCode, locationSubsidiaryCode,
        time, operationalTrainNumber, trainUID, asmVal)).up()
      .ele(TrainActivationPlannedCalendarBuilder.plannedCalendar())
      .doc();
    return pathInformation.end({prettyPrint: true});
  }
}
