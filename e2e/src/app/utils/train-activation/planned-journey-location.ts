import {fragment} from 'xmlbuilder2';
import {TrainActivationLocationSubsidiaryIdentificationBuilder} from './location-subsidiary-identification';
import {TrainActivationTimingAtLocationBuilder} from './timing-at-location';
import {TrainActivationTrainActivityBuilder} from './train-activity';
import {TrainActivationNetworkSpecificParameter} from './network-specific-parameter';

export class TrainActivationPlannedJourneyLocationBuilder {

  public static plannedJourneyLocation = (locationPrimaryCode: string, locationSubsidiaryCode: string,
                                          time: string, operationalTrainNumber: string, trainUID: string, asmVal: string) => {
    const plannedJourneyLocation = fragment().ele('ns0:PlannedJourneyLocation').att('JourneyLocationTypeCode', '01')
      .ele(TrainActivationLocationSubsidiaryIdentificationBuilder.locationSubsidiaryIdentification(locationSubsidiaryCode))
      .ele(TrainActivationTimingAtLocationBuilder.timingAtLocation(time))
      .ele(TrainActivationTrainActivityBuilder.trainActivity())
      .ele(TrainActivationNetworkSpecificParameter.networkSpecificParameter('UID', trainUID))
      .ele(TrainActivationNetworkSpecificParameter.networkSpecificParameter('SER', operationalTrainNumber))
      .ele(TrainActivationNetworkSpecificParameter.networkSpecificParameter('ASM', asmVal))
      .ele('ns0:CountryCodeISO').txt('GB').up()
      .ele('ns0:LocationPrimaryCode').txt(locationPrimaryCode).up()
      .ele('ns0:ResponsibleRU').txt('9984').up()
      .ele('ns0:ResponsibleIM').txt('0070').up()
      .ele('ns0:OperationalTrainNumber').txt(operationalTrainNumber).up()
      .doc();
    return plannedJourneyLocation.end({prettyPrint: true});
  }
}
