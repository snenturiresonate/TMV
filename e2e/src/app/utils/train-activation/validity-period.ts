import {fragment} from 'xmlbuilder2';
import {LocalDateTime} from '@js-joda/core';

export class TrainActivationValidityPeriodBuilder {
  public static runDateTime = LocalDateTime.now();

  public static validityPeriod = (startDateTime: any = TrainActivationValidityPeriodBuilder.runDateTime) => {
    const validityPeriod = fragment().ele('ns0:ValidityPeriod')
      .ele('ns0:StartDateTime').txt(startDateTime)
      .doc();
    return validityPeriod.end({prettyPrint: true});
  }
}
