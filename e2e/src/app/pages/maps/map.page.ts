import {browser, by, element, ElementArrayFinder, ElementFinder, protractor} from 'protractor';
import {of} from 'rxjs';
import {CssColorConverterService} from '../../services/css-color-converter.service';
import * as fs from 'fs';
import {CucumberLog} from '../../logging/cucumber-log';
import {ProjectDirectoryUtil} from '../../utils/project-directory.util';
import assert = require('assert');
import path = require('path');

const SCALEFACTORX_START = 7;

export class MapPageObject {
  public platformLayer: ElementFinder;
  public berthElements: ElementFinder;
  public manualBerthLayer: ElementFinder;
  public platformLayerItems: ElementArrayFinder;
  public trackLayerItems: ElementArrayFinder;
  public signalLayerPoleItems: ElementArrayFinder;
  public signalLayerIndicatorItems: ElementArrayFinder;
  public mapArea: ElementFinder;
  public zoomableLayer: ElementFinder;
  public draggableLayer: ElementFinder;
  public currentlyDraggedLayer: ElementFinder;
  public mapContextMenuItems: ElementArrayFinder;
  public originallyOpenedMapTitle: string;
  public lastMapLinkSelectedCode: string;

  constructor() {
    this.platformLayer = element(by.id('platform-layer'));
    this.berthElements = element(by.id('berth-elements'));
    this.manualBerthLayer = element(by.id('manual-trust-berth-layer'));
    this.platformLayerItems = element.all(by.css('#platform-layer polygon'));
    this.trackLayerItems = element.all(by.css('#track-layer line'));
    this.signalLayerPoleItems = element.all(by.css('[id^=signal-element-post]'));
    this.signalLayerIndicatorItems = element.all(by.css('[id^=signal-element-lamp]'));
    this.mapArea = element(by.css('.map-parent'));
    this.zoomableLayer = element(by.css('.zoomable-map'));
    this.draggableLayer = element(by.css('.draggable-map'));
    this.currentlyDraggedLayer = element(by.css('.draggable-map.grabbing'));
    this.mapContextMenuItems = element.all(by.css('.dropdown-item'));
    this.originallyOpenedMapTitle = '';
    this.lastMapLinkSelectedCode = '';
  }

  navigateTo(mapId: string): Promise<unknown> {
    return browser.get(browser.baseUrl + '/tmv/maps/' + mapId) as Promise<unknown>;
  }

  public async isPlatformLayerPresent(): Promise<boolean> {
    return browser.isElementPresent(this.platformLayer);
  }

  public async isBerthLayerVisible(): Promise<boolean> {
    const visibleStyle: string = await this.berthElements.getAttribute('visibility');
    return of(visibleStyle === 'visible').toPromise();
  }

  public async isManualTrustBerthPresent(): Promise<boolean> {
    return browser.isElementPresent(this.manualBerthLayer);
  }

  public async isMidDrag(): Promise<boolean> {
    return browser.isElementPresent(this.currentlyDraggedLayer);
  }

  public async getDraggableAreaTop(): Promise<number> {
    const topPX =  await this.draggableLayer.getCssValue('top');
    return parseFloat(topPX);
  }

  public async getDraggableAreaLeft(): Promise<number> {
    const leftPX =  await this.draggableLayer.getCssValue('left');
    return parseFloat(leftPX);
  }

  public async getCursor(): Promise<string> {
    return this.draggableLayer.getCssValue('cursor');
  }

  public async getCurrentScaleFactor(): Promise<number> {
    const transform = await this.zoomableLayer.getCssValue('transform');
    const scaleFactorX = transform.substr(SCALEFACTORX_START, transform.indexOf(',') - SCALEFACTORX_START);
    return parseFloat(scaleFactorX);
  }

  public async getBerthText(berthId: string, trainDescriber: string): Promise<string> {
    const berth: ElementFinder = await this.getBerthElementFinder(berthId, trainDescriber);
    return berth.getText();
  }

  public async isBerthPresent(berthId: string, trainDescriber: string): Promise<boolean> {
    const berth: ElementFinder = await this.getBerthElementFinder(berthId, trainDescriber);
    return berth.isPresent();
  }

  public async getSignalLampRoundColour(signalId: string): Promise<string> {
    const signalLampRound: ElementFinder = element(by.css('[id^=shunt-element-lamp-round-' + signalId  + ']'));
    const lampRoundColourRgb: string = await signalLampRound.getCssValue('fill');
    return CssColorConverterService.rgb2Hex(lampRoundColourRgb);
  }

  public async getStaticSignalColour(signalId: string): Promise<string> {
    const staticSignalLampRound: ElementFinder = element(by.css('[id^=shunt-element-lamp-round-' + signalId  + ']'));
    const lampRoundColourRgb: string = await staticSignalLampRound.getCssValue('fill');
    return CssColorConverterService.rgb2Hex(lampRoundColourRgb);
  }

  public async getMarkerBoardTriangleColour(markerBoardId: string): Promise<string> {
    const markerBoardTriangle: ElementFinder = element(by.css('[id^=marker-boards-element-triangle-' + markerBoardId  + ']'));
    const triangleColourRgb: string = await markerBoardTriangle.getCssValue('fill');
    return CssColorConverterService.rgb2Hex(triangleColourRgb);
  }

  public async getMarkerBoardBackgroundColour(markerBoardId: string): Promise<string> {
    const markerBrdRect: ElementFinder = element(by.css('[id^=marker-boards-element-rect-' + markerBoardId  + ']'));
    const rectColourRgb: string = await markerBrdRect.getCssValue('fill');
    return CssColorConverterService.rgb2Hex(rectColourRgb);
  }

  public async getShuntMarkerBoardTriangleColour(markerBoardId: string): Promise<string> {
    const markerBrdTriangle: ElementFinder = element(by.css('[id^=shunt-marker-boards-element-triangle-' + markerBoardId  + ']'));
    const triangleColourRgb: string = await markerBrdTriangle.getCssValue('fill');
    return CssColorConverterService.rgb2Hex(triangleColourRgb);
  }

  public async getShuntMarkerBoardSmallTriangleColour(markerBoardId: string): Promise<string> {
    const markerBrdSmallTri: ElementFinder = element(by.css('[id^=shunt-marker-boards-element-small-triangle-' + markerBoardId  + ']'));
    const smallTriangleColourRgb: string = await markerBrdSmallTri.getCssValue('fill');
    return CssColorConverterService.rgb2Hex(smallTriangleColourRgb);
  }

  public async berthTextIsVisible(berthId: string, trainDescriber: string): Promise<boolean> {
    const berth: ElementFinder = await this.getBerthElementFinder(berthId, trainDescriber);
    return berth.isDisplayed();
  }

  public async getBerthElementFinder(berthId: string, trainDescriber: string): Promise<ElementFinder> {
    // id for berths can be either berth-element-text-bth.[train_id] or berth-element-text-btl.[train_id]
    // using $= to get element based on just train_id
    const berth: ElementFinder = element(by.css('text[id$=' + trainDescriber + berthId + ']'));
    return berth;
  }

  public async navigateToMapWithBerth(berthId: string, trainDescriber: string): Promise<void> {
    const rawData: Buffer = fs.readFileSync(path.join(ProjectDirectoryUtil.testDataFolderPath(), 'maps/maps-western.json'));
    const mapBerthData = JSON.parse(rawData.toString());
    const filtered = mapBerthData.filter((mapObj) => mapObj.berths.includes(trainDescriber + berthId));
    assert(filtered.length > 0, 'no map found containing berth ' + berthId + ' in train describer ' + trainDescriber + ' found');
    await CucumberLog.addText(browser.baseUrl + '/tmv/maps/' + filtered[0].map);
    await this.navigateTo(filtered[0].map);
  }

  public async waitForContextMenu(): Promise<boolean> {
    browser.wait(async () => {
      return this.mapContextMenuItems.isPresent();
    }, browser.displayTimeout, 'The context menu should be displayed');
    return this.mapContextMenuItems.isPresent();
  }


  public async getMapContextMenuItem(rowIndex: number): Promise<string> {
    return this.mapContextMenuItems.get(rowIndex - 1).getText();
  }

  public async getMapContextMenuElementByRow(rowIndex: number): Promise<ElementFinder> {
    return this.mapContextMenuItems.get(rowIndex - 1);
  }

  public async rightClickManualTrustBerth(manualTrustBerthId: string): Promise<void> {
    const berthLink: ElementFinder = element(by.id('manual-trust-berth-element-text-' + manualTrustBerthId));
    await browser.actions().click(berthLink, protractor.Button.RIGHT).perform();
  }

  public async rightClickBerth(berthId: string): Promise<void> {
    const berthLink: ElementFinder = element(by.id('berth-element-text-' + berthId));
    await browser.actions().click(berthLink, protractor.Button.RIGHT).perform();
  }

  public async getBerthContextInfoText(): Promise<string> {
    return element(by.id('berthContextMenu')).getText();
  }

  public async getManualTrustBerthContextInfoText(): Promise<string> {
    return element(by.id('manualTrustberthContextMenu')).getText();
  }

}
