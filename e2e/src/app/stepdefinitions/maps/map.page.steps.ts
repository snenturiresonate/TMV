import {Before, Given, Then, When} from 'cucumber';
import {expect} from 'chai';
import {MapPageObject} from '../../pages/maps/map.page';
import {CssColorConverterService} from '../../services/css-color-converter.service';
import {browser} from 'protractor';
import {SignallingUpdate} from '../../../../../src/app/api/linx/models/signalling-update';
import {LinxRestClient} from '../../api/linx/linx-rest-client';

let page: MapPageObject;
let linxRestClient: LinxRestClient;

Before(() => {
  page = new MapPageObject();
  linxRestClient = new LinxRestClient();
});

const mapPageObject: MapPageObject = new MapPageObject();

const mapObjectColour = {
  red: '#ff0000',
  green: '#00ff00',
  white: '#ffffff',
  orange: '#ffa700',
  grey: '#969696'
};

Given(/^I am viewing the map (.*)$/, async (mapId: string) => {
  await mapPageObject.navigateTo(mapId);
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
    const expectedPresent: boolean = (isPresent == 'true');
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
    const expectedSignalColourHex = mapObjectColour[expectedSignalColour];
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

Given('I am on a map showing berth {string} and in train describer {string}', async (berthId: string, trainDescriber: string) => {
  await page.navigateToMapWithBerth(berthId, trainDescriber);
});
