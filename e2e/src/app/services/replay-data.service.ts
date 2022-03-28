import {browser} from 'protractor';
import {DateTimeFormatter, ZonedDateTime} from '@js-joda/core';
import {DateAndTimeUtils} from '../pages/common/utilities/DateAndTimeUtils';
import {DynamodbClient} from '../api/dynamo/dynamodb-client';
import * as fs from 'fs';
import * as path from 'path';
import {ProjectDirectoryUtil} from '../utils/project-directory.util';

export class ReplayDataService {
  private dynamoClient: DynamodbClient = new DynamodbClient();

  public async injectBerthStateIntoOldSnapshot(
    daysOld: number,
    plusMinutesOffset: number,
    trainDescriber: string,
    berth: string,
    headcode: string,
    signalName: string,
    punctuality: string): Promise<void> {

    if (headcode.includes('generated')) {
      headcode = browser.referenceTrainDescription;
    }
    const now: ZonedDateTime = DateAndTimeUtils.getCurrentDateTime().plusMinutes(plusMinutesOffset);
    const sortKey = `${now.minusDays(daysOld).plusMinutes(plusMinutesOffset).toEpochSecond() * 1000}-0`;
    const oldDate: string = now.minusDays(daysOld).plusMinutes(plusMinutesOffset).format(DateTimeFormatter.ofPattern('yyyy-MM-dd'));
    const punctualityNum = (!!punctuality ? parseInt(punctuality, 10) : 0);

    const tdState = {
      trainDescriberCode: trainDescriber,
      lastMessageId: sortKey,
      trainDescriberStateBerths: [
        {
          berthName: berth,
          trainDescription: headcode,
          trainDescriberCode: trainDescriber,
          scheduleId: {
            planningUid: 'V33732',
            scheduledOriginDepartureDate: `${oldDate}`
          },
          currentSignals: signalName,
          punctuality: punctualityNum
        }
      ]
    };

    const item = {
      partitionKey: {S: trainDescriber},
      sortKey: {S: sortKey},
      trainDescriberState: {S: JSON.stringify(tdState)}
    };

    return this.dynamoClient.putItem(item, `ArchiveTrainDescriberState-${browser.params.dynamo_suffix}`);
  }

  public async injectBerthStateIntoOldObjectState(
    daysOld: number,
    plusMinutesOffset: number,
    trainDescriber: string,
    berth: string,
    headcode: string,
    signalName: string,
    punctuality: string): Promise<void> {

    if (headcode.includes('generated')) {
      headcode = browser.referenceTrainDescription;
    }
    const now: ZonedDateTime = DateAndTimeUtils.getCurrentDateTime().plusMinutes(plusMinutesOffset);
    const sortKey = `${now.minusDays(daysOld).toEpochSecond() * 1000}-0`;
    const oldDate: string = now.minusDays(daysOld).format(DateTimeFormatter.ofPattern('yyyy-MM-dd'));
    const nowTime: string = now.format(DateTimeFormatter.ofPattern('hh:mm:ss'));
    const punctualityNum = (!!punctuality ? parseInt(punctuality, 10) : 0);

    const tdState = {
      berthState: {
        berthStateDateTime: `${oldDate}T${nowTime}Z`,
        berthTrainDescription: headcode,
        scheduleId: {
          planningUid: 'V33732',
          scheduledOriginDepartureDate: `${oldDate}`
        },
        currentSignals: signalName,
        berthId: {
          trainDescriberCode: trainDescriber,
          berthName: berth
        },
        punctuality: punctualityNum
      },
      signalState: {
        signalId: '',
        signalPlatedName: '',
        trainDescriberCode: '',
        signalStateDateTime: '',
        signalState: ''
      }
    };

    const item = {
      objectState: {S: JSON.stringify(tdState)},
      partitionKey: {S: trainDescriber},
      sortKey: {S: sortKey}
    };

    return this.dynamoClient.putItem(item, `ArchiveObjectState-${browser.params.dynamo_suffix}`);
  }

  public async injectMapGroupingConfigurationIntoOldData(daysOld: number): Promise<void> {
    const now: ZonedDateTime = DateAndTimeUtils.getCurrentDateTime();
    const epoch = now.minusDays(daysOld).toEpochSecond() * 1000;

    const mapGroupingConfigBuffer: Buffer = fs.readFileSync(path.join(ProjectDirectoryUtil.testDataFolderPath(), 'map/map-groupings-config.json'));
    const mapGroupingsConfig = JSON.parse(mapGroupingConfigBuffer.toString());

    const item = {
      partitionKey: {S: 'MapGrouping'},
      createdDateTime: {N: epoch},
      mapGroupings: {S: JSON.stringify(mapGroupingsConfig)}
    };

    return this.dynamoClient.putItem(item, `MapGroupingConfiguration-${browser.params.dynamo_suffix}`);
  }
}
