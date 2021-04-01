import {TrainJourneyModificationMessageBuilder} from '../../utils/train-journey-modifications/train-journey-modification-message';
import {OperationalTrainNumberIdentifierBuilder} from '../../utils/train-journey-modifications/operational-train-number-identifier';
import {TrainJourneyModificationBuilder} from '../../utils/train-journey-modifications/train-journey-modification';
import {LocationModifiedBuilder} from '../../utils/train-journey-modifications/location-modified';
import {TimingAtLocationBuilder} from '../../utils/train-journey-modifications/timing-at-location';
import {TimingBuilder} from '../../utils/train-journey-modifications/timing';
import {When} from 'cucumber';
import moment = require('moment');
import {LinxRestClient} from '../../api/linx/linx-rest-client';
import {LocationBuilder} from '../../utils/train-journey-modifications/location';

const linxRestClient: LinxRestClient = new LinxRestClient();

When(/^a TJM is received for train modification$/, async (table: any) => {
  const messages: any = table.hashes();
  for (let i = 0; i < messages.length; i++) {
    const tjmType = (table.hashes()[i].tjmType).toLowerCase();
    const trainNumber = table.hashes()[i].trainNumber;
    const trainUID = table.hashes()[i].trainUID;
    const locationPrimaryCode = table.hashes()[i].locationPrimaryCode;
    const time = moment().format('hh:mm:ss');
    // tslint:disable-next-line:max-line-length
    console.log(routeTJMBuilder(tjmType, trainNumber, trainNumber, locationPrimaryCode, time).toXML());
    // tslint:disable-next-line:max-line-length
    await linxRestClient.postTrainJourneyModification(routeTJMBuilder(tjmType, trainNumber, trainUID, locationPrimaryCode, time).toXML());
    await linxRestClient.waitMaxTransmissionTime();
  }
});

When(/^a TJM is received for change of location$/, async (table: any) => {
  const messages: any = table.hashes();
  for (let i = 0; i < messages.length; i++) {
    const tjmType = (table.hashes()[i].tjmType).toLowerCase();
    const trainNumber = table.hashes()[i].trainNumber;
    const locationPrimaryCodeOfInitialLoc = table.hashes()[i].locationPrimaryCodeOfInitialLoc;
    const locationPrimaryCodeOfNewLoc = table.hashes()[i].locationPrimaryCodeOfNewLoc;
    const locationCodeOfInitialLoc = table.hashes()[i].locationCodeOfInitialLoc;
    const locationCodeOfNewLoc = table.hashes()[i].locationCodeOfNewLoc;
    const time = moment().format('hh:mm:ss');
    // tslint:disable-next-line:max-line-length
    await linxRestClient.postTrainJourneyModification(buildChangeOfLocationTJM(trainNumber, '06', locationCodeOfInitialLoc, locationCodeOfNewLoc, locationPrimaryCodeOfInitialLoc, locationPrimaryCodeOfNewLoc, time).toXML());
    await linxRestClient.waitMaxTransmissionTime();
  }
});

function buildTJM(trainNumber, trainUID, tjmIndicator, locationPrimaryCode, time): any {
  const tjmBuilder = new TrainJourneyModificationMessageBuilder()
    .create()
    .withMessageHeader(trainNumber)
    .withOperationalTrainNumberIdentifier(new OperationalTrainNumberIdentifierBuilder()
      .withOperationalTrainNumber(trainNumber)
      .build())
    .withTrainJourneyModification(new TrainJourneyModificationBuilder()
      .withTrainJourneyModificationIndicator(tjmIndicator)
        .withLocationModified(new LocationModifiedBuilder()
          .withModificationStatusIndicator(tjmIndicator)
            .withLocation(locationPrimaryCode)
              .withTimingAtLocation(new TimingAtLocationBuilder()
                .withTiming(new TimingBuilder()
                  .withTime(time)
                  .build())
                .build())
              .build())
            .build())
      .build();
  return tjmBuilder;
}

function buildOutOfPlanCancellationTJM(trainNumber, tjmIndicatorLocation1, tjmIndicatorLocation2, locationPrimaryCode, time): any {
  const tjmBuilder = new TrainJourneyModificationMessageBuilder()
    .create()
    .withOperationalTrainNumberIdentifier(new OperationalTrainNumberIdentifierBuilder()
      .withOperationalTrainNumber(trainNumber)
      .build())
    .withTrainJourneyModification(new TrainJourneyModificationBuilder()
      .withTrainJourneyModificationIndicator(tjmIndicatorLocation1)
      .withLocationModified(new LocationModifiedBuilder()
        .withModificationStatusIndicator(tjmIndicatorLocation1)
        .withLocation(locationPrimaryCode)
        .withTimingAtLocation(new TimingAtLocationBuilder()
          .withTiming(new TimingBuilder()
            .withTime(time)
            .build())
          .build())
        .build())
      .build())
    .withTrainJourneyModification(new TrainJourneyModificationBuilder()
      .withTrainJourneyModificationIndicator(tjmIndicatorLocation2)
      .withLocationModified(new LocationModifiedBuilder()
        .withModificationStatusIndicator(tjmIndicatorLocation2)
        .withLocation(locationPrimaryCode)
        .withTimingAtLocation(new TimingAtLocationBuilder()
          .withTiming(new TimingBuilder()
            .withTime(time)
            .build())
          .build())
        .build())
      .build())
    .build();
  return tjmBuilder;
}

// tslint:disable-next-line:max-line-length
function buildChangeOfLocationTJM(trainNumber, tjmIndicatorLocation, initialLocation, newLocation, locationPrimaryCodeInitialLoc, locationPrimaryCodeNewLoc, time): any {
  const tjmBuilder = new TrainJourneyModificationMessageBuilder()
    .create()
    .withOperationalTrainNumberIdentifier(new OperationalTrainNumberIdentifierBuilder()
      .withOperationalTrainNumber(trainNumber)
      .build())
    .withTrainJourneyModification(new TrainJourneyModificationBuilder()
      .withTrainJourneyModificationIndicator(tjmIndicatorLocation)
        .withLocationModified(new LocationModifiedBuilder()
          .withModificationStatusIndicator(tjmIndicatorLocation)
          // tslint:disable-next-line:max-line-length
          .withLocation(new LocationBuilder().withLocationSubsidiaryIdentification(initialLocation).withLocationPrimaryCode(locationPrimaryCodeInitialLoc).build())
          .withTimingAtLocation(new TimingAtLocationBuilder()
            .withTiming(new TimingBuilder()
              .withTime(time)
              .build())
            .build())
          .build())
      .withLocationModified(new LocationModifiedBuilder()
        .withModificationStatusIndicator(tjmIndicatorLocation)
        // tslint:disable-next-line:max-line-length
        .withLocation(new LocationBuilder().withLocationSubsidiaryIdentification(newLocation).withLocationPrimaryCode(locationPrimaryCodeNewLoc).build())
        .withTimingAtLocation(new TimingAtLocationBuilder()
          .withTiming(new TimingBuilder()
            .withTime(time)
            .build())
          .build())
        .build())
      .build())
    .build();
  return tjmBuilder;
}

function routeTJMBuilder(modificationType: string, trainNumber: string, trainUID: string, locationPrimaryCode: string, time: string): any {
  let tjmModificationMessage;
  switch (modificationType) {
    case ('cancel at origin'):
      tjmModificationMessage = buildTJM(trainNumber, trainUID, 91, locationPrimaryCode, time);
      break;
    case ('cancel en route'):
      tjmModificationMessage = buildTJM(trainNumber, trainUID, 92, locationPrimaryCode, time);
      break;
    case ('out of plan cancellation'):
      tjmModificationMessage = buildOutOfPlanCancellationTJM(trainNumber, '93', '06', locationPrimaryCode, time);
      break;
    case ('Trains reinstatement - Whole train'):
      tjmModificationMessage = buildTJM(trainNumber, trainUID, 96, locationPrimaryCode, time);
      break;
    case ('Change of Origin'):
      tjmModificationMessage = buildTJM(trainNumber, trainUID, 94, locationPrimaryCode, time);
      break;
    case ('Change of Identity'):
      tjmModificationMessage = buildTJM(trainNumber, trainUID, '07', locationPrimaryCode, time);
      break;
  }
  return tjmModificationMessage;
}
