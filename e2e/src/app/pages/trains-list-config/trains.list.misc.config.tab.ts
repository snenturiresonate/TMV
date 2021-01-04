import { by, element, ElementArrayFinder, ElementFinder} from 'protractor';

export class TrainsListMiscConfigTab {
  public classHeader: ElementFinder;
  public classToggle: ElementArrayFinder;
  public className: ElementArrayFinder;
  public selectAllClassBtn: ElementFinder;
  public clearAllClassBtn: ElementFinder;
  public miscClassRight: ElementArrayFinder;
  public ignoreToggleButton: ElementFinder;
  public timeToRemainBox: ElementFinder;
  constructor() {
    this.classHeader = element(by.id('class-header'));
    this.classToggle = element.all(by.css('.misc-table .toggle-switch >span:nth-child(3)'));
    this.className = element.all(by.css('.misc-table td:nth-child(1)'));
    this.selectAllClassBtn = element(by.id('selectAllClasses'));
    this.clearAllClassBtn = element(by.id('clearAllClasses'));
    this.miscClassRight = element.all(by.css('.misc-div-container>div>div:nth-child(1)'));
    this.ignoreToggleButton = element(by.css('#ignorePdCancel-toggle-menu>label>span:nth-child(3)'));
    this.timeToRemainBox = element(by.id('timeToRemain'));
  }

  public async getTrainMiscClassHeader(): Promise<string> {
    return this.classHeader.getText();
  }

  public async getTrainMiscClassName(index: number): Promise<string> {
    return this.className.get(index).getText();
  }

  public async getTrainMiscClassToggle(index: number): Promise<string> {
    return this.classToggle.get(index).getText();
  }
  public async selectAllButton(): Promise<void> {
    return this.selectAllClassBtn.click();
  }
  public async clearAllButton(): Promise<void> {
    return this.clearAllClassBtn.click();
  }
  public async getTrainMiscClassNameRight(): Promise<string> {
    return this.miscClassRight.getText();
  }
  public async getIgnoreToggleState(): Promise<string> {
    return this.ignoreToggleButton.getText();
  }
  public async clickIgnoreToggle(): Promise<void> {
    return this.ignoreToggleButton.click();
  }
  public async getTimeToRemain(): Promise<string> {
    return this.timeToRemainBox.getAttribute('value');
  }
  public async clickTimeToRemain(): Promise<void> {
    return this.timeToRemainBox.click();
  }
}
