/* tslint:disable */

export class VstpUpdates {

  /**
   * Returns a vstp XML with update input data.
   * Input: replaceString (Ex: <schedule_start_date>), replaceStringValue (Ex: 2020-01-11) & vstpXML
   */
  updateVSTPXML(replaceString: string, replaceStringValue: string, vstpXML: string){
    vstpXML = vstpXML.replace(replaceString, replaceStringValue);
    return vstpXML;
  }

  /**
   * Returns a vstp XML with update input data.
   * Input: RegExp (Ex: /CIF_stp_indicator=".*"/g), replaceStringValue (Ex: 2020-01-11) & vstpXML
   */
  updateVSTPXMLRegEx(replaceString: RegExp, replaceStringValue: string, vstpXML: string){
    vstpXML = vstpXML.replace(replaceString, replaceStringValue);
    return vstpXML;
  }

  /**
   * Returns a SchduleDaysToRun
   * Input: day (Ex: tuesday)
   */
  runOneDay(day : String){
    let daysToRun = "0000000";

    switch (day.toLowerCase()) {
      case 'monday':
        daysToRun = "1000000";
        break;
      case 'tuesday':
        daysToRun = "0100000";
        break;
      case 'wednesday':
        daysToRun = "0010000";
        break;
      case 'thursday':
        daysToRun = "0001000";
        break;
      case 'friday':
        daysToRun = "0000100";
        break;
      case 'saturday':
        daysToRun = "0000010";
        break;
      case 'sunday':
        daysToRun = "0000001";
        break;
    }
    return daysToRun;
  }
}
