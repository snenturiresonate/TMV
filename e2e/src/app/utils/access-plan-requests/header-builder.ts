/* tslint:disable */

import {Header} from '../../../../../src/app/api/linx/models/header';

export class HeaderBuilder {
  bleedOffUpdateInd: string

  update() {
    this.bleedOffUpdateInd = 'U';
    return this;
  }

  new() {
    this.bleedOffUpdateInd = 'F';
    return this;
  }

  build() {
    return new Header(
      this.bleedOffUpdateInd
    );
  }
}
