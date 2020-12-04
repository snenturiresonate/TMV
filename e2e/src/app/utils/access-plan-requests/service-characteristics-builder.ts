/* tslint:disable */
import {ServiceCharacteristics} from '../../../../../src/app/api/linx/models/service-characteristics';

export class ServiceCharacteristicsBuilder {
  private connectionIndicator?: string;
  private courseIndicator?: string;
  private headcode?: string;
  private tractionClass?: string;
  private trainCategory?: string;
  private trainIdentity?: string;
  private trainServiceCode?: string;
  private uicCode?: string;

  constructor() {

    this.withTrainCategory('H4');
    this.withTrainIdentity('0A00');
    this.withCourseIndicator('1');
    this.withTrainServiceCode('57610310');
  }

  withConnectionIndicator(connectionIndicator: string) {
    this.connectionIndicator = connectionIndicator;
    return this;
  }

  withCourseIndicator(courseIndicator: string) {
    this.courseIndicator = courseIndicator;
    return this;
  }

  withHeadcode(headcode: string) {
    this.headcode = headcode;
    return this;
  }

  withTractionClass(tractionClass: string) {
    this.tractionClass = tractionClass;
    return this;
  }

  withTrainCategory(trainCategory: string) {
    this.trainCategory = trainCategory;
    return this;
  }

  withTrainIdentity(trainIdentity: string) {
    this.trainIdentity = trainIdentity;
    return this;
  }

  withTrainServiceCode(trainServiceCode: string) {
    this.trainServiceCode = trainServiceCode;
    return this;
  }

  withUicCode(uicCode: string) {
    this.uicCode = uicCode;
    return this;
  }

  build(): ServiceCharacteristics {
    return new ServiceCharacteristics(
      this.connectionIndicator,
      this.courseIndicator,
      this.headcode,
      this.tractionClass,
      this.trainCategory,
      this.trainIdentity,
      this.trainServiceCode,
      this.uicCode,
    );
  }
}
