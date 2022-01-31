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
import {CommonActions} from '../../pages/common/ui-event-handlers/actionsAndWaits';
import {AppPage} from '../../pages/app.po';
import {TMVRedisUtils} from '../../utils/tmv-redis-utils';
import {DateAndTimeUtils} from '../../pages/common/utilities/DateAndTimeUtils';
import {CucumberLog} from '../../logging/cucumber-log';
import {BerthStep} from '../../../../../src/app/api/linx/models/berth-step';
import {BerthCancel} from '../../../../../src/app/api/linx/models/berth-cancel';

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
  red:        '#ff0000',
  blue:       '#0000ff',
  green:      '#00ff00',
  yellow:     '#ffff00',
  white:      '#ffffff',
  orange:     '#ffa700',
  stone:      '#f9cb9c',
  grey:       '#969696',
  palegrey:   '#b2b2b2',
  paleblue:   '#00d2ff',
  purple:     '#ff3cb1',
  lightgrey:  '#e1e1e1',
  lightgreen: '#78ff78',
  lightblue:  '#78e7ff',
  lilac:      '#e5b4ff',
  salmon:     '#ffb4b4',
  pink:       '#ff009c'
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
  const currentTime = DateAndTimeUtils.getCurrentDateTimeString('HH:mm:ss');
  const redSignallingUpdate: SignallingUpdate = new SignallingUpdate( address, '00', currentTime, trainDescriber);
  const greenSignallingUpdate: SignallingUpdate = new SignallingUpdate( address, 'FF', currentTime, trainDescriber);
  if (state === 'not-proceed') {
    await linxRestClient.postSignallingUpdate(greenSignallingUpdate);
    await linxRestClient.waitMaxTransmissionTime();
    await linxRestClient.postSignallingUpdate(redSignallingUpdate);
    await linxRestClient.waitMaxTransmissionTime();
  }
  if (state === 'proceed') {
    await linxRestClient.postSignallingUpdate(redSignallingUpdate);
    await linxRestClient.waitMaxTransmissionTime();
    await linxRestClient.postSignallingUpdate(greenSignallingUpdate);
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
  if (berthType === 'last') {
    await mapPageObject.rightClickBerth(berthId);
  }
});

When('I use the {word} mouse on {word} signal {word}', async (mouseButtonType: string, signalType: string, signalId: string) => {
  if (signalType.includes('main')) {
    await mapPageObject.clickSignal(signalId, 'main', mouseButtonType);
  }
  else if (signalType.includes('shunt_markerboard')) {
    await mapPageObject.clickSignal(signalId, 'shunt_markerboard', mouseButtonType);
  }
  else if (signalType.includes('markerboard')) {
    await mapPageObject.clickSignal(signalId, 'markerboard', mouseButtonType);
  }
  else if (signalType.includes('shunt')) {
    await mapPageObject.clickSignal(signalId, 'shunt', mouseButtonType);
  }
  else {
    await mapPageObject.clickSignal(signalId, 'other', mouseButtonType);
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
    if (berthContents.includes('generated')) {
      berthContents = browser.referenceTrainDescription;
    }
    await mapPageObject.waitUntilBerthTextIs(berthId, trainDescriber, berthContents);
    const trainDescription = await mapPageObject.getBerthText(berthId, trainDescriber);
    expect(trainDescription, 'Train description is not in the berth text')
      .equals(berthContents);
    expect(await mapPageObject.berthTextIsVisible(berthId, trainDescriber), 'Berth text is not visible');
});

Then('berth {string} in train describer {string} contains {string} and is visible on map',
  async (berthId: string, trainDescriber: string, berthContents: string) => {
    await browser.waitForAngularEnabled(false);
    if (berthContents.includes('generated')) {
      berthContents = browser.referenceTrainDescription;
    }
    await mapPageObject.waitUntilBerthTextIs(berthId, trainDescriber, berthContents);
    const trainDescription = await mapPageObject.getBerthText(berthId, trainDescriber);
    expect(trainDescription, 'Train description is not in the berth text')
      .equals(berthContents);
    expect(await mapPageObject.berthTextIsVisible(berthId, trainDescriber), 'Berth text is not visible');
    await browser.waitForAngularEnabled(true);
  });

Then('berth {string} in train describer {string} and is not visible',
  async (berthId: string, trainDescriber: string) => {
    await browser.waitForAngularEnabled(false);
    expect(await mapPageObject.berthTextIsVisible(berthId, trainDescriber), 'Berth text is not visible').equals(false);
    await browser.waitForAngularEnabled(true);
  });

Then('berth {string} in train describer {string} is visible',
  async (berthId: string, trainDescriber: string) => {
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
  async (berthId: string, trainDescriber: string, expectedBerthContents: string) => {
    if (expectedBerthContents.includes('generated')) {
      expectedBerthContents = browser.referenceTrainDescription;
    }
    await browser.wait(async () => {
      const trainDescription = await mapPageObject.getBerthText(berthId, trainDescriber);
      return trainDescription !== expectedBerthContents;
    }, 20 * 1000, `Berth contains ${expectedBerthContents} when it shouldn't`);
});

Then('the signal roundel for signal {string} is {word}',
  async (signalId: string, expectedSignalColour: string) => {
    const expectedSignalColourHex = mapColourHex[expectedSignalColour];
    let actualSignalColourHex = 'none';

    await browser.wait(async () => {
      actualSignalColourHex = await mapPageObject.getSignalLampRoundColour(signalId);
      return (expectedSignalColourHex === actualSignalColourHex);
    }, browser.params.general_timeout, `The signal roundel for signal ${signalId} was not ${expectedSignalColour}`);
  });

Then('the TRTS visibility status for {string} is {word}',
  async (signalId: string, expectedStatus: string) => {
    await browser.wait(async () => {
      const actualStatusWait = await mapPageObject.getVisibilityStatus(signalId);
      return (actualStatusWait === expectedStatus);
    }, browser.params.replay_timeout, `The TRTS visibility status for ${signalId} was not ${expectedStatus}`);

    const actualStatus = await mapPageObject.getVisibilityStatus(signalId);
    expect(actualStatus, `TRTS ${signalId} status is not correct`)
      .to.equal(expectedStatus);
  });

Then('the marker board triangle for marker board {string} is {word}',
  async (markerBoardId: string, expectedMarkerBoardColour: string) => {
    await browser.wait(async () => {
      const expectedMarkerBoardColourHexWait = mapColourHex[expectedMarkerBoardColour];
      const actualMarkerBoardColourHexWait = await mapPageObject.getMarkerBoardTriangleColour(markerBoardId);
      return (actualMarkerBoardColourHexWait === expectedMarkerBoardColourHexWait);
    }, browser.params.general_timeout, `Marker board triangle colour for ${markerBoardId} is not correct`);

    const expectedMarkerBoardColourHex = mapColourHex[expectedMarkerBoardColour];
    const actualMarkerBoardColourHex = await mapPageObject.getMarkerBoardTriangleColour(markerBoardId);
    expect(actualMarkerBoardColourHex, `Marker board triangle colour for ${markerBoardId} is not correct`)
      .to.equal(expectedMarkerBoardColourHex);
  });

Then('the shunt marker board triangle for shunt marker board {string} is {word}',
  async (markerBoardId: string, expectedShuntMarkerBoardColour: string) => {
    await browser.wait(async () => {
      const expectedShuntMarkerBoardColourHexWait = mapColourHex[expectedShuntMarkerBoardColour];
      const actualShuntMarkerBoardColourHexWait = await mapPageObject.getShuntMarkerBoardTriangleColour(markerBoardId);
      return (actualShuntMarkerBoardColourHexWait === expectedShuntMarkerBoardColourHexWait);
    }, browser.params.general_timeout, `Shunt marker board triangle colour for ${markerBoardId} is not correct`);

    const expectedShuntMarkerBoardColourHex = mapColourHex[expectedShuntMarkerBoardColour];
    const actualShuntMarkerBoardColourHex = await mapPageObject.getShuntMarkerBoardTriangleColour(markerBoardId);
    expect(actualShuntMarkerBoardColourHex, `Shunt marker board triangle colour for ${markerBoardId} is not correct`)
      .to.equal(expectedShuntMarkerBoardColourHex);
  });

Then('the marker board {string} will display a Movement Authority {word} [{word} triangle on blue background]',
  async (markerBoardId: string, authorityType: string, expectedMarkerBoardColour: string) => {
    const expectedMarkerBoardColourHex = mapColourHex[expectedMarkerBoardColour];

    await browser.wait(async () => {
      const actualMarkerBoardColourHexWait = await mapPageObject.getMarkerBoardTriangleColour(markerBoardId);
      const actualMarkerBoardBackgroundColourHexWait = await mapPageObject.getMarkerBoardBackgroundColour(markerBoardId);
      return (
        (actualMarkerBoardColourHexWait === expectedMarkerBoardColourHex) &&
        (actualMarkerBoardBackgroundColourHexWait === mapColourHex.blue)
      );
    }, browser.params.replay_timeout, `The marker board ${markerBoardId} did not display movement authority ${authorityType}`);

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

    await browser.wait(async () => {
        const actualShuntMarkerBoardTriangleColourHexWait = await mapPageObject.getShuntMarkerBoardTriangleColour(markerBoardId);
        const actualShuntMarkerBoardSmallTriangleColourHexWait = await mapPageObject.getShuntMarkerBoardSmallTriangleColour(markerBoardId);
        return (
          (actualShuntMarkerBoardTriangleColourHexWait === expectedShuntMarkerBoardColourHex) &&
          (actualShuntMarkerBoardSmallTriangleColourHexWait === mapColourHex.blue));
    }, browser.params.replay_timeout,
      `The shunt marker board ${markerBoardId} did not display a Movement Authority ${authorityType} [${expectedMarkerBoardColour} triangle with blue inner triangle]`);

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
    await browser.wait(async () => {
      const actualIndicationTextWait = await mapPageObject.getSClassBerthElementText(sClassBerthId);
      const actualIndicationTextColourHexWait = await mapPageObject.getSClassBerthElementTextColour(sClassBerthId);
      return ((actualIndicationTextWait === lineCode) && (actualIndicationTextColourHexWait === mapColourHex.paleblue));
    }, browser.params.replay_timeout, `S-class berth ${sClassBerthId} did not display ${expectedIndicationCount} route indication of ${lineCode}`);

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
      await browser.wait(async () => {
        const actualIndicationTextWait = await mapPageObject.getSClassBerthElementText(sClassBerthId);
        const actualIndicationTextColourHexWait = await mapPageObject.getSClassBerthElementTextColour(sClassBerthId);
        return ((actualIndicationTextWait === aesCode) && (actualIndicationTextColourHexWait === mapColourHex.purple));
      }, browser.params.replay_timeout,
        `The AES box containing s-class-berth ${sClassBerthId} did not display ${expectedIndicationCount} aes text of ${aesCode}`);

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

      await browser.wait(async () => {
          const actualIndicationTextColourHexWait = await mapPageObject.getReleaseElementColour(releaseId);
          return (actualIndicationTextColourHexWait === mapColourHex.white);
      }, browser.params.replay_timeout,
        `The shunters-release ${releaseId} did not display a ${authorityType} state
        [${expectedIndicationCount} white cross in the white box]`);

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

Then(/^I am presented with a set of information about the (?:berth|signal)$/, async () => {
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

Then('the manual trust berth information for {word} only contains {string}', async (berthId: string, expectedBerthInfo: string) => {
  const infoString: string = await mapPageObject.getManualTrustBerthContextInfoText();
  expect(infoString, 'Expected berth information not correct')
    .to.equal(expectedBerthInfo);
});

Then('the signal information for {word} contains {word}', async (berthId: string, expectedSignalInfo: string) => {
  const infoString: string = await mapPageObject.getSignalContextInfoText();
  expect(infoString, 'Expected signal information not correct')
    .to.contain(expectedSignalInfo);
});

Given('I am on a map showing berth {string} and in train describer {string}', async (berthId: string, trainDescriber: string) => {
  await page.navigateToMapWithBerth(berthId, trainDescriber);
});

Then('the shunt signal state for signal {string} is {word}',
  async (signalId: string, expectedSignalColour: string) => {
    const expectedSignalColourHex = mapColourHex[expectedSignalColour];

    await browser.wait(async () => {
      const actualSignalColourHexWait = await mapPageObject.getShuntSignalColour(signalId);
      return (actualSignalColourHexWait === expectedSignalColourHex);
    }, browser.params.replay_timeout, `The shunt signal state for signal ${signalId} was not ${expectedSignalColour}`);

    const actualSignalColourHex = await mapPageObject.getShuntSignalColour(signalId);
    expect(actualSignalColourHex, `shunt signal for ${signalId} is not the correct colour`)
      .to.equal(expectedSignalColourHex);
  });

When('I launch a new map {string} the new map should have start time from the moment it was opened', async (mapName: string) => {
  await mapPageObject.clickMapName();
  await mapPageObject.enterReplayMapSearchString(mapName);
  await mapPageObject.launchReplayMap();
});

When('I launch a new replay map {string}', async (mapName: string) => {
  await mapPageObject.clickMapName();
  await mapPageObject.enterReplayMapSearchString(mapName);
  await mapPageObject.launchReplayMap();
});

When('I launch a new map {string}', async (mapName: string) => {
  await mapPageObject.clickMapName();
  await mapPageObject.enterMapSearchString(mapName);
  await mapPageObject.launchMap();
});

Then('the TRTS status for signal {string} is {word}',
  async (signalId: string, expectedSignalStatus: string) => {
    await browser.wait(async () => {
      const expectedSignalStatusHexWait = mapColourHex[expectedSignalStatus];
      const actualSignalStatusWait: string = await mapPageObject.getTrtsStatus(signalId);
      return (actualSignalStatusWait === expectedSignalStatusHexWait);
    }, browser.params.replay_timeout, `The TRTS status for signal ${signalId} was not ${expectedSignalStatus}`);

    const expectedSignalStatusHex = mapColourHex[expectedSignalStatus];
    const actualSignalStatus: string = await mapPageObject.getTrtsStatus(signalId);
    expect(actualSignalStatus, `TRTS status for ${signalId} is not correct`)
      .to.equal(expectedSignalStatusHex);
  });

Then('the level crossing barrier status of {string} is {word}',
  async (lvlCrossingId: string, expectedStatus: string) => {
    const actualBarrierStatus: string = await CommonActions
      .waitForFunctionalStringResult(mapPageObject.getLvlCrossingBarrierState, lvlCrossingId, expectedStatus);
    expect(actualBarrierStatus, `level crossing barrier status for ${lvlCrossingId} is not correct`)
      .to.equal(expectedStatus);
  });

Then('the direction lock chevron of {string} is {word}',
  async (directionLockId: string, expectedStatus: string) => {
    await browser.wait(async () => {
      const actualBarrierStatusWait = await mapPageObject.getLvlCrossingBarrierState(directionLockId);
      return (actualBarrierStatusWait === expectedStatus);
    }, browser.params.replay_timeout, `The direction lock chevron of ${directionLockId} is not ${expectedStatus}`);
    const actualBarrierStatus = await mapPageObject.getLvlCrossingBarrierState(directionLockId);
    expect(actualBarrierStatus, `direction lock chevron for ${directionLockId} is not correct`)
      .to.equal(expectedStatus);
  });

Then('the direction lock chevrons are not displayed',
  async () => {
    browser.wait(async () => {
      const chevronsDisplayed = await mapPageObject.isDirectionChevronDisplayed();
      return (chevronsDisplayed === false);
    }, browser.params.replay_timeout, `The direction lock chevrons were displayed, but should not have been`);
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
  await mapPageObject.clickScheduleForTrainDescription(trainDescription, protractor.Button.RIGHT);
});

When(/^I click on the map for train (.*)$/, async (trainDescription: string) => {
  await mapPageObject.clickScheduleForTrainDescription(trainDescription, protractor.Button.LEFT);
});

When(/^I disable waiting for angular$/, async () => {
  await browser.waitForAngularEnabled(false);
});

When(/^I enable waiting for angular$/, async () => {
  await browser.waitForAngularEnabled(true);
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
  const actualContextMenuItem: string = await CommonActions.waitAndGetText(mapPageObject.mapContextMenuItems.get(rowNum - 1));
  expect(actualContextMenuItem.toLowerCase(), `Map menu item not as expected`).to.contain(expectedText.toLowerCase());
});

Then(/^the map context menu punctuality is one of (.*)$/, async (expectedList: string) => {
  const possibleValues = expectedList.split(',');
  const punctuality: string = await mapPageObject.getContextMenuPunctuality();
  expect(punctuality, `Map menu punctuality not as expected`).to.be.oneOf(possibleValues);
});

Then('the map context menu does not contain {string} on line {int}', async (expectedText: string, rowNum: number) => {
  const actualContextMenuItem: string = await mapPageObject.mapContextMenuItems.get(rowNum - 1).getText();
  expect(actualContextMenuItem, `Map menu item not as expected`).to.not.contain(expectedText);
});

Then('the map context menu has {string} on line {int}', async (expectedText: string, rowNum: number) => {
  const actualContextMenuItem: string = await mapPageObject.mapContextMenuItems.get(rowNum - 1).getText();
  expect(actualContextMenuItem, `Map menu item not as expected`).to.equal(expectedText);
});

Then('the track state width for {string} is {string}',
  async (trackId: string, expectedWidth: string) => {
    const actualWidth = await mapPageObject.getTrackWidth(trackId);
    expect(actualWidth, `Track width for ${trackId} is not as expected`)
      .to.equal(expectedWidth);
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
    await browser.wait(async () => {
      for (const trackId of expectedTrackIds) {
        const actualTrackColour: string = await mapPageObject.getTrackColour(trackId);
        const actualTrackWidth: string = await mapPageObject.getTrackWidth(trackId);
        if ((actualTrackColour !== expectedTrackColourHex) || (actualTrackWidth !== expectedTrackWidth)) {
          return false;
        }
      }
      return true;
    }, browser.params.replay_timeout, `Tracks ${trackIds} were not displayed in ${expectedWidth} ${expectedColour}`);
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

When(/^I click on (Highlight|Unhighlight) link$/, async (highlightOption: string) => {
  await mapPageObject.trainHighlight(highlightOption);
});

When(/^I click on the clear berth option$/, async () => {
  await mapPageObject.clearBerth();
});

Then('the berth context menu is displayed with berth name {string}', async (expectedBerthName: string) => {
  const berthName: string = await mapPageObject.getBerthName();
  expect(berthName).to.equal(expectedBerthName);
});

Then('the train headcode color for berth {string} is {word}',
  async (berthId: string, expectedColor: string) => {
    await browser.wait(async () => {
      const expectedColorHex = mapColourHex[expectedColor];
      const actualBerthColour = await mapPageObject.getBerthColor(berthId);
      await CucumberLog.addText(`Expecting ${actualBerthColour} to be ${expectedColorHex}`);
      return (actualBerthColour === expectedColorHex);
    }, browser.params.general_timeout, `Berth colour was not ${expectedColor}, see info for more details`);
  });

Then('the train headcode color for berth {string} is {word} or {word}',
  async (berthId: string, expectedColor1: string, expectedColor2: string) => {
    await browser.wait(async () => {
      const expectedColor1Hex = mapColourHex[expectedColor1];
      const expectedColor2Hex = mapColourHex[expectedColor2];
      const actualBerthColour = await mapPageObject.getBerthColor(berthId);
      await CucumberLog.addText(`Expecting ${actualBerthColour} to be ${expectedColor1Hex} or ${expectedColor2Hex}`);
      return ((actualBerthColour === expectedColor1Hex) || (actualBerthColour === expectedColor2Hex));
    }, browser.params.general_timeout, `Berth colour was not ${expectedColor1} or ${expectedColor2}, see info for more details`);
  });

Then('the train highlight color for berth {string} is {word}',
  async (berthId: string, expectedColor: string) => {
    const expectedColorHex = mapColourHex[expectedColor];
    const actualColorHex: string = await mapPageObject.getBerthColor(berthId);
    expect(actualColorHex, 'Headcode colour is not ' + expectedColor)
      .to.equal(expectedColorHex);
  });

Then(/^the (?:train|signal) in berth (\w+) is highlighted$/,
  async (berthId: string) => {
    await browser.wait(() => {
      return mapPageObject.isBerthHighlighted(berthId);
    }, browser.params.general_timeout, `The train in berth ${berthId} was not highlighted`);
  });

Then(/^the (?:train|signal) in berth (\w+) is highlighted on page load$/,
  async (berthId: string) => {
    await browser.waitForAngularEnabled(false);
    await browser.wait(() => {
      return mapPageObject.isBerthTempHighlighted(berthId);
    }, browser.params.general_timeout, `The train in berth ${berthId} was not highlighted`);
    await browser.waitForAngularEnabled(true);
  });

Then(/^the train in berth (\w+) is not highlighted$/,
  async (berthId: string) => {
    // needed when checking replay
    await browser.waitForAngularEnabled(false);
    const berthIsHighlighted: boolean = await mapPageObject.isBerthHighlighted(berthId);
    expect(berthIsHighlighted, `The train in berth ${berthId} was highlighted`)
      .to.equal(false);
    await browser.waitForAngularEnabled(true);
  });

Then('the menu is displayed with {string} option',
  async (expectedText: string) => {
    const actualText = await mapPageObject.getTrainHighlightText();
    expect(actualText).to.equal(expectedText);
  });

Then(/^the rectangle colour for berth (\w+) (is|is not) (\w+) meaning (.*)$/,
  async (berthId: string, negate: string, verificationColour: string, explanation: string) => {
    const expectedRectangleColourHex = mapColourHex[verificationColour];
    const actualRectangleColour: string = await mapPageObject.getBerthRectangleColour(berthId);
    if (negate === 'is not')
    {
      expect(actualRectangleColour,
        'Berth rectangle colour is ' + verificationColour + ' meaning ' + explanation + ', which is unexpected')
        .to.not.equal(expectedRectangleColourHex);
    }
    else
    {
      expect(actualRectangleColour,
        'Berth rectangle colour is not ' + verificationColour + ' - ' + explanation + ', it is ' + actualRectangleColour)
        .to.equal(expectedRectangleColourHex);
    }
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

Then('the punctuality color for berth {string} is {word}',
  async (berthId: string, expectedColor: string) => {
    const expectedColorHex = mapColourHex[expectedColor];
    const actualColorHex: string = await mapPageObject.getBerthColor(berthId);
    expect(actualColorHex, 'Punctuality colour is not ' + expectedColor)
      .to.equal(expectedColorHex);
  });

Then('the manual trust berth type for {string} is {word}',
  async (berthId: string, expectedType: string) => {
    const actualType: string = await mapPageObject.getManualBerthType(berthId);
    expect(actualType, 'Manual Berth type is not ' + expectedType)
      .to.equal(expectedType);
  });

Then(/^the (Matched|Unmatched|Left behind Matched) version of the (Schedule-matching|Non-Schedule-matching) map context menu is displayed$/,
  async (matchType: string, userType: string) => {
  await mapPageObject.waitForContextMenu();
  let expected1;
  let expected2;
  let expected3;
  let expected4;
  let expected5;
  if (userType === 'Schedule-matching') {
    if (matchType === 'Matched') {
      expected1 = 'Open Timetable';
      expected2 = 'Unmatch/Rematch';
      expected3 = 'Turn Path On';
      expected4 = 'Highlight';

    } else if (matchType === 'Left behind Matched') {
      expected1 = 'Open Timetable';
      expected2 = 'Unmatch/Rematch';
      expected3 = 'Turn Path On';
      expected4 = 'Clear Berth';
      expected5 = 'Highlight';

    } else {
      expected1 = 'No Timetable';
      expected2 = 'Match';
      expected3 = 'Highlight';
    }
  } else {
    if (matchType === 'Matched') {
      expected1 = 'Open Timetable';
      expected2 = 'Turn Path On';
      expected3 = 'Highlight';

    } else if (matchType === 'Left behind Matched') {
      expected1 = 'Open Timetable';
      expected2 = 'Turn Path On';
      expected3 = 'Clear Berth';
      expected4 = 'Highlight';

    } else {
      expected1 = 'No Timetable';
      expected2 = 'Highlight';
    }
  }
  const contextMenuItem1: string = await mapPageObject.getMapContextMenuItem(2);
  const contextMenuItem2: string = await mapPageObject.getMapContextMenuItem(3);
  expect(contextMenuItem1.toLowerCase(), `Context menu does not imply ${userType} ${matchType} state - does not contain ${expected1}`)
    .to.contain(expected1.toLowerCase());
  expect(contextMenuItem2.toLowerCase(), `Context menu does not imply ${userType} ${matchType} state - does not contain ${expected2}`)
    .to.contain(expected2.toLowerCase());
  if (expected3 != null) {
    const contextMenuItem3: string = await mapPageObject.getMapContextMenuItem(4);
    expect(contextMenuItem3.toLowerCase(), `Context menu does not imply ${userType} ${matchType} state - does not contain ${expected3}`)
      .to.contain(expected3.toLowerCase());
  }
  if (expected4 != null) {
    const contextMenuItem4: string = await mapPageObject.getMapContextMenuItem(5);
    expect(contextMenuItem4.toLowerCase(), `Context menu does not imply ${userType} ${matchType} state - does not contain ${expected4}`)
      .to.contain(expected4.toLowerCase());
  }
  if (expected5 != null) {
    const contextMenuItem5: string = await mapPageObject.getMapContextMenuItem(6);
    expect(contextMenuItem5.toLowerCase(), `Context menu does not imply ${userType} ${matchType} state - does not contain ${expected5}`)
      .to.contain(expected5.toLowerCase());
  }
});

Then(/^the Matched or Left behind Matched version of the Schedule-matching map context menu (is|is not) displayed$/,
  async (negate: string) => {
  await mapPageObject.waitForContextMenu();
  const expected1 = 'Open Timetable';
  const expected2 = 'Unmatch/Rematch';
  const expected3 = 'Turn Path On';
  const contextMenuItem1: string = await mapPageObject.getMapContextMenuItem(2);
  const contextMenuItem2: string = await mapPageObject.getMapContextMenuItem(3);
  const contextMenuItem3: string = await mapPageObject.getMapContextMenuItem(4);
  if (negate === 'is') {
    expect(contextMenuItem1.toLowerCase(), `Context menu does not imply a matched state - does not contain ${expected1}`)
      .to.contain(expected1.toLowerCase());
    expect(contextMenuItem2.toLowerCase(), `Context menu does not imply a matched state - does not contain ${expected2}`)
      .to.contain(expected2.toLowerCase());
    expect(contextMenuItem3.toLowerCase(), `Context menu does not imply a matched state - does not contain ${expected3}`)
      .to.contain(expected3.toLowerCase());
  } else {
    expect(contextMenuItem1.toLowerCase(), `Context menu implies a matched state - contains ${expected1}`)
      .to.not.contain(expected1.toLowerCase());
    expect(contextMenuItem2.toLowerCase(), `Context menu implies a matched state - contains ${expected2}`)
      .to.not.contain(expected2.toLowerCase());
    expect(contextMenuItem3.toLowerCase(), `Context menu implies a matched state - contains ${expected3}`)
      .to.not.contain(expected3.toLowerCase());
  }
});

When(/^I wait for the option to (Match|Unmatch) train description (\w+) in berth (\w+), describer (\w+) to be available$/,
  async (matchIndicator: string, trainDescription: string, berth: string, describer: string) => {
    if (trainDescription.includes('generated')) {
      trainDescription = browser.referenceTrainDescription;
    }
    const optionAvailable: boolean = await mapPageObject.waitForMatchIndication(trainDescription, matchIndicator, berth, describer, 3);
    expect(optionAvailable).to.equal(true);
});

When(/^I wait for the (Open|No) timetable option for train description (\w+) in berth (\w+), describer (\w+) to be available$/,
  async (matchIndicator: string, trainDescription: string, berth: string, describer: string) => {
    if (trainDescription.includes('generated')) {
      trainDescription = browser.referenceTrainDescription;
    }
    const optionAvailable: boolean = await mapPageObject.waitForMatchIndication(trainDescription, matchIndicator, berth, describer, 2);
    expect(optionAvailable).to.equal(true);
  });

Given(/^I have cleared out all headcodes$/, async () => {
  await new TMVRedisUtils().clearBerths(false);
});

Given(/^headcode '(.*)' is present in manual\-trust berth '(.*)'$/, async (headcode: string, berthID: string) => {
  await browser.wait(async () => {
    return (await mapPageObject.getHeadcodesAtManualTrustBerth(berthID)).includes(headcode);
  }, browser.params.general_timeout, `headcode ${headcode} not in manual trust berth stack ${berthID} when should be`);
});

Given(/^headcode '(.*)' is not present in manual\-trust berth '(.*)'$/, async (headcode: string, berthID: string) => {
  await browser.wait(async () => {
    return !(await mapPageObject.getHeadcodesAtManualTrustBerth(berthID)).includes(headcode);
  }, 30000, `headcode ${headcode} in manual trust berth stack ${berthID} when shouldn't be`);
});

Given(/^I wait for the tracks to be displayed$/, {timeout: 40000}, async () => {
  await MapPageObject.waitForTracksToBeDisplayed();
});

Then(/^the train remains (matched|unmatched) throughout the following berth steps$/,
  async (matchState: string, berthStepsDataTable: any) => {
  const berthStepsRequired = berthStepsDataTable.hashes();
  for (const requiredBerthStep of berthStepsRequired) {
    // open appropriate map
    if (! await mapPageObject.isCurrentMap(requiredBerthStep.map)) {
      const url = '/tmv/maps/' + requiredBerthStep.map;
      await appPage.navigateTo(url);
      await MapPageObject.waitForTracksToBeDisplayed();
    }

    // step train
    let trainDescription = requiredBerthStep.trainDescription;
    if (trainDescription.includes('generated')) {
      trainDescription = browser.referenceTrainDescription;
    }
    const berthCancel: BerthCancel = new BerthCancel(
      requiredBerthStep.fromBerth,
      DateAndTimeUtils.getCurrentTimeString(),
      requiredBerthStep.fromTrainDescriber,
      trainDescription
    );
    await CucumberLog.addJson(berthCancel);
    await linxRestClient.postBerthCancel(berthCancel);
    await linxRestClient.waitMaxTransmissionTime();
    await linxRestClient.postInterpose(
      DateAndTimeUtils.getCurrentTimeString(),
      requiredBerthStep.toBerth, requiredBerthStep.toTrainDescriber, trainDescription);
    await linxRestClient.waitMaxTransmissionTime();

    // check match status
    await mapPageObject.rightClickBerth(`${requiredBerthStep.toTrainDescriber}${requiredBerthStep.toBerth}`);
    await mapPageObject.waitForContextMenu();
    const contextMenuItem: string = await mapPageObject.getMapContextMenuItem(2);
    if (matchState === 'matched') {
      expect(contextMenuItem.toLowerCase(), `Context menu does not imply matched state - does not contain 'Open Timetable'`)
        .to.contain('open timetable');
    }
    else {
      expect(contextMenuItem.toLowerCase(), `Context menu does not imply matched state - does not contain 'Open Timetable'`)
        .to.contain('no timetable');
    }
  }
});
