import {by, element} from 'protractor';
import {TrainsListConfigMultiSelectListPageObject} from './trains.list.config.multi.select.list.page';

export class TrainsListColumnConfigTabPageObject extends TrainsListConfigMultiSelectListPageObject {
  constructor() {
    super(
      element.all(by.css('.tmv-tabs >ul>li')),
      element.all(by.css('.column-container .header')),
      element.all(by.css('#columnConfiguation >div >div:nth-child(2) div[class*=section-name]>span:nth-child(1)')),
      element.all(by.css('#columnConfiguation >div >div:nth-child(4) div[class*=section-name]>span:nth-child(2)')),
      element.all(by.css('.col-sm-6 >span')),
      element.all(by.css('#columnConfiguation >div >div:nth-child(2) div[class*=section-name]>span:nth-child(2)')),
      element.all(by.css('#columnConfiguation >div >div:nth-child(4) div[class*=section-name]>span:nth-child(1)'))
    );
  }
}
