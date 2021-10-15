import * as moment from 'moment';
import {DateTimeFormatter, LocalDate, LocalDateTime, LocalTime, ZoneId} from '@js-joda/core';

export class DateAndTimeUtils {

  public static getCurrentDateTime(): any {
    return LocalDateTime.now().atZone(ZoneId.of('Europe/London'));
  }

  public static getCurrentDateTimeString(pattern): any {
    return DateAndTimeUtils.getCurrentDateTime().format(DateTimeFormatter.ofPattern(pattern));
  }

  public static getCurrentTime(): any {
    return LocalTime.now(ZoneId.of('Europe/London'));
  }

  public static getCurrentTimePlusOrMinusMins(plusMins = 0, minusMins = 0, format = 'HH:mm:ss'): string {
    return DateAndTimeUtils.getCurrentTime().plusMinutes(plusMins).minusMinutes(minusMins).format(DateTimeFormatter.ofPattern(format));
  }

  public static parseTimeEquation(equation = 'now + 2', format = 'HH:mm:ss'): string {
    const value = parseInt(equation.substr(5), 10);
    if (equation.includes('+')) {
      return DateAndTimeUtils.getCurrentTimePlusOrMinusMins(value, 0, format);
    }
    if (equation.includes('-')) {
      return DateAndTimeUtils.getCurrentTimePlusOrMinusMins(0, value, format);
    }
    if (equation.includes('now')) {
      return DateAndTimeUtils.getCurrentTimePlusOrMinusMins(0, 0, format);
    }
    return equation;
  }

  public static getCurrentTimeString(pattern = 'HH:mm:ss'): any {
    return DateAndTimeUtils.getCurrentTime().format(DateTimeFormatter.ofPattern(pattern));
  }

  public static dayOfWeek(): string {
    return DateAndTimeUtils.getCurrentDateTime().dayOfWeek().name();
  }

  /**
   * Returns a day from current day with no days incremented.
   * Input: plusDays, a number indicating days to increment
   */
  public static dayOfWeekPlusDays(plusDays): string {
    return LocalDate.now().plusDays(plusDays).dayOfWeek().name();
  }

  /**
   * Returns a parsed date from the string input in the format specified.
   * Input: date, a date string or one of 'today', 'yesterday' & 'tomorrow' and the date will be calculated
   * Input: dateFormat, string of format to return the date in eg dd/MM/yyyy, yyyy-MM-dd etc
   */
  public static convertToDesiredDateAndFormat(date: string, dateFormat: string): string {
    switch (date.toLowerCase()) {
      case 'today':
        return DateAndTimeUtils.getCurrentDateTime().format(DateTimeFormatter.ofPattern(dateFormat));
      case 'tomorrow':
        return DateAndTimeUtils.getCurrentDateTime().plusDays(1).format(DateTimeFormatter.ofPattern(dateFormat));
      case 'yesterday':
        return DateAndTimeUtils.getCurrentDateTime().minusDays(1).format(DateTimeFormatter.ofPattern(dateFormat));
      default:
        return LocalDate.parse(date, DateTimeFormatter.ofPattern(dateFormat)).format(DateTimeFormatter.ofPattern(dateFormat));
    }
  }
  /**
   * Returns a parsed date from the string input of date & time. Not to be used for assertions with tolerance
   * Input: DateTime of type string
   */
  public static async getParsedTimestamp(dateText: string): Promise<any> {
    return new Date(dateText);
  }
  /**
   * Returns the time hour (HH) from the string input of date & time
   * Input: DateTime of type string
   */
  public static async getHourFromTimeStamp(dateTime: string): Promise<any> {
    const inputDateTime = new Date(dateTime);
    return inputDateTime.getHours();
  }
  /**
   * Returns the time minutes (MM) from the string input of date & time
   * Input: DateTime of type string
   */
  public static async getMinsFromTimeStamp(dateTime: string): Promise<any> {
    const inputDateTime = new Date(dateTime);
    return inputDateTime.getMinutes();
  }
  /**
   * Returns the time seconds (SS) from the string input of date & time
   * Input: DateTime of type string
   */
  public static async getSecsFromTimeStamp(dateTime: string): Promise<any> {
    const inputDateTime = new Date(dateTime);
    return inputDateTime.getSeconds();
  }
  /**
   * Returns the entire time component (HH:MM:SS) from the string input of date & time
   * Input: DateTime of type string
   */
  public static async getTimeComponent(dateTime: string): Promise<string> {
    const inputDateTime = new Date(dateTime);
    const options = { timeZone: 'Europe/London', timeStyle: 'medium' };
    return inputDateTime.toLocaleTimeString('en-GB', options);
  }

  /**
   * Adds the increment minutes to the time and Returns the parsed date time from the string input of date & time.
   * Useful for adding minutes to time
   * Input: DateTime of type string, mins to increment of type number
   */
  public static async addMinsToDateTime(timeStamp: string, increment: number): Promise<any> {
    const parsedDateTime = new Date(timeStamp);
    return moment(parsedDateTime).add(increment, 'minute').toDate();
  }
  /**
   * Subtracts the decrement minutes to the time and Returns the parsed date time from the string input of date & time.
   * Useful for subtracting minutes from time
   * Input: DateTime of type string, mins to subtract of type number
   */
  public static async subtractMinsToDateTime(timeStamp: string, decrement: number): Promise<any> {
    const parsedDateTime = new Date(timeStamp);
    return moment(parsedDateTime).subtract(decrement, 'minute').toDate();
  }
  /**
   * Adds the increment hours to the time and Returns the parsed date time from the string input of date & time.
   * Useful for adding hours to time
   * Input: DateTime of type string, hours to increment of type number
   */
  public static async addHoursToDateTime(timeStamp: string, increment: number): Promise<any> {
    const parsedDateTime = new Date(timeStamp);
    return moment(parsedDateTime).add(increment, 'hours').toDate();
  }
  /**
   * Subtracts the decrement hours to the time and Returns the parsed date time from the string input of date & time.
   * Useful for subtracting hours from time
   * Input: DateTime of type string, hours to subtract of type number
   */
  public static async subtractHoursToDateTime(timeStamp: string, decrement: number): Promise<any> {
    const parsedDateTime = new Date(timeStamp);
    return moment(parsedDateTime).subtract(decrement, 'hours').toDate();
  }
  /**
   * Adds the increment seconds to the time and Returns the parsed date time from the string input of date & time.
   * Useful for adding hours to time
   * Input: DateTime of type string, seconds to increment of type number
   */
  public static async addSecondsToDateTime(timeStamp: string, increment: number): Promise<any> {
    const parsedDateTime = new Date(timeStamp);
    return moment(parsedDateTime).add(increment, 'seconds').toDate();
  }
  /**
   * Subtracts the decrement seconds to the time and Returns the parsed date time from the string input of date & time.
   * Useful for subtracting hours to time
   * Input: DateTime of type string, seconds to decrement of type number
   */
  public static async subtractSecondsToDateTime(timeStamp: string, decrement: number): Promise<any> {
    const parsedDateTime = new Date(timeStamp);
    return moment(parsedDateTime).subtract(decrement, 'seconds').toDate();
  }
  /**
   * Adds the increment days to the date and Returns the parsed date time from the string input of date & time.
   * Useful for adding days to date
   * Input: DateTime of type string, days to increment of type number
   */
  public static async addDaysToDateTime(timeStamp: string, increment: number): Promise<any> {
    const parsedDateTime = new Date(timeStamp);
    return moment(parsedDateTime).add(increment, 'days').toDate();
  }
  /**
   * Subtracts the decrement days to the date and Returns the parsed date time from the string input of date & time.
   * Useful for subtracting days from date
   * Input: DateTime of type string, days to decrement of type number
   */
  public static async subtractDaysToDateTime(timeStamp: string, decrement: number): Promise<any> {
    const parsedDateTime = new Date(timeStamp);
    return moment(parsedDateTime).subtract(decrement, 'days').toDate();
  }
  /**
   * Adds the increment weeks to the date and Returns the parsed date time from the string input of date & time.
   * Useful for adding weeks to date
   * Input: DateTime of type string, weeks to increment of type number
   */
  public static async addWeeksToDateTime(timeStamp: string, increment: number): Promise<any> {
    const parsedDateTime = new Date(timeStamp);
    return moment(parsedDateTime).add(increment, 'weeks').toDate();
  }
  /**
   * Subtracts the decrement weeks to the date and Returns the parsed date time from the string input of date & time.
   * Useful for subtracting weeks from date
   * Input: DateTime of type string, weeks to decrement of type number
   */
  public static async subtractWeeksToDateTime(timeStamp: string, decrement: number): Promise<any> {
    const parsedDateTime = new Date(timeStamp);
    return moment(parsedDateTime).subtract(decrement, 'weeks').toDate();
  }

  /**
   * adjustNowTime
   * @param operator: either '+' or '-'
   * @param minutesToAdjust: the number of minutes to add or subtract to the current time
   */
  public static async adjustNowTime(operator: string, minutesToAdjust: number): Promise<string> {
    let adjustedTime = DateAndTimeUtils.getCurrentTime();
    if (operator === '-') {
      adjustedTime = await DateAndTimeUtils.subtractMinsToDateTime(
        DateAndTimeUtils.getCurrentDateTimeString('MM-dd-yyyy HH:mm:ss xxx'), minutesToAdjust);
      adjustedTime = await DateAndTimeUtils.getTimeComponent(adjustedTime);
    }
    else if (operator === '+') {
      adjustedTime = await DateAndTimeUtils.addMinsToDateTime(
        DateAndTimeUtils.getCurrentDateTimeString('MM-dd-yyyy HH:mm:ss xxx'), minutesToAdjust);
      adjustedTime = await DateAndTimeUtils.getTimeComponent(adjustedTime);
    }
    return adjustedTime;
  }

  public static async formulateDateTime(timeStamp: string, format = 'dd/MM/yyy HH:mm:ss'): Promise<Date> {
    const dateTime = LocalDateTime.parse(timeStamp, DateTimeFormatter.ofPattern(format));
    const parsedDateTime = new Date(
      dateTime.year(), dateTime.monthValue(), dateTime.dayOfMonth(), dateTime.hour(), dateTime.minute(), dateTime.second());
    return moment(parsedDateTime).toDate();
  }

  public static async formulateTime(timeStamp: string, format = 'HH:mm:ss'): Promise<Date> {
    const now = LocalDateTime.now();
    const dateTime = LocalTime.parse(timeStamp, DateTimeFormatter.ofPattern(format));
    const parsedDateTime = new Date(
      now.year(), now.monthValue(), now.dayOfMonth(), dateTime.hour(), dateTime.minute(), dateTime.second());
    return moment(parsedDateTime).toDate();
  }

}
