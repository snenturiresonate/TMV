/* tslint:disable */
export class ServiceCharacteristics {
  connectionIndicator?: string;
  courseIndicator?: string;
  headcode?: string;
  tractionClass?: string;
  trainCategory?: string;
  trainIdentity?: string;
  trainServiceCode?: string;
  uicCode?: string;

  constructor(connectionIndicator: string, courseIndicator: string, headcode: string, tractionClass: string, trainCategory: string, trainIdentity: string, trainServiceCode: string, uicCode: string) {
    this.connectionIndicator = connectionIndicator;
    this.courseIndicator = courseIndicator;
    this.headcode = headcode;
    this.tractionClass = tractionClass;
    this.trainCategory = trainCategory;
    this.trainIdentity = trainIdentity;
    this.trainServiceCode = trainServiceCode;
    this.uicCode = uicCode;
  }
}
