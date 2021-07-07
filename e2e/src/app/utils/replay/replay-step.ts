import {ReplayActionType} from './replay-action-type';
import {DateAndTimeUtils} from '../../pages/common/utilities/DateAndTimeUtils';

export class ReplayStep{
  public timestamp: string;
  public actionType: ReplayActionType;
  public step: string;
  constructor(actionType: ReplayActionType, step: string) {
    this.timestamp = DateAndTimeUtils.getCurrentTimeString();
    this.actionType = actionType;
    this.step = step;
  }
}
