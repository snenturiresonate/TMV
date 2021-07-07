import { fragment } from 'xmlbuilder2';
import {SenderReferenceCalculator} from '../sender-reference-calculator';
import {DateAndTimeUtils} from '../../pages/common/utilities/DateAndTimeUtils';

export class TrainActivationMessageHeader {
  public static runDateTime = DateAndTimeUtils.getCurrentDateTime();

  static calculateSenderReference(trainNumber: string, trainUid: string, hourDepartFromOrigin: number, runDate: string = 'today'): string {
    return (trainNumber + SenderReferenceCalculator.encodeToSenderReference(trainUid, hourDepartFromOrigin, runDate));
  }

  public static messageReference = (messageDateTime: any = TrainActivationMessageHeader.runDateTime) => {
    const messageReferenceObj = fragment().ele('ns0:MessageReference')
      .ele('ns0:MessageType').txt('2003').up()
      .ele('ns0:MessageTypeVersion').txt('5.3.1.GB').up()
      .ele('ns0:MessageIdentifier').txt('414d51204e52504230303920202020205e504839249a2a40').up()
      .ele('ns0:MessageDateTime').txt(messageDateTime)
      .doc();
    return messageReferenceObj.end({prettyPrint: true});

  }
  public static messageHeader = (trainNumber: string, trainUid: string, hourDepartFromOrigin: number, runDate: string = 'today') => {
    const senderReference = TrainActivationMessageHeader.calculateSenderReference(trainNumber, trainUid, hourDepartFromOrigin, runDate);
    const messageHeaderObj = fragment().ele('ns0:MessageHeader')
      .ele(TrainActivationMessageHeader.messageReference())
      .ele('ns0:SenderReference').txt(senderReference).up()
      .ele('ns0:Sender', {'ns0:CI_InstanceNumber': '01'}).txt('0070').up()
      .ele('ns0:Recipient', {'ns0:CI_InstanceNumber': '99'}).txt('0070').up()
      .doc();
    return messageHeaderObj.end({prettyPrint: true});
  }
}
