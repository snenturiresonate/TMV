import {browser, by, element, ElementArrayFinder, ElementFinder, ExpectedConditions, protractor} from 'protractor';
import {of} from 'rxjs';
import {CssColorConverterService} from '../../services/css-color-converter.service';
import * as fs from 'fs';
import {CucumberLog} from '../../logging/cucumber-log';
import {ProjectDirectoryUtil} from '../../utils/project-directory.util';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';
import {AppPage} from '../app.po';
import assert = require('assert');
import path = require('path');
import {BerthInterpose} from '../../../../../src/app/api/linx/models/berth-interpose';
import {LinxRestClient} from '../../api/linx/linx-rest-client';

let linxRestClient: LinxRestClient;

const SCALEFACTORX_START = 7;
const appPage: AppPage = new AppPage();
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
  public mapNameDropdown: ElementFinder;
  public mapSearch: ElementFinder;
  public liveMap: ElementFinder;
  public sClassBerthTextElements: ElementFinder;
  public aesBoundaryElements: ElementFinder;
  public headcodeOnMap: ElementArrayFinder;

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
    this.mapNameDropdown = element(by.css('.map-dropdown-button:nth-child(1)'));
    this.mapSearch = element(by.id('map-search-box'));
    this.liveMap = element(by.css('#live-map'));
    this.sClassBerthTextElements = element(by.css('#s-class-berth-text-elements'));
    this.aesBoundaryElements = element(by.css('#aes-boundaries-elements'));

    this.headcodeOnMap = element.all(by.css('text[data-train-description]:not([data-train-description=""])'));
    linxRestClient = new LinxRestClient();
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

  public async getHeadcodesOnMap(): Promise<string[]> {
    return this.headcodeOnMap.map((el: ElementFinder) => {
      return el.getText();
    });
  }

  public async waitUntilBerthTextIs(berthId: string, trainDescriber: string, expectedString: string): Promise<void> {
    const berth: ElementFinder = await this.getBerthElementFinder(berthId, trainDescriber);
    await browser.wait(ExpectedConditions.textToBePresentInElement(berth, expectedString),
      15000,
      `Berth text was not ${expectedString} in Berth ${trainDescriber}${berthId}`);
  }

  public async isBerthPresent(berthId: string, trainDescriber: string): Promise<boolean> {
    const berth: ElementFinder = await this.getBerthElementFinder(berthId, trainDescriber);
    return berth.isPresent();
  }

  public async isSClassBerthElementPresent(berthId: string): Promise<boolean> {
    const sClassBerth: ElementFinder = await this.getSClassBerthElementFinder(berthId);
    return sClassBerth.isPresent();
  }

  public async waitUntilSClassBerthElementIsPresent(berthId: string): Promise<void> {
    const sClassBerth: ElementFinder = await this.getSClassBerthElementFinder(berthId);
    await CommonActions.waitForElementToBePresent(sClassBerth,
      10000,
      `S class berth ${berthId} not present in time limit`);
  }

  public async isReleaseIndicationPresent(releaseId: string): Promise<boolean> {
    const release: ElementFinder = await this.getSClassBerthElementFinder(releaseId);
    return release.isPresent();
  }

  public async getSignalLampRoundColour(signalId: string): Promise<string> {
    const signalLampRound: ElementFinder = element(by.css('[id^=signal-element-lamp-round-' + signalId  + ']'));
    const lampRoundColourRgb: string = await signalLampRound.getCssValue('fill');
    return CssColorConverterService.rgb2Hex(lampRoundColourRgb);
  }

  public async getShuntSignalColour(signalId: string): Promise<string> {
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

  public async getSClassBerthElementTextColour(elementId: string): Promise<string> {
    const textElement: ElementFinder = await this.getSClassBerthElementFinder(elementId);
    const textElementRgb: string = await textElement.getCssValue('fill');
    return CssColorConverterService.rgb2Hex(textElementRgb);
  }

  public async getSClassBerthElementText(elementId: string): Promise<string> {
    await this.waitUntilSClassBerthElementIsPresent(elementId);
    const textElement: ElementFinder = await this.getSClassBerthElementFinder(elementId);
    return textElement.getText();
  }

  public async getReleaseElementColour(releaseId: string): Promise<string> {
    const release: ElementFinder = element(by.css('[id=shunters-release-rect-element-' + releaseId + ']'));
    const elementRgb: string = await release.getCssValue('stroke');
    return CssColorConverterService.rgb2Hex(elementRgb);
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
    const berth: ElementFinder = element(by.css('text[id$=' + trainDescriber + berthId + ']:not(text[id^=s-class])'));
    return berth;
  }

  public async getSClassBerthElementFinder(berthId: string): Promise<ElementFinder> {
    return element(by.css('[id=s-class-berth-element-text-' + berthId + ']'));
  }

  public async releaseElementIsVisible(releaseId: string): Promise<ElementFinder> {
    const release: ElementFinder = element(by.css('[id=shunters-release-rect-element-' + releaseId + ']'));
    return release.isDisplayed();
  }

  public async navigateToMapWithBerth(berthId: string, trainDescriber: string): Promise<void> {
    const rawData: Buffer = fs.readFileSync(path.join(ProjectDirectoryUtil.testDataFolderPath(), 'maps/maps-western.json'));
    const mapBerthData = JSON.parse(rawData.toString());
    const filtered = mapBerthData.filter((mapObj) => mapObj.berths.includes(trainDescriber + berthId));
    assert(filtered.length > 0, 'no map found containing berth ' + berthId + ' in train describer ' + trainDescriber + ' found');
    await CucumberLog.addText(browser.baseUrl + '/tmv/maps/' + filtered[0].map);
    const url = '/tmv/maps/' + filtered[0].map;
    await appPage.navigateTo(url);
  }

  public async waitForContextMenu(): Promise<boolean> {
    await browser.wait(async () => {
      return this.mapContextMenuItems.isPresent();
    }, browser.displayTimeout, 'The context menu should be displayed');
    return this.mapContextMenuItems.isPresent();
  }

  public async openContextMenuForTrainDescription(trainDescription: string): Promise<void> {
    const berth: ElementFinder = element(by.xpath('//*[@data-train-description=\"' + trainDescription + '\"]'));
    await CommonActions.waitForElementInteraction(berth);
    await browser.actions().click(berth, protractor.Button.RIGHT).perform();
    await this.waitForContextMenu();
  }

  public async closeContextMenuForTrainDescription(trainDescription: string): Promise<void> {
    const berth: ElementFinder = element(by.xpath('//*[@data-train-description=\"' + trainDescription + '\"]'));
    await CommonActions.waitForElementInteraction(berth);
    await berth.click();
  }

  public async getMapContextMenuItem(rowIndex: number): Promise<string> {
    return this.mapContextMenuItems.get(rowIndex - 1).getText();
  }

  public async waitForMatchIndication(trainDescription: string, indication: string,
                                      berth: string, describer: string, row: number): Promise<boolean> {
    return browser.wait(async () => {
      try {
        await this.openContextMenuForTrainDescription(trainDescription);
        await this.waitForContextMenu();
        const contextMenuItem = await this.getMapContextMenuItem(row);
        if (contextMenuItem.includes(indication)) {
          return true;
        }
        await this.closeContextMenuForTrainDescription(trainDescription);
        await linxRestClient.postBerthInterpose(
          new BerthInterpose(
            new Date().toTimeString().substr(0, 8),
            berth,
            describer,
            trainDescription
          )
        );
      }
      catch (exception) {
        if (exception.toString().includes('StaleElementReferenceError'))
        {
          // the train has been removed which constitutes a change in state
          return true;
        }
      }
      return false;
    },
    browser.displayTimeout, 'The train description did not disappear');
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

  public async trainHighlight(): Promise<void> {
    const highlightLink: ElementFinder = element(by.id(''));
    return highlightLink.click();
  }

  public async getTrainHighlightText(): Promise<string> {
    return element(by.id('')).getText();
  }

  public async getBerthContextInfoText(): Promise<string> {
    return element(by.id('berthContextMenu')).getText();
  }

  public async getManualTrustBerthContextInfoText(): Promise<string> {
    return element(by.id('manualTrustberthContextMenu')).getText();
  }

  public async clickMapName(): Promise<void> {
    return this.mapNameDropdown.click();
  }
  public async enterMapSearchString(searchMap: string): Promise<void> {
    this.mapSearch.clear();
    return this.mapSearch.sendKeys(searchMap);
  }
  public async launchMap(): Promise<any> {
    browser.actions().mouseMove(element(by.css('li[id*=map-link]'))).perform();
    await element(by.css('li[id*=map-link] .new-tab-button')).click();
  }

  public async getTrtsStatus(signalId: string): Promise<string> {
    const signalLatchElement: ElementFinder = element(by.css('[id^=signal-latch-cross-element-line-1-' + signalId  + ']'));
    const latchColourRgb: string = await signalLatchElement.getCssValue('stroke');
    return CssColorConverterService.rgb2Hex(latchColourRgb);
  }

  public async getVisibilityStatus(signalId: string): Promise<string> {
    const signalVisibility: ElementFinder = element(by.css('[id=signal-latch-cross-element-' + signalId  + ']'));
    return signalVisibility.getCssValue('visibility');
  }

  public async getTrackWidth(trackId: string): Promise<string> {
    const track: ElementFinder = element(by.name('track-element-path-' + trackId));
    return track.getCssValue('stroke-width');
  }

  public async getTrackColour(trackId: string): Promise<string> {
    const track: ElementFinder = element(by.name('track-element-path-' + trackId));
    const trackColourRgb: string = await track.getCssValue('stroke');
    return CssColorConverterService.rgb2Hex(trackColourRgb);
  }

  public async getLvlCrossingBarrierState(lvlCrossingId: string): Promise<string> {
    await CommonActions.waitForElementToBeVisible(this.liveMap);
    return this.sClassBerthTextElements.element(by.css('[id^=s-class-berth-element-text-' + lvlCrossingId  + ']')).getText();
  }
  public async isDirectionChevronDisplayed(): Promise<boolean> {
    await CommonActions.waitForElementToBeVisible(this.liveMap);
    return element(by.css(`text[class='DIRECTION_LOCK']`)).isPresent();
  }
  public async aesElementsAreDisplayed(): Promise<boolean> {
    const elm = this.aesBoundaryElements.element(by.css('[id^=aes-boundaries-element]'));
    await CommonActions.waitForElementToBeVisible(this.liveMap);
    return elm.isPresent();
  }
  public async getBerthName(): Promise<string> {
    return element(by.id('berth-context-menu-berth-name')).getText();
  }

  public async getBerthColor(berthId: string): Promise<string> {
    const berthLink: ElementFinder = element(by.id('berth-element-rect-' + berthId));
    const berthColourRgb: string = await berthLink.getCssValue('fill');
    return CssColorConverterService.rgb2Hex(berthColourRgb);
  }

  public async getBerthType(berthId: string): Promise<string> {
    const berth: ElementFinder = element(by.id('berth-element-text-' + berthId));
    const berthType: string = await berth.getCssValue('class');
    return berthType;
  }

  public async getManualBerthType(berthId: string): Promise<string> {
    const manualBerth: ElementFinder = element(by.id('manual-berth-element-text-' + berthId));
    const manualBerthType: string = await manualBerth.getText();
    return manualBerthType;
  }
  public async getBerthRectangleColour(berthId: string): Promise<string> {
    const berthRectangleElement: ElementFinder = element(by.id('berth-element-rect-' + berthId));
    const berthRectangleColourRgb: string = await berthRectangleElement.getCssValue('fill');
    return CssColorConverterService.rgb2Hex(berthRectangleColourRgb);
  }

  public async getBerthContextMenuSignalName(signalId: string): Promise<string> {
    return element(by.id('berth-context-menu-signal-' + signalId)).getText();
  }
  public async getHeadcode(berthId: string): Promise<string> {
    const berthLink: ElementFinder = element(by.id('berth-element-text-' + berthId));
    return berthLink.getCssValue('data-train-description');
  }
}
