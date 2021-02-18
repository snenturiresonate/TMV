import * as moment from 'moment';
import {DateTimeFormatter, LocalDate} from '@js-joda/core';

export class DateAndTimeUtils {

  public static dayOfWeek(): string {
    return LocalDate.now().dayOfWeek().name();
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
   * Input: dateFormat, string of format to return the date in eg dd/MM/YYYY, yyyy-MM-dd etc
   */
  public static convertToDesiredDateAndFormat(date: string, dateFormat: string): string {
    switch (date.toLowerCase()) {
      case 'today':
        return LocalDate.now().format(DateTimeFormatter.ofPattern(dateFormat));
      case 'tomorrow':
        return LocalDate.now().plusDays(1).format(DateTimeFormatter.ofPattern(dateFormat));
      case 'yesterday':
        return LocalDate.now().minusDays(1).format(DateTimeFormatter.ofPattern(dateFormat));
      default:
        return LocalDate.parse(date).format(DateTimeFormatter.ofPattern(dateFormat));
    }
  }
  /**
   * Returns a parsed date from the string input of date & time. Not to be used for assertions with tolerance
   * Input: DateTime of type string
   */
  public static async getParsedTimestamp(dateText: string): Promise<any> {
    const parsedDate = new Date(dateText);
    return parsedDate;
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
    return inputDateTime.toLocaleTimeString();
  }
  /**
   * Returns the parsed date time from the string input of date & time. Useful for assertions with tolerance
   * Input: DateTime of type string
   */
  public static async formulateDateTime(timeStamp: string): Promise<any> {
    const parsedDateTime = new Date(timeStamp);
    return moment(parsedDateTime).toDate();
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
}
