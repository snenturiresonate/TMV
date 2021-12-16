import {browser, by, element, ElementArrayFinder, ElementFinder, protractor} from 'protractor';
import {CheckBox} from './common/ui-element-handlers/checkBox';
import {CommonActions} from './common/ui-event-handlers/actionsAndWaits';
import {DateAndTimeUtils} from './common/utilities/DateAndTimeUtils';

export class NavBarPageObject {
  public navBarIcons: ElementArrayFinder;
  public mapLayerToggles: ElementArrayFinder;
  public berthToggle: ElementFinder;
  public routeSetTrackToggle: ElementFinder;
  public routeSetCodeToggle: ElementFinder;
  public platformToggleIndicator: ElementFinder;
  public berthToggleIndicator: ElementFinder;
  public platformToggleOn: ElementFinder;
  public platformToggleOff: ElementFinder;
  public berthToggleOn: ElementFinder;
  public berthToggleOff: ElementFinder;
  public routeSetCodeToggleOn: ElementFinder;
  public routeSetCodeToggleOff: ElementFinder;
  public routeSetTrackToggleOn: ElementFinder;
  public routeSetTrackToggleOff: ElementFinder;
  public version: ElementFinder;
  public configOption: ElementFinder;
  public trainSearchBox: ElementFinder;
  public trainSearchOption: ElementFinder;
  public trainSearchBtn: ElementFinder;
  public signalOption: ElementFinder;
  public timeTableOption: ElementFinder;
  public navBar: ElementFinder;
  public trainTable: ElementFinder;
  public timeTable: ElementFinder;
  public signalTable: ElementFinder;
  public searchTable: ElementFinder;
  public trainTableCloseIcon: ElementFinder;
  public trainTableCloseBtn: ElementFinder;
  public trainTableWindow: ElementFinder;
  public tableColumnHeader: ElementFinder;
  public timeTableColumnHeader: ElementFinder;
  public trainContextMenu: ElementFinder;
  public timeTableContextMenu: ElementFinder;
  public trainsContextListItems: ElementArrayFinder;
  public searchContextMenu: ElementFinder;
  public contextListItems: ElementArrayFinder;
  public trainSearchWarningMsg: ElementFinder;
  public invalidCharactersWarningMsg: ElementFinder;
  public noResultsFoundMessage: ElementFinder;
  public berthSearchResultsTitle: ElementFinder;
  public timeTableLink: ElementFinder;
  public contextMapArrowLink: ElementFinder;
  public contextMapLink: ElementFinder;
  public signalMapLink: ElementArrayFinder;
  public trainSearchRow: ElementArrayFinder;
  public timeTableSearchRow: ElementArrayFinder;
  public signalSearchRow: ElementArrayFinder;
  public statusUnmatched: ElementFinder;
  public signalColumnHeader: ElementFinder;
  public signalContext: ElementFinder;
  public unscheduledContext: ElementFinder;
  public tmvKeyButton: ElementFinder;
  public modalWindow: ElementArrayFinder;
  public helpMenu: ElementFinder;
  public searchFilterToggle: ElementFinder;
  public mapLink: ElementArrayFinder;
  public mapLinkSignal: ElementArrayFinder;
  public mapPathToggle: ElementFinder;
  public recentMaps: ElementArrayFinder;
  public mapChanger: ElementFinder;
  public mapSearchBox: ElementFinder;
  public routeSetTrackIndicator: ElementFinder;
  public routeSetCodeIndicator: ElementFinder;
  public mapItemSearchContext: ElementFinder;
  public signOutIcon: ElementFinder;
  public berthSearchResults: ElementArrayFinder;
  constructor() {
    this.navBarIcons = element.all(by.css('.navbar .material-icons'));
    this.mapLayerToggles = element.all(by.css('.map-toggle-div .toggle-text'));
    this.berthToggle = element(by.css('#berthtoggle .toggle-switch'));
    this.routeSetTrackToggle = element(by.css('#routesettracktoggle .toggle-switch'));
    this.routeSetCodeToggle = element(by.css('#routesetcodetoggle .toggle-switch'));
    this.platformToggleIndicator = element(by.css('#platformtoggle .toggle-switch'));
    this.platformToggleOn = element(by.css('#platformtoggle .absolute-on'));
    this.platformToggleOff = element(by.css('#platformtoggle .absolute-off'));
    this.berthToggleOn = element(by.css('#berthtoggle .absolute-on'));
    this.berthToggleOff = element(by.css('#berthtoggle .absolute-off'));
    this.routeSetTrackToggleOn = element(by.css('#routesettracktoggle .absolute-on'));
    this.routeSetTrackToggleOff = element(by.css('#routesettracktoggle .absolute-off'));
    this.routeSetCodeToggleOn = element(by.css('#routesetcodetoggle .absolute-on'));
    this.routeSetCodeToggleOff = element(by.css('#routesetcodetoggle .absolute-off'));
    this.version = element(by.id('settings-menu-tmvVersion'));
    this.configOption = element(by.css('li.dropdown-item.dropdown-item-Menu.trains-config-button'));
    this.trainSearchBox = element(by.id('national-search-box'));
    this.trainSearchBtn = element(by.css('#national-search-submit >span'));
    this.trainSearchOption = element(by.css('#national-search-dropdown >button'));
    this.searchFilterToggle = element(by.id('national-search-dropdown-toggle'));
    this.signalOption = element(by.css('#national-search-dropdown-menu >button:nth-child(1)'));
    this.timeTableOption = element(by.css('#national-search-dropdown-menu >button:nth-child(2)'));
    this.navBar = element(by.id('collapsibleNavbar'));
    this.berthToggleIndicator = element(by.css('#berthtoggle .toggle-switch'));
    this.searchTable = element(by.css('.modalbody:nth-child(2)'));
    this.trainTable = element(by.css('.modalbody:nth-child(2)'));
    this.timeTable = element(by.css('.modalbody:nth-child(2)'));
    this.signalTable = element(by.css('.modalbody:nth-child(2)'));
    this.trainTableCloseIcon = element(by.css('.closemodal:nth-child(1)'));
    this.trainTableCloseBtn = element(by.css('.tmv-btn-cancel:nth-child(1)'));
    this.trainTableWindow = element(by.css('.modaltitle:nth-child(1)'));
    this.trainContextMenu = element(by.id('trainSearchContextmenu'));
    this.timeTableContextMenu = element(by.id('timetableSearchContextmenu'));
    this.searchContextMenu = element(by.css('[id$=SearchContextmenu]'));
    this.trainSearchRow = element.all(by.css('#trainSearchResults-tbody tr'));
    this.timeTableSearchRow = element.all(by.css('#timetableSearchResults-tbody tr'));
    this.trainsContextListItems = element.all(by.css('.dropdown-item-menu:nth-child(1)'));
    this.contextListItems = element.all(by.css('.dropdown-item-menu:nth-child(1)'));
    this.trainSearchWarningMsg = element(by.css('.div-warning-msg:nth-child(1)'));
    this.invalidCharactersWarningMsg = element(by.xpath('//div[contains(text(),\'Invalid characters\')]'));
    this.noResultsFoundMessage = element(by.id('no-berth-search-results'));
    this.berthSearchResultsTitle = element(by.xpath('//div[contains(text(),\'Berth Search Results\')]'));
    this.timeTableLink = element(by.id('btn-open-timetable'));
    this.contextMapArrowLink = element(by.css('#right-arrow:nth-child(1)'));
    this.contextMapLink = element(by.css('#map-list >ul >li:nth-child(1)'));
    this.signalMapLink = element.all(by.css('#signal-map-list >ul >li'));
    this.statusUnmatched = element(by.cssContainingText('#trainSearchResults-tbody tr', 'UNMATCHED'));
    this.tableColumnHeader = element(by.css('#trainSearchResults thead'));
    this.timeTableColumnHeader = element(by.css('#timetableSearchResults thead'));
    this.signalColumnHeader = element(by.css('#signalSearchResults thead'));
    this.signalSearchRow = element.all(by.css('#signalSearchResults tbody>tr'));
    this.signalContext = element(by.id('signalSearchContextMenu'));
    this.unscheduledContext = element(by.id('un-schedule-context-menu-timetable'));
    this.tmvKeyButton = element(by.id('tmv-key-button'));
    this.modalWindow = element.all(by.css('.modalpopup'));
    this.helpMenu = element(by.id('help-menu-button'));
    this.mapLink = element.all(by.css('#map-list>ul>li'));
    this.mapLinkSignal = element.all(by.css('#signal-map-list>ul>li'));
    this.mapPathToggle = element(by.id('map-path-toggle-button'));
    this.recentMaps = element.all(by.css('.map-details'));
    this.mapChanger = element(by.css('#mapNameDropDown'));
    this.mapSearchBox = element(by.id('map-search-box'));
    this.routeSetTrackIndicator = element(by.css('#routesettracktoggle .toggle-switch'));
    this.routeSetCodeIndicator = element(by.css('#routesetcodetoggle .toggle-switch'));
    this.mapItemSearchContext = element(by.css('div.map-link'));
    this.signOutIcon = element(by.id('logout1'));
    this.berthSearchResults = element.all(by.css('#berthSearchResults tr'));
  }

  public async navBarIsDisplayed(): Promise<boolean> {
    return this.navBar.isPresent();
  }

  public async getNavbarIconNames(): Promise<string> {
    return this.navBarIcons.getText();
  }

  public async openUserProfileMenu(): Promise<void> {
    const userProfileMenu: ElementFinder = element(by.id('user-profile-menu-button'));
    await userProfileMenu.click();
  }

  public async clickSignOutButton(): Promise<void> {
    await CommonActions.waitForElementToBeVisible(this.signOutIcon);
    await this.signOutIcon.click();
  }

  public async openLayersMenu(): Promise<void> {
    const LayersMenu: ElementFinder = element(by.id('layers-menu-button'));
    await LayersMenu.click();
  }

  public async getToggleNames(): Promise<string> {
    return this.mapLayerToggles.getText();
  }

  public async getToggleState(toggleName: string): Promise<boolean> {
    const elm = await this.getToggle(toggleName);
    return CheckBox.getToggleCurrentState(elm);
  }

  private async getToggle(toggleName): Promise<ElementFinder> {
    if (toggleName === 'Berth') {
      return this.berthToggle;
    }
    else if (toggleName === 'Route Set - Track') {
      return this.routeSetTrackToggle;
    }
    else if (toggleName === 'Route Set - Code') {
      return this.routeSetCodeToggle;
    }
  }

  public async toggle(toggleName: string, requiredState: string): Promise<void> {
    const elm = await this.getToggle(toggleName);
    return CheckBox.updateToggle(elm, requiredState);
  }

  public async toggleMapPathOff(): Promise<void> {
    await this.mapPathToggle.click();
  }

  public async getServiceWithStatus(statusType: string, searchType: string): Promise<number> {
    const statuses = await this.getSearchListValuesForColumn(searchType, 'Status');
    return statuses.indexOf(statusType);
  }

  public async getSearchListValuesForColumn(list: string, column: string): Promise<string[]> {
    const entryColValues: ElementArrayFinder = element.all(by.id(list + 'Search' + column));
    return entryColValues.map((colValue: ElementFinder) => {
      return colValue.getText();
    });
  }

  public async getSearchListValueForColumnAndRow(list: string, column: string, row: number): Promise<string> {
    const entryColValues: ElementArrayFinder = element.all(by.id(list + 'Search' + column));
    return entryColValues.get(row - 1).getText();
  }

  public async getUserProfileMenuDisplayName(): Promise<string> {
    const icon: ElementFinder = element(by.id('user-profile-menu-display-name'));
    return icon.getText();
  }

  public async getUserProfileMenuRoleName(row: number): Promise<string> {
    const roleNames: ElementArrayFinder = element.all(by.id('user-profile-menu-role-name'));
    return roleNames.get(row - 1).getText();
  }

  public async getCurrentTimeText(): Promise<string> {
    const icon: ElementFinder = element(by.id('nav-bar-current-time'));
    return icon.getText();
  }

  public async openSettingsMenu(): Promise<void> {
    const userSettingsMenu: ElementFinder = element(by.id('settings-menu-button'));
    await userSettingsMenu.click();
  }

  public async getVersionNumber(): Promise<string> {
    return this.version.getText();
  }

  public async getTmvListConfig(): Promise<string> {
    return this.configOption.getText();
  }

  public async getNewPageTitle(): Promise<string> {
    return browser.getTitle();
  }

  public async openTmvTrainsListConfig(): Promise<void> {
    const tmvTrainsList: ElementFinder = element(by.css('li.dropdown-item.dropdown-item-Menu.trains-config-button'));
    await tmvTrainsList.click();
  }

  public async clickLaunch(): Promise<void> {
    const launchIcon: ElementFinder = element(by.css('.tmv-home-btn .material-icons'));
    await launchIcon.click();
  }

  public async clickHome(): Promise<void> {
    const homeIcon: ElementFinder = element(by.css('#navbar > span > span:nth-child(1) > img'));
    await homeIcon.click();
  }

  public async getTrainSearchBoxText(): Promise<string> {
    return this.trainSearchBox.getAttribute('placeholder');
  }

  public async trainSearchBoxIsVisible(): Promise<boolean> {
    await CommonActions.waitForElementToBeVisible(this.trainSearchBox);
    return true;
  }

  public async trainSearchBoxIsNotVisible(): Promise<boolean> {
    try {
      return ! await this.trainSearchBox.isDisplayed();
    }
    catch (NoSuchElementError) {
      return true;
    }
  }

  public async getTrainSearchValue(): Promise<string> {
    return this.trainSearchOption.getText();
  }

  public async getTrainSearchOptions(): Promise<string> {
    return this.trainSearchOption.getText();
  }

  public async getTrainSearchBtnValue(): Promise<string> {
    return this.trainSearchBtn.getText();
  }

  public async clickTrainSearch(): Promise<void> {
    return this.trainSearchOption.click();
  }

  public async clickSearchIcon(): Promise<void> {
    return this.trainSearchBtn.click();
  }

  public async selectSignalOption(): Promise<void> {
    await element(by.cssContainingText('div.search-dropdown-menu', 'Signal')).click();
  }

  public async selectTimetableOption(): Promise<void> {
    await element(by.cssContainingText('div.search-dropdown-menu', 'Timetable')).click();
  }

  public async rightClick(): Promise<void> {
    browser.actions().click(this.navBar, protractor.Button.RIGHT).perform();
  }

  public async enterSearchValue(searchValue: string): Promise<void> {
    const elm = this.trainSearchBox;
    await elm.clear();
    await elm.sendKeys(searchValue);
  }

  public async isTrainTablePresent(): Promise<boolean> {
    return browser.isElementPresent(this.trainTable);
  }

  public async isTimetablePresent(): Promise<boolean> {
    return browser.isElementPresent(this.timeTable);
  }

  public async isSignalTablePresent(): Promise<boolean> {
    return browser.isElementPresent(this.signalTable);
  }

  public async isSearchTablePresent(): Promise<boolean> {
    return browser.isElementPresent(this.searchTable);
  }

  public async isTrainTableWarningPresent(): Promise<boolean> {
    return browser.isElementPresent(this.trainSearchWarningMsg);
  }

  public async isInvalidCharactersWarningPresent(): Promise<boolean> {
    return browser.isElementPresent(this.invalidCharactersWarningMsg);
  }

  public async isNoResultsFoundMessagePresent(): Promise<boolean> {
    return browser.isElementPresent(this.noResultsFoundMessage);
  }

  public async isBerthSearchResultsTitlePresent(): Promise<boolean> {
    return browser.isElementPresent(this.berthSearchResultsTitle);
  }

  public async countBerthSearchResults(): Promise<number> {
    return (await this.berthSearchResults.count()) - 1;
  }

  public async trainClickCloseIcon(): Promise<void> {
    return this.trainTableCloseIcon.click();
  }

  public async trainClickCloseBtn(): Promise<void> {
    return CommonActions.waitAndClick(this.trainTableCloseBtn);
  }

  public async unmatchedStatus(): Promise<void> {
    browser.actions().click(this.statusUnmatched, protractor.Button.RIGHT).perform();
  }

  public async getTrainWindowTitle(): Promise<string> {
    return this.trainTableWindow.getText();
  }

  public async getTableColumnHeader(): Promise<string> {
    return this.tableColumnHeader.getText();
  }

  public async getTimeTableColumnHeader(): Promise<string> {
    return this.timeTableColumnHeader.getText();
  }

  public async getSignalColumnHeader(): Promise<string> {
    return this.signalColumnHeader.getText();
  }

  public async getTrainsSearchContextMenuItem(rowIndex: number): Promise<string> {
    return this.trainsContextListItems.get(rowIndex - 1).getText();
  }

  public async clickTrainsSearchContextMenuItem(rowIndex: number): Promise<void> {
    const trainContextList = this.trainsContextListItems.get(rowIndex - 1);
    browser.actions().click(trainContextList);
  }

  public async getSearchContextMenuItem(rowIndex: number): Promise<string> {
    return this.contextListItems.get(rowIndex - 1).getText();
  }

  public async isContextMenuDisplayed(): Promise<boolean> {
    return this.trainContextMenu.isPresent();
  }

  public async isSignalContextMenuDisplayed(): Promise<boolean> {
    return this.signalContext.isPresent();
  }

  public async isUnscheduledContextMenuDisplayed(): Promise<boolean> {
    return this.unscheduledContext.isPresent();
  }

  public async isTMVKeyOptionDisplayed(): Promise<boolean> {
    return this.tmvKeyButton.isPresent();
  }

  public async countKeyModelWindows(): Promise<number> {
    return this.modalWindow.count();
  }

  public async isTimetableContextMenuDisplayed(): Promise<boolean> {
    return this.timeTableContextMenu.isPresent();
  }

  public async waitForTimetableContext(): Promise<boolean> {
    await browser.wait(async () => {
      return this.timeTableContextMenu.isPresent();
    }, browser.params.general_timeout, 'The trains list context menu should be displayed');
    return this.timeTableContextMenu.isPresent();
  }
  public async waitForSignalContext(): Promise<boolean> {
    await browser.wait(async () => {
      return this.signalContext.isPresent();
    }, browser.params.general_timeout, 'The trains list context menu should be displayed');
    return this.signalContext.isPresent();
  }

  public async waitForUnscheduledContext(): Promise<boolean> {
    await browser.wait(async () => {
      return this.unscheduledContext.isPresent();
    }, browser.params.general_timeout, 'The unscheduled context menu should be displayed');
    return this.unscheduledContext.isPresent();
  }

  public async waitForContextMap(): Promise<boolean> {
    await browser.wait(async () => {
      return this.contextMapLink.isPresent();
    }, browser.params.general_timeout, 'The trains list context menu map should be displayed');
    return this.contextMapLink.isPresent();
  }

  public async rightClickTrainSearchList(position: number): Promise<void> {
    const rows = this.trainSearchRow;
    const targetRow = rows.get(position - 1);
    browser.actions().click(targetRow, protractor.Button.RIGHT).perform();
  }

  public async rightClickTimeTableSearchList(position: number): Promise<void> {
    const rows = this.timeTableSearchRow;
    const targetRow = rows.get(position - 1);
    browser.actions().click(targetRow, protractor.Button.RIGHT).perform();
  }

  public async rightClickSignalSearchList(position: number): Promise<void> {
    const rows = this.signalSearchRow;
    const targetRow = rows.get(position - 1);
    browser.actions().click(targetRow, protractor.Button.RIGHT).perform();
  }

  public async waitForTrainContext(): Promise<boolean> {
    await browser.wait(async () => {
      return this.trainContextMenu.isPresent();
    }, browser.params.general_timeout, 'The trains list context menu should be displayed');
    return this.trainContextMenu.isPresent();
  }

  public async waitForSearchContext(): Promise<boolean> {
    await browser.wait(async () => {
      return this.searchContextMenu.isPresent();
    }, browser.params.general_timeout, 'The search context menu should be displayed');
    return this.searchContextMenu.isPresent();
  }

  public async getTimetableEntryValues(): Promise<string[]> {
    const entryColValue: ElementArrayFinder = element.all(by.css('#trainSearchResults-tbody tr'));
    return entryColValue.map((colValues: ElementFinder) => {
      return colValues.getText();
    });
  }

  public async openTimetableForTrainUid(trainUid: string): Promise<void> {
    const today: string = await DateAndTimeUtils.convertToDesiredDateAndFormat('today', 'dd/MM/yyyy');
    const tomorrow: string = DateAndTimeUtils.convertToDesiredDateAndFormat('tomorrow', 'dd/MM/yyyy');
    let rowLocator: ElementFinder =
      element(by.xpath(`//*[child::*[text()='${trainUid}']][following-sibling::*[child::*[text()='${today}']]]`));
    if (!rowLocator.isPresent()) {
      rowLocator =
        element(by.xpath(`//*[child::*[text()='${trainUid}']][following-sibling::*[child::*[text()='${tomorrow}']]]`));
    }
    await CommonActions.waitForElementInteraction(rowLocator);
    await browser.actions().click(rowLocator, protractor.Button.RIGHT).perform();
    await this.waitForSearchContext();
    await this.timeTableLink.click();
  }

  public async openHelpMenu(): Promise<void> {
    await this.helpMenu.click();
  }

  public async openTMVKey(): Promise<void> {
    await this.tmvKeyButton.click();
  }

  public async setSearchFilter(filter: string): Promise<void> {
    if (filter !== (await this.searchFilterToggle.getText())) {
      await this.searchFilterToggle.click();
      await element(by.buttonText(filter)).click();
    }
  }

  public async hoverOverContextMenuMapsLink(): Promise<void> {
    await browser.actions().mouseMove(this.mapItemSearchContext).perform();
  }

  public async getMapNames(): Promise<any> {
    await this.hoverOverContextMenuMapsLink();
    return this.mapLink.getText();
  }

  public async getMapNamesForSignal(): Promise<any> {
    await this.hoverOverContextMenuMapsLink();
    return this.mapLinkSignal.getText();
  }

  public async getSignalMapNames(): Promise<string> {
    await browser.actions().mouseMove(this.mapItemSearchContext).perform();
    return this.signalMapLink.getText();
  }

  public async openMap(mapName: string): Promise<void> {
    if (mapName !== (await this.mapLink.getText())) {
      await this.hoverOverContextMenuMapsLink();
      await CommonActions.waitAndClick(element(by.xpath(`//li//span[text() = '${mapName}']`)));
    }
  }

  public async enterMapSearchString(searchString: string): Promise<void> {
    this.mapSearchBox.clear();
    return this.mapSearchBox.sendKeys(searchString);
  }

  public async changeToRecentMap(mapName: string): Promise<void> {
    await this.mapChanger.click();
    const recentMap = element(by.id('map-search-menu-recent-history-item-map-name-' + mapName));
    await CommonActions.waitAndClick(recentMap);
  }

  public async getHighlightStatus(signalId: string): Promise<string> {
    const signalHighlight: ElementFinder = element(by.css('[id^=signal-latch-cross-element-' + signalId  + ']'));
    return signalHighlight.getCssValue('highlighted');
  }

  public async getBerthHighlightStatus(trainDescription: string, berthId: string): Promise<string> {
    const berthHighlight: ElementFinder = element(by.css(`[id=berth-element-text-${trainDescription}${berthId}]`));
    return berthHighlight.getCssValue('highlighted');
  }
}
