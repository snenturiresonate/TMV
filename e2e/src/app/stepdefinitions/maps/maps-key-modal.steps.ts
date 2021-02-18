import {Then, When} from 'cucumber';
import {expect} from 'chai';
import {MapsKeyPageObject} from '../../pages/maps/maps-key-modal.page';
import {CssColorConverterService} from '../../services/css-color-converter.service';

const mapsKeyPageObject: MapsKeyPageObject = new MapsKeyPageObject();

Then('the following tabs can be seen on the modal', async (tabNameDataTable: any) => {
  const expectedKeyTabNames = tabNameDataTable.hashes();
  const actualKeyTabNames = await mapsKeyPageObject.getKeyTabNames();

  expectedKeyTabNames.forEach((expectedTabName: any) => {
    expect(actualKeyTabNames, `Tab ${expectedTabName.tabName} not present`)
      .to.contain(expectedTabName.tabName);
  });
});

When('I switch to the {string} key tab', async (tabName: string) => {
  switch (tabName) {
    case 'Colour': {
      await mapsKeyPageObject.openColourTab();
      break;
    }
    case 'Symbol': {
      await mapsKeyPageObject.openSymbolTab();
      break;
    }
    case 'Train Describer': {
      await mapsKeyPageObject.openTDTab();
      break;
    }
    default: {
      // statements;
      break;
    }
  }
});

When('I close the TMV key', async () => {
  await mapsKeyPageObject.closeTMVKey();
});

When('I close the TMV key via clicking X', async () => {
  await mapsKeyPageObject.closeTMVKeyX();
});

Then('The TMV Key is no longer displayed', async () => {
  expect(await mapsKeyPageObject.getModalWindow(), `TMV key is still displayed`)
    .to.equal(false);
});

Then('the active tab is {string}', async (expectedActiveTabName: string) => {
  const actualActiveTabName: string = await mapsKeyPageObject.getActiveTabName();

  expect(actualActiveTabName, `Active tab is not ${expectedActiveTabName}`)
    .to.equal(expectedActiveTabName);
});

Then('the key table has columns', async (tabNameDataTable: any) => {
  const expectedColumnNames = tabNameDataTable.hashes();
  const actualColumnNames = await mapsKeyPageObject.getKeyTableColumnNames();

  expectedColumnNames.forEach((expectedColumnName: any) => {
    expect(actualColumnNames, `Column name ${expectedColumnName.colName} not found in Key Table`)
      .to.contain(expectedColumnName.colName);
  });
});

// tslint:disable-next-line:max-line-length
Then('The key punctuality table contains a row at position {int} with text {string} and background colour {string} and font colour {string}',
  async (rowIndex: number, text: string, backgroundColour: string, fontColour: string) => {
    const keyPunctualityText: string = await mapsKeyPageObject.getKeyPunctualityText(rowIndex);
    const keyPunctualityBackgroundColourRgb: string = await mapsKeyPageObject.getKeyPunctualityPropertyValue(rowIndex, 'background-color');
    const keyPunctualityBackgroundColourHex: string = CssColorConverterService.rgba2Hex(keyPunctualityBackgroundColourRgb);
    const keyPunctualityFontColourRgb: string = await mapsKeyPageObject.getKeyPunctualityPropertyValue(rowIndex, 'color');
    const keyPunctualityFontColourHex: string = CssColorConverterService.rgba2Hex(keyPunctualityFontColourRgb);

    expect(keyPunctualityText, `Text was not ${text} for row ${rowIndex}`)
      .to.equal(text);
    expect(keyPunctualityBackgroundColourHex, `Background colour was not ${backgroundColour} for row ${rowIndex}`)
      .to.equal(backgroundColour);
    expect(keyPunctualityFontColourHex, `Font colour was not ${fontColour} for row ${rowIndex}`)
      .to.equal(fontColour);
  });

Then('The key punctuality table contains the following data', async (keyPropertyValues: any) => {
  const expectedKeyPropertyValues: any[] = keyPropertyValues.hashes();
  for (const expectedKeyPropertyValue of expectedKeyPropertyValues) {
    const actualText: string = await mapsKeyPageObject.keyPunctualityEntries.get(expectedKeyPropertyValue.position).getText();
    const actualKeyPunctualityBackgroundColourRgb: string = await mapsKeyPageObject
      .keyPunctualityEntries.get(expectedKeyPropertyValue.position).getCssValue('background-color');
    const actualKeyPunctualityBackgroundColourHex: string = CssColorConverterService.rgba2Hex(actualKeyPunctualityBackgroundColourRgb);
    const actualKeyPunctualityFontColourRgb: string = await mapsKeyPageObject
      .keyPunctualityEntries.get(expectedKeyPropertyValue.position).getCssValue('color');
    const actualKeyPunctualityFontColourHex: string = CssColorConverterService.rgba2Hex(actualKeyPunctualityFontColourRgb);

    expect(actualText, `Text was not ${expectedKeyPropertyValue.text}`)
      .to.equal(expectedKeyPropertyValue.text);
    expect(actualKeyPunctualityBackgroundColourHex, `Background colour was not ${expectedKeyPropertyValue.backgroundColour}`)
      .to.equal(expectedKeyPropertyValue.backgroundColour);
    expect(actualKeyPunctualityFontColourHex, `Font colour was not ${expectedKeyPropertyValue.colour}`)
      .to.equal(expectedKeyPropertyValue.colour);
  }
});

Then('The key berth table contains a row at position {int} with text {string} and background colour {string} and font colour {string}',
  async (rowIndex: number, text: string, backgroundColour: string, fontColour: string) => {
    const keyBerthText: string = await mapsKeyPageObject.getKeyBerthText(rowIndex);
    const keyBerthBackgroundColourRgb: string = await mapsKeyPageObject.getKeyBerthPropertyValue(rowIndex, 'background-color');
    const keyBerthBackgroundColourHex: string = CssColorConverterService.rgba2Hex(keyBerthBackgroundColourRgb);
    const keyBerthFontColourRgb: string = await mapsKeyPageObject.getKeyBerthPropertyValue(rowIndex, 'color');
    const keyBerthFontColourHex: string = CssColorConverterService.rgba2Hex(keyBerthFontColourRgb);

    expect(keyBerthText, `Text was not ${text} for row ${rowIndex}`)
      .to.equal(text);
    expect(keyBerthBackgroundColourHex, `Background colour was not ${fontColour}`)
      .to.equal(backgroundColour);
    expect(keyBerthFontColourHex, `Font colour was not ${fontColour}`)
      .to.equal(fontColour);
  });

Then('The key berth table contains the following data', async (keyBerthValues: any) => {
  const expectedKeyBerthValues: any[] = keyBerthValues.hashes();
  for (const expectedKeyBerthValue of expectedKeyBerthValues) {
    const actualText: string = await mapsKeyPageObject.keyBerthEntries.get(expectedKeyBerthValue.position).getText();
    const actualKeyBerthBackgroundColourRgb: string = await mapsKeyPageObject
      .keyBerthEntries.get(expectedKeyBerthValue.position).getCssValue('background-color');
    const actualKeyBerthBackgroundColourHex: string = CssColorConverterService.rgba2Hex(actualKeyBerthBackgroundColourRgb);
    const actualKeyBerthFontColourRgb: string = await mapsKeyPageObject
      .keyBerthEntries.get(expectedKeyBerthValue.position).getCssValue('color');
    const actualKeyBerthFontColourHex: string = CssColorConverterService.rgba2Hex(actualKeyBerthFontColourRgb);

    expect(actualText, `Text was not ${expectedKeyBerthValue.text}`)
      .to.equal(expectedKeyBerthValue.text);
    expect(actualKeyBerthBackgroundColourHex, `Background colour was not ${expectedKeyBerthValue.backgroundColour}`)
      .to.equal(expectedKeyBerthValue.backgroundColour);
    expect(actualKeyBerthFontColourHex, `Font colour was not ${expectedKeyBerthValue.colour}`)
      .to.equal(expectedKeyBerthValue.colour);
  }
});

Then('the TDs listed contains {string} at position {int}', async (expectedText: string, position: number) => {
  const actualTDNames: string = await mapsKeyPageObject.getTDlist();
  expect(actualTDNames[position - 1], `TD list does not contain ${expectedText} at position ${position}`)
    .to.equal(expectedText);
});

Then('the Line Status listed contains {string} at position {int}', async (expectedText: string, index: number) => {
  const actualTDNames: string = await mapsKeyPageObject.getLineStatuses();
  expect(actualTDNames[index], `Line Status does not contain ${expectedText} at position ${index}`)
    .to.equal(expectedText);
});

Then('the Lineside Features listed contains {string} at position {int}', async (expectedText: string, index: number) => {
  const actualTDNames: string = await mapsKeyPageObject.getLinesideFeatures();
  expect(actualTDNames[index], `Lineside Features does not contain ${expectedText} at position ${index}`)
    .to.equal(expectedText);
});

Then('the Lineside Features list contains the following data', async (lineSideFeatures: any) => {
  const expectedLineSideFeatures: any[] = lineSideFeatures.hashes();
  for (const expectedLineSideFeature of expectedLineSideFeatures) {
    const actualTDNames: string = await mapsKeyPageObject.getLinesideFeatures();
    expect(actualTDNames[expectedLineSideFeature.position], `Lineside Features does not contain ${expectedLineSideFeature.feature}`)
      .to.equal(expectedLineSideFeature.feature);
  }
});

Then('the Line Status list contains the following data', async (lineStatus: any) => {
  const expectedLinesStatus: any[] = lineStatus.hashes();
  for (const expectedLineStatus of expectedLinesStatus) {
    const actualTDNames: string = await mapsKeyPageObject.getLineStatuses();
    expect(actualTDNames[expectedLineStatus.position], `Line Status does not contain ${expectedLineStatus.status}`)
      .to.equal(expectedLineStatus.status);
  }
});

Then('the TD list contains the following data', async (tDNames: any) => {
  const expectedTDNames: any[] = tDNames.hashes();
  for (const expectedTDName of expectedTDNames) {
    const actualTDNames: string = await mapsKeyPageObject.getTDlist();
    expect(actualTDNames[expectedTDName.position - 1], `TD list does not contain ${expectedTDName.name}`)
      .to.equal(expectedTDName.name);
  }
});
