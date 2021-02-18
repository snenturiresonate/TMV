/* tslint:disable */
export class TrainActivation {
  linxTrainId?: string;
  activationDatetime?: string;
  trainServiceCode?: string;
  uicCompanyCode?: string;
  scheduleOriginLocation?: string;
  trainActivationId?: string;
  trustTrainId?: string;
  messageReceivedDateTime?: string;

  constructor(linxTrainId: string, activationDatetime: string, trainServiceCode: string, uicCompanyCode: string, scheduleOriginLocation: string, trainActivationId: string, trustTrainId: string, messageReceivedDateTime: string) {
    this.linxTrainId = linxTrainId;
    this.activationDatetime = activationDatetime;
    this.trainServiceCode = trainServiceCode;
    this.uicCompanyCode = uicCompanyCode;
    this.scheduleOriginLocation = scheduleOriginLocation;
    this.trainActivationId = trainActivationId;
    this.trustTrainId = trustTrainId;
    this.messageReceivedDateTime = messageReceivedDateTime;
  }
}
