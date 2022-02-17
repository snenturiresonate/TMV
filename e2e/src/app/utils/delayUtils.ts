import {browser} from 'protractor';

export class DelayUtils {
  public static async waitFor(durationInMs: number): Promise<void> {
    await new Promise((resolve => {
      setTimeout(resolve, durationInMs);
    }));
  }

  public static async waitForTabTitleToContain(title: string): Promise<void> {
    await browser.driver.wait(async () => {
      const tabTitle: string = await browser.driver.getTitle();
      return tabTitle.includes(title);
    }, browser.params.quick_timeout, `Tab title did not contain ${title}`);
  }
}
