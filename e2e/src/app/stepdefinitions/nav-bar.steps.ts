import {NavBarPageObject} from '../pages/nav-bar.page';
import {Then, When} from 'cucumber';
import {expect} from 'chai';
import {browser, by, element} from 'protractor';

const navBarPage: NavBarPageObject = new NavBarPageObject();


When('I open the user profile menu', async () => {
  await navBarPage.openUserProfileMenu();
});

When('I click on the layers icon in the nav bar', async () => {
  await navBarPage.openLayersMenu();
});

When('I toggle the {string} toggle {string}', async (toggle: string, toState: string) => {
  await navBarPage.toggle(toggle, toState);
});

When('I toggle path off from the nav bar', async () => {
  await navBarPage.toggleMapPathOff();
});

When('I open map {string} via the recent map list', async (mapName: string) => {
  await navBarPage.changeToRecentMap(mapName);
});

Then('the following map layer toggles can be seen', async (toggleName: any) => {
  const expectedToggleNames = toggleName.hashes();
  const actualToggleNames = await navBarPage.getToggleNames();

  expectedToggleNames.forEach((expectedToggleName: any) => {
    expect(actualToggleNames, `Toggle ${expectedToggleName.toggle} is not present in the map toggles`)
      .to.contain(expectedToggleName.toggle);
  });
});

Then('{string} toggle is displayed in the title bar', async (expectedState: string) => {
  const actualState: boolean = await browser.isElementPresent(navBarPage.mapPathToggle);
  if (expectedState === 'no') {
    expect(actualState, `PATH toggle is being displayed when it shouldn't be`)
      .to.equal(false);
  }
  else {
    const mapPathIndicator = await navBarPage.mapPathToggle.getText();
    expect(mapPathIndicator, `PATH toggle is not shown when it should be`)
      .to.equal(expectedState);
  }
});

Then('the {string} toggle is {string}', async (toggle: string, expectedToggleState: string) => {
  const actualToggleState: string = await navBarPage.getToggleState(toggle);
  expect(actualToggleState, `Toggle ${toggle} is not ${expectedToggleState}`)
    .to.equal(expectedToggleState);
});

Then('The user profile shows display name as {string}', async (displayName: string) => {
  const displayNameText: string = await navBarPage.getUserProfileMenuDisplayName();
  expect(displayName, 'User profile name is not correct')
    .to.equal(displayNameText);
});

Then('The user profile shows role name as {string}', async (roleName: string) => {
  const roleNameText: string = await navBarPage.getUserProfileMenuRoleName();
  expect(roleName, 'User profile role is not correct')
    .to.equal(roleNameText);
});

Then('The user profile shows user roles as', async (table: any) => {
  const tableValues = table.hashes();
  const roleNameText: string = await navBarPage.getUserProfileMenuRoleName();
  tableValues.forEach(row => {
    expect(roleNameText, 'User profile role is not correct')
      .to.equal(row.roleName);
  });
});

Then('the following icons can be seen on the navigation bar', async (iconNameDataTable: any) => {
  const expectedNavbarIconNames = iconNameDataTable.hashes();
  const actualNavbarIconNames = await navBarPage.getNavbarIconNames();

  expectedNavbarIconNames.forEach((expectedIconName: any) => {
    expect(actualNavbarIconNames, `Icon ${expectedIconName.iconName} is not present in the nav bar`)
      .to.contain(expectedIconName.iconName);
  });
});

When('I click on the Settings', async () => {
  await navBarPage.openSettingsMenu();
});

Then('Version number should be displayed as {string}', async (expectedVersionNo: string) => {
  const actualVersionNo: string = await navBarPage.getVersionNumber();
  expect(actualVersionNo, 'Version number is not correct')
    .to.equal(expectedVersionNo);
});

Then('Configuration should be displayed as {string}', async (expConfigOption: string) => {
  const actualConfigOption: string = await navBarPage.getTmvListConfig();
  expect(actualConfigOption, `Configuration is not displayed as ${expConfigOption}`)
    .to.equal(expConfigOption);
});

When('I click on the TMV Trains list option', async () => {
  await navBarPage.openTmvTrainsListConfig();
});

When('I click on the launch icon', async () => {
  await navBarPage.clickLaunch();
});

When('I click on the Resonate Home logo', async () => {
  await navBarPage.clickHome();
});

Then('The current time is displayed as {string}', async (currentTime: string) => {
  browser.wait(async () => {
    return element(by.id('nav-bar-current-time')).isPresent();
  }, browser.displayTimeout, 'The current time should be displayed');

  const currentTimeText: string = await navBarPage.getCurrentTimeText();
  expect(currentTime, `Current time is not displayed as ${currentTimeText}`)
    .to.equal(currentTimeText);
});

Then('the Train Search Box has the value {string}', async (expectedText: string) => {
  const actualPlaceHolder: string = await navBarPage.getTrainSearchBoxText();
  expect(actualPlaceHolder, 'The train search box value is not correct')
    .to.equal(expectedText);
});

Then('the user enter the value {string}', async (searchValue: string) => {
  await navBarPage.enterSearchValue(searchValue);
});

When('I click on the Search icon', async () => {
  await navBarPage.clickSearchIcon();
});


When(/^I search (Train|Signal|Timetable) for '(.*)'$/, async (filter: string, searchFor: string) => {
  await navBarPage.setSearchFilter(filter);
  await navBarPage.enterSearchValue(searchFor);
  await navBarPage.clickSearchIcon();
});

Then('the option in the train search is displayed as {string}', async (expectedValue: string) => {
  const actualDropdownValue: string = await navBarPage.getTrainSearchValue();
  expect(actualDropdownValue, `The search option is not ${expectedValue}`)
    .to.equal(expectedValue);
});

Then('Train Search icon is displayed as {string}', async (expectedSearchText: string) => {
  const actualSearchText: string = await navBarPage.getTrainSearchBtnValue();
  expect(actualSearchText, `the search button value is not ${expectedSearchText}`)
    .to.equal(expectedSearchText);
});

When('I click on the Train search', async () => {
  await navBarPage.clickTrainSearch();
});

When('I click on the Signal option', async () => {
  await navBarPage.selectSignalOption();
});

When('I click on the Timetable option', async () => {
  await navBarPage.selectTimetableOption();
});

When('I invoke the context menu from the nav bar', async () => {
  await navBarPage.rightClick();
});

Then('the Train search table is shown', async () => {
  const actualTrainTable = await navBarPage.isTrainTablePresent();
  expect(actualTrainTable, `Train search table is not displayed`)
    .to.equal(true);
});

Then('the timetable search table is shown', async () => {
  const actualTimetable = await navBarPage.isTimetablePresent();
  expect(actualTimetable, `Timetable is not displayed`)
    .to.equal(true);
});

Then('the signal search table is shown', async () => {
  const actualSignalTable = await navBarPage.isSignalTablePresent();
  expect(actualSignalTable, `Signal search table is not displayed`)
    .to.equal(true);
});

Then('the search table is shown', async () => {
  const actualSearchTable = await navBarPage.isSearchTablePresent();
  expect(actualSearchTable, `Search table is not displayed`)
    .to.equal(true);
});

Then('Warning Message is displayed for minimum characters', async () => {
  const trainWarningMessage = await navBarPage.isTrainTableWarningPresent();
  expect(trainWarningMessage, `Minimum characters warning is not displayed`)
    .to.equal(true);
});

Then('the Train search table is not shown', async () => {
  const actualTrainTable = await navBarPage.isTrainTablePresent();
  expect(actualTrainTable, `Train search table shown when it shouldn't`)
    .to.equal(false);
});

Then('I click close icon on the top of table', async () => {
  await navBarPage.trainClickCloseIcon();
});

Then('I click close button at the bottom of table', async () => {
  await navBarPage.trainClickCloseBtn();
});

Then('I click on the Unmatched status', async () => {
  await navBarPage.unmatchedStatus();
});

Then('the window title is displayed as {string}', async (expectedTitle: string) => {
  const actualTitle: string = await navBarPage.getTrainWindowTitle();
  expect(actualTitle, `Window title does not contain ${expectedTitle}`)
    .to.contain(expectedTitle);
});

Then('the table column header is {string}', async (expectedTitle: string) => {
  const actualTitle: string = await navBarPage.getTableColumnHeader();
  expect(actualTitle, `Table column header does not contain ${expectedTitle}`)
    .to.contain(expectedTitle);
});

Then('the timetable column header is {string}', async (expectedTitle: string) => {
  const actualTitle: string = await navBarPage.getTimeTableColumnHeader();
  expect(actualTitle, `Timetable column header does not contain ${expectedTitle}`)
    .to.contain(expectedTitle);
});

Then('the signal column header is {string}', async (expectedHeader: string) => {
  const actualHeader: string = await navBarPage.getSignalColumnHeader();
  expect(actualHeader, `Signal column header does not contain ${expectedHeader}`)
    .to.contain(expectedHeader);
});

Then('the trains context menu is not shown', async () => {
  const isTrainsContextMenuVisible: boolean = await navBarPage.isContextMenuDisplayed();
  expect(isTrainsContextMenuVisible, `Trains context menu is shown when it shouldn't`)
    .to.equal(false);
});

Then('the {string} context menu is not displayed', async (searchType: string) => {
  let isContextMenuVisible = true;
  if (searchType === 'Train') {
    isContextMenuVisible = await navBarPage.isContextMenuDisplayed();
  }
  if (searchType === 'Timetable') {
    isContextMenuVisible = await navBarPage.isTimetableContextMenuDisplayed();
  }
  if (searchType === 'Signal') {
    isContextMenuVisible = await navBarPage.isSignalContextMenuDisplayed();
  }
  expect(isContextMenuVisible, `The ${searchType} context menu is shown when it shouldn't be`).to.equal(false);
});

Then('the {string} context menu is displayed', async (searchType: string) => {
  let isContextMenuVisible = false;
  if (searchType === 'Train') {
    isContextMenuVisible = await navBarPage.isContextMenuDisplayed();
  }
  if (searchType === 'Timetable') {
    isContextMenuVisible = await navBarPage.isTimetableContextMenuDisplayed();
  }
  if (searchType === 'Signal') {
    isContextMenuVisible = await navBarPage.isSignalContextMenuDisplayed();
  }
  expect(isContextMenuVisible, `The ${searchType} context menu is not shown`).to.equal(true);
});

Then('the trains context menu is displayed', async () => {
  const isTrainsContextMenuVisible: boolean = await navBarPage.isContextMenuDisplayed();
  expect(isTrainsContextMenuVisible, `Trains context menu is not shown`)
    .to.equal(true);
});

Then('the timetable context menu is displayed', async () => {
  const isTrainsContextMenuVisible: boolean = await navBarPage.isTimetableContextMenuDisplayed();
  expect(isTrainsContextMenuVisible, `Timetable context menu is not shown`)
    .to.equal(true);
});

Then('the signal context menu is displayed', async () => {
  const isTrainsContextMenuVisible: boolean = await navBarPage.isSignalContextMenuDisplayed();
  expect(isTrainsContextMenuVisible, `Signal context menu is not shown`)
    .to.equal(true);
});

Then('the train search context menu contains {string} on line {int}', async (expectedText: string, rowNum: number) => {
  const actualContextMenuItem: string = await navBarPage.getTrainsSearchContextMenuItem(rowNum);
  expect(actualContextMenuItem, `Item ${rowNum} in train search context menu was not ${expectedText}`)
    .to.contain(expectedText);
});

Then('I select map {string} on line {int} from the search context menu', async (expectedText: string, rowNum: number) => {
  await navBarPage.clickTrainsSearchContextMenuItem(rowNum);
});

Then('the {string} search context menu contains {string} on line {int}',
  async (searchType: string, expectedText: string, rowNum: number) => {
  const actualContextMenuItem = await navBarPage.getSearchContextMenuItem(rowNum);
  expect(actualContextMenuItem, `Item ${rowNum} in ${searchType} search context menu was not ${expectedText}`)
    .to.contain(expectedText);
});

When('I wait for the {string} search context menu to display', async (searchType: string) => {
  if (searchType === 'Train') {
    await navBarPage.waitForTrainContext();
  }
  else if (searchType === 'Timetable') {
    await navBarPage.waitForTimetableContext();
  }
  else if (searchType === 'Signal') {
    await navBarPage.waitForSignalContext();
  }
});

When('I wait for the train search context menu to display', async () => {
  await navBarPage.waitForTrainContext();
});

When('I wait for the timetable search context menu to display', async () => {
  await navBarPage.waitForTimetableContext();
});

When('I wait for the signal search context menu to display', async () => {
  await navBarPage.waitForSignalContext();
});

When('I wait for the train search context menu map to display', async () => {
  await navBarPage.waitForContextMap();
});

Then('I click away to clear the trains menu', async () => {
  await navBarPage.tableColumnHeader.click();
});

Then('I click on timetable link', async () => {
  await navBarPage.timeTableLink.click();
});


Then('I placed the mouseover on map arrow link', async () => {
  await browser.actions().mouseMove(element(by.css('.map-link:nth-child(1)'))).perform();
});

Then('I placed the mouseover on map option', async () => {
  await browser.actions().mouseMove(element(by.css('#map-list >ul >li:nth-child(1)'))).perform();
});

Then('I placed the mouseover on signal map option', async () => {
  await browser.actions().mouseMove(element(by.css('.map-link:nth-child(1)'))).perform();
});

Then('I click on the map option', async () => {
  await navBarPage.contextMapLink.click();
});

Then('I click on the signal map option', async () => {
  await navBarPage.signalMapLink.click();
});

Then(/^I invoke the context menu from signal (.*)$/, async (itemNum: number) => {
  await navBarPage.rightClickSignal(itemNum);

});

Then(/^I invoke the context menu from trains (.*)$/, async (itemNum: number) => {
  await navBarPage.rightClickTrainList(itemNum);

});

Then(/^I invoke the context menu from an? (.*) service in the (.*) list$/, async (statusType: string, searchType: string) => {
  const itemNum = await navBarPage.getServiceWithStatus(statusType, searchType.toLowerCase()) + 1;
  expect(itemNum, `No service with status ${statusType}`).to.not.equal(-1);
  if (searchType === 'Train') {
    await navBarPage.rightClickTrainList(itemNum);
    browser.selectedTrain = await navBarPage.getSearchListValueForColumnAndRow(searchType.toLowerCase(), 'TrainDesc', itemNum);
  }
  else if (searchType === 'Timetable') {
    await navBarPage.rightClickTimeTableList(itemNum);
    browser.selectedTrain = await navBarPage.getSearchListValueForColumnAndRow(searchType.toLowerCase(), 'TrainDesc', itemNum);
  }
});

Then(/^I invoke the context menu from timetable (.*)$/, async (itemNum: number) => {
  await navBarPage.rightClickTimeTableList(itemNum);
});

When('I invoke the context menu from train {int} on the timetable results table', async (itemNum: number) => {
  await navBarPage.rightClickTimeTableList(itemNum);
});

When('I invoke the context menu from train {int} on the trains list table', async (itemNum: number) => {
  await navBarPage.rightClickTrainList(itemNum);
});

When('I click on the Help icon', async () => {
  await navBarPage.openHelpMenu();
});

When('I select the TMV Key option', async () => {
  await navBarPage.openTMVKey();
});

Then('the TMV Key option should not be visible', async () => {
  const isTMVKeyOptionVisible: boolean = await navBarPage.isTMVKeyOptionDisplayed();
  expect(isTMVKeyOptionVisible, `TMV key option is displayed when it shouldn't`)
    .to.equal(false);
});

Then('there should only be one key model window open', async () => {
  expect(await navBarPage.countKeyModelWindows(), `No key Model window or more than 1 displayed`)
    .to.equal(1);
});

Then('the following map names can be seen', async (mapNameDataTable: any) => {
  const expectedMapNames = mapNameDataTable.hashes();
  const actualMapNames = await navBarPage.getMapNames();

  expectedMapNames.forEach((expectedMapName: any) => {
    expect(actualMapNames).to.contain(expectedMapName.mapName);
  });
});

Then('I open the Map {string}', async (mapName: string) => {
  await navBarPage.openMap(mapName);
});

Then('the signal {string} is {word}',
  async (signalId: string, expectedStatus: string) => {
    const actualStatus = await navBarPage.getHighlightStatus(signalId);
    expect(actualStatus).to.equal(expectedStatus);
  });

Then('the berth {string} is {word}',
  async (berthId: string, expectedStatus: string) => {
    const actualStatus = await navBarPage.getBerthHighlightStatus(berthId);
    expect(actualStatus).to.equal(expectedStatus);
  });
