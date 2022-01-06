import {browser, by, element, ElementArrayFinder, ElementFinder, ExpectedConditions, protractor} from 'protractor';
import {of} from 'rxjs';
import {CssColorConverterService} from '../../services/css-color-converter.service';
import {CucumberLog} from '../../logging/cucumber-log';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';
import {AppPage} from '../app.po';
import {LinxRestClient} from '../../api/linx/linx-rest-client';
import {RedisClient} from '../../api/redis/redis-client';
import {DateAndTimeUtils} from '../common/utilities/DateAndTimeUtils';

let linxRestClient: LinxRestClient;

const SCALEFACTORX_START = 7;
const appPage: AppPage = new AppPage();
export class MapPageObject {
  private static liveMap = element(by.css('#live-map'));
  private static sClassBerthTextElements = element(by.css('#s-class-berth-text-elements'));

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
  public contextMenuPunctualityText: ElementFinder;
  public originallyOpenedMapTitle: string;
  public lastMapLinkSelectedCode: string;
  public mapNameDropdown: ElementFinder;
  public replayMapSearch: ElementFinder;
  public mapSearch: ElementFinder;
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
    this.contextMenuPunctualityText = element(by.id('schedule-context-menu-punctuality'));
    this.originallyOpenedMapTitle = '';
    this.lastMapLinkSelectedCode = '';
    this.mapNameDropdown = element(by.css('.map-dropdown-button:nth-child(1)'));
    this.replayMapSearch = element(by.css('.map-search input'));
    this.mapSearch = element(by.id('map-search-box'));
    this.aesBoundaryElements = element(by.css('#aes-boundaries-elements'));

    this.headcodeOnMap = element.all(by.css('text[data-train-description]:not([data-train-description=""])'));
    linxRestClient = new LinxRestClient();
  }

  public static async waitForTracksToBeDisplayed(): Promise<void> {
    const tracks = element.all(by.css('[name^=track-element]'));
    await CommonActions.waitForElementToBePresent(tracks.first());
    await browser.wait(
      tracks.first().isDisplayed(),
      30000,
      'Tracks were not displayed'
    );
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
      browser.params.general_timeout,
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
      browser.params.replay_timeout,
      `S class berth ${berthId} not present in time limit`);
  }

  public async isReleaseIndicationPresent(releaseId: string): Promise<boolean> {
    const release: ElementFinder = await this.getSClassBerthElementFinder(releaseId);
    return release.isPresent();
  }

  public async getSignalLampRoundColour(signalId: string): Promise<string> {
    const signalLampRound: ElementFinder = element.all(by.css('[id^=signal-element-lamp-round-' + signalId  + ']')).first();
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
    await CommonActions.waitForElementToBeVisible(textElement);
    const textElementRgb: string = await textElement.getCssValue('fill');
    return CssColorConverterService.rgb2Hex(textElementRgb);
  }

  public async getSClassBerthElementText(elementId: string): Promise<string> {
    await this.waitUntilSClassBerthElementIsPresent(elementId);
    const textElement: ElementFinder = await this.getSClassBerthElementFinder(elementId);
    await CommonActions.waitForElementToBeVisible(textElement);
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
    return element(by.css('text[id$=' + trainDescriber + berthId + ']:not(text[id^=s-class])'));
  }

  public async getSClassBerthElementFinder(berthId: string): Promise<ElementFinder> {
    return element(by.css('[id=s-class-berth-element-text-' + berthId + ']'));
  }

  public async releaseElementIsVisible(releaseId: string): Promise<ElementFinder> {
    const release: ElementFinder = element(by.css('[id=shunters-release-rect-element-' + releaseId + ']'));
    return release.isDisplayed();
  }

  public async navigateToMapWithBerth(berthId: string, trainDescriber: string): Promise<void> {
    const maps = await new RedisClient().hgetParseJSON('berth-to-maps-hash', trainDescriber + berthId);
    const map = maps.maps[0].id;
    const url = '/tmv/maps/' + map;
    await CucumberLog.addText(url);
    await appPage.navigateTo(url);
  }

  public async waitForContextMenu(): Promise<boolean> {
    await browser.wait(async () => {
      return this.mapContextMenuItems.isPresent();
    }, browser.params.general_timeout, 'The context menu should be displayed');
    return this.mapContextMenuItems.isPresent();
  }

  public async clickScheduleForTrainDescription(trainDescription: string, type: string): Promise<void> {
    if (trainDescription.includes('generated')) {
      trainDescription = browser.referenceTrainDescription;
    }
    const berth: ElementFinder = element(by.xpath('//*[@data-train-description=\"' + trainDescription + '\"]'));
    await CommonActions.waitForElementInteraction(berth);
    await browser.actions().click(berth, type).perform();
    if (type === protractor.Button.RIGHT) {
      await this.waitForContextMenu();
    }
  }

  public async openContextMenuForTrainDescriptionInBerth(trainDescription: string, trainDescriber: string, berth: string): Promise<void> {
    const berthLocator: ElementFinder =
      element(by.xpath(`//*[@data-train-description='${trainDescription}'][@data-berth-name='${berth}']`));
    await CommonActions.waitForElementInteraction(berthLocator);
    await browser.actions().click(berthLocator, protractor.Button.RIGHT).perform();
    await this.waitForContextMenu();
  }

  public async closeContextMenuForTrainDescription(trainDescription: string): Promise<void> {
    const berth: ElementFinder = element(by.xpath('//*[@data-train-description=\"' + trainDescription + '\"]'));
    await CommonActions.waitForElementInteraction(berth);
    await berth.click();
  }

  public async closeContextMenuForTrainDescriptionInBerth(trainDescription: string, trainDescriber: string, berth: string): Promise<void> {
    const berthLocator: ElementFinder =
      element(by.xpath(`//*[@data-train-description='${trainDescription}'][@data-berth-name='${berth}']`));
    await CommonActions.waitForElementInteraction(berthLocator);
    await berthLocator.click();
  }

  public async getMapContextMenuItem(rowIndex: number): Promise<string> {
    return this.mapContextMenuItems.get(rowIndex - 1).getText();
  }

  public async waitForMatchIndication(trainDescription: string, indication: string,
                                      berth: string, describer: string, row: number): Promise<boolean> {
    return browser.wait(async () => {
      try {
        await this.openContextMenuForTrainDescriptionInBerth(trainDescription, describer, berth);
        await this.waitForContextMenu();
        const contextMenuItem = await this.getMapContextMenuItem(row);
        if (contextMenuItem.toLowerCase().includes(indication.toLowerCase())) {
          return true;
        }
        const now = DateAndTimeUtils.getCurrentTimeString();
        await linxRestClient.postInterpose(now, berth, describer, trainDescription);
        await this.closeContextMenuForTrainDescriptionInBerth(trainDescription, describer, berth);
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
      browser.params.general_timeout, `${indication} not found in context menu`);
  }

  public async getMapContextMenuElementByRow(rowIndex: number): Promise<ElementFinder> {
    return this.mapContextMenuItems.get(rowIndex - 1);
  }

  public async clickUnmatchRematchMatchOption(): Promise<void> {
    const berthLink: ElementFinder = element(by.id('match-unmatch-selection-item'));
    await browser.actions().click(berthLink, protractor.Button.LEFT).perform();
  }

  public async rightClickManualTrustBerth(manualTrustBerthId: string): Promise<void> {
    const berthLink: ElementFinder = element(by.id('manual-trust-berth-element-text-' + manualTrustBerthId));
    await browser.actions().click(berthLink, protractor.Button.RIGHT).perform();
  }

  public async rightClickBerth(berthId: string): Promise<void> {
    const berthLink: ElementFinder = element(by.id('berth-element-text-' + berthId));
    await browser.actions().click(berthLink, protractor.Button.RIGHT).perform();
  }

  public async clickSignal(signalId: string, signalType: string, clickType: string): Promise<void> {
    let signalLink: ElementFinder = element(by.id('signal-element-' + signalId));
    if (signalType === 'main') {
      signalLink = element(by.id('signal-element-lamp-round-' + signalId));
    }
    if (signalType === 'shunt') {
      signalLink = element(by.id('shunt-element-lamp-round-' + signalId));
    }
    if (signalType === 'shunt_markerboard') {
      signalLink = element(by.id('shunt-marker-boards-element-triangle-' + signalId));
    }
    if (signalType === 'markerboard') {
      signalLink = element(by.id('marker-boards-element-rect-' + signalId));
    }
    let mouseButton = protractor.Button.LEFT;
    if (clickType === 'secondary') {
      mouseButton = protractor.Button.RIGHT;
    }
    await browser.actions().click(signalLink, mouseButton).perform();
  }

  public async trainHighlight(highlightOption: string): Promise<void> {
    let highlightLink: ElementFinder;
    if (highlightOption === 'Highlight') {
      highlightLink = element(by.id('schedule-context-menu-highlight-train-on'));
    }
    else {
      highlightLink = element(by.id('schedule-context-menu-highlight-train-off'));
    }
    return highlightLink.click();
  }

  public async clearBerth(): Promise<void> {
    const clearBerthOption: ElementFinder = element(by.id('schedule-context-menu-clear-left-behind'));
    return clearBerthOption.click();
  }

  public async getTrainHighlightText(): Promise<string> {
    const unhighligtedElement: ElementFinder = element(by.id('schedule-context-menu-highlight-train-on'));
    const highlightedElement: ElementFinder = element(by.id('schedule-context-menu-highlight-train-off'));
    if (await unhighligtedElement.isPresent()) {
      return unhighligtedElement.getText();
    }
    else {
      return highlightedElement.getText();
    }
  }

  public async getBerthContextInfoText(): Promise<string> {
    return element(by.id('berthContextMenu')).getText();
  }

  public async getSignalContextInfoText(): Promise<string> {
    return element(by.id('signalContextMenu')).getText();
  }

  public async getManualTrustBerthContextInfoText(): Promise<string> {
    return element(by.id('manualTrustberthContextMenu')).getText();
  }

  public async clickMapName(): Promise<void> {
    return this.mapNameDropdown.click();
  }
  public async enterReplayMapSearchString(searchMap: string): Promise<void> {
    this.replayMapSearch.clear();
    return this.replayMapSearch.sendKeys(searchMap);
  }
  public async launchReplayMap(): Promise<any> {
    browser.actions().mouseMove(element(by.css('li[id*=map-link]'))).perform();
    await element(by.css('li[id*=map-link] .new-tab-button')).click();
  }
  public async enterMapSearchString(searchMap: string): Promise<void> {
    await this.mapSearch.clear();
    await this.mapSearch.sendKeys(searchMap);
    return this.mapSearch.sendKeys(protractor.Key.ENTER);
  }
  public async launchMap(): Promise<any> {
    await element(by.css('#searchResultsTable tbody tr')).click();
  }

  public async getTrtsStatus(signalId: string): Promise<string> {
    const signalLatchElement: ElementFinder = element.all(by.css('[id^=signal-latch-cross-element-line-1-' + signalId  + ']')).first();
    const latchColourRgb: string = await signalLatchElement.getCssValue('stroke');
    return CssColorConverterService.rgb2Hex(latchColourRgb);
  }

  public async getVisibilityStatus(signalId: string): Promise<string> {
    const signalVisibility: ElementFinder = element(by.css('[id=signal-latch-cross-element-' + signalId  + ']'));
    return signalVisibility.getCssValue('visibility');
  }

  public async getTrackWidth(trackId: string): Promise<string> {
    const track: ElementFinder = element.all(by.name('track-element-path-' + trackId)).first();
    return track.getCssValue('stroke-width');
  }

  public async getTrackColour(trackId: string): Promise<string> {
    const track: ElementFinder = element.all(by.name('track-element-path-' + trackId)).first();
    const trackColourRgb: string = await track.getCssValue('stroke');
    return CssColorConverterService.rgb2Hex(trackColourRgb);
  }

  public async getLvlCrossingBarrierState(lvlCrossingId: string): Promise<string> {
    const levelCrossingLabel: ElementFinder =
      MapPageObject.sClassBerthTextElements.element(by.css('[id^=s-class-berth-element-text-' + lvlCrossingId  + ']'));
    await CommonActions.waitForElementToBeVisible(MapPageObject.liveMap);
    await CommonActions.waitForElementToBeVisible(levelCrossingLabel);
    return levelCrossingLabel.getText();
  }

  public async isDirectionChevronDisplayed(): Promise<boolean> {
    await CommonActions.waitForElementToBeVisible(MapPageObject.liveMap);
    return element(by.css(`text[class='DIRECTION_LOCK']`)).isPresent();
  }
  public async aesElementsAreDisplayed(): Promise<boolean> {
    const elm = this.aesBoundaryElements.element(by.css('[id^=aes-boundaries-element]'));
    await CommonActions.waitForElementToBeVisible(MapPageObject.liveMap);
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

  public async isBerthHighlighted(berthId: string): Promise<boolean> {
    const berth: ElementFinder = element(by.id('berth-element-rect-' + berthId));
    const berthClass: string = await berth.getAttribute('class');
    if (berthClass === null) {
      return Promise.resolve(false);
    }
    await CucumberLog.addText(`Berth class: ${berthClass}`);
    return Promise.resolve(berthClass.indexOf('berth_highlighted') >= 0);
  }

  public async isBerthTempHighlighted(berthId: string): Promise<boolean> {
    const berth: ElementFinder = element(by.id('berth-element-rect-' + berthId));
    await CommonActions.waitForElementToBeVisible(berth);
    const berthClass: string = await berth.getAttribute('class');
    if (berthClass === null) {
      return Promise.resolve(false);
    }
    await CucumberLog.addText(`Berth class: ${berthClass}`);
    return Promise.resolve(berthClass.indexOf('berth_highlight_temp') >= 0);
  }

  public async getBerthType(berthId: string): Promise<string> {
    const berth: ElementFinder = element(by.id('berth-element-text-' + berthId));
    return berth.getCssValue('class');
  }

  public async getManualBerthType(berthId: string): Promise<string> {
    const manualBerth: ElementFinder = element(by.id('manual-berth-element-text-' + berthId));
    return manualBerth.getText();
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
    return berthLink.getText();
  }

  public async getHeadcodesAtManualTrustBerth(berthID: string): Promise<Array<string>> {
    const elements = element.all(by.xpath(`//*[@id='manual-trust-berth-list-container-element-${berthID}']//*[starts-with(@id, 'manual-trust-berth-entry-element-text')]`));
    return elements.map(el => el.getText());
  }

  public async getContextMenuPunctuality(): Promise<string> {
    return this.contextMenuPunctualityText.getText();
  }
}
