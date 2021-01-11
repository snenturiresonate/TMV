import { by, element, ElementArrayFinder, ElementFinder} from 'protractor';
import {InputBox} from '../common/ui-element-handlers/inputBox';
import {CommonActions} from "../common/ui-event-handlers/actionsAndWaits";

export class TrainsListPunctualityConfigTab {
  public punctualityHeader: ElementFinder;
  public punctualityColor: ElementArrayFinder;
  public punctualityText: ElementArrayFinder;
  public fromTime: ElementFinder;
  public toTime: ElementFinder;
  constructor() {
    this.punctualityHeader = element(by.css('#punctualityConfiguation .punctuality-header'));
    this.punctualityColor = element.all(by.css('#punctualityConfiguation [class=punctuality-colour][style]'));
    this.punctualityText = element.all(by.css('input[class*=punctuality-name]'));
    this.fromTime = element.all(by.css('section-name')).get(1).element(by.css('input'));
    this.toTime = element.all(by.css('section-name')).get(2).element(by.css('input'));
  }
  public async getTrainPunctualityHeader(): Promise<string> {
    return CommonActions.waitAndGetText(this.punctualityHeader);
  }
  public async getTrainPunctualityColor(index): Promise<string> {
    return InputBox.waitAndGetTextOfInputBox(this.punctualityColor.get(index));
  }
  public async getTrainPunctualityText(index): Promise<string> {
    return InputBox.waitAndGetTextOfInputBox(this.punctualityText.get(index));
  }
  public async getPunctualityFromTime(index): Promise<string> {
    const indexForCss = index + 2; // Incremented by 2 for the purposes of locator
    const elm: ElementFinder = element(by.css(`#punctualityConfiguation div:nth-child(${indexForCss})[class*=col-grid] div:nth-child(2)[class*=section-name] input`));
    return InputBox.waitAndGetTextOfInputBox(elm);
  }
  public async getPunctualityToTime(index): Promise<string> {
    const indexForCss = index + 2; // Incremented by 2 for the purposes of locator
    const elm: ElementFinder = element(by.css(`#punctualityConfiguation div:nth-child(${indexForCss})[class*=col-grid] div:nth-child(3)[class*=section-name] input`));
    return InputBox.waitAndGetTextOfInputBox(elm);
  }
  public async setTrainDisplayNameText(id: string, displayText: string): Promise<void> {
      await InputBox.updateInputBox(element(by.id(id)), displayText);
  }

  public async getTrainDisplayNameText(id: string): Promise<string> {
    return InputBox.waitAndGetTextOfInputBox(element(by.id(id)));
  }
}
