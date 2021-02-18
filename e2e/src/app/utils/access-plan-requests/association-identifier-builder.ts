/* tslint:disable */
import {AssociationIdentifier} from '../../../../../src/app/api/linx/models/association-identifier';

export class AssociationIdentifierBuilder {
  private associatedTrainUid?: string;
  private associationStartDate?: string;
  private mainTrainUid?: string;
  private stpIndicator?: string;

  withAssociatedTrainUid(associatedTrainUid: string) {
    this.associatedTrainUid = associatedTrainUid;
    return this;
  }

  withAssociationStartDate(associationStartDate: string) {
    this.associationStartDate = associationStartDate;
    return this;
  }

  withMainTrainUid(mainTrainUid: string) {
    this.mainTrainUid = mainTrainUid;
    return this;
  }

  withStpIndicator(stpIndicator: string) {
    this.stpIndicator = stpIndicator;
    return this;
  }

  build(): AssociationIdentifier {
    return new AssociationIdentifier(
      this.associatedTrainUid,
      this.associationStartDate,
      this.mainTrainUid,
      this.stpIndicator
    );
  }
}
