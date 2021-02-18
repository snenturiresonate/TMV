/* tslint:disable */
export class TrainJourneyModification {
  trainJourneyModificationId?: string;
  modificationType?: string;
  modificationLocation?: string;
  activeServiceId?: string;
  modifiedTrainDescription?: string;
  linxTrainId?: string;
  trustTrainId?: string;
  modificationDatetime?: string;
  trainServiceCode?: string;
  modificationReason?: string;
  messageReceivedDatetime?: string;

  constructor(trainJourneyModificationId: string, modificationType: string, modificationLocation: string, activeServiceId: string, modifiedTrainDescription: string, linxTrainId: string, trustTrainId: string, modificationDateTime: string, trainServiceCode: string, modificationReason: string, messageReceivedDateTime: string) {
    this.trainJourneyModificationId = trainJourneyModificationId;
    this.modificationType = modificationType;
    this.modificationLocation = modificationLocation;
    this.activeServiceId = activeServiceId;
    this.modifiedTrainDescription = modifiedTrainDescription;
    this.linxTrainId = linxTrainId;
    this.trustTrainId = trustTrainId;
    this.modificationDatetime = modificationDateTime;
    this.trainServiceCode = trainServiceCode;
    this.modificationReason = modificationReason;
    this.messageReceivedDatetime = messageReceivedDateTime;
  }
}
