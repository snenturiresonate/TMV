/* tslint:disable */
export class AssociationIdentifier {
  associatedTrainUid?: string;
  associationStartDate?: string;
  mainTrainUid?: string;
  stpIndicator?: string;

  constructor(associatedTrainUid: string, associationStartDate: string, mainTrainUid: string, stpIndicator: string) {
    this.associatedTrainUid = associatedTrainUid;
    this.associationStartDate = associationStartDate;
    this.mainTrainUid = mainTrainUid;
    this.stpIndicator = stpIndicator;
  }
}
