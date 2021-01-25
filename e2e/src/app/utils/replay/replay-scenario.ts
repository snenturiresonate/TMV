import {ReplayStep} from './replay-step';
import {DateTimeFormatter, LocalDateTime} from '@js-joda/core';

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
    this.startTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern('HH:mm:ss'));
    this.date = LocalDateTime.now().format(DateTimeFormatter.ofPattern('dd/MM/yyyy'));
  }
}
