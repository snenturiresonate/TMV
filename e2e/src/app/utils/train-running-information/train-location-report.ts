import {fragment} from 'xmlbuilder2';
import {DateAndTimeUtils} from '../../pages/common/utilities/DateAndTimeUtils';
import {TRILocation} from './location';
import {TRITrainDelay} from './train-delay';
import * as moment from 'moment';
import {DateTimeFormatter, LocalDate, LocalDateTime} from '@js-joda/core';

export class TRITrainLocationReport {
  public static locationDateTime = DateAndTimeUtils.getCurrentDateTime();
  private static delayedLocationDateTime(delayMins: number): string {
    const parsedDateTime = new Date(TRITrainLocationReport.locationDateTime);
    const delayedDateTime = moment(parsedDateTime).subtract(delayMins, 'minute').toDate();
    return moment(delayedDateTime).format();
  }
  public static trainLocationReportWithoutDelay = (locationPrimaryCode: string, locationSubsidiaryCode: string,
                                                   trainLocationStatus: string) => {
    const trainLocationReport = fragment().ele('TrainLocationReport')
      .ele(TRILocation.trainLocation(locationPrimaryCode, locationSubsidiaryCode))
      .ele('LocationDateTime').txt(TRITrainLocationReport.locationDateTime).up()
      .ele('TrainLocationStatus').txt(trainLocationStatus).up()
      .doc();
    return trainLocationReport.end({prettyPrint: true});
  }

  public static trainLocationReportAtTime = (locationPrimaryCode: string, locationSubsidiaryCode: string,
                                             trainLocationStatus: string, timestamp: string) => {
    const formattedTime = `${LocalDate.now().format(DateTimeFormatter.ofPattern('yyyy-MM-dd'))}T${timestamp}-00:00`;
    const trainLocationReport = fragment().ele('TrainLocationReport')
      .ele(TRILocation.trainLocation(locationPrimaryCode, locationSubsidiaryCode))
      .ele('LocationDateTime').txt(formattedTime).up()
      .ele('TrainLocationStatus').txt(trainLocationStatus).up()
      .doc();
    return trainLocationReport.end({prettyPrint: true});
  }

  public static trainLocationReportWithDelayAgainstBookedTime = (locationPrimaryCode: string, locationSubsidiaryCode: string,
                                                                 trainLocationStatus: string, delay: string) => {
    const totalDelayMins: number = (parseInt(delay.split(':')[0], 2) * 60) + parseInt(delay.split(':')[1], 2);
    const bookedLocationDateTime: string = TRITrainLocationReport.delayedLocationDateTime(totalDelayMins);
    const trainLocationReport = fragment().ele('TrainLocationReport')
      .ele(TRILocation.trainLocation(locationPrimaryCode, locationSubsidiaryCode))
      .ele('LocationDateTime').txt(TRITrainLocationReport.locationDateTime).up()
      .ele('TrainLocationStatus').txt(trainLocationStatus).up()
      .ele('BookedLocationDateTime').txt(bookedLocationDateTime).up()
      .ele(TRITrainDelay.trainDelayAgainstBooked(delay))
      .doc();
    return trainLocationReport.end({prettyPrint: true});
  }

  public static trainLocationReportWithTime = (locationPrimaryCode: string, locationSubsidiaryCode: string,
                                               trainLocationStatus: string, timeInfo: string) => {
    const trainLocationReport = fragment().ele('TrainLocationReport')
      .ele(TRILocation.trainLocation(locationPrimaryCode, locationSubsidiaryCode))
      .ele('LocationDateTime').txt(TRITrainLocationReport.locationDateTime).up()
      .ele('TrainLocationStatus').txt(trainLocationStatus).up()
      .ele('TrainDelay').txt(timeInfo).up()
      .doc();
    return trainLocationReport.end({prettyPrint: true});
  }
}
