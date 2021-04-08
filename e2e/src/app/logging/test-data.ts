import {TrainJourneyModificationMessage} from '../utils/train-journey-modifications/train-journey-modification-message';

export class TestData {

  private static tjmsSent: TrainJourneyModificationMessage[];

  public static addTJM(message: TrainJourneyModificationMessage): void {
    TestData.tjmsSent.push(message);
  }

  public static getTJMs(): TrainJourneyModificationMessage[] {
    return TestData.tjmsSent;
  }

  public static resetTJMsCaptured(): void {
    TestData.tjmsSent = new Array<TrainJourneyModificationMessage>();
  }
}
