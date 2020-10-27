import {After, Given, Then, When} from 'cucumber';
import { browser } from 'protractor';
import { expect } from 'chai';

const TAB_CREATION_TIMEOUT = 1000;
const TAB_CLOSE_DOWN_TIMEOUT = 10000;
const defaultBrowserWidth = 1980;
const defaultBrowserHeight = 1080;

After({timeout: TAB_CLOSE_DOWN_TIMEOUT}, async () => {
  await closeAllButTheFirstTab();
  await browser.driver.manage().window().setSize(defaultBrowserWidth, defaultBrowserHeight);
});

Given('the number of tabs open is {int}', async (tabs: number) => {
  await browser.wait(async () => {
    const handles = await browser.getAllWindowHandles();
    return handles.length === tabs;
  }, TAB_CREATION_TIMEOUT, 'The number of tabs should be ' + tabs.toString());

  const windowHandles: string[] = await browser.driver.getAllWindowHandles();
  expect(windowHandles.length).to.equal(tabs);
});

When('I switch to the new tab', async () => {
  const windowHandles: string[] = await browser.getAllWindowHandles();
  const finalTab: number = windowHandles.length - 1;
  await browser.driver.switchTo().window(windowHandles[finalTab]);
});

When('I switch to the second-newest tab', async () => {
  const windowHandles: string[] = await browser.getAllWindowHandles();
  const finalTab: number = windowHandles.length - 1;
  const penultimateTab: number = finalTab - 1;
  await browser.driver.switchTo().window(windowHandles[penultimateTab]);
});

When('I close the last tab', async () => {
  await closeLastTab();
});

When('I resize the browser to {int} by {int}', async (width: number, height: number) => {
  await browser.driver.manage().window().setSize(width, height);
});

Then('the url contains {string}', async (appUrlParameter: string) => {
  const appUrl: string = await browser.driver.getCurrentUrl();
  expect(appUrl).to.contain(appUrlParameter);
});

async function closeAllButTheFirstTab(): Promise<void> {
  while ((await browser.getAllWindowHandles()).length > 1) {
    await closeLastTab();
  }

}

async function closeLastTab(): Promise<void> {
  const windowHandles: string[] = await browser.getAllWindowHandles();
  const finalTab: number = windowHandles.length - 1;
  const penultimateTab: number = finalTab - 1;

  await browser.driver.switchTo().window(windowHandles[finalTab]);
  await browser.driver.close();
  await browser.driver.switchTo().window(windowHandles[penultimateTab]);
}
