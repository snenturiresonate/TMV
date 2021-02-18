import {DateTimeFormatter, LocalDateTime} from '@js-joda/core';
import {ReplayActionType} from './replay-action-type';

export class ReplayStep{
  public timestamp: string;
  public actionType: ReplayActionType;
  public step: string;
  constructor(actionType: ReplayActionType, step: string) {
    this.timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern('HH:mm:ss'));
    this.actionType = actionType;
    this.step = step;
  }
}
