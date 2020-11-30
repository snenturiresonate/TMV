/* tslint:disable */

import {Location} from './location';
import {ServiceCharacteristics} from './service-characteristics';
import {StockCharacteristics} from './stock-characteristics';

export class ChangesEnRoute {
  location?: Location;
  serviceCharacteristics?: ServiceCharacteristics;
  stockCharacteristics?: StockCharacteristics;

  constructor(location: Location, serviceCharacteristics: ServiceCharacteristics, stockCharacteristics: StockCharacteristics) {
    this.location = location;
    this.serviceCharacteristics = serviceCharacteristics;
    this.stockCharacteristics = stockCharacteristics;
  }
}
