import {browser, by, element, ElementArrayFinder, ElementFinder, protractor} from 'protractor';

export class NavBarPageObject {
  public navBarIcons: ElementArrayFinder;
  public mapLayerToggles: ElementArrayFinder;
  public platformToggleIndicator: ElementFinder;
  public berthToggleIndicator: ElementFinder;
  public platformToggleOn: ElementFinder;
  public platformToggleOff: ElementFinder;
  public berthToggleOn: ElementFinder;
  public berthToggleOff: ElementFinder;
  public version: ElementFinder;
  public configOption: ElementFinder;
  public trainSearchBox: ElementFinder;
  public trainSearchOption: ElementFinder;
  public trainSearchBtn: ElementFinder;
  public signalOption: ElementFinder;
  public timeTableOption: ElementFinder;
  public navBar: ElementFinder;
  public trainTable: ElementFinder;
  public trainTableCloseIcon: ElementFinder;
  public trainTableCloseBtn: ElementFinder;
  public trainTableWindow: ElementFinder;
  public tableColumnHeader: ElementFinder;
  public timeTableColumnHeader: ElementFinder;
  public trainContextMenu: ElementFinder;
  public timeTableContextMenu: ElementFinder;
  public trainsContextListItems: ElementArrayFinder;
  public trainSearchWarningMsg: ElementFinder;
  public timeTableLink: ElementFinder;
  public contextMapArrowLink: ElementFinder;
  public contextMapLink: ElementFinder;
  public signalMapLink: ElementFinder;
  public trainSearchRow: ElementArrayFinder;
  public timeTableSearchRow: ElementArrayFinder;
  public signalSearchRow: ElementArrayFinder;
  public statusUnmatched: ElementFinder;
  public signalColumnHeader: ElementFinder;
  public signalContext: ElementFinder;
  public tmvKeyButton: ElementFinder;
  public modalWindow: ElementArrayFinder;
  public helpMenu: ElementFinder;
  public searchFilterToggle: ElementFinder;
  constructor() {
    this.navBarIcons = element.all(by.css('.navbar .material-icons'));
    this.mapLayerToggles = element.all(by.css('.map-toggle-div .toggle-text'));
    this.platformToggleIndicator = element(by.css('#platformtoggle .toggle-switch'));
    this.platformToggleOn = element(by.css('#platformtoggle .absolute-on'));
    this.platformToggleOff = element(by.css('#platformtoggle .absolute-off'));
    this.berthToggleOn = element(by.css('#berthtoggle .absolute-on'));
    this.berthToggleOff = element(by.css('#berthtoggle .absolute-off'));
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
    this.trainTable = element(by.css('.modalbody:nth-child(2)'));
    this.trainTableCloseIcon = element(by.css('.closemodal:nth-child(1)'));
    this.trainTableCloseBtn = element(by.css('.tmv-btn-cancel:nth-child(1)'));
    this.trainTableWindow = element(by.css('.modaltitle:nth-child(1)'));
    this.trainContextMenu = element(by.id('trainSearchContextmenu'));
    this.timeTableContextMenu = element(by.id('timetableSearchContextmenu'));
    this.trainSearchRow = element.all(by.css('#trainSearchResults-tbody tr'));
    this.timeTableSearchRow = element.all(by.css('#timetableSearchResults-tbody tr'));
    this.trainsContextListItems = element.all(by.css('.dropdown-item-menu:nth-child(1)'));
    this.trainSearchWarningMsg = element(by.css('.div-warning-msg:nth-child(1)'));
    this.timeTableLink = element(by.id('btn-open-timetable'));
    this.contextMapArrowLink = element(by.css('#right-arrow:nth-child(1)'));
    this.contextMapLink = element(by.css('#map-list >ul >li:nth-child(1)'));
    this.signalMapLink = element(by.css('#signal-map-list >ul >li:nth-child(1)'));
    this.statusUnmatched = element(by.cssContainingText('#trainSearchResults-tbody tr', 'UNMATCHED'));
    this.tableColumnHeader = element(by.css('#trainSearchResults thead'));
    this.timeTableColumnHeader = element(by.css('#timetableSearchResults thead'));
    this.signalColumnHeader = element(by.css('#signalSearchResults thead'));
    this.signalSearchRow = element.all(by.css('#signalSearchResults tbody>tr'));
    this.signalContext = element(by.id('signalSearchContextMenu'));
    this.tmvKeyButton = element(by.id('tmv-key-button'));
    this.modalWindow = element.all(by.css('.modalpopup'));
    this.helpMenu = element(by.id('help-menu-button'));

  }

  public async getNavbarIconNames(): Promise<string> {
    return this.navBarIcons.getText();
  }

  public async openUserProfileMenu(): Promise<void> {
    const userProfileMenu: ElementFinder = element(by.id('user-profile-menu-button'));
    await userProfileMenu.click();
  }
  public async openLayersMenu(): Promise<void> {
    const LayersMenu: ElementFinder = element(by.id('layers-menu-button'));
    await LayersMenu.click();
  }

  public async getToggleNames(): Promise<string> {
    return this.mapLayerToggles.getText();
  }

  public async getToggleState(toggleName: string): Promise<string> {
    if (toggleName === 'Platform') {
      return this.platformToggleIndicator.getText();
    }
    if (toggleName === 'Berth') {
      return this.berthToggleIndicator.getText();
    }
    return 'Unknown';
  }

  public async toggle(toggleName: string, requiredState: string): Promise<void> {
    const currentState: string = await this.getToggleState(toggleName);
    if (currentState === requiredState)
    {
      return;
    }
    if (toggleName === 'Platform') {
      if (requiredState === 'on') {
        await this.platformToggleOff.click();
      } else {
        await this.platformToggleOn.click();
      }
    }
    else if (toggleName === 'Berth') {
      if (requiredState === 'on') {
        await this.berthToggleOff.click();
      } else {
        await this.berthToggleOn.click();
      }
    }
  }

  public async getUserProfileMenuDisplayName(): Promise<string> {
    const icon: ElementFinder = element(by.id('user-profile-menu-display-name'));
    return icon.getText();
  }

  public async getUserProfileMenuRoleName(): Promise<string> {
    const icon: ElementFinder = element(by.id('user-profile-menu-role-name'));
    return icon.getText();
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
    await this.trainSearchBox.sendKeys(searchValue);
  }

  public async isTrainTablePresent(): Promise<boolean> {
    return browser.isElementPresent(this.trainTable);
  }

  public async isTrainTableWarningPresent(): Promise<boolean> {
    return browser.isElementPresent(this.trainSearchWarningMsg);
  }

  public async trainClickCloseIcon(): Promise<void> {
    return this.trainTableCloseIcon.click();
  }

  public async trainClickCloseBtn(): Promise<void> {
    return this.trainTableCloseBtn.click();
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

  public async isContextMenuDisplayed(): Promise<boolean> {
    return this.trainContextMenu.isPresent();
  }
  public async isSignalContextMenuDisplayed(): Promise<boolean> {
    return this.signalContext.isPresent();
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
    browser.wait(async () => {
      return this.timeTableContextMenu.isPresent();
    }, browser.displayTimeout, 'The trains list context menu should be displayed');
    return this.timeTableContextMenu.isPresent();
  }
  public async waitForSignalContext(): Promise<boolean> {
    browser.wait(async () => {
      return this.signalContext.isPresent();
    }, browser.displayTimeout, 'The trains list context menu should be displayed');
    return this.signalContext.isPresent();
  }
  public async waitForContextMap(): Promise<boolean> {
    browser.wait(async () => {
      return this.contextMapLink.isPresent();
    }, browser.displayTimeout, 'The trains list context menu map should be displayed');
    return this.contextMapLink.isPresent();
  }

  public async rightClickTrainList(position: number): Promise<void> {
    const rows = this.trainSearchRow;
    const targetRow = rows.get(position - 1);
    browser.actions().click(targetRow, protractor.Button.RIGHT).perform();
  }

  public async rightClickTimeTableList(position: number): Promise<void> {
    const rows = this.timeTableSearchRow;
    const targetRow = rows.get(position - 1);
    browser.actions().click(targetRow, protractor.Button.RIGHT).perform();
  }

  public async rightClickSignal(position: number): Promise<void> {
    const rows = this.signalSearchRow;
    const targetRow = rows.get(position - 1);
    browser.actions().click(targetRow, protractor.Button.RIGHT).perform();
  }


  public async waitForContext(): Promise<boolean> {
    browser.wait(async () => {
      return this.trainContextMenu.isPresent();
    }, browser.displayTimeout, 'The trains list context menu should be displayed');
    return this.trainContextMenu.isPresent();
  }

  public async getTimetableEntryValues(): Promise<string[]> {
    const entryColValue: ElementArrayFinder = element.all(by.css('#trainSearchResults-tbody tr'));
    return entryColValue.map((colValues: ElementFinder) => {
      return colValues.getText();
    });
  }

  public async openHelpMenu(): Promise<void> {
    return this.helpMenu.click();
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
}
