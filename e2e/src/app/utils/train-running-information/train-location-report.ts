import {fragment} from 'xmlbuilder2';
import {DateAndTimeUtils} from '../../pages/common/utilities/DateAndTimeUtils';
import {TRILocation} from './location';
import {TRITrainDelay} from './train-delay';
import * as moment from 'moment';
import {DateTimeFormatter, LocalDate, LocalDateTime, LocalTime, OffsetDateTime, ZoneId} from '@js-joda/core';

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
    const lt = LocalTime.parse(timestamp);
    const formattedTime = OffsetDateTime.now(ZoneId.of('Europe/London'))
      .withHour(lt.hour())
      .withMinute(lt.minute())
      .withSecond(lt.second())
      .format(DateTimeFormatter.ISO_OFFSET_DATE_TIME);
    const trainLocationReport = fragment().ele('TrainLocationReport')
      .ele(TRILocation.trainLocation(locationPrimaryCode, locationSubsidiaryCode))
      .ele('LocationDateTime').txt(formattedTime).up()
      .ele('TrainLocationStatus').txt(trainLocationStatus).up()
      .doc();
    return trainLocationReport.end({prettyPrint: true});
  }

  public static trainLocationReportWithDelayAgainstBookedTime = (locationPrimaryCode: string, locationSubsidiaryCode: string,
                                                                 trainLocationStatus: string, delay: string) => {
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
    const trainLocationReport = fragment().ele('TrainLocationReport')
      .ele(TRILocation.trainLocation(locationPrimaryCode, locationSubsidiaryCode))
      .ele('LocationDateTime').txt(TRITrainLocationReport.locationDateTime).up()
      .ele('TrainLocationStatus').txt(trainLocationStatus).up()
      .ele('TrainDelay').txt(timeInfo).up()
      .doc();
    return trainLocationReport.end({prettyPrint: true});
  }
}
