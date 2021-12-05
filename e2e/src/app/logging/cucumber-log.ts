import {Status} from 'cucumber';
import {browser} from 'protractor';
import {RedisClient} from '../api/redis/redis-client';

export class CucumberLog
{
  public static cucumberLog: any;
  public static async attachLog(log: any): Promise<void> {
    CucumberLog.cucumberLog = log;
  }
  public static async addScreenshotOnFailure(scenario: any): Promise<void> {
    if (scenario.result.status === Status.FAILED){
      await CucumberLog.addScreenshot();
    }
  }
  public static async addEnvironmentDetailsOnFailure(scenario: any): Promise<void> {
    if (scenario.result.status === Status.FAILED){
      await CucumberLog.addText(`Stack Name: ${browser.params.dynamo_suffix}, IP: ${browser.params.test_harness_ci_ip}`);
    }
  }
  public static async addLatestRedisMessagesOnFailure(scenario: any): Promise<void> {
    if (scenario.result.status === Status.FAILED){
      const scheduleStreams = ['access-plans', 'agreed-schedules', 'current-schedules', 'enriched-schedules', 'berth-level-schedules'];
      const tdStreams = ['train-describer-updates', 'berth-steps', 'schedule-matching', 'train-describer-D3'];
      const sigStreams = ['signalling-updates', 'signal-states'];
      const redisClient: RedisClient = new RedisClient();
      await CucumberLog.addText('-----');
      await CucumberLog.addText('Schedule Streams:');
      for (const stream of scheduleStreams) {
        await CucumberLog.addText(`${stream}:`);
        await CucumberLog.addText((await redisClient.getLatestFromStream(stream)).toString());
      }
      await CucumberLog.addText('-----');
      await CucumberLog.addText('TD Streams:');
      for (const stream of tdStreams) {
        await CucumberLog.addText(`${stream}:`);
        await CucumberLog.addText((await redisClient.getLatestFromStream(stream)).toString());
      }
      await CucumberLog.addText('-----');
      await CucumberLog.addText('S-class Streams:');
      for (const stream of sigStreams) {
        await CucumberLog.addText(`${stream}:`);
        await CucumberLog.addText((await redisClient.getLatestFromStream(stream)).toString());
      }
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
