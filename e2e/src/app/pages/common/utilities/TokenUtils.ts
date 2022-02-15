import {DateAndTimeUtils} from './DateAndTimeUtils';
import {DateTimeFormatter} from '@js-joda/core';

export class TokenUtils {

  private static readonly TODAY_TOKEN = new RegExp('<TODAY:yyyyMMdd>', 'g');
  private static readonly TODAY_KEBAB_TOKEN = new RegExp('<TODAY:yyyy-MM-dd>', 'g');

  public static process(text: string): any {
    return text
      .replace(this.TODAY_TOKEN, DateAndTimeUtils.getCurrentDateTime().format(DateTimeFormatter.ofPattern('yyyyMMdd')))
      .replace(this.TODAY_KEBAB_TOKEN, DateAndTimeUtils.getCurrentDateTime().format(DateTimeFormatter.ofPattern('yyyy-MM-dd')));
  }

}
