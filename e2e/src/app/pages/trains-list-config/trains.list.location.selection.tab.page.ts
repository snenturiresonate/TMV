import {by, element, ElementArrayFinder, ElementFinder, protractor} from 'protractor';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';
import {InputBox} from '../common/ui-element-handlers/inputBox';
import {CheckBox} from '../common/ui-element-handlers/checkBox';

export class TrainsListLocationSelectionTab {

    public locationSearchBox: ElementFinder;
    public locationSuggestSearchResultList: ElementFinder;
    public locationSuggestSearchResults: ElementArrayFinder;
    public locationFilterValue: ElementFinder;
    public locationFilterValues: ElementArrayFinder;
    public locationName: ElementArrayFinder;
    public locationFirstType: ElementArrayFinder;
    public locationSecondType: ElementArrayFinder;
    public locationThirdType: ElementArrayFinder;
    public locationFourthType: ElementArrayFinder;
    public locationCancel: ElementArrayFinder;
    public locationSearchResult: ElementFinder;
    public originateCheckbox: ElementFinder;
    public locationTabHeader: ElementFinder;
    public locationTableRow: ElementArrayFinder;
    public locationTableArrows: ElementArrayFinder;
    public locationRemoveIcon: ElementArrayFinder;
    public clearAllButton: ElementFinder;
    public resetButton: ElementFinder;
    constructor() {
        this.locationSearchBox = element(by.id('map-search-box'));
        this.locationSuggestSearchResultList = element(by.id('searchResults'));
        this.locationSuggestSearchResults = element.all(by.css('div#searchResults .result-item'));
        this.locationFilterValue = element(by.id('dropdownFilters'));
        this.locationFilterValues = element.all(by.css('#dropdownFilters:nth-child(1)>option'));
        this.locationName = element.all(by.css('#location-selection-table .row .top-row-padding >span'));
        this.locationCancel = element.all(by.css('.remove-icon-v-align .material-icons'));
        this.locationFirstType = element.all(by.css('.stoptypes:nth-child(1) >span:nth-child(2)'));
        this.locationSecondType = element.all(by.css('.stoptypes:nth-child(1) >span:nth-child(3)'));
        this.locationThirdType = element.all(by.css('.stoptypes:nth-child(1) >span:nth-child(4)'));
        this.locationFourthType = element.all(by.css('.stoptypes:nth-child(1) >span:nth-child(5)'));
        this.locationSearchResult = element(by.css('.result-item:nth-child(1)'));
        this.originateCheckbox = element(by.id('PADTON-ORIGINATE'));
        this.locationTabHeader = element(by.css('#locationSelectionTabContent .punctuality-header'));
        this.locationTableRow = element.all(by.css('#location-selection-table tr'));
        this.locationTableArrows = element.all(by.cssContainingText('#location-selection-table tr span.material-icons', 'keyboard_arrow'));
        this.locationRemoveIcon = element.all(by.cssContainingText('#location-selection-table span.material-icons', `cancel`));
        this.clearAllButton = element(by.id('clearAllTLLocationConfig'));
        this.resetButton = element(by.id('resetTLLocationConfig'));
    }

    public async getLocationSearchBoxText(): Promise<string> {
        return this.locationSearchBox.getAttribute('placeholder');
    }

    public async isLocationSuggestSearchResultDisplayed(): Promise<boolean> {
        return this.locationSuggestSearchResultList.isDisplayed();
    }

    public async getLocationSuggestSearchResults(): Promise<string> {
        return this.locationSuggestSearchResults.getText();
    }

    public async enterLocationSearchString(searchString: string): Promise<void> {
        return InputBox.updateInputBox(this.locationSearchBox, searchString);
    }
    public async getLocationFilterValue(): Promise<string> {
    return this.locationFilterValues.getAttribute('label');
  }
  public async clickLocationFilter(): Promise<void> {
    return this.locationFilterValue.click();
  }
  public async clickLocationResult(): Promise<void> {
    return this.locationSearchResult.click();
  }
  public async chooseLocationFromResult(locationName: string): Promise<void> {
      return CommonActions.waitAndClick(element.all(by.cssContainingText('app-search li', `${locationName}`)).first());
  }
  public async getLocationCancel(): Promise<string> {
    return this.locationCancel.getText();
  }
  public async getLocationValue(): Promise<string> {
    return this.locationName.getText();
  }
  public async getLocationCount(): Promise<number> {
    return this.locationName.count();
  }
  public async getLocationFirstType(): Promise<string> {
    return this.locationFirstType.getText();
  }
  public async getLocationSecondType(): Promise<string> {
    return this.locationSecondType.getText();
  }
  public async getLocationThirdType(): Promise<string> {
    return this.locationThirdType.getText();
  }
  public async getLocationFourthType(): Promise<string> {
    return this.locationFourthType.getText();
  }
  public async cancelLocation(position: number): Promise<void> {
    const rows = this.locationCancel;
    await rows.get(position - 1).click();
  }
  public async clickOriginateCheckbox(): Promise<void> {
    return this.originateCheckbox.click();
  }
  public async isOriginateSelected(): Promise<boolean> {
    return this.originateCheckbox.isSelected();
  }
  public async getLocationTabTitle(): Promise<string> {
      return CommonActions.waitAndGetText(this.locationTabHeader);
  }
  public async getStopTypeOfRow(rowIndex: number, elementOrder: number): Promise<string> {
      const rowIndexForCss = rowIndex + 1;
      const orderIndex = elementOrder + 2;
      return CommonActions.waitAndGetText(element(by.css(`#location-selection-table tr:nth-child(${rowIndexForCss}) .stoptypes span:nth-child(${orderIndex}) label`)));
  }
  public async getLocationTableRowCount(): Promise<number> {
      return this.locationTableRow.count();
  }
  public async moveElementOnePosition(movementDir: string, name: string): Promise <void> {
      let arrowDir: string;
      if (movementDir.toLowerCase() === 'up') {
        arrowDir = 'keyboard_arrow_up';
      } else {
        arrowDir = 'keyboard_arrow_down';
      }
      return CommonActions.waitAndClick(this.getLocationTableIcon(name, arrowDir)
        );
  }
  public async removeLocation(name: string): Promise <void> {
    return CommonActions.waitAndClick(this.getLocationTableIcon(name, 'cancel'));
  }
  public async removeAllLocations(): Promise<void> {
      return this.locationRemoveIcon.each(elm => {
        return CommonActions.waitAndClick(elm);
      });
  }
  public getLocationTableIcon(locationName: string, iconName: string): ElementFinder {
    return this.getRowByLocationName(locationName)
      .element(by.cssContainingText('span.material-icons', `${iconName}`));
  }
  public getRowByLocationName(name: string): ElementFinder {
      return element(by.cssContainingText('#location-selection-table tr', name));
  }
  public async getStopTypeCheckedState(type: string, locationName: string): Promise<boolean> {
      await CommonActions.waitForElementToBeVisible(this.locationTableRow.first());
      return this.getStopTypeOfLocation(type, locationName).isSelected();
  }
  public async setStopTypeCheckedState(type: string, locationName: string, updatedState: string): Promise<void> {
    await CommonActions.waitForElementToBeVisible(this.locationTableRow.first());
    const chkBox = await this.getStopTypeOfLocation(type, locationName);
    if (await chkBox.isEnabled()) {
      return CheckBox.updateCheckBox(chkBox, updatedState);
    } else {
      return;
    }
  }
  public async locationTableArrowsDisplay(): Promise<any> {
      return this.locationTableArrows.isDisplayed();
  }

  public getStopTypeOfLocation(type: string, locationName: string): ElementFinder {
    let stopTypeElm: ElementFinder;
    switch (type) {
      case 'Originate':
        stopTypeElm = element(by.id(`${locationName}-ORIGINATE`));
        break;
      case 'Stop':
        stopTypeElm = element(by.id(`${locationName}-STOP`));
        break;
      case 'Pass':
        stopTypeElm = element(by.id(`${locationName}-PASS`));
        break;
      case 'Terminate':
        stopTypeElm = element(by.id(`${locationName}-TERMINATE`));
        break;
    }
    return stopTypeElm;
  }

  public async makeChange(change: any): Promise<void> {
    switch (change.type) {
      case 'add':
        await this.enterLocationSearchString(change.dataItem);
        await this.clickLocationResult();
        if ((change.parameter !== '' && change.newSetting !== '')) {
          if (change.parameter === 'All') {
            const stopTypes = ['Originate', 'Stop', 'Pass', 'Terminate'];
            for (const stopType of stopTypes) {
              await this.setStopTypeCheckedState(stopType, change.dataItem, change.newSetting);
            }
          }
          else {
             await this.setStopTypeCheckedState(change.parameter, change.dataItem, change.newSetting);
          }
        }
        break;
      case 'remove':
        await this.removeLocation(change.dataItem);
        break;
      case 'edit':
        if (change.parameter === 'All') {
          const stopTypes = ['Originate', 'Stop', 'Pass', 'Terminate'];
          for (const stopType of stopTypes) {
            await this.setStopTypeCheckedState(stopType, change.dataItem, change.newSetting);
          }
        }
        else {
          await this.setStopTypeCheckedState(change.parameter, change.dataItem, change.newSetting);
        }
        break;
      default:
        throw new Error(`Please check the type value in feature file`);
     }
  }

  public async clickClearAllButton(): Promise<void> {
    return CommonActions.waitAndClick(this.clearAllButton);
  }

  public async clickResetButton(): Promise<void> {
    return CommonActions.waitAndClick(this.resetButton);
  }
}

