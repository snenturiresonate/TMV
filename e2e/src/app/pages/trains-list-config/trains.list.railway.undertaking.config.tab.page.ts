import {by, element, ElementFinder} from 'protractor';
import {TrainsListConfigMultiSelectListPageObject} from './trains.list.config.multi.select.list.page';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';


export class TrainsListRailwayUndertakingConfigTabPageObject extends TrainsListConfigMultiSelectListPageObject {
  public tocFocTabTitle: ElementFinder;
  public tocFocClearAllButton: ElementFinder;
  public tocFocResetButton: ElementFinder;
  constructor() {
    super(
      element.all(by.css('.tmv-tabs >ul>li')),
      element.all(by.css('.column-container .header')),
      element.all(by.css('#railwayUndertakingConfiguation >div >div:nth-child(2) div[class*=section-name]>span:nth-child(1)')),
      element.all(by.css('#railwayUndertakingConfiguation >div >div:nth-child(4) div[class*=section-name]>span:nth-child(2)')),
      element.all(by.css('.col-sm-6 >span')),
      element.all(by.css('#railwayUndertakingConfiguation >div >div:nth-child(2) div[class*=section-name]>span:nth-child(2)')),
      element.all(by.css('#railwayUndertakingConfiguation >div >div:nth-child(4) div[class*=section-name]>span:nth-child(1)'))
    );
    this.tocFocTabTitle = element(by.css('#railwayUndertakingConfiguation .punctuality-header'));
    this.tocFocClearAllButton = element(by.id('clearAllTLRailwayUndertakingConfig'));
    this.tocFocResetButton = element(by.id('resetTLRailwayUndertakingConfig'));
  }
  public getTocFocTabTitle(): Promise<string> {
    return CommonActions.waitAndGetText(this.tocFocTabTitle);
  }

  public clickTocFocClearAllButton(): Promise<void> {
    return CommonActions.waitAndClick(this.tocFocClearAllButton);
  }

  public clickTocFocResetButton(): Promise<void> {
    return CommonActions.waitAndClick(this.tocFocResetButton);
  }
}
