import {fragment} from 'xmlbuilder2';
import {TRILocationSubsidiaryIdentificationBuilder} from './location-subsidiary-identification';
import {DateAndTimeUtils} from '../../pages/common/utilities/DateAndTimeUtils';
import {TRILocation} from './location';
import {TRITrainDelay} from './train-delay';

export class TRITrainLocationReport {
  private static locationDateTime = DateAndTimeUtils.getCurrentDateTime();
  private static delayedLocationDateTime(delay: number): string {
    const reducedDate = DateAndTimeUtils.subtractHoursToDateTime(TRITrainLocationReport.locationDateTime, delay);
    return reducedDate[Symbol.toStringTag];
  }
  public static trainLocationReportWithoutDelay = (locationPrimaryCode: string, locationSubsidiaryCode: string,
                                                   trainLocationStatus: string) => {
    const trainLocationReport = fragment().ele(TRILocation.trainLocation(locationPrimaryCode, locationSubsidiaryCode))
      .ele('LocationDateTime').txt(TRITrainLocationReport.locationDateTime).up()
      .ele('TrainLocationStatus').txt(trainLocationStatus).up()
      .ele(TRILocationSubsidiaryIdentificationBuilder.locationSubsidiaryIdentification(locationSubsidiaryCode))
      .doc();
    return trainLocationReport.end({prettyPrint: true});
  }

  public static trainLocationReportWithDelayAgainstBookedTime = (locationPrimaryCode: string, locationSubsidiaryCode: string,
                                                                 trainLocationStatus: string, delay: number, hoursOrMins: string) => {
    const bookedLocationDateTime: string = TRITrainLocationReport.delayedLocationDateTime(delay);
    const trainLocationReport = fragment().ele(TRILocation.trainLocation(locationPrimaryCode, locationSubsidiaryCode))
      .ele('LocationDateTime').txt(TRITrainLocationReport.locationDateTime()).up()
      .ele('TrainLocationStatus').txt(trainLocationStatus).up()
      .ele('BookedLocationDateTime').txt(bookedLocationDateTime).up()
      .ele(TRILocationSubsidiaryIdentificationBuilder.locationSubsidiaryIdentification(locationSubsidiaryCode))
      .ele(TRITrainDelay.trainDelayAgainstBooked(delay, hoursOrMins))
      .doc();
    return trainLocationReport.end({prettyPrint: true});
  }
}
