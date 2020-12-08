import {ElementArrayFinder} from 'protractor';

export class MapLayerItem {
  public styleProperty: string;
  public layerItems: ElementArrayFinder;
  constructor(styleProperty: string, layerItems: ElementArrayFinder) {
    this.styleProperty = styleProperty;
    this.layerItems = layerItems;
  }
}
