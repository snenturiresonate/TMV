import {browser} from 'protractor';
import {DynamodbClient} from '../../api/dynamo/dynamodb-client';
import {DateTimeFormatter, ZonedDateTime} from '@js-joda/core';
import {DateAndTimeUtils} from '../../pages/common/utilities/DateAndTimeUtils';

export class ReplayTimetableDataService {
  private dynamoClient: DynamodbClient = new DynamodbClient();

  public async injectIntoActiveService(
    daysOld: number,
    plusMinutesOffset: number,
    trainDescription: string,
    planningUid: string,
    snapshot: any[]
  ): Promise<void> {
    const now: ZonedDateTime = DateAndTimeUtils.getCurrentDateTime().plusMinutes(plusMinutesOffset);
    const timestamp = now.minusDays(daysOld).toEpochSecond() * 1000;
    const oldDate: string = now.minusDays(daysOld).format(DateTimeFormatter.ofPattern('yyyy-MM-dd'));
    const partitionKey: string = planningUid + ':' + oldDate + '-active-service';
    const modificationsList = this.getModifications(snapshot);

    const entry = {
      currentTrainDescription: {
        S: trainDescription
      },
      trustID: {
        S: 'trustId'
      },
      modifications: {
        L: modificationsList
      }
    };

    const item = {
      partitionKey: {S: partitionKey},
      timestamp: {N: timestamp},
      activeServiceDetails: {M: entry}
    };

    return this.dynamoClient.putItem(item, `ArchiveScheduleDetails-${browser.params.dynamo_suffix}`);
  }

  public async injectIntoPunctuality(
    daysOld: number,
    plusMinutesOffset: number,
    planningUid: string,
    punctuality: number
  ): Promise<void> {
    const now: ZonedDateTime = DateAndTimeUtils.getCurrentDateTime().plusMinutes(plusMinutesOffset);
    const timestamp = now.minusDays(daysOld).toEpochSecond() * 1000;
    const oldDate: string = now.minusDays(daysOld).format(DateTimeFormatter.ofPattern('yyyy-MM-dd'));
    const partitionKey: string = planningUid + ':' + oldDate + '-punctuality';

    const entry = {
      signalPlatedNames: {
        L: [
          {
            S: 'SN7'
          }
        ]
      },
      currentPunctuality: {
        N: punctuality
      },
      offPlan: {
        BOOL: false
      },
      onPathStatus: {
        S: 'ON_PLANNED_PATH'
      },
      berthName: {
        S: 'D3A007'
      }
    };

    const item = {
      partitionKey: {S: partitionKey},
      timestamp: {N: timestamp},
      punctualityDetails: {M: entry}
    };

    return this.dynamoClient.putItem(item, `ArchiveScheduleDetails-${browser.params.dynamo_suffix}`);
  }

  public async injectIntoAssociations(
    daysOld: number,
    plusMinutesOffset: number,
    snapshot: any[],
    planningUid: string
  ): Promise<void> {
    const entries = [];
    const now: ZonedDateTime = DateAndTimeUtils.getCurrentDateTime().plusMinutes(plusMinutesOffset);
    const timestamp = now.minusDays(daysOld).toEpochSecond() * 1000;
    const oldDate: string = now.minusDays(daysOld).format(DateTimeFormatter.ofPattern('yyyy-MM-dd'));
    const partitionKey: string = planningUid + ':' + oldDate + '-associations';

    for (const snapshotEntry of snapshot) {

      const entry = this.getAssociationEntry(snapshotEntry.headcode, snapshotEntry.type, snapshotEntry.location);
      entries.push(entry);
    }

    const item = {
      partitionKey: {S: partitionKey},
      timestamp: {N: timestamp},
      associationDetails: {M: this.getAssociations(entries)}
    };

    return this.dynamoClient.putItem(item, `ArchiveScheduleDetails-${browser.params.dynamo_suffix}`);
  }

  public async injectIntoPlanned(
    daysOld: number,
    plusMinutesOffset: number,
    trainDescription: string,
    planningUidStr: string,
    numberOfEntries: number
  ): Promise<void> {
    const now: ZonedDateTime = DateAndTimeUtils.getCurrentDateTime().plusMinutes(plusMinutesOffset);
    const timestamp = now.minusDays(daysOld).toEpochSecond() * 1000;
    const oldDate: string = now.minusDays(daysOld).format(DateTimeFormatter.ofPattern('yyyy-MM-dd'));
    const partitionKey: string = planningUidStr + ':' + oldDate + '-planned';

    const entry = {
      planningUid: {
        S: planningUidStr
      },
      startDate: {
        S: oldDate
      },
      endDate: {
        S: oldDate
      },
      dateOfTrainService: {
        S: oldDate
      },
      daysRun: {
        L: []
      },
      plannedPathEntries: {
        L: this.getPlannedEntries(numberOfEntries)
      },
      plannedServiceCharacteristics: {
        M: {
          plannedTrainDescription: {
            S: trainDescription
          },
          originLocationId: {
            S: 'PADTON'
          },
          destinationLocationId: {
            S: 'OXFD'
          },
          workingOriginDeptTime: {
            S: '14:09:00'
          },
          workingDestinationArrivalTime: {
            S: '15:19:00'
          },
          publicPlannedOriginDepartureTime: {
            S: '14:09:00'
          },
          publicPlannedDestinationArrivalTime: {
            S: '15:19:00'
          },
          trainCategoryCode: {
            S: 'XX'
          },
          trainClass: {
            N: 7
          },
          serviceBranding: {
            NULL: true
          },
          serviceCode: {
            N: 25507005
          },
          operatorCode: {
            S: 'EF'
          }
        }
      }
    };

    const item = {
      partitionKey: {S: partitionKey},
      timestamp: {N: timestamp},
      plannedScheduleDetails: {M: entry}
    };

    return this.dynamoClient.putItem(item, `ArchiveScheduleDetails-${browser.params.dynamo_suffix}`);
  }

  public async injectIntoPredicted(
    daysOld: number,
    plusMinutesOffset: number,
    trainDescription: string,
    planningUidStr: string
  ): Promise<void> {
    const now: ZonedDateTime = DateAndTimeUtils.getCurrentDateTime().plusMinutes(plusMinutesOffset);
    const timestamp = now.minusDays(daysOld).toEpochSecond() * 1000;
    const oldDate: string = now.minusDays(daysOld).format(DateTimeFormatter.ofPattern('yyyy-MM-dd'));
    const partitionKey: string = planningUidStr + ':' + oldDate + '-predicted';

    const entry = {
      predictedPathEntryList: {
        L: this.getPredictedEntries()
      }
    };

    const item = {
      partitionKey: {S: partitionKey},
      timestamp: {N: timestamp},
      predictedPathEntries: {M: entry}
    };

    return this.dynamoClient.putItem(item, `ArchiveScheduleDetails-${browser.params.dynamo_suffix}`);
  }

  public async injectIntoActuals(
    daysOld: number,
    plusMinutesOffset: number,
    trainDescription: string,
    planningUidStr: string
  ): Promise<void> {
    const now: ZonedDateTime = DateAndTimeUtils.getCurrentDateTime().plusMinutes(plusMinutesOffset);
    const timestamp = now.minusDays(daysOld).toEpochSecond() * 1000;
    const oldDate: string = now.minusDays(daysOld).format(DateTimeFormatter.ofPattern('yyyy-MM-dd'));
    const partitionKey: string = planningUidStr + ':' + oldDate + '-actuals';

    const entry = {
      actualPathEntryList: {
        L: this.getActualEntries()
      }
    };

    const item = {
      partitionKey: {S: partitionKey},
      timestamp: {N: timestamp},
      actualPathEntries: {M: entry}
    };

    return this.dynamoClient.putItem(item, `ArchiveScheduleDetails-${browser.params.dynamo_suffix}`);
  }

  private getAssociations(entries: any): any {
    return {
      associations: {
        L: entries
      }
    };
  }

  private getAssociationEntry(headcode: string, type: string, location: string): any {
    return {
      M: {
        trainDescription: {
          S: headcode
        },
        locationId: {
          S: location
        },
        associationType: {
          S: type
        }
      }
    };
  }

  private getModifications(snapshot: any[]): any {
    const modifications: any[] = [];
    if (snapshot) {
      // tslint:disable-next-line:prefer-for-of
      for (let i = 0; i < snapshot.length; i++) {
        const snapshotEntry = snapshot[i];
        if (snapshotEntry) {
          modifications.push(this.getModificationEntry(snapshotEntry));
        }
      }
    }

    return modifications;
  }

  private getModificationEntry(snapshotEntry: any): any {
    return {
      M: {
        modificationType: {
          S: snapshotEntry.type
        },
        modificationLocation: {
          S: snapshotEntry.location
        },
        modificationDatetime: {
          S: snapshotEntry.dateTime
        },
        modificationReason: {
          S: snapshotEntry.reason
        }
      }
    };
  }

  private getPlannedEntries(numberOfEntries: number): any {
    const plannedEntries: any[] = [
      {
        M: {
          plannedPathEntryId: {
            S: 'fc30301a-3a44-41b9-b410-dcb94ee47757'
          },
          sequenceNumber: {
            N: 0
          },
          workingArrivalTime: {
            NULL: true
          },
          workingDeptTime: {
            S: '14:09:00'
          },
          publicArrivalTime: {
            NULL: true
          },
          publicDeptTime: {
            S: '14:09:00'
          },
          enrichedAssetCode: {
            S: 4
          },
          enrichedPathCode: {
            S: ''
          },
          enrichedLineCode: {
            S: 1
          },
          engineeringAllowance: {
            NULL: true
          },
          pathingAllowance: {
            NULL: true
          },
          performanceAllowance: {
            NULL: true
          },
          activity: {
            L: [
              {
                S: 'TB'
              }
            ]
          },
          planningLocationCode: {
            S: 'PADTON'
          },
          locationType: {
            S: 'PLAN'
          },
          changeEnRoutePlannedStockCharacteristics: {
            NULL: true
          }
        }
      }
    ];

    if (numberOfEntries > 1) {
      plannedEntries.push({
        M: {
          plannedPathEntryId: {
            S: '7c3f5239-7cb5-48ce-8155-246c9db0853f'
          },
          sequenceNumber: {
            N: 1
          },
          workingArrivalTime: {
            NULL: true
          },
          workingDeptTime: {
            S: '14:10:00'
          },
          publicArrivalTime: {
            NULL: true
          },
          publicDeptTime: {
            NULL: true
          },
          enrichedAssetCode: {
            S: ''
          },
          enrichedPathCode: {
            N: 1
          },
          enrichedLineCode: {
            S: '1'
          },
          engineeringAllowance: {
            NULL: true
          },
          pathingAllowance: {
            NULL: true
          },
          performanceAllowance: {
            NULL: true
          },
          activity: {
            L: []
          },
          planningLocationCode: {
            S: 'ROYAOJN'
          },
          locationType: {
            S: 'PLAN'
          },
          changeEnRoutePlannedStockCharacteristics: {
            NULL: true
          }
        }
      });
    }

    return plannedEntries;
  }

  private getPredictedEntries(): any[] {
    return [
      {
        M: {
          predictedPathEntryId: {
            S: 'pre0301a-3a44-41b9-b410-dcb94ee47757'
          },
          sequenceNumber: {
            N: 0
          },
          predictedArrivalTime: {
            NULL: true
          },
          predictedDeptTime: {
            S: '14:11:00'
          },
          predictedAssetCode: {
            S: 5
          },
          predictedPathCode: {
            S: ''
          },
          predictedLineCode: {
            S: '2'
          },
          predictedArrivalPunctuality: {
            N: 120
          },
          predictedDeparturePunctuality: {
            N: 180
          },
          locationCode: {
            S: '2'
          }
        }
      }
    ];
  }

  private getActualEntries(): any[] {
    return [
      {
        M: {
          actualPathEntryId: {
            S: 'act0301a-3a44-41b9-b410-dcb94ee47757'
          },
          sequenceNumber: {
            N: 1
          },
          actualArrivalDateTime: {
            NULL: true
          },
          actualDeptDateTime: {
            S: '14:12:00'
          },
          calculatedArrivalTime: {
            NULL: true
          },
          calculatedDepartureTime: {
            S: '14:12:00'
          },
          trustArrivalTime: {
            NULL: true
          },
          trustDepartureTime: {
            S: '14:12:00'
          },
          actualAsset: {
            S: 5
          },
          actualPathCode: {
            S: ''
          },
          actualLineCode: {
            S: '2'
          },
          actualPunctuality: {
            N: 120
          },
          locationCode: {
            S: '2'
          },
          source: {
            S: 'INTERNAL'
          }
        }
      }
    ];
  }
}
