import {browser, by, element, ElementArrayFinder, ElementFinder, protractor} from 'protractor';
import {CommonActions} from './common/ui-event-handlers/actionsAndWaits';

export class HomePageObject {
  public wecomeMessage: ElementFinder;
  public mapGroupingIcons: ElementArrayFinder;
  public mapList: ElementArrayFinder;
  public appList: ElementArrayFinder;

  public homeIcon: ElementFinder;
  public newTabIcon: ElementFinder;
  public userProfileIcon: ElementFinder;
  public helpIcon: ElementFinder;
  public timeDisplay: ElementFinder;

  public mapSearchBox: ElementFinder;
  public mapAutoSuggestSearchResultList: ElementFinder;
  public mapAutoSuggestSearchResults: ElementArrayFinder;
  public mapSearchResultList: ElementFinder;
  public mapSearchResultTable: ElementFinder;
  public mapSearchResults: ElementArrayFinder;
  public searchButton: ElementFinder;

  public recentHistoryNextPageButton: ElementFinder;
  public recentHistoryPreviousPageButton: ElementFinder;
  public recentSearchedMap: ElementFinder;
  public recentMapsBox: ElementFinder;
  public allMapsHeader: ElementFinder;

  public replayButton: ElementFinder;
  public adminIcon: ElementFinder;

  constructor() {
    this.wecomeMessage = element(by.css('.tmv-container h1'));
    this.mapGroupingIcons = element.all(by.css('app-map-list .material-icons'));
    this.mapList = element.all(by.css('.mapLink'));
    this.appList = element.all(by.css('.btn-box .app-button-link-text'));
    this.recentHistoryNextPageButton = element(by.id('recent-history-map-next-page'));
    this.recentHistoryPreviousPageButton = element(by.id('recent-history-map-previous-page'));
    this.mapSearchBox = element(by.id('map-search-box'));
    this.mapAutoSuggestSearchResultList = element(by.id('searchResults'));
    this.mapAutoSuggestSearchResults = element.all(by.css('div#searchResults .result-item'));
    this.mapSearchResultList = element(by.css('.map-search-results-container'));
    this.mapSearchResultTable = element(by.css('table#searchResultsTable tbody'));
    this.mapSearchResults = element.all(by.css('table#searchResultsTable tr'));
    this.searchButton = element(by.id('map-search-submit-button'));
    this.recentSearchedMap = element(by.css('.recent-history-item-entry'));
    this.adminIcon = element(by.css('.btn-box .app-button-link-text'));
    this.replayButton = element(by.id('icon-replay'));

    this.homeIcon = element(by.css('img[alt="logo"]'));
    this.newTabIcon = element(by.xpath('//span[contains(text(),\'launch\')]'));
    this.userProfileIcon = element(by.id('user-profile-menu-button'));
    this.helpIcon = element(by.xpath('//span[contains(text(),\'help\')]'));
    this.timeDisplay = element(by.id('nav-bar-current-time'));
    this.recentMapsBox = element(by.tagName('app-recent-maps'));
    this.allMapsHeader = element(by.xpath('//h2[contains(text(),\'All Maps\')]'));
  }

  public async homeIconIsDispayed(): Promise<boolean> {
    await CommonActions.waitForElementToBeVisible(this.homeIcon);
    return this.homeIcon.isDisplayed();
  }

  public async newTabIconIsDispayed(): Promise<boolean> {
    await CommonActions.waitForElementToBeVisible(this.newTabIcon);
    return this.newTabIcon.isDisplayed();
  }

  public async userProfileIconIsDispayed(): Promise<boolean> {
    await CommonActions.waitForElementToBeVisible(this.userProfileIcon);
    return this.userProfileIcon.isDisplayed();
  }

  public async helpIconIsDispayed(): Promise<boolean> {
    await CommonActions.waitForElementToBeVisible(this.helpIcon);
    return this.helpIcon.isDisplayed();
  }

  public async timeIsDispayed(): Promise<boolean> {
    await CommonActions.waitForElementToBeVisible(this.timeDisplay);
    return this.timeDisplay.isDisplayed();
  }

  public async mapSearchBoxIsDisplayed(): Promise<boolean> {
    await CommonActions.waitForElementToBeVisible(this.mapSearchBox);
    return this.mapSearchBox.isDisplayed();
  }

  public async mapSearchBoxIsNotDisplayed(): Promise<boolean> {
    return ! await this.mapSearchBox.isPresent();
  }

  public async recentMapsBoxIsDisplayed(): Promise<boolean> {
    await CommonActions.waitForElementToBeVisible(this.recentMapsBox);
    return this.recentMapsBox.isDisplayed();
  }

  public async recentMapsBoxIsNotDisplayed(): Promise<boolean> {
    return ! await this.recentMapsBox.isPresent();
  }

  public async allMapsHeaderIsDisplayed(): Promise<boolean> {
    await CommonActions.waitForElementToBeVisible(this.allMapsHeader);
    return this.allMapsHeader.isDisplayed();
  }

  public async allMapsHeaderIsNotDisplayed(): Promise<boolean> {
    return ! await this.allMapsHeader.isPresent();
  }

  public async getWelcomeMessageText(): Promise<string> {
    return this.wecomeMessage.getText();
  }

  public async expandMapGrouping(position: number): Promise<void>
  {
    return this.mapGroupingIcons.get(position - 1).click();
  }

  public async expandMapGroupingForName(mapName: string): Promise<void>
  {
    const mapListItem: ElementFinder = element(by.xpath('//div[contains(text(),"' + mapName + '")]'));
    return mapListItem.click();
  }

  public async getMapsListed(): Promise<string> {
    return this.mapList.getText();
  }

  public async openMap(mapId: string): Promise<void> {
    const mapItem: ElementFinder = element(by.id('map-link-' + mapId));
    await mapItem.click();
  }

  public async chooseRandomMap(): Promise<string> {
    const numMaps = await this.mapList.count();
    const randomIndex = Math.floor(Math.random() * numMaps);
    const mapItem: ElementFinder = this.mapList.get(randomIndex);
    const mapId = await mapItem.getWebElement().getAttribute('id');
    return mapId.replace('map-link-', '');
  }

  public async getRecentHistoryMapName(recentHistoryIndex: number): Promise<string> {
    const recentHistoryItemEntries: ElementArrayFinder = element.all(by.css('.recent-history-item-entry'));
    return recentHistoryItemEntries.get(recentHistoryIndex).getText();
  }

  public async getRecentHistoryMapLastAccessed(recentHistoryIndex: number): Promise<string> {
    const recentHistoryItemEntries: ElementArrayFinder = element.all(by.css('.recent-history-item-entry-last-accessed'));
    return recentHistoryItemEntries.get(recentHistoryIndex).getText();
  }

  public async clickNextPageOfRecentHistoryResults(): Promise<void> {
    await this.recentHistoryNextPageButton.click();
  }

  public async clickPreviousPageOfRecentHistoryResults(): Promise<void> {
    await this.recentHistoryPreviousPageButton.click();
  }

  public async checkRecentHistoryMapNameIsPresent(mapId: number): Promise<boolean> {
    return browser.isElementPresent(element(by.id('recent-history-item-map-name-' + String(mapId))));
  }

  public async getAppNames(): Promise<string> {
    return this.appList.getText();
  }

  public async getMapSearchBoxText(): Promise<string> {
    return this.mapSearchBox.getAttribute('placeholder');
  }

  public async isMapAutoSuggestSearchResultDisplayed(): Promise<boolean> {
    return this.mapAutoSuggestSearchResultList.isDisplayed();
  }

  public async getMapAutoSuggestSearchResults(): Promise<string> {
    return this.mapAutoSuggestSearchResults.getText();
  }

  public async enterMapSearchString(searchString: string): Promise<void> {
    this.mapSearchBox.clear();
    return this.mapSearchBox.sendKeys(searchString);
  }

  public async clickIcon(iconName: string): Promise<void> {
    const icon: ElementFinder = element(by.id('icon-' + iconName));
    await CommonActions.waitAndClick(icon);
  }

  public async clickSearchButton(): Promise<void> {
    await this.searchButton.click();
  }

  public async enterReturnInSearchBox(): Promise<void> {
    return this.mapSearchBox.sendKeys(protractor.Key.ENTER);
  }

  public async isMapSearchResultListDisplayed(): Promise<boolean> {
    return this.mapSearchResultList.isDisplayed();
  }

  public async getMapSearchResults(): Promise<string> {
    return this.mapSearchResults.getText();
  }

  public async clickMapSearchResult(position: number): Promise<void> {
    const rows = this.mapSearchResults;
    await rows.get(position - 1).click();
  }

  public async isMapSearchResultVisible(position: number): Promise<boolean> {
    const rows = this.mapSearchResults;
    return rows.get(position - 1).isDisplayed();
  }

  public async getMapSearchResultsVisibleHeight(): Promise<number> {
    const visibleHeight = await this.mapSearchResultTable.getAttribute('clientHeight');
    return parseFloat(visibleHeight);
  }

  public async getMapSearchResultsTotalHeight(): Promise<number> {
    const totalHeight = await this.mapSearchResultTable.getAttribute('scrollHeight');
    return parseFloat(totalHeight);
  }

  public async openRecentMap(): Promise<void> {
    return this.recentSearchedMap.click();
  }

  public async adminIconIsPresent(): Promise<boolean> {
    await CommonActions.waitForElementToBeVisible(this.appList.last());
    return this.adminIcon.isPresent();
  }

  public async clickAdminIcon(): Promise<void> {
    await CommonActions.waitAndClick(this.adminIcon);
  }
}
