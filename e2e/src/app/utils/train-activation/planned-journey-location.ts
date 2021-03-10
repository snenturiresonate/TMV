import {fragment} from 'xmlbuilder2';
import {TrainActivationLocationSubsidiaryIdentificationBuilder} from './location-subsidiary-identification';
import {TrainActivationTimingAtLocationBuilder} from './timing-at-location';
import {TrainActivationTrainActivityBuilder} from './train-activity';
import {TrainActivationNetworkSpecificParameter} from './network-specific-parameter';

export class TrainActivationPlannedJourneyLocationBuilder {

  public static plannedJourneyLocation = (locationPrimaryCode: string, locationSubsidiaryCode: string,
                                          time: string, operationalTrainNumber: string, trainUID: string) => {
    const plannedJourneyLocation = fragment().ele('PlannedJourneyLocation').att('JourneyLocationTypeCode', '01')
      .ele(TrainActivationLocationSubsidiaryIdentificationBuilder.locationSubsidiaryIdentification(locationSubsidiaryCode))
      .ele(TrainActivationTimingAtLocationBuilder.timingAtLocation(time))
      .ele(TrainActivationTrainActivityBuilder.trainActivity())
      .ele(TrainActivationNetworkSpecificParameter.networkSpecificParameter('UID', trainUID))
      .ele('CountryCodeISO').txt('GB').up()
      .ele('LocationPrimaryCode').txt(locationPrimaryCode).up()
      .ele('ResponsibleRU').txt('9984').up()
      .ele('ResponsibleIM').txt('0070').up()
      .ele('OperationalTrainNumber').txt(operationalTrainNumber).up()
      .doc();
    console.log('plannedJourneyLocation: ' + plannedJourneyLocation.end({prettyPrint: true}));
    return plannedJourneyLocation.end({prettyPrint: true});
  }
}
