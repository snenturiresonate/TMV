import {ReplayStep} from './replay-step';
import {DateTimeFormatter, LocalDateTime} from '@js-joda/core';
import {Scenario} from 'cucumber';
import * as fs from 'fs';
import {ReplayScenario} from './replay-scenario';
import {CucumberLog} from '../../logging/cucumber-log';

export class ReplayRecordings {
  private static scenarios: ReplayScenario[];
  private static recording = false;
  public static start(scenario: Scenario): void {
    this.recording = true;
    if (this.scenarios == null) {
      this.scenarios = new Array<ReplayScenario>();
    }
    this.scenarios.push(new ReplayScenario(scenario.pickle.name));
  }
  public static addStep(step: ReplayStep): void {
    this.lastScenario().steps.push(step);
  }
  public static isRecording(): boolean {
    return this.recording;
  }
  public static finish(scenario: any): void {
    this.recording = false;
    this.lastScenario().finishTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern('HH:mm:ss'));
    this.lastScenario().testResult = scenario.result.status.toString();
    CucumberLog.addText(JSON.stringify(this.lastScenario()));
  }
  public static writeFiles(): void {
    if (this.scenarios != null) {
      const replayOutputDir = '.tmp/replay-recordings';
      if (!fs.existsSync(replayOutputDir)) {
        fs.mkdirSync(replayOutputDir, { recursive: true });
      }
      this.scenarios.forEach(step => {
        fs.writeFileSync(replayOutputDir + `/${step.scenarioName.replace(/ /g, '_')}.json`, JSON.stringify(step));
      });
    }
  }
  private static lastScenario(): ReplayScenario {
    return this.scenarios[this.scenarios.length - 1];
  }
}
