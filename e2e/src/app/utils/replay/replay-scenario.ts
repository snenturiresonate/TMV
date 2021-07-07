import {ReplayStep} from './replay-step';
import {DateAndTimeUtils} from '../../pages/common/utilities/DateAndTimeUtils';

export class ReplayScenario {
  public scenarioName: string;
  public date: string;
  public startTime: string;
  public finishTime: string;
  public testResult: string;
  public steps: ReplayStep[];

  constructor(scenarioName: string) {
    this.scenarioName = scenarioName;
    this.steps = Array<ReplayStep>();
    this.startTime = DateAndTimeUtils.getCurrentTimeString();
    this.date = DateAndTimeUtils.getCurrentDateTimeString('dd/MM/yyyy');
  }
}
