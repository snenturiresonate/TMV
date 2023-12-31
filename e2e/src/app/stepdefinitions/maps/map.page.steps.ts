import {Before, Given, Then, When} from 'cucumber';
import {expect} from 'chai';
import {MapPageObject} from '../../pages/maps/map.page';
import {CssColorConverterService} from '../../services/css-color-converter.service';
import {browser, ElementFinder, ExpectedConditions, protractor} from 'protractor';
import {SignallingUpdate} from '../../../../../src/app/api/linx/models/signalling-update';
import {LinxRestClient} from '../../api/linx/linx-rest-client';
import {MapLayerPageObject} from '../../pages/maps/map-layer.page';
import {MapLayerType} from '../../pages/maps/map-layer-type.enum';
import {MapLayerItem} from '../../pages/maps/map-layer-item.model';
import {HomePageObject} from '../../pages/home.page';
import {CommonActions} from '../../pages/common/ui-event-handlers/actionsAndWaits';
import {AppPage} from '../../pages/app.po';
import {BerthCancel} from '../../../../../src/app/api/linx/models/berth-cancel';
import {CucumberLog} from '../../logging/cucumber-log';

let page: MapPageObject;
const appPage: AppPage = new AppPage();
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
  blue: '#0000ff',
  green: '#00ff00',
  yellow: '#fffe3c',
  white: '#ffffff',
  orange: '#ffa700',
  stone: '#f9cb9c',
  grey: '#969696',
  palegrey: '#b2b2b2',
  paleblue: '#00d2ff',
  purple: '#ff3cb1'
};

const mapLineWidth = {
  thin: '2px',
  solid: '3px',
};

const mapObjectColourHex = {
  platform: ['#ffa700', '#ffffff00'],
  WILD_indicator: ['#ffffff'],
  OHL_limits: ['#ffffff'],
  HABDS: ['#ffffff'],
  signal_box: ['#ffffff'],
  direction_arrows: ['#ffffff'],
  end_of_line_indication: ['#ffffff'],
  OHNS: ['#ffffff'],
  tripcock: ['#ffffff'],
  flight_path: ['#ffffff'],
  train_washer_indicator: ['#969696'],
  AES_boundaries_line_group: ['#ff3cb1'],
  alarm_box: ['#ffffff'],
  tunnel_bridge_viaduct: ['#666666'],
  cut_bar: ['#ffffff'],
  level_crossing: ['#ffffff'],
  dashed_track_section: ['#b2b2b2'],
  continuation_button: ['#0000ff', '#ffffff'],
  limit_of_shunt_static_signal: ['#000000'],
  static_signal: ['#000000'],
  static_shunt_signal: ['#000000'],
  static_markerboard: ['#000000'],
  active_track_section: ['#b2b2b2', '#ffffff'],
  active_main_signal: ['#ff0000', '#00ff00', '#969696'],
  active_shunters_release: ['#ffffff'],
  active_markerboard: ['#ff0000', '#00ff00', '#969696'],
  active_shunt_markerboard: ['#ff0000', '#ffffff', '#969696'],
  active_shunt_signal: ['#ff0000', '#ffffff', '#969696'],
  aes_boundaries_text_label: ['#ff3cb1'],
  direction_lock_text_label: ['#ffb578'],
  connector_text_label: ['#0000ff', '#ffffff'],
  other_text_label: ['#ffffff'],
  berth: ['#e1e1e1', '#ffd6b6'],
  manual_trust_berth: ['#ffff00']
};

Given(/^I am viewing the map (.*)$/, {timeout: 1 * 40000}, async (mapId: string) => {
  const url = '/tmv/maps/' + mapId;
  await appPage.navigateTo(url);
});

Given('I view a schematic that contains a continuation button', async () => {
  const randomMap = await homePage.chooseRandomMap();
  const url = '/tmv/maps/' + randomMap;
  await appPage.navigateTo(url);
  mapPageObject.originallyOpenedMapTitle = await browser.getTitle();
  const continuationTextLayerItems: MapLayerItem[]
    = mapLayerPageObject.getStaticLinesideFeatureLayerSvgElements(MapLayerType.connector_text_label);
  const continuationTextLayerItem: MapLayerItem = continuationTextLayerItems[0];
  const continuationTextElements: any[] = await continuationTextLayerItem.layerItems.getWebElements();
  const numContinuationLinks = continuationTextElements.length;
  expect(numContinuationLinks, 'Expect map to contain 1 or more continuation link')
    .to.be.greaterThan(0);
});

Given('I set up all signals for address {word} in {word} to be {word}', async (address: string, trainDescriber: string, state: string) => {
  const redSignallingUpdate: SignallingUpdate = new SignallingUpdate( address, '00', '10:45:00', trainDescriber);
  const greenSignallingUpdate: SignallingUpdate = new SignallingUpdate( address, 'FF', '10:45:00', trainDescriber);
  if (state === 'not-proceed') {
    linxRestClient.postSignallingUpdate(greenSignallingUpdate);
    await linxRestClient.waitMaxTransmissionTime();
    linxRestClient.postSignallingUpdate(redSignallingUpdate);
    await linxRestClient.waitMaxTransmissionTime();
  }
  if (state === 'proceed') {
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

When('I use the primary mouse click on a continuation button', async () => {
  const continuationTextLayerItems: MapLayerItem[]
    = mapLayerPageObject.getStaticLinesideFeatureLayerSvgElements(MapLayerType.connector_text_label);
  const continuationTextLayerItem: MapLayerItem = continuationTextLayerItems[0];
  const continuationTextElements: any[] = await continuationTextLayerItem.layerItems.getWebElements();
  const numContinuationLinks = continuationTextElements.length;
  const randomIndex = Math.floor(Math.random() * numContinuationLinks);
  mapPageObject.lastMapLinkSelectedCode  = await continuationTextElements[randomIndex].getText();
  await continuationTextElements[randomIndex].click();
});


When('I use the secondary mouse click on a continuation button', async () => {
  const continuationTextLayerItems: MapLayerItem[]
    = mapLayerPageObject.getStaticLinesideFeatureLayerSvgElements(MapLayerType.connector_text_label);
  const continuationTextLayerItem: MapLayerItem = continuationTextLayerItems[0];
  const continuationTextElements: any[] = await continuationTextLayerItem.layerItems.getWebElements();
  const numContinuationLinks = continuationTextElements.length;
  const randomIndex = Math.floor(Math.random() * numContinuationLinks);
  mapPageObject.lastMapLinkSelectedCode  = await continuationTextElements[randomIndex].getText();
  await browser.actions().click(continuationTextElements[randomIndex], protractor.Button.RIGHT).perform();
});

When('I move to map {string} via continuation link', async (mapName: string) => {
  const mapNumber = mapName.substr(mapName.length - 2, 2);
  const continuationTextLayerItems: MapLayerItem[]
    = mapLayerPageObject.getStaticLinesideFeatureLayerSvgElements(MapLayerType.connector_text_label);
  const continuationTextLayerItem: MapLayerItem = continuationTextLayerItems[0];
  const continuationTextElements: any[] = await continuationTextLayerItem.layerItems.getWebElements();
  for (const textItem of continuationTextElements) {
    const textString = await textItem.getText();
    if (textString === mapNumber) {
      return textItem.click();
    }
  }
});

When('I select "Open" map from the menu', async () => {
  const openMapLink: ElementFinder = await mapPageObject.getMapContextMenuElementByRow(3);
  await openMapLink.click();
});

When('I select "Open (new tab)" map from the menu', async () => {
  const openMapLink: ElementFinder = await mapPageObject.getMapContextMenuElementByRow(4);
  await openMapLink.click();
});

When('I release the mouse key', async () => {
  await browser.actions().mouseUp().perform();
});

When('I use the secondary mouse on {word} berth {word}', async (berthType: string, berthId: string) => {
  if (berthType === 'normal') {
    await mapPageObject.rightClickBerth(berthId);
  }
  if (berthType === 'manual-trust') {
    await mapPageObject.rightClickManualTrustBerth(berthId);
  }
});

Then('the zoom level is the same as previously noted', async () => {
  const currentSF = await mapPageObject.getCurrentScaleFactor();
  expect(currentSF, 'the zoom level has changed')
    .to.equal(browser.referenceMapScaleFactor);
});

Then('the zoom level has increased', async () => {
  const currentSF = await mapPageObject.getCurrentScaleFactor();
  expect(currentSF, 'the zoom level has not increased')
    .to.be.greaterThan(browser.referenceMapScaleFactor);
});

Then('the zoom level has decreased', async () => {
  const currentSF = await mapPageObject.getCurrentScaleFactor();
  expect(currentSF, 'the zoom level has not decreased')
    .to.be.lessThan(browser.referenceMapScaleFactor);
});

Then('the zoom level is {int}', async (expectedSF: number) => {
  const currentSF = await mapPageObject.getCurrentScaleFactor();
  expect(currentSF, `the zoom level is not ${expectedSF}`)
    .to.equal(expectedSF);
});

Then('the berth is not shown', async () => {
  const actualBerthVisibility = await mapPageObject.isBerthLayerVisible();
  expect(actualBerthVisibility, 'Berth layer is shown')
    .to.equal(false);
});

Then('the berth is shown', async () => {
  const actualBerthVisibility = await mapPageObject.isBerthLayerVisible();
  expect(actualBerthVisibility, 'Berth layer is not show')
    .to.equal(true);
});

Then('the manual trust berth is not shown', async () => {
  const actualBerthVisibility = await mapPageObject.isManualTrustBerthPresent();
  expect(actualBerthVisibility, 'Manual trust berth layer is shown')
    .to.equal(false);
});

Then('the manual trust berth is shown', async () => {
  const actualBerthVisibility = await mapPageObject.isManualTrustBerthPresent();
  expect(actualBerthVisibility, 'Manual trust berth layer is not shown')
    .to.equal(true);
});

Then('the platform layer is shown', async () => {
  const actualPlatformLayerVisibility = await mapPageObject.isPlatformLayerPresent();
  expect(actualPlatformLayerVisibility, 'Platform layer is not shown')
    .to.equal(true);
});

Then('the platform layer is not shown', async () => {
  const actualPlatformLayerVisibility = await mapPageObject.isPlatformLayerPresent();
  expect(actualPlatformLayerVisibility, 'Platform layer is shown')
    .to.equal(false);
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
  expect(actualLayerItems.length, `The number ${layer} elements is not correct`)
    .to.equal(expectedItemCount);
});

Then ('{int} objects of type {word} are rendered', async (expectedItemCount: number, objectType: string) => {
  await CommonActions.waitForElementInteraction(mapPageObject.zoomableLayer);
  const mapLayerItems: MapLayerItem[] = mapLayerPageObject.getStaticLinesideFeatureLayerSvgElements(MapLayerType[objectType]);
  const mapLayerItem: MapLayerItem = mapLayerItems[0];
  const webElements: any[] = await mapLayerItem.layerItems.getWebElements();

  expect(webElements.length, `The number ${objectType} elements is not correct`)
    .to.equal(expectedItemCount);

});

Then ('the objects of type {word} are the correct colour', async (objectType: string) => {
  const mapLayerItems: MapLayerItem[] = mapLayerPageObject.getStaticLinesideFeatureLayerSvgElements(MapLayerType[objectType]);
  const mapLayerItem: MapLayerItem = mapLayerItems[0];
  const expectedObjectColourHex = mapObjectColourHex[objectType];
  const webElements: any[] = await mapLayerItem.layerItems.getWebElements();

  if (mapLayerItem.styleProperty) {
    const actualItemColourRgb: string = await webElements[0].getCssValue(mapLayerItem.styleProperty);
    const actualItemColourHex: string = CssColorConverterService.rgb2Hex(actualItemColourRgb);
    expect(actualItemColourHex, `${objectType} Object is not the correct colour`)
      .oneOf(expectedObjectColourHex);
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
  expect(isMidDrag, 'The map is being dragged')
    .to.equal(false);
});

Then('the map is being dragged', async () => {
  const isMidDrag = await mapPageObject.isMidDrag();
  expect(isMidDrag, 'The map is not being dragged')
    .to.equal(true);
});

Then('the mouse icon is a {string}', async (cursorIcon: string) => {
  const actualCursorIcon = await mapPageObject.getCursor();
  if (cursorIcon === 'pointer') {
    expect(actualCursorIcon, `The mouse cursor is not icon ${cursorIcon}`)
      .to.equal('auto');
  }
  if (cursorIcon === 'closed fist') {
    expect(actualCursorIcon, `The mouse cursor is not icon ${cursorIcon}`)
      .to.equal('grabbing');
  }
});

Then('the map has moved right {int}, down {int}', async (xVal: number, yVal: number) => {
  const newMapTopPX = await mapPageObject.getDraggableAreaTop();
  const newMapLeftPX = await mapPageObject.getDraggableAreaLeft();
  const scaleFactor = browser.referenceMapScaleFactor;
  expect(Math.round((newMapLeftPX - browser.referenceMapLeftPX) * scaleFactor), 'x location of map is not correct')
    .to.equal(xVal);
  expect(Math.round((newMapTopPX - browser.referenceMapTopPX) * scaleFactor), 'y location of map is not correct')
    .to.equal(yVal);
});

Then('the map has not moved', async () => {
  const newMapTopPX = await mapPageObject.getDraggableAreaTop();
  const newMapLeftPX = await mapPageObject.getDraggableAreaLeft();
  expect(newMapLeftPX, 'x location of map has moved')
    .to.equal(browser.referenceMapLeftPX);
  expect(newMapTopPX, 'y location of map has moved')
    .to.equal(browser.referenceMapTopPX);
});

Then('berth {string} in train describer {string} contains {string}',
  async (berthId: string, trainDescriber: string, berthContents: string) => {
    const trainDescription = await mapPageObject.getBerthText(berthId, trainDescriber);
    expect(trainDescription, 'Train description is not in the berth text')
      .equals(berthContents);
});

Then('berth {string} in train describer {string} contains {string} and is visible',
  async (berthId: string, trainDescriber: string, berthContents: string) => {
    await mapPageObject.waitUntilBerthTextIs(berthId, trainDescriber, berthContents);
    const trainDescription = await mapPageObject.getBerthText(berthId, trainDescriber);
    expect(trainDescription, 'Train description is not in the berth text')
      .equals(berthContents);
    expect(await mapPageObject.berthTextIsVisible(berthId, trainDescriber), 'Berth text is not visible');
});

Then('it is {string} that berth {string} in train describer {string} is present',
  async (isPresent: string, berthId: string, trainDescriber: string) => {
    const expectedPresent: boolean = (isPresent === 'true');
    const present: boolean = await mapPageObject.isBerthPresent(berthId, trainDescriber);
    expect(present, 'The presence/absence of the berth is not as expected')
      .equals(Boolean(expectedPresent));
});

Then('berth {string} in train describer {string} does not contain {string}',
  async (berthId: string, trainDescriber: string, berthContents: string) => {
    const trainDescription = await mapPageObject.getBerthText(berthId, trainDescriber);
    expect(trainDescription, `Berth contains ${berthContents} when it shouldn't`)
      .to.not.equal(berthContents);
});

Then('the signal roundel for signal {string} is {word}',
  async (signalId: string, expectedSignalColour: string) => {
    const expectedSignalColourHex = mapColourHex[expectedSignalColour];
    const actualSignalColourHex = await mapPageObject.getSignalLampRoundColour(signalId);
    expect(actualSignalColourHex, `Signal ${signalId} colour is not correct`)
      .to.equal(expectedSignalColourHex);
  });

Then('the TRTS visibility status for {string} is {word}',
  async (signalId: string, expectedStatus: string) => {
    const actualStatus = await mapPageObject.getVisibilityStatus(signalId);
    expect(actualStatus, `TRTS ${signalId} status is not correct`)
      .to.equal(expectedStatus);
  });

Then('the marker board triangle for marker board {string} is {word}',
  async (markerBoardId: string, expectedMarkerBoardColour: string) => {
    const expectedMarkerBoardColourHex = mapColourHex[expectedMarkerBoardColour];
    const actualMarkerBoardColourHex = await mapPageObject.getMarkerBoardTriangleColour(markerBoardId);
    expect(actualMarkerBoardColourHex, `Marker board triangle colour for ${markerBoardId} is not correct`)
      .to.equal(expectedMarkerBoardColourHex);
  });

Then('the shunt marker board triangle for shunt marker board {string} is {word}',
  async (markerBoardId: string, expectedShuntMarkerBoardColour: string) => {
    const expectedShuntMarkerBoardColourHex = mapColourHex[expectedShuntMarkerBoardColour];
    const actualShuntMarkerBoardColourHex = await mapPageObject.getShuntMarkerBoardTriangleColour(markerBoardId);
    expect(actualShuntMarkerBoardColourHex, `Shunt marker board triangle colour for ${markerBoardId} is not correct`)
      .to.equal(expectedShuntMarkerBoardColourHex);
  });

Then('the marker board {string} will display a Movement Authority {word} [{word} triangle on blue background]',
  async (markerBoardId: string, authorityType: string, expectedMarkerBoardColour: string) => {
    const expectedMarkerBoardColourHex = mapColourHex[expectedMarkerBoardColour];
    const actualMarkerBoardColourHex = await mapPageObject.getMarkerBoardTriangleColour(markerBoardId);
    const actualMarkerBoardBackgroundColourHex = await mapPageObject.getMarkerBoardBackgroundColour(markerBoardId);
    expect(actualMarkerBoardColourHex, `Marker board triangle colour for ${markerBoardId} is not correct`)
      .to.equal(expectedMarkerBoardColourHex);
    expect(actualMarkerBoardBackgroundColourHex, `Triangle background colour is not blue`)
      .to.equal(mapColourHex.blue);
  });

Then('the shunt marker board {string} will display a Movement Authority {word} [{word} triangle with blue inner triangle]',
  async (markerBoardId: string, authorityType: string, expectedMarkerBoardColour: string) => {
    const expectedShuntMarkerBoardColourHex = mapColourHex[expectedMarkerBoardColour];
    const actualShuntMarkerBoardTriangleColourHex = await mapPageObject.getShuntMarkerBoardTriangleColour(markerBoardId);
    const actualShuntMarkerBoardSmallTriangleColourHex = await mapPageObject.getShuntMarkerBoardSmallTriangleColour(markerBoardId);
    expect(actualShuntMarkerBoardTriangleColourHex, `Shunt marker board triangle colour for ${markerBoardId} is not correct`)
      .to.equal(expectedShuntMarkerBoardColourHex);
    expect(actualShuntMarkerBoardSmallTriangleColourHex, `Triangle background colour is not blue`)
      .to.equal(mapColourHex.blue);
  });

Then('the s-class-berth {string} will display {word} Route indication of {string}',
  async (sClassBerthId: string, expectedIndicationCount: string, lineCode: string) => {
  if (expectedIndicationCount === 'no') {
    expect(! await mapPageObject.isSClassBerthElementPresent(sClassBerthId));
  }
  else {
    const actualIndicationText = await mapPageObject.getSClassBerthElementText(sClassBerthId);
    const actualIndicationTextColourHex = await mapPageObject.getSClassBerthElementTextColour(sClassBerthId);
    expect(actualIndicationTextColourHex).to.equal(mapColourHex.paleblue);
    expect(actualIndicationText).to.equal(lineCode);
  }
});

Then('the AES box containing s-class-berth {string} will display {word} aes text of {string}',
  async (sClassBerthId: string, expectedIndicationCount: string, aesCode: string) => {
    if (expectedIndicationCount === 'no') {
      expect(! await mapPageObject.isSClassBerthElementPresent(sClassBerthId));
    }
    else {
      const actualIndicationText = await mapPageObject.getSClassBerthElementText(sClassBerthId);
      const actualIndicationTextColourHex = await mapPageObject.getSClassBerthElementTextColour(sClassBerthId);
      expect(actualIndicationTextColourHex, 'Text colour is not purple')
        .to.equal(mapColourHex.purple);
      expect(actualIndicationText, 'AES text is not correct')
        .to.equal(aesCode);
    }
  });


Then('there is no text indication for {word} {string}', async (sClassBerthType: string, sClassBerthId: string) => {
  expect(! await mapPageObject.isSClassBerthElementPresent(sClassBerthId));
});

Then('there is a text indication for {word} {string}', async (sClassBerthType: string, sClassBerthId: string) => {
  expect(await mapPageObject.isSClassBerthElementPresent(sClassBerthId));
});

Then('the shunt-marker-board {string} will display a Node Proven {word} [{word} green cross next to the shunt marker board]',
  async (markerBoardId: string, authorityType: string, expectedIndicationCount: string) => {
    if (expectedIndicationCount === 'no') {
      expect(! await mapPageObject.isSClassBerthElementPresent(markerBoardId));
    }
    else {
      const actualIndicationText = await mapPageObject.getSClassBerthElementText(markerBoardId);
      const actualIndicationTextColourHex = await mapPageObject.getSClassBerthElementTextColour(markerBoardId);
      expect(actualIndicationTextColourHex, 'Text colour is not green')
        .to.equal(mapColourHex.green);
      expect(actualIndicationText, 'Text is not a green +')
        .to.equal('+');
    }
  });

Then('the cross indication for shunters-release {string} is not visible', async (releaseId: string) => {
  expect(! await mapPageObject.releaseElementIsVisible(releaseId));
});

Then('the cross indication for shunters-release {string} is visible', async (releaseId: string) => {
  expect(await mapPageObject.releaseElementIsVisible(releaseId));
});

Then('the shunters-release {string} will display a {word} state [{word} white cross in the white box]',
  async (releaseId: string, authorityType: string, expectedIndicationCount: string) => {
    if (expectedIndicationCount === 'no') {
      expect(! await mapPageObject.releaseElementIsVisible(releaseId));
    }
    else {
      expect(await mapPageObject.releaseElementIsVisible(releaseId));
      const actualIndicationTextColourHex = await mapPageObject.getReleaseElementColour(releaseId);
      expect(actualIndicationTextColourHex, 'Text colour is not white')
        .to.equal(mapColourHex.white);
    }
  });

Then('berth {string} in train describer {string} contains the train description {string} but the first 2 characters have been swapped',
  async (berthId: string, trainDescriber: string, trainDescription: string) => {
    await page.navigateToMapWithBerth(berthId, trainDescriber);
    const array = trainDescription.split('');
    const expectedTrainDescription = array[1] + array[0] + array[2] + array[3];
    const present: boolean = await mapPageObject.isBerthPresent(berthId, trainDescriber);
    expect(present, 'Berth is not present')
      .equals(true);
    const berthText = await mapPageObject.getBerthText(berthId, trainDescriber);
    expect(berthText, 'Berth text is not correct')
      .equals(expectedTrainDescription);
    expect(await mapPageObject.berthTextIsVisible(berthId, trainDescriber), 'Berth text is not visible');
});

Then('the view is refreshed with the linked map', async () => {
  const actualTabTitle: string = await browser.getTitle();
  expect(actualTabTitle, 'Map code is not correct in the browser title')
    .to.contain(mapPageObject.lastMapLinkSelectedCode);
});

Then ('I am presented with a menu which I choose to open the map within to the same view or new tab', async () => {
  await mapPageObject.waitForContextMenu();
  const actualContextMenuItem2: string = await mapPageObject.getMapContextMenuItem(2);
  const actualContextMenuItem3: string = await mapPageObject.getMapContextMenuItem(3);
  const actualContextMenuItem4: string = await mapPageObject.getMapContextMenuItem(4);
  expect(actualContextMenuItem2, '2nd item on the context menu is not correct map code')
    .to.contain(mapPageObject.lastMapLinkSelectedCode);
  expect(actualContextMenuItem3, '3rd item on the context menu is not Open')
    .equals('Open');
  expect(actualContextMenuItem4, '4th item on the context menu is not Open (new tab)')
    .equals('Open (new tab)');
});

Then('a new tab opens showing the linked map', async () => {
  const windowHandles: string[] = await browser.getAllWindowHandles();
  const finalTab: number = windowHandles.length - 1;
  await browser.driver.switchTo().window(windowHandles[finalTab]);
  const actualTabTitle: string = await browser.getTitle();
  expect(actualTabTitle, 'Map code is not correct in the browser title')
    .to.contain(mapPageObject.lastMapLinkSelectedCode);
});

Then('the previous tab still displays the original map', async () => {
  const windowHandles: string[] = await browser.getAllWindowHandles();
  const finalTab: number = windowHandles.length - 1;
  const penultimateTab: number = finalTab - 1;
  await browser.driver.switchTo().window(windowHandles[penultimateTab]);
  const actualTabTitle: string = await browser.getTitle();
  expect(actualTabTitle, 'Map code is not correct in the browser title')
    .equals(mapPageObject.originallyOpenedMapTitle);
});

Then('I am presented with a set of information about the berth', async () => {
  const contextMenuAppears = await mapPageObject.waitForContextMenu();
  expect(contextMenuAppears, 'Context menu is not displayed')
    .equals(true);
});

Then('the berth information for {word} contains {word}', async (berthId: string, expectedBerthInfo: string) => {
  const infoString: string = await mapPageObject.getBerthContextInfoText();
  expect(infoString, 'Expected berth information not correct')
    .to.contain(expectedBerthInfo);
});

Then('the berth information for {word} only contains {word}', async (berthId: string, expectedBerthInfo: string) => {
  const infoString: string = await mapPageObject.getBerthContextInfoText();
  expect(infoString, 'Expected berth information not correct')
    .to.equal(expectedBerthInfo);
});

Then('the manual trust berth information for {word} only contains {word}', async (berthId: string, expectedBerthInfo: string) => {
  const infoString: string = await mapPageObject.getManualTrustBerthContextInfoText();
  expect(infoString, 'Expected berth information not correct')
    .to.equal(expectedBerthInfo);
});

Given('I am on a map showing berth {string} and in train describer {string}', async (berthId: string, trainDescriber: string) => {
  await page.navigateToMapWithBerth(berthId, trainDescriber);
});

Then('the shunt signal state for signal {string} is {word}',
  async (signalId: string, expectedSignalColour: string) => {
    const expectedSignalColourHex = mapColourHex[expectedSignalColour];
    const actualSignalColourHex = await mapPageObject.getShuntSignalColour(signalId);
    expect(actualSignalColourHex, `shunt signal for ${signalId} is not the correct colour`)
      .to.equal(expectedSignalColourHex);
  });

When('I launch a new map {string} the new map should have start time from the moment it was opened', async (mapName: string) => {
  await mapPageObject.clickMapName();
  await mapPageObject.enterMapSearchString(mapName);
  await mapPageObject.launchMap();
});

Then('the TRTS status for signal {string} is {word}',
  async (signalId: string, expectedSignalStatus: string) => {
    const expectedSignalStatusHex = mapColourHex[expectedSignalStatus];
    const actualSignalStatus: string = await mapPageObject.getTrtsStatus(signalId);
    expect(actualSignalStatus, `TRTS status for ${signalId} is not correct`)
      .to.equal(expectedSignalStatusHex);
  });

Then('the level crossing barrier status of {string} is {word}',
  async (lvlCrossingId: string, expectedStatus: string) => {
    const actualBarrierStatus = await mapPageObject.getLvlCrossingBarrierState(lvlCrossingId);
    expect(actualBarrierStatus, `level crossing barrier status for ${lvlCrossingId} is not correct`)
      .to.equal(expectedStatus);
  });

Then('the direction lock chevron of {string} is {word}',
  async (directionLockId: string, expectedStatus: string) => {
    const actualBarrierStatus = await mapPageObject.getLvlCrossingBarrierState(directionLockId);
    expect(actualBarrierStatus, `direction lock chevron for ${directionLockId} is not correct`)
      .to.equal(expectedStatus);
  });

Then('the direction lock chevrons are not displayed',
  async () => {
    const chevronsDisplayed = await mapPageObject.isDirectionChevronDisplayed();
    expect(chevronsDisplayed, 'Direction lock chevron is displayed when it shouldn\'t be')
      .to.equal(false);
  });

Then('I should see the AES boundary elements', async () => {
    const aesDisplayed = await mapPageObject.aesElementsAreDisplayed();
    expect(aesDisplayed, 'AES boundary elements are not displayed')
      .to.equal(true);
  });

Then('I should not see the AES boundary elements', async () => {
  const aesDisplayed = await mapPageObject.aesElementsAreDisplayed();
  expect(aesDisplayed, 'AES boundary elements are displayed')
    .to.equal(false);
});

When(/^I invoke the context menu on the map for train (.*)$/, async (trainDescription: string) => {
  await mapPageObject.openContextMenuForTrainDescription(trainDescription);
});

When('I open timetable from the map context menu', async () => {
  await mapPageObject.mapContextMenuItems.get(1).click();
});

When('I open schedule matching screen from the map context menu', async () => {
  await mapPageObject.mapContextMenuItems.get(2).click();
});

When(/^I toggle path (?:on|off) from the map context menu$/, async () => {
  await mapPageObject.mapContextMenuItems.get(3).click();
});

Then('the map context menu contains {string} on line {int}', async (expectedText: string, rowNum: number) => {
  const actualContextMenuItem: string = await mapPageObject.mapContextMenuItems.get(rowNum - 1).getText();
  expect(actualContextMenuItem).to.contain(expectedText);
});

Then('the track state width for {string} is {string}',
  async (trackId: string, expectedWidth: string) => {
    const actualWidth = await mapPageObject.getTrackWidth(trackId);
    expect(actualWidth, `Track width for ${trackId} is not as expected`)
      .to.equal(expectedWidth);
  });

Then('the route indication for {string} is {string}',
  async (trackId: string, expectedValue: string) => {
    const actualValue = await mapPageObject.getRouteIndication(trackId);
    expect(actualValue, `Route Indication for ${trackId} is not correct`)
      .to.equal(expectedValue);
  });

Then('the track colour for track {string} is {word}',
  async (trackId: string, expectedValue: string) => {
    const expectedSignalStatusHex = mapColourHex[expectedValue];
    const actualSignalStatus: string = await mapPageObject.getTrackColour(trackId);
    expect(actualSignalStatus, `Track colour for ${trackId} is not as expected`)
      .to.equal(expectedSignalStatusHex);
  });

Then('the tracks {string} are displayed in {word} {word}',
  async (trackIds: string, expectedWidth: string, expectedColour: string) => {
    const expectedTrackIds = trackIds.split(',').map(item => item.trim());
    const expectedTrackColourHex = mapColourHex[expectedColour];
    const expectedTrackWidth = mapLineWidth[expectedWidth];
    for (const trackId of expectedTrackIds) {
      const actualTrackColour: string = await mapPageObject.getTrackColour(trackId);
      const actualTrackWidth: string = await mapPageObject.getTrackWidth(trackId);
      expect(actualTrackColour, `Track colour for ${trackIds} is not as expected`)
        .to.equal(expectedTrackColourHex);
      expect(actualTrackWidth, `Track width for ${trackIds} is not as expected`)
        .to.equal(expectedTrackWidth);
    }
  });

Then('the berth context menu contains the signal id {string}', async (signalId: string) => {
  const signalName: string = await mapPageObject.getBerthContextMenuSignalName(signalId);
  expect(signalName).length.greaterThan(1);
});

Then('the berth id for {string} is {word}',
  async (berthId: string, expectedStatus: string) => {
    const actualStatus = await mapPageObject.getVisibilityStatus(berthId);
    expect(actualStatus).to.equal(expectedStatus);
  });

Then('the headcode displayed for {string} is {word}',
  async (berthId: string, expectedHeadcode: string) => {
    const actualHeadcode = await mapPageObject.getHeadcode(berthId);
    expect(actualHeadcode).to.equal(expectedHeadcode);
  });

When('I right click on berth with id {string}', async (berthId: string) => {
  await mapPageObject.rightClickBerth(berthId);
});

Then('the berth context menu is displayed with berth name {string}', async (expectedBerthName: string) => {
  const berthName: string = await mapPageObject.getBerthName();
  expect(berthName).to.equal(expectedBerthName);
});

Then('the train headcode color for berth {string} is {word}',
  async (berthId: string, expectedColor: string) => {
    const expectedColorHex = mapColourHex[expectedColor];
    const actualSignalStatus: string = await mapPageObject.getBerthColor(berthId);
    expect(actualSignalStatus, 'Headcode colour is not ' + expectedColor)
      .to.equal(expectedColorHex);
  });

Then('the train headcode {string} is {string} on the map', async (trainDesc: string, visibilityType: string) => {
  const headcodes: string[] = await mapPageObject.getHeadcodesOnMap();
  let found = false;
  for (const hcode of headcodes) {
    if (hcode === trainDesc) {
      found = true;
      break;
    }
  }
  if (visibilityType === 'displayed') {
    expect(found, 'Headcode expected to be present on map').to.equal(true);
  } else {
    expect(found, 'Headcode not expected to be present on map').to.equal(false);
  }
});

Then(/^the (Matched|Unmatched) version of the context menu is displayed$/, async (matchType: string) => {
  await mapPageObject.waitForContextMenu();
  let expected;
  if (matchType === 'Matched') {
    expected = 'Unmatch';
  } else {
    expected = 'Match';
  }
  const contextMenuItem: string = await mapPageObject.getMapContextMenuItem(3);
  expect(contextMenuItem, `${matchType} option not found in the context menu`)
    .to.equal(expected);
});

Given(/^I have cleared out all headcodes$/, async () => {
  await browser.wait(ExpectedConditions.visibilityOf(mapPageObject.berthElements), 60 * 1000);
  await browser.sleep(1000);
  await CucumberLog.addScreenshot();
  await mapPageObject.headcodeOnMap.each((el) => {
    el.getAttribute('id').then((id) => {
      const berthID = id.replace('berth-element-text-', '');
      el.getText().then(headcode => {
        CucumberLog.addText(`Clearing headcode ${headcode} from ${berthID}`);
        const berthCancel: BerthCancel = new BerthCancel(
          berthID.substring(2, 6),
          '00:00:00',
          berthID.substring(0, 2),
          headcode
        );
        linxRestClient.postBerthCancel(berthCancel);
      });
    });
  });
  await linxRestClient.waitMaxTransmissionTime();
});
