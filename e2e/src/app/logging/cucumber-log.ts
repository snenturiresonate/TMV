import {Status} from 'cucumber';
import {browser, by, element} from 'protractor';

export class CucumberLog
{
  public static cucumberLog: any;
  public static async attachLog(log: any): Promise<void> {
    CucumberLog.cucumberLog = log;
  }
  public static async addScreenshotOnFailure(scenario: any): Promise<void> {
    if (scenario.result.status === Status.FAILED){
      await element(by.css('#user-profile-menu-button')).click();
      await CucumberLog.addScreenshot();
    }
  }
  public static async addJson(obj: any): Promise<void> {
      CucumberLog.cucumberLog.attach(JSON.stringify(obj), 'application/json');
  }
  public static async addText(message: string): Promise<void> {
    CucumberLog.cucumberLog.attach(message);
  }

  public static async addScreenshot(): Promise<void> {
    const screenShotFail = await browser.takeScreenshot();
    await CucumberLog.cucumberLog.attach(screenShotFail, 'image/png');
  }
}
