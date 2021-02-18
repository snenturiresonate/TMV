/* tslint:disable */
import {Location} from '../../../../../src/app/api/linx/models/location';
import {ServiceCharacteristics} from '../../../../../src/app/api/linx/models/service-characteristics';
import {StockCharacteristics} from '../../../../../src/app/api/linx/models/stock-characteristics';
import {ChangesEnRoute} from '../../../../../src/app/api/linx/models/changes-en-route';

export class ChangesEnRouteBuilder {
  private location?: Location;
  private serviceCharacteristics?: ServiceCharacteristics;
  private stockCharacteristics?: StockCharacteristics;

  withLocation(location: Location) {
    this.location = location;
    return this;
  }

  withServiceCharacteristics(serviceCharacteristics: ServiceCharacteristics) {
    this.serviceCharacteristics = serviceCharacteristics;
    return this;
  }

  withStockCharacteristics(stockCharacteristics: StockCharacteristics) {
    this.stockCharacteristics = stockCharacteristics;
    return this;
  }

  build(): ChangesEnRoute {
    return new ChangesEnRoute(
      this.location,
      this.serviceCharacteristics,
      this.stockCharacteristics
    )
  }
}
