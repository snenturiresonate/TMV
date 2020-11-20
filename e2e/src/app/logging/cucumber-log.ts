import {Status} from 'cucumber';
import {browser} from 'protractor';

export class CucumberLog
{
  public static cucumberLog;
  public static async attachLog(log: any): Promise<void> {
    CucumberLog.cucumberLog = log;
  }
  public static async addScreenshotOnFailure(scenario: any): Promise<void> {
    if (scenario.result.status === Status.FAILED){
      const screenShotFail = await browser.takeScreenshot();
      CucumberLog.cucumberLog.attach(screenShotFail, 'image/png');
    }
  }
  public static async addJson(obj: any): Promise<void> {
      CucumberLog.cucumberLog.attach(JSON.stringify(obj), 'application/json');
  }
  public static async addText(message: string): Promise<void> {
    CucumberLog.cucumberLog.attach(message);
  }
}
