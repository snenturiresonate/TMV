import {browser} from 'protractor';
import {DateTimeFormatter, ZonedDateTime, ZoneId} from '@js-joda/core';
import {DateAndTimeUtils} from '../../pages/common/utilities/DateAndTimeUtils';
import {DynamodbClient} from '../../api/dynamo/dynamodb-client';
import * as fs from 'fs';
import * as path from 'path';
import {ProjectDirectoryUtil} from '../../utils/project-directory.util';

export class ReplayMapDataService {
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
    const sortKey = `${now.minusDays(daysOld).toEpochSecond() * 1000}-0`;
    const oldDate: string = now.minusDays(daysOld).format(DateTimeFormatter.ofPattern('yyyy-MM-dd'));
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
    const now: ZonedDateTime = DateAndTimeUtils.getCurrentDateTime().minusDays(daysOld).plusMinutes(plusMinutesOffset);
    const sortKey = `${now.toEpochSecond() * 1000}-0`;
    const oldDate: string = now.format(DateTimeFormatter.ofPattern('yyyy-MM-dd'));
    const nowTime: string = now.withZoneSameInstant(ZoneId.UTC).format(DateTimeFormatter.ofPattern('HH:mm:ss'));
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
    const epoch = now.minusDays(daysOld + 1).toEpochSecond() * 1000;

    const mapGroupingConfigBuffer: Buffer = fs.readFileSync(path.join(ProjectDirectoryUtil.testDataFolderPath(), 'map/map-groupings-config.json'));
    const mapGroupingsConfig = JSON.parse(mapGroupingConfigBuffer.toString());

    const item = {
      partitionKey: {S: 'MapGrouping'},
      createdDateTime: {N: epoch},
      mapGroupings: {S: JSON.stringify(mapGroupingsConfig)}
    };

    return this.dynamoClient.putItem(item, `MapGroupingConfiguration-${browser.params.dynamo_suffix}`);
  }

  public async injectManualTrustBerthSnapshotAudit(
    daysOld: number,
    plusMinutesOffset: number,
    mapId: string,
    planningUid: string,
    headcode: string,
    locationSubsidiaryCode: string,
    manualTrustBerthId: string): Promise<void> {

    if (headcode.includes('generated')) {
      headcode = browser.referenceTrainDescription;
    }
    const now: ZonedDateTime = DateAndTimeUtils.getCurrentDateTime().minusDays(daysOld).plusMinutes(plusMinutesOffset);
    const updateTime = `${now.toEpochSecond() * 1000}`;
    const oldDate: string = now.format(DateTimeFormatter.ISO_LOCAL_DATE);
    const nowTime: string = now.withZoneSameInstant(ZoneId.UTC).format(DateTimeFormatter.ofPattern('HH:mm:ss'));
    const manualTrustBerthDateTime = `${oldDate}T${nowTime}Z`;

    const manualTrustBerth = {
      lastMessageId: `${updateTime}-0`,
      manualTrustBerthStates: [
        {
          manualTrustBerthId,
          planningLocationCode: locationSubsidiaryCode,
          manualTrustBerthDateTime,
          manualTrustBerthStateUpdates: [
            {
              manualTrustBerthDateTime,
              manualTrustBerthTrainDescription: headcode,
              offRoute: '0',
              status: 'C',
              manualTrustBerthScheduleId: {
                planningUid,
                scheduledOriginDepartureDate: oldDate
              }
            }
          ]
        }
      ]
    };

    const item = {
      mapId: {S: mapId.toLowerCase()},
      updateTime: {N: updateTime},
      newValue: {S: JSON.stringify(manualTrustBerth)}
    };

    return this.dynamoClient.putItem(item, `ManualTrustBerthSnapshotAudit-${browser.params.dynamo_suffix}`);
  }


  public async injectManualTrustBerthObjectStateAudit(
    daysOld: number,
    plusMinutesOffset: number,
    trainDescriber: string,
    planningUid: string,
    headcode: string,
    locationSubsidiaryCode: string,
    manualTrustBerthId: string): Promise<void> {

    if (headcode.includes('generated')) {
      headcode = browser.referenceTrainDescription;
    }
    const now: ZonedDateTime = DateAndTimeUtils.getCurrentDateTime().minusDays(daysOld).plusMinutes(plusMinutesOffset);
    const streamRecordId = `${now.toEpochSecond() * 1000}-0`;
    const oldDate: string = now.format(DateTimeFormatter.ofPattern('yyyy-MM-dd'));
    const nowTime: string = now.withZoneSameInstant(ZoneId.UTC).format(DateTimeFormatter.ofPattern('HH:mm:ss'));
    const manualTrustBerthDateTime = `${oldDate}T${nowTime}Z`;

    const manualTrustBerth = {
      manualTrustBerthId,
      planningLocationCode: locationSubsidiaryCode,
      manualTrustBerthDateTime,
      manualTrustBerthStateUpdates: [
        {
          manualTrustBerthDateTime,
          manualTrustBerthTrainDescription: headcode,
          offRoute: '0',
          status: 'C',
          manualTrustBerthScheduleId: {
            planningUid,
            scheduledOriginDepartureDate: oldDate
          }
        }
      ]
    };

    const item = {
      partitionKey: {S: trainDescriber},
      streamRecordId: {S: streamRecordId},
      newValue: {S: JSON.stringify(manualTrustBerth)}
    };

    return this.dynamoClient.putItem(item, `ManualTrustBerthEventAudit-${browser.params.dynamo_suffix}`);
  }

}
