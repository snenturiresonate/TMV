import {Before, Given, Then, When} from 'cucumber';
import {expect} from 'chai';
import {MapPageObject} from '../../pages/maps/map.page';
import {CssColorConverterService} from '../../services/css-color-converter.service';
import {browser, ElementFinder, protractor} from 'protractor';
import {SignallingUpdate} from '../../../../../src/app/api/linx/models/signalling-update';
import {LinxRestClient} from '../../api/linx/linx-rest-client';
import {MapLayerPageObject} from '../../pages/maps/map-layer.page';
import {MapLayerType} from '../../pages/maps/map-layer-type.enum';
import {MapLayerItem} from '../../pages/maps/map-layer-item.model';
import {HomePageObject} from '../../pages/home.page';

let page: MapPageObject;
let linxRestClient: LinxRestClient;

Before(() => {
  page = new MapPageObject();
  linxRestClient = new LinxRestClient();
});

const homePage: HomePageObject = new HomePageObject();
const mapPageObject: MapPageObject = new MapPageObject();
const mapLayerPageObject: MapLayerPageObject = new MapLayerPageObject();

const mapColourHex = {
  red: '#ff0000',
  green: '#00ff00',
  white: '#ffffff',
  orange: '#ffa700',
  grey: '#969696'
};

const mapObjectColourHex = {
  platform: '#ffa700',
  WILD_indicator: '#ffffff',
  OHL_limits: '#ffffff',
  HABDS: '#ffffff',
  signal_box: '#ffffff',
  direction_arrows: '#ffffff',
  end_of_line_indication: '#ffffff',
  OHNS: '#ffffff',
  tripcock: '#ffffff',
  flight_path: '#ffffff',
  train_washer_indicator: '#969696',
  AES_boundaries_line_group: '#ff3cb1',
  alarm_box: '#ffffff',
  tunnel_bridge_viaduct: '#969696',
  cut_bar: '#ffffff',
  level_crossing: '#ffffff',
  dashed_track_section: '#ffffff',
  continuation_button: '#0000ff',
  limit_of_shunt_static_signal: '#000000',
  static_signal: '#000000',
  static_shunt_signal: '#000000',
  static_markerboard: '#000000',
  active_track_section: '#ffffff',
  active_main_signal: '#969696',
  active_shunters_release: '#ffffff',
  active_markerboard: '#fffe3c',
  active_shunt_markerboard: '#0000ff',
  active_shunt_signal: '#969696',
  aes_boundaries_text_label: '#ff3cb1',
  direction_lock_text_label: '#ffb578',
  connector_text_label: '#ffffff',
  other_text_label: '#ffffff',
  berth: '#e1e1e1',
  last_berth: '#ffd6b4',
  manual_trust_berth: '#ffff00'
};

Given(/^I am viewing the map (.*)$/, async (mapId: string) => {
  await mapPageObject.navigateTo(mapId);
});

Given('the user is viewing a schematic map', async () => {
  const randomMap = await homePage.chooseRandomMap();
  await mapPageObject.navigateTo(randomMap);
  mapPageObject.originallyOpenedMapTitle = await browser.getTitle();
});

Given('the user is viewing a schematic that contains a continuation button', async () => {
  const randomMap = await homePage.chooseRandomMap();
  await mapPageObject.navigateTo(randomMap);
  mapPageObject.originallyOpenedMapTitle = await browser.getTitle();
  const continuationTextLayerItems: MapLayerItem[]
    = mapLayerPageObject.getStaticLinesideFeatureLayerSvgElements(MapLayerType.connector_text_label);
  const continuationTextLayerItem: MapLayerItem = continuationTextLayerItems[0];
  const continuationTextElements: any[] = await continuationTextLayerItem.layerItems.getWebElements();
  const numContinuationLinks = continuationTextElements.length;
  expect(numContinuationLinks).to.be.greaterThan(0);
});

Given('I set up all signals for address {word} in {word} to be {word}', async (address: string, trainDescriber: string, colour: string) => {
  const redSignallingUpdate: SignallingUpdate = new SignallingUpdate( address, '00', '10:45:00', trainDescriber);
  const greenSignallingUpdate: SignallingUpdate = new SignallingUpdate( address, 'FF', '10:45:00', trainDescriber);
  if (colour === 'red') {
    linxRestClient.postSignallingUpdate(greenSignallingUpdate);
    await linxRestClient.waitMaxTransmissionTime();
    linxRestClient.postSignallingUpdate(redSignallingUpdate);
    await linxRestClient.waitMaxTransmissionTime();
  }
  if (colour === 'green') {
    linxRestClient.postSignallingUpdate(redSignallingUpdate);
    await linxRestClient.waitMaxTransmissionTime();
    linxRestClient.postSignallingUpdate(greenSignallingUpdate);
    await linxRestClient.waitMaxTransmissionTime();
  }
});

When('I make a note of the zoom level', async () => {
  browser.referenceMapScaleFactor = await mapPageObject.getCurrentScaleFactor();
});

When('I make a note of the map position and zoom level', async () => {
  browser.referenceMapScaleFactor = await mapPageObject.getCurrentScaleFactor();
  browser.referenceMapTopPX = await mapPageObject.getDraggableAreaTop();
  browser.referenceMapLeftPX = await mapPageObject.getDraggableAreaLeft();
});

When('I pan the map right {int}, down {int}', async (xVal: number, yVal: number) => {
  await browser.actions().mouseDown(mapPageObject.mapArea).perform();
  await browser.actions().mouseMove({x: xVal, y: yVal}).perform();
});

When('the user uses the primary mouse click on a continuation button', async () => {
  const continuationTextLayerItems: MapLayerItem[]
    = mapLayerPageObject.getStaticLinesideFeatureLayerSvgElements(MapLayerType.connector_text_label);
  const continuationTextLayerItem: MapLayerItem = continuationTextLayerItems[0];
  const continuationTextElements: any[] = await continuationTextLayerItem.layerItems.getWebElements();
  const numContinuationLinks = continuationTextElements.length;
  const randomIndex = Math.floor(Math.random() * numContinuationLinks);
  mapPageObject.lastMapLinkSelectedCode  = await continuationTextElements[randomIndex].getText();
  await continuationTextElements[randomIndex].click();
});


When('the user uses the secondary mouse click on a continuation button', async () => {
  const continuationTextLayerItems: MapLayerItem[]
    = mapLayerPageObject.getStaticLinesideFeatureLayerSvgElements(MapLayerType.connector_text_label);
  const continuationTextLayerItem: MapLayerItem = continuationTextLayerItems[0];
  const continuationTextElements: any[] = await continuationTextLayerItem.layerItems.getWebElements();
  const numContinuationLinks = continuationTextElements.length;
  const randomIndex = Math.floor(Math.random() * numContinuationLinks);
  mapPageObject.lastMapLinkSelectedCode  = await continuationTextElements[randomIndex].getText();
  await browser.actions().click(continuationTextElements[randomIndex], protractor.Button.RIGHT).perform();
});

When('the user selects "Open" map from the menu', async () => {
  const openMapLink: ElementFinder = await mapPageObject.getMapContextMenuElementByRow(3);
  await openMapLink.click();
});

When('the user selects "Open (new tab)" map from the menu', async () => {
  const openMapLink: ElementFinder = await mapPageObject.getMapContextMenuElementByRow(4);
  await openMapLink.click();
});

When('I release the mouse key', async () => {
  await browser.actions().mouseUp().perform();
});

Then('the zoom level is the same as previously noted', async () => {
  const currentSF = await mapPageObject.getCurrentScaleFactor();
  expect(currentSF).to.equal(browser.referenceMapScaleFactor);
});

Then('the zoom level has increased', async () => {
  const currentSF = await mapPageObject.getCurrentScaleFactor();
  expect(currentSF).to.be.greaterThan(browser.referenceMapScaleFactor);
});

Then('the zoom level has decreased', async () => {
  const currentSF = await mapPageObject.getCurrentScaleFactor();
  expect(currentSF).to.be.lessThan(browser.referenceMapScaleFactor);
});

Then('the zoom level is {int}', async (expectedSF: number) => {
  const currentSF = await mapPageObject.getCurrentScaleFactor();
  expect(currentSF).to.equal(expectedSF);
});

Then('the berth is not shown', async () => {
  const actualBerthVisibility = await mapPageObject.isBerthLayerVisible();
  expect(actualBerthVisibility).to.equal(false);
});

Then('the berth is shown', async () => {
  const actualBerthVisibility = await mapPageObject.isBerthLayerVisible();
  expect(actualBerthVisibility).to.equal(true);
});

Then('the manual trust berth is not shown', async () => {
  const actualBerthVisibility = await mapPageObject.isManualTrustBerthPresent();
  expect(actualBerthVisibility).to.equal(false);
});

Then('the manual trust berth is shown', async () => {
  const actualBerthVisibility = await mapPageObject.isManualTrustBerthPresent();
  expect(actualBerthVisibility).to.equal(true);
});

Then('the platform layer is shown', async () => {
  const actualPlatformLayerVisibility = await mapPageObject.isPlatformLayerPresent();
  expect(actualPlatformLayerVisibility).to.equal(true);
});

Then('the platform layer is not shown', async () => {
  const actualPlatformLayerVisibility = await mapPageObject.isPlatformLayerPresent();
  expect(actualPlatformLayerVisibility).to.equal(false);
});

Then('there are {int} {word} elements in the {word} layer', async (expectedItemCount: number, elementName: string, layer: string) => {
  let actualLayerItems: any[];
  if (layer === 'Platform') {
    actualLayerItems = await mapPageObject.platformLayerItems.getWebElements();
  }
  if (layer === 'Track') {
    actualLayerItems = await mapPageObject.trackLayerItems.getWebElements();
  }
  if (layer === 'Signal') {
    if (elementName === 'Pole') {
      actualLayerItems = await mapPageObject.signalLayerPoleItems.getWebElements();
    }
    if (elementName === 'Indicator') {
      actualLayerItems = await mapPageObject.signalLayerIndicatorItems.getWebElements();
    }
  }
  expect(actualLayerItems.length).to.equal(expectedItemCount);
});

Then ('{int} objects of type {word} are rendered', async (expectedItemCount: number, objectType: string) => {
  const layerType: MapLayerType = MapLayerType[objectType];
  const mapLayerItems: MapLayerItem[] = mapLayerPageObject.getStaticLinesideFeatureLayerSvgElements(layerType);
  const mapLayerItem: MapLayerItem = mapLayerItems[0];
  const webElements: any[] = await mapLayerItem.layerItems.getWebElements();

  expect(webElements.length).to.equal(expectedItemCount);

});

Then ('the objects of type {word} are the correct colour', async (objectType: string) => {
  const layerType: MapLayerType = MapLayerType[objectType];
  const mapLayerItems: MapLayerItem[] = mapLayerPageObject.getStaticLinesideFeatureLayerSvgElements(layerType);
  const mapLayerItem: MapLayerItem = mapLayerItems[0];
  const expectedObjectColourHex = mapObjectColourHex[objectType];
  const webElements: any[] = await mapLayerItem.layerItems.getWebElements();

  if (mapLayerItem.styleProperty) {
    const actualItemColourRgb: string = await webElements[0].getCssValue(mapLayerItem.styleProperty);
    const actualItemColourHex: string = CssColorConverterService.rgb2Hex(actualItemColourRgb);
    expect(actualItemColourHex).to.equal(expectedObjectColourHex);
  }
});

Then('the {word} elements in the {word} layer have colour {string}',
  async (elementName: string, layer: string, designatedColour: string) => {
  let actualLayerItems: any[];
  let styleProperty: string;
  if (layer === 'Platform') {
    actualLayerItems = await mapPageObject.platformLayerItems.getWebElements();
    styleProperty = 'fill';
  }
  if (layer === 'Track') {
    actualLayerItems = await mapPageObject.trackLayerItems.getWebElements();
    styleProperty = 'stroke';
  }
  if (layer === 'Signal') {
    if (elementName === 'Pole') {
      actualLayerItems = await mapPageObject.signalLayerPoleItems.getWebElements();
      styleProperty = 'stroke';
    }
    if (elementName === 'Indicator') {
      actualLayerItems = await mapPageObject.signalLayerIndicatorItems.getWebElements();
      styleProperty = 'fill';
    }
  }
  for (const actualItem of actualLayerItems) {
      const actualItemColourRgb: string = await actualItem.getCssValue(styleProperty);
      const actualItemColourHex: string = CssColorConverterService.rgb2Hex(actualItemColourRgb);
      expect(actualItemColourHex).to.equal(designatedColour);
  }
});


Then('the map is not being dragged', async () => {
  const isMidDrag = await mapPageObject.isMidDrag();
  expect(isMidDrag).to.equal(false);
});

Then('the map is being dragged', async () => {
  const isMidDrag = await mapPageObject.isMidDrag();
  expect(isMidDrag).to.equal(true);
});


Then('the mouse icon is a {string}', async (cursorIcon: string) => {
  const actualCursorIcon = await mapPageObject.getCursor();
  if (cursorIcon === 'pointer') {
    expect(actualCursorIcon).to.equal('auto');
  }
  if (cursorIcon === 'closed fist') {
    expect(actualCursorIcon).to.equal('grabbing');
  }
});

Then('the map has moved right {int}, down {int}', async (xVal: number, yVal: number) => {
  const newMapTopPX = await mapPageObject.getDraggableAreaTop();
  const newMapLeftPX = await mapPageObject.getDraggableAreaLeft();
  const scaleFactor = browser.referenceMapScaleFactor;
  expect(Math.round((newMapLeftPX - browser.referenceMapLeftPX) * scaleFactor)).to.equal(xVal);
  expect(Math.round((newMapTopPX - browser.referenceMapTopPX) * scaleFactor)).to.equal(yVal);
});

Then('the map has not moved', async () => {
  const newMapTopPX = await mapPageObject.getDraggableAreaTop();
  const newMapLeftPX = await mapPageObject.getDraggableAreaLeft();
  expect(newMapLeftPX).to.equal(browser.referenceMapLeftPX);
  expect(newMapTopPX).to.equal(browser.referenceMapTopPX);
});

Then('berth {string} in train describer {string} contains {string}',
  async (berthId: string, trainDescriber: string, berthContents: string) => {
  const trainDescription = await mapPageObject.getBerthText(berthId, trainDescriber);
  expect(trainDescription).equals(berthContents);
});

Then('berth {string} in train describer {string} contains {string} and is visible',
  async (berthId: string, trainDescriber: string, berthContents: string) => {
  const trainDescription = await mapPageObject.getBerthText(berthId, trainDescriber);
  expect(trainDescription).equals(berthContents);
  expect(await mapPageObject.berthTextIsVisible(berthId, trainDescriber));
});

Then('it is {string} that berth {string} in train describer {string} is present',
  async (isPresent: string, berthId: string, trainDescriber: string) => {
    const expectedPresent: boolean = (isPresent === 'true');
    const present: boolean = await mapPageObject.isBerthPresent(berthId, trainDescriber);
    expect(present).equals(Boolean(expectedPresent));
});

Then('berth {string} in train describer {string} does not contain {string}',
  async (berthId: string, trainDescriber: string, berthContents: string) => {
    const trainDescription = await mapPageObject.getBerthText(berthId, trainDescriber);
    expect(trainDescription).to.not.equal(berthContents);
});

Then('the signal roundel for signal {string} is {word}',
  async (signalId: string, expectedSignalColour: string) => {
    const expectedSignalColourHex = mapColourHex[expectedSignalColour];
    const actualSignalColourHex = await mapPageObject.getSignalLampRoundColour(signalId);
    expect(actualSignalColourHex).to.equal(expectedSignalColourHex);
  });

Then('berth {string} in train describer {string} contains the train description {string} but the first 2 characters have been swapped',
  async (berthId: string, trainDescriber: string, trainDescription: string) => {
    await page.navigateToMapWithBerth(berthId, trainDescriber);
    const array = trainDescription.split('');
    const expectedTrainDescription = array[1] + array[0] + array[2] + array[3];
    const present: boolean = await mapPageObject.isBerthPresent(berthId, trainDescriber);
    expect(present).equals(true);
    const berthText = await mapPageObject.getBerthText(berthId, trainDescriber);
    expect(berthText).equals(expectedTrainDescription);
    expect(await mapPageObject.berthTextIsVisible(berthId, trainDescriber));
});

Then('the view is refreshed with the linked map', async () => {
  const actualTabTitle: string = await browser.getTitle();
  expect(actualTabTitle).to.contain(mapPageObject.lastMapLinkSelectedCode);
});

Then ('the user is presented with a menu which they choose to open the map within to the same view or new tab', async () => {
  await mapPageObject.waitForContextMenu();
  const actualContextMenuItem2: string = await mapPageObject.getMapContextMenuItem(2);
  const actualContextMenuItem3: string = await mapPageObject.getMapContextMenuItem(3);
  const actualContextMenuItem4: string = await mapPageObject.getMapContextMenuItem(4);
  expect(actualContextMenuItem2).to.contain(mapPageObject.lastMapLinkSelectedCode);
  expect(actualContextMenuItem3).equals('Open');
  expect(actualContextMenuItem4).equals('Open (new tab)');
});

Then('a new tab opens showing the linked map', async () => {
  const windowHandles: string[] = await browser.getAllWindowHandles();
  const finalTab: number = windowHandles.length - 1;
  await browser.driver.switchTo().window(windowHandles[finalTab]);
  const actualTabTitle: string = await browser.getTitle();
  expect(actualTabTitle).to.contain(mapPageObject.lastMapLinkSelectedCode);
});

Then('the previous tab still displays the original map', async () => {
  const windowHandles: string[] = await browser.getAllWindowHandles();
  const finalTab: number = windowHandles.length - 1;
  const penultimateTab: number = finalTab - 1;
  await browser.driver.switchTo().window(windowHandles[penultimateTab]);
  const actualTabTitle: string = await browser.getTitle();
  expect(actualTabTitle).equals(mapPageObject.originallyOpenedMapTitle);
});


Given('I am on a map showing berth {string} and in train describer {string}', async (berthId: string, trainDescriber: string) => {
  await page.navigateToMapWithBerth(berthId, trainDescriber);
});
