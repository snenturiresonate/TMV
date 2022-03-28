import {fragment} from 'xmlbuilder2';
import {DateAndTimeUtils} from '../../pages/common/utilities/DateAndTimeUtils';

export class TrainActivationValidityPeriodBuilder {

  public static validityPeriod = (startDateTime: any = DateAndTimeUtils.getCurrentDateTime()) => {
    const validityPeriod = fragment().ele('ns0:ValidityPeriod')
      .ele('ns0:StartDateTime').txt(startDateTime)
      .doc();
    return validityPeriod.end({prettyPrint: true});
  }
}
