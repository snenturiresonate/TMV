/* tslint:disable */

import {Days} from "./days";
import {AssociationIdentifier} from "./association-identifier";

export class Association {
  assocLocationSuffix?: number;
  associationCategory?: string;
  associationDateInd?: string;
  associationDays?: Days;
  associationEndDate?: string;
  associationIdentifier?: AssociationIdentifier;
  associationLocation?: string;
  associationType?: string;
  baseLocationSuffix?: number;
  diagramType?: string;
  transactionType?: string;

  constructor(assocLocationSuffix: number, associationCategory: string, associationDateInd: string, associationDays: Days, associationEndDate: string, associationIdentifier: AssociationIdentifier, associationLocation: string, associationType: string, baseLocationSuffix: number, diagramType: string, transactionType: string) {
    this.assocLocationSuffix = assocLocationSuffix;
    this.associationCategory = associationCategory;
    this.associationDateInd = associationDateInd;
    this.associationDays = associationDays;
    this.associationEndDate = associationEndDate;
    this.associationIdentifier = associationIdentifier;
    this.associationLocation = associationLocation;
    this.associationType = associationType;
    this.baseLocationSuffix = baseLocationSuffix;
    this.diagramType = diagramType;
    this.transactionType = transactionType;
  }
}
