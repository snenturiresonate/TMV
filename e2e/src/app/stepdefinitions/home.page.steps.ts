import {Then, When} from 'cucumber';
import {expect} from 'chai';

import {HomePageObject} from '../pages/home.page';
import {browser} from 'protractor';
import {WelcomeModalPage} from '../pages/welcome-modal-dialogue.page';

const homePage: HomePageObject = new HomePageObject();
const welcomeModal = new WelcomeModalPage();

Then('the home icon is displayed', async () => {
  const isDisplayed: boolean = await homePage.homeIconIsDispayed();
  expect(isDisplayed, 'Home icon is not displayed').to.equal(true);
});

Then('the new tab icon is displayed', async () => {
  const isDisplayed: boolean = await homePage.newTabIconIsDispayed();
  expect(isDisplayed, 'New tab icon is not displayed').to.equal(true);
});

Then('the user profile icon is displayed', async () => {
  const isDisplayed: boolean = await homePage.userProfileIconIsDispayed();
  expect(isDisplayed, 'User profile icon is not displayed').to.equal(true);
});

Then('the help icon is displayed', async () => {
  const isDisplayed: boolean = await homePage.helpIconIsDispayed();
  expect(isDisplayed, 'Help icon is not displayed').to.equal(true);
});

Then('the time is displayed', async () => {
  const isDisplayed: boolean = await homePage.timeIsDispayed();
  expect(isDisplayed, 'Time is not displayed').to.equal(true);
});

Then(/^the map search box (is|is not) displayed$/, async (adverb: string) => {
  if (adverb === 'is') {
    const isDisplayed: boolean = await homePage.mapSearchBoxIsDisplayed();
    expect(isDisplayed, 'Map search box is not displayed').to.equal(true);
    return;
  }
  const isNotDisplayed: boolean = await homePage.mapSearchBoxIsNotDisplayed();
  expect(isNotDisplayed, 'Map search box is displayed').to.equal(true);
});

Then(/^the recent maps section (is|is not) displayed$/, async (adverb: string) => {
  if (adverb === 'is') {
    const isDisplayed: boolean = await homePage.recentMapsBoxIsDisplayed();
    expect(isDisplayed, 'Recent maps are not displayed').to.equal(true);
    return;
  }
  const isNotDisplayed: boolean = await homePage.recentMapsBoxIsNotDisplayed();
  expect(isNotDisplayed, 'Recent maps are displayed').to.equal(true);
});

Then(/^the all maps section (is|is not) displayed$/, async (adverb: string) => {
  if (adverb === 'is') {
    const isDisplayed: boolean = await homePage.allMapsHeaderIsDisplayed();
    expect(isDisplayed, 'All maps are not displayed').to.equal(true);
    return;
  }
  const isNotDisplayed: boolean = await homePage.allMapsHeaderIsNotDisplayed();
  expect(isNotDisplayed, 'All maps are displayed').to.equal(true);
});

Then('the welcome message should read {string}', async (expectedMessage: string) => {
  const message: string = await homePage.getWelcomeMessageText();
  expect(message, `Welcome message is not as expected`)
    .to.equal(expectedMessage);
});

When('I expand the group of maps located at position number {int}', async (position: number) => {
  await homePage.expandMapGrouping(position);
});

When('I expand the group of maps with name {string}', async (mapName: string) => {
  await homePage.expandMapGroupingForName(mapName);
});

Then('the maps listed include {string}', async (location: string) => {
  const maps: string = await homePage.getMapsListed();
  expect(maps.toString(), `${location} not present in maps list`)
    .to.contain(location);
});

Then('the maps listed do not include {string}', async (location: string) => {
  const maps: string = await homePage.getMapsListed();
  expect(maps, `${location} was present in maps list when it shouldn't`)
    .to.not.contain(location);
});

Then('the app list contains the following apps', async (appsDataTable: any) => {
  const expectedAppNames: any = appsDataTable.hashes();
  const actualAppNames: string = await homePage.getAppNames();

  expectedAppNames.forEach((expectedAppName: any) => {
    expect(actualAppNames, `${expectedAppName.app} not found in the apps list`)
      .to.contain(expectedAppName.app);
  });
});

Then('the app list does not contain the following apps', async (appsDataTable: any) => {
  const expectedAppNames: any = appsDataTable.hashes();
  const actualAppNames: string = await homePage.getAppNames();

  expectedAppNames.forEach((expectedAppName: any) => {
    expect(actualAppNames, `${expectedAppName.app} was found in the apps list`)
      .to.not.contain(expectedAppName.app);
  });
});

When('I navigate to the maps view with id {word}', async (mapId: string) => {
  await homePage.openMap(mapId);
});

When('I navigate to the next page of the recent history results', async () => {
  await homePage.clickNextPageOfRecentHistoryResults();
});

When('I navigate to the previous page of the recent history results', async () => {
  await homePage.clickPreviousPageOfRecentHistoryResults();
});

When('I switch back to the home page tab', async () => {
  const handles: string[] = await browser.getAllWindowHandles();
  await browser.switchTo().window(handles[0]);
});

Then('the recent history map with index {int} is listed with {string}', async (recentHistoryIndex: number, location: string) => {
  const mapName: string = await homePage.getRecentHistoryMapName(recentHistoryIndex);
  expect(mapName, `item ${recentHistoryIndex} in recent history maps was not ${location}`)
    .to.contain(location);
});

Then('the recent history map with id {int} is not listed', async (id: number) => {
  const isPresent: boolean = await homePage.checkRecentHistoryMapNameIsPresent(id);
  expect(isPresent, `Recent map with ${id} is listed when it shouldn't be`)
    .to.equal(false);
});

When('I type {string} into the map search box', async (text: string) => {
  await homePage.enterMapSearchString(text);
});

Then('the map Search Box has the value {string}', async (expectedText: string) => {
  const message: string = await homePage.getMapSearchBoxText();
  expect(message, `${expectedText} not found in the map search box`)
    .to.equal(expectedText);
});

Then('the maps auto-suggest list has {int} entries', async (mapCount: number) => {
  const mapAutoSuggestSearchResults: string = await homePage.getMapAutoSuggestSearchResults();
  expect(mapAutoSuggestSearchResults.length, `Expecting ${mapCount} entries to be returned from maps auto-suggest`)
    .to.equal(mapCount);
});

Then('the maps auto-suggest list is hidden', async () => {
  const isDisplayed: boolean = await homePage.isMapAutoSuggestSearchResultDisplayed();
  const isHidden: boolean = !isDisplayed;
  expect(isHidden, `Maps auto-suggest was not hidden`)
    .to.equal(true);
});

Then('the maps auto-suggest list is not hidden', async () => {
  const isDisplayed: boolean = await homePage.isMapAutoSuggestSearchResultDisplayed();
  const isHidden: boolean = !isDisplayed;
  expect(isHidden, `Maps auto-suggest was hidden`)
    .to.equal(false);
});

Then('the maps auto-suggest list contains {string} at position {int}', async (expectedText: string, position: number) => {
  const actualMapNames: string = await homePage.getMapAutoSuggestSearchResults();
  expect(actualMapNames[position - 1], `item ${position} in maps auto-suggest was not ${expectedText}`)
    .to.equal(expectedText);
});

When('I click the app {string}', async (appName: string) => {
  await homePage.clickIcon(appName);
});

When('I click the search icon', async () => {
  await homePage.clickSearchButton();
});

When('I click on the recently searched Map', async () => {
  await homePage.openRecentMap();
});

When('I hit return', async () => {
  await homePage.enterReturnInSearchBox();
});

When('I select the map at position {int} in the search results list', async (position: number) => {
  await homePage.clickMapSearchResult(position);
});

Then('the maps search results list is hidden', async () => {
  const isDisplayed: boolean = await homePage.isMapSearchResultListDisplayed();
  const isHidden: boolean = !isDisplayed;
  expect(isHidden, `Maps search list is not hidden`)
    .to.equal(true);
});

Then('the maps search results list is not hidden', async () => {
  const isDisplayed: boolean = await homePage.isMapSearchResultListDisplayed();
  const isHidden: boolean = !isDisplayed;
  expect(isHidden, `Maps search list is hidden`)
    .to.equal(false);
});

Then('the maps search results list contains {int} items', async (mapCount: number) => {
  const mapSearchResults: string = await homePage.getMapSearchResults();
  expect(mapSearchResults.length, `Expect ${mapCount} maps to be in the maps search results list`)
    .to.equal(mapCount);
});

Then('the maps search results list contains {string} at position {int}', async (expectedText: string, position: number) => {
  const actualMapNames: string = await homePage.getMapSearchResults();
  expect(actualMapNames[position - 1], `item ${position} in maps search results list was not ${expectedText}`)
    .to.equal(expectedText);
});

Then('the map at position {int} is not visible', async (position: number) => {
  const isMapSearchResultVisible = await homePage.isMapSearchResultVisible(position);
  expect(isMapSearchResultVisible, `Map at position ${position} is visible`)
    .to.equal(false);
});

Then('the map at position {int} is visible', async (position: number) => {
  const isMapSearchResultVisible = await homePage.isMapSearchResultVisible(position);
  expect(isMapSearchResultVisible, `Map at position ${position} is not visible`)
    .to.equal(true);
});

Then('the maps search results list has a scroll', async () => {
  const visibleTableHeight = await homePage.getMapSearchResultsVisibleHeight();
  const totalTableHeight = await homePage.getMapSearchResultsTotalHeight();
  expect(totalTableHeight, `Table height is not larger than visible table height, no scroll`)
    .to.be.greaterThan(visibleTableHeight);
});

Then('the maps search results list has no scroll', async () => {
  const visibleTableHeight = await homePage.getMapSearchResultsVisibleHeight();
  const totalTableHeight = await homePage.getMapSearchResultsTotalHeight();
  expect(totalTableHeight, `Table height is larger than visible table height, there should be no scroll`)
    .to.be.at.most(visibleTableHeight);
});

When(/^I select the replay button from the home page$/, async () => {
  await homePage.replayButton.click();
});

When(/^I dismiss the welcome message$/, async () => {
  await welcomeModal.dismissModal();
});
