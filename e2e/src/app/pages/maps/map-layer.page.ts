import {browser, by, element, ElementFinder} from 'protractor';
import {MapLayerItem} from './map-layer-item.model';
import {MapLayerType} from './map-layer-type.enum';

export class MapLayerPageObject {
  public platformLayer: ElementFinder;
  public berthLayer: ElementFinder;
  public manualBerthLayer: ElementFinder;
  public platformColor: ElementFinder;

  public mapLayerItems: Map<MapLayerType, MapLayerItem[]> = new Map();

  constructor() {
    this.platformColor = element(by.css('polygon[id*=platform-element-polygon]'));
    this.platformLayer = element(by.id('platform-layer'));
    this.berthLayer = element(by.id('berth-layer'));
    this.manualBerthLayer = element(by.id('manual-trust-berth-layer'));

    this.setStaticLinesideFeaturesMapLayerItems();
    this.setStaticObjectDetailsMapLayerItems();
    this.setActiveMapLayerItems();
    this.setTextLayerItems();
    this.setOtherMapLayerItems();
  }

  private setActiveMapLayerItems(): void {
    this.mapLayerItems.set(MapLayerType.active_track_section,
      [new MapLayerItem('stroke', element.all(by.css('#track-layer path:not(#track-element-path-track)')))]);
    this.mapLayerItems.set(MapLayerType.active_main_signal,
      [new MapLayerItem('fill', element.all(by.css('[id^=signal-element-lamp]')))]);
    this.mapLayerItems.set(MapLayerType.active_shunt_signal,
      [new MapLayerItem('fill', element.all(by.css('[id^=shunt-element-lamp]')))]);
    this.mapLayerItems.set(MapLayerType.active_markerboard,
      [new MapLayerItem('fill', element.all(by.css('[id^=marker-boards-element-triangle]')))]);
    this.mapLayerItems.set(MapLayerType.active_shunt_markerboard,
      [new MapLayerItem('fill', element.all(by.css('[id^=shunt-marker-boards-element-small-triangle]')))]);
    this.mapLayerItems.set(MapLayerType.active_shunters_release,
      [new MapLayerItem('stroke', element.all(by.css('#shunters-release-layer polygon')))]);
    this.mapLayerItems.set(MapLayerType.berth,
      [new MapLayerItem('fill', element.all(by.css('[id^=berth-element-rect-bth]')))]);
    this.mapLayerItems.set(MapLayerType.last_berth,
      [new MapLayerItem('fill', element.all(by.css('[id^=berth-element-rect-btl]')))]);
    this.mapLayerItems.set(MapLayerType.manual_trust_berth,
      [new MapLayerItem('stroke', element.all(by.css('#manual-trust-berth-layer circle')))]);
  }


  private setStaticObjectDetailsMapLayerItems(): void {
    this.mapLayerItems.set(MapLayerType.flight_path,
      [new MapLayerItem('stroke', element.all(by.css('#flight-paths-layer line')))]);
    this.mapLayerItems.set(MapLayerType.train_washer_indicator,
      [new MapLayerItem('fill', element.all(by.css('#train-wash-indicator-layer polygon')))]);
    this.mapLayerItems.set(MapLayerType.AES_boundaries_line_group,
      [new MapLayerItem('stroke', element.all(by.css('[id^=aes-boundaries-element-line-0]')))]);
    this.mapLayerItems.set(MapLayerType.alarm_box,
      [new MapLayerItem('stroke', element.all(by.css('#aes-alarm-boxes-layer polygon')))]);
    this.mapLayerItems.set(MapLayerType.tunnel_bridge_viaduct,
      [new MapLayerItem('stroke', element.all(by.css('#tunnels-layer path')))]);
    this.mapLayerItems.set(MapLayerType.tripcock,
      [new MapLayerItem('fill', element.all(by.css('#tripcocks-layer polygon')))]);
    this.mapLayerItems.set(MapLayerType.cut_bar,
      [new MapLayerItem('fill', element.all(by.css('#cut-bars-layer polygon')))]);
    this.mapLayerItems.set(MapLayerType.level_crossing,
      [new MapLayerItem('stroke', element.all(by.css('#level-crossings-layer line')))]);
  }

  private setOtherMapLayerItems(): void {
    this.mapLayerItems.set(MapLayerType.dashed_track_section,
      [new MapLayerItem('stroke', element.all(by.css('#track-element-path-track')))]);
    this.mapLayerItems.set(MapLayerType.continuation_button,
      [new MapLayerItem('fill', element.all(by.css('#continuation-links-layer rect')))]);
  }

  private setStaticLinesideFeaturesMapLayerItems(): void {
    this.mapLayerItems.set(MapLayerType.platform,
      [new MapLayerItem('fill', element.all(by.css('#platform-layer polygon')))]);
    this.mapLayerItems.set(MapLayerType.direction_arrows,
      [new MapLayerItem('fill', element.all(by.css('#direction-arrows-layer polygon')))]);
    this.mapLayerItems.set(MapLayerType.HABDS,
      [new MapLayerItem('fill', element.all(by.css('#habds-layer polygon')))]);
    this.mapLayerItems.set(MapLayerType.OHL_limits,
      [new MapLayerItem('stroke', element.all(by.css('#ohl-limits-layer path')))]);
    this.mapLayerItems.set(MapLayerType.signal_box,
      [new MapLayerItem('stroke', element.all(by.css('#signal-boxes-layer rect')))]);
    this.mapLayerItems.set(MapLayerType.end_of_line_indication,
      [new MapLayerItem('fill', element.all(by.css('#end-of-line-indications-layer polygon')))]);
    this.mapLayerItems.set(MapLayerType.OHNS,
      [new MapLayerItem('fill', element.all(by.css('#ohns-indications-layer polygon')))]);
    this.mapLayerItems.set(MapLayerType.WILD_indicator,
      [new MapLayerItem('stroke', element.all(by.css('#wild-indications-layer circle')))]);
    this.setStaticSignalLinesideFeaturesMapLayerItems();
  }

  private setStaticSignalLinesideFeaturesMapLayerItems(): void {
    this.mapLayerItems.set(MapLayerType.static_signal,
      [new MapLayerItem('fill', element.all(by.css('#static-signals-layer circle')))]);
    this.mapLayerItems.set(MapLayerType.static_shunt_signal,
      [new MapLayerItem('fill', element.all(by.css('#static-shunt-signals-layer path')))]);
    this.mapLayerItems.set(MapLayerType.static_markerboard,
      [new MapLayerItem('fill', element.all(by.css('[id^=static-marker-boards-element-triangle]')))]);
    this.mapLayerItems.set(MapLayerType.limit_of_shunt_static_signal,
      [new MapLayerItem('fill', element.all(by.css('#limit-of-shunt-static-signals-layer polygon')))]);
  }

  private setTextLayerItems(): void {
    this.mapLayerItems.set(MapLayerType.aes_boundaries_text_label,
      [new MapLayerItem('fill', element.all(by.cssContainingText('#text-layer-text-elements tspan', 'AES')))]);
    this.mapLayerItems.set(MapLayerType.direction_lock_text_label,
      [new MapLayerItem('fill', element.all(by.cssContainingText('#text-layer-text-elements tspan', 'Dir Lock')))]);
    this.mapLayerItems.set(MapLayerType.connector_text_label,
      [new MapLayerItem('fill', element.all(by.css('#continuation-links-layer text')))]);
    this.mapLayerItems.set(MapLayerType.other_text_label,
      [new MapLayerItem('fill', element.all(by.css('#text-layer-text-elements tspan')))]);
  }

  public async isPlatformLayerPresent(): Promise<boolean> {
    return browser.isElementPresent(this.platformLayer);
  }

  public async getPlatformColor(): Promise<string> {
    return this.platformColor.getCssValue('fill');
  }

  public async isBerthLayerVisible(): Promise<boolean> {
    return browser.isElementPresent(this.berthLayer);
  }

  public async isManualTrustBerthPresent(): Promise<boolean> {
    return browser.isElementPresent(this.manualBerthLayer);
  }

  public getStaticLinesideFeatureLayerSvgElements(layer: MapLayerType): MapLayerItem[] {
    return this.mapLayerItems.get(layer);
  }
}
