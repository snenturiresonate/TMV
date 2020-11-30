/* tslint:disable */
import {Days} from '../../../../../src/app/api/linx/models/days';
import {AssociationIdentifier} from '../../../../../src/app/api/linx/models/association-identifier';
import {Association} from '../../../../../src/app/api/linx/models/association';

export class AssociationBuilder {
  private assocLocationSuffix?: number;
  private associationCategory?: string;
  private associationDateInd?: string;
  private associationDays?: Days;
  private associationEndDate?: string;
  private associationIdentifier?: AssociationIdentifier;
  private associationLocation?: string;
  private associationType?: string;
  private baseLocationSuffix?: number;
  private diagramType?: string;
  private transactionType?: string;

  withAssocLocationSuffix(assocLocationSuffix: number) {
    this.assocLocationSuffix = assocLocationSuffix;
    return this;
  }

  withAssociationCategory(associationCategory: string) {
    this.associationCategory = associationCategory;
    return this;
  }

  withAssociationDateInd(associationDateInd: string) {
    this.associationDateInd = associationDateInd;
    return this;
  }

  withAssociationDays(associationDays: Days) {
    this.associationDays = associationDays;
    return this;
  }

  withAssociationEndDate(associationEndDate: string) {
    this.associationEndDate = associationEndDate;
    return this;
  }

  withAssociationIdentifier(associationIdentifier: AssociationIdentifier) {
    this.associationIdentifier = associationIdentifier;
    return this;
  }

  withAssociationLocation(associationLocation: string) {
    this.associationLocation = associationLocation;
    return this;
  }

  withAssociationType(associationType: string) {
    this.associationType = associationType;
    return this;
  }

  withBaseLocationSuffix(baseLocationSuffix: number) {
    this.baseLocationSuffix = baseLocationSuffix;
    return this;
  }

  withDiagramType(diagramType: string) {
    this.diagramType = diagramType;
    return this;
  }

  withTransactionType(transactionType: string) {
    this.transactionType = transactionType;
    return this;
  }

  build(): Association {
    return new Association(
      this.assocLocationSuffix,
      this.associationCategory,
      this.associationDateInd,
      this.associationDays,
      this.associationEndDate,
      this.associationIdentifier,
      this.associationLocation,
      this.associationType,
      this.baseLocationSuffix,
      this.diagramType,
      this.transactionType
    );
  }
}
