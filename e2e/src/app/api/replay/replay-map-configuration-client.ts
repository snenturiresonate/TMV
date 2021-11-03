import {browser} from 'protractor';

const axios = require('axios');
import {LocalStorage} from '../../../../local-storage/local-storage';
import {CucumberLog} from '../../logging/cucumber-log';
import {AxiosInstance} from 'axios';
import {DateAndTimeUtils} from '../../pages/common/utilities/DateAndTimeUtils';

export class ReplayMapConfigurationClient {
  private client: AxiosInstance;

  public async getClient(): Promise<AxiosInstance> {
    if (this.client == null) {
      const accessToken: string = await LocalStorage.getLocalStorageValueFromRegexKey('CognitoIdentityServiceProvider\..*\.accessToken');
      await CucumberLog.addText(`Using Access Token: ${accessToken}`);

      this.client = axios.create({
        baseURL: browser.baseUrl,
        timeout: browser.params.general_timeout,
        headers: {
          Accept: 'application/json',
          Connection: 'keep-alive',
          Authorization: `Bearer: ${accessToken}`
        }
      });
    }
    return this.client;
  }

  public async getReplayMapGroupings(): Promise<any> {
    try {
      const client = await this.getClient();
      const date = DateAndTimeUtils.getCurrentDateTimeString('yyyy-MM-dd');
      const time = DateAndTimeUtils.getCurrentDateTimeString('HH:mm:ss');
      const url = `/replay-map-configuration-service/maps/groupings/${date}T${time}`;
      await CucumberLog.addText(`Getting URL: ${url}`);
      return client.get(url);
    } catch (error) {
      console.error(error);
    }
  }
}
