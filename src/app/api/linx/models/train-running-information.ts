/* tslint:disable */
export class TrainRunningInformation {
  trustTrainId?: string;
  location?: string;
  actualLocationDatetime?: string;
  plannedLocationDatetime?: string;
  trainLocationStatus?: string;
  actualPunctuality?: string;
  linxTrainId?: string;
  trainRunningInformationId?: string;
  messageReceivedDatetime?: string;
  trainRunningInformationDatetime?: string;
  activeServiceId?: string;
  correction?: string;
  uicCompanyCode?: string;

  constructor(trustTrainId: string, location: string, actualLocationDatetime: string, plannedLocationDatetime: string, trainLocationStatus: string, actualPunctuality: string, linxTrainId: string, trainRunningInformationId: string, messageReceivedDatetime: string, trainRunningInformationDatetime: string, activeServiceId: string, correction: string, uicCompanyCode: string) {
    this.trustTrainId = trustTrainId;
    this.location = location;
    this.actualLocationDatetime = actualLocationDatetime;
    this.plannedLocationDatetime = plannedLocationDatetime;
    this.trainLocationStatus = trainLocationStatus;
    this.actualPunctuality = actualPunctuality;
    this.linxTrainId = linxTrainId;
    this.trainRunningInformationId = trainRunningInformationId;
    this.messageReceivedDatetime = messageReceivedDatetime;
    this.trainRunningInformationDatetime = trainRunningInformationDatetime;
    this.activeServiceId = activeServiceId;
    this.correction = correction;
    this.uicCompanyCode = uicCompanyCode;
  }
}
