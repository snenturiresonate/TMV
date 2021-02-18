import {by, element, ElementFinder} from 'protractor';
import {TrainsListConfigMultiSelectListPageObject} from './trains.list.config.multi.select.list.page';
import {CommonActions} from '../common/ui-event-handlers/actionsAndWaits';


export class TrainsListRailwayUndertakingConfigTabPageObject extends TrainsListConfigMultiSelectListPageObject {
  public tocFocTabTitle: ElementFinder;
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
  }
  public getTocFocTabTitle(): Promise<string> {
    return CommonActions.waitAndGetText(this.tocFocTabTitle);
  }
}
