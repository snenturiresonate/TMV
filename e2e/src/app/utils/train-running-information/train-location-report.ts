import {fragment} from 'xmlbuilder2';
import {DateAndTimeUtils} from '../../pages/common/utilities/DateAndTimeUtils';
import {TRILocation} from './location';
import {TRITrainDelay} from './train-delay';
import {ChronoUnit, DateTimeFormatter, LocalTime, OffsetDateTime} from '@js-joda/core';

export class TRITrainLocationReport {
  public static locationDateTime;

  private static delayedLocationDateTime(delayMins: number): string {
    TRITrainLocationReport.locationDateTime =
      DateAndTimeUtils.getCurrentDateTime().withSecond(0).format(DateTimeFormatter.ISO_OFFSET_DATE_TIME);
    return OffsetDateTime
      .parse(TRITrainLocationReport.locationDateTime)
      .minusMinutes(delayMins)
      .format(DateTimeFormatter.ISO_OFFSET_DATE_TIME);
  }

  public static trainLocationReportWithoutDelay = (locationPrimaryCode: string, locationSubsidiaryCode: string,
                                                   trainLocationStatus: string) => {
    TRITrainLocationReport.locationDateTime =
      DateAndTimeUtils.getCurrentDateTime().withSecond(0).format(DateTimeFormatter.ISO_OFFSET_DATE_TIME);
    const trainLocationReport = fragment().ele('TrainLocationReport')
      .ele(TRILocation.trainLocation(locationPrimaryCode, locationSubsidiaryCode))
      .ele('LocationDateTime').txt(TRITrainLocationReport.locationDateTime).up()
      .ele('TrainLocationStatus').txt(trainLocationStatus).up()
      .doc();
    return trainLocationReport.end({prettyPrint: true});
  }

  public static trainLocationReportAtTime = (locationPrimaryCode: string, locationSubsidiaryCode: string,
                                             trainLocationStatus: string, timestamp: string) => {
    const lt = LocalTime.parse(timestamp);
    const formattedTime = DateAndTimeUtils.getCurrentDateTime()
      .withHour(lt.hour())
      .withMinute(lt.minute())
      .withSecond(0)
      .withNano(0)
      .format(DateTimeFormatter.ISO_OFFSET_DATE_TIME);

    const trainLocationReport = fragment().ele('TrainLocationReport')
      .ele(TRILocation.trainLocation(locationPrimaryCode, locationSubsidiaryCode))
      .ele('LocationDateTime').txt(formattedTime).up()
      .ele('TrainLocationStatus').txt(trainLocationStatus).up()
      .doc();
    return trainLocationReport.end({prettyPrint: true});
  }

  public static trainLocationReportAtTimeAgainstBooked = (locationPrimaryCode: string,
                                                          locationSubsidiaryCode: string,
                                                          trainLocationStatus: string,
                                                          bookedTimestamp: string,
                                                          eventTimestamp: string) => {
    const eventLocalTime = LocalTime.parse(eventTimestamp);
    const eventTime = DateAndTimeUtils.getCurrentDateTime()
      .withHour(eventLocalTime.hour())
      .withMinute(eventLocalTime.minute())
      .withSecond(0)
      .withNano(0);

    const bookedLocalTime = LocalTime.parse(bookedTimestamp);
    const bookedTime = DateAndTimeUtils.getCurrentDateTime()
      .withHour(bookedLocalTime.hour())
      .withMinute(bookedLocalTime.minute())
      .withSecond(bookedLocalTime.second())
      .withNano(0);

    const delayMinutes = ChronoUnit.MINUTES.between(bookedTime, eventTime);
    const isLate = delayMinutes > 0;
    const formattedDelay: string = isLate ? `+${Math.abs(delayMinutes).toString().padStart(4, '0')}` : `-${Math.abs(delayMinutes).toString().padStart(4, '0')}`;

    const trainLocationReport = fragment().ele('TrainLocationReport')
      .ele(TRILocation.trainLocation(locationPrimaryCode, locationSubsidiaryCode))
      .ele('LocationDateTime').txt(eventTime.format(DateTimeFormatter.ISO_OFFSET_DATE_TIME)).up()
      .ele('TrainLocationStatus').txt(trainLocationStatus).up()
      .ele('BookedLocationDateTime').txt(bookedTime.format(DateTimeFormatter.ISO_OFFSET_DATE_TIME)).up()
      .ele(fragment().ele('TrainDelay').ele('AgainstBooked').txt(formattedDelay).doc().end())
      .doc();
    return trainLocationReport.end({prettyPrint: true});
  }

  public static trainLocationReportWithDelayAgainstBookedTime = (locationPrimaryCode: string, locationSubsidiaryCode: string,
                                                                 trainLocationStatus: string, delay: string) => {
    TRITrainLocationReport.locationDateTime =
      DateAndTimeUtils.getCurrentDateTime().withSecond(0).format(DateTimeFormatter.ISO_OFFSET_DATE_TIME);
    let isEarly = false;
    let absTimeDiff = delay;
    if (delay.substr(0, 1) === '-') {
      absTimeDiff = delay.substr(1, 5);
      isEarly = true;
    }
    let timeDiffMins: number = (parseInt(absTimeDiff.split(':')[0], 10) * 60) + parseInt(absTimeDiff.split(':')[1], 10);
    if (isEarly) {
      timeDiffMins = -1 * timeDiffMins;
    }
    const bookedLocationDateTime: string = TRITrainLocationReport.delayedLocationDateTime(timeDiffMins);
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
    TRITrainLocationReport.locationDateTime =
      DateAndTimeUtils.getCurrentDateTime().withSecond(0).format(DateTimeFormatter.ISO_OFFSET_DATE_TIME);
    const trainLocationReport = fragment().ele('TrainLocationReport')
      .ele(TRILocation.trainLocation(locationPrimaryCode, locationSubsidiaryCode))
      .ele('LocationDateTime').txt(TRITrainLocationReport.locationDateTime).up()
      .ele('TrainLocationStatus').txt(trainLocationStatus).up()
      .ele('TrainDelay').txt(timeInfo).up()
      .doc();
    return trainLocationReport.end({prettyPrint: true});
  }
}
