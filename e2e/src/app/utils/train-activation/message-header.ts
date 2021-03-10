import { fragment } from 'xmlbuilder2';
import {SenderReferenceCalculator} from '../sender-reference-calculator';
import {LocalDateTime} from '@js-joda/core';

export class TrainActivationMessageHeader {
  public static runDateTime = LocalDateTime.now();

  static calculateSenderReference(trainNumber: string, trainUid: string, hourDepartFromOrigin: number): string {
    return (trainNumber + SenderReferenceCalculator.encodeToSenderReference(trainUid, hourDepartFromOrigin));
  }

  public static messageReference = (messageDateTime: any = TrainActivationMessageHeader.runDateTime) => {
    const messageReferenceObj = fragment().ele('MessageReference')
      .ele('MessageType').txt('2003').up()
      .ele('MessageTypeVersion').txt('5.3.1.GB').up()
      .ele('MessageIdentifier').txt('414d51204e52504230303920202020205e504839249a2a40').up()
      .ele('MessageDateTime').txt(messageDateTime)
      .doc();
    return messageReferenceObj.end({prettyPrint: true});

  }
  public static messageHeader = (trainNumber: string, trainUid: string, hourDepartFromOrigin: number) => {
    const senderReference = TrainActivationMessageHeader.calculateSenderReference(trainNumber, trainUid, hourDepartFromOrigin);
    const messageHeaderObj = fragment().ele('MessageHeader')
      .ele(TrainActivationMessageHeader.messageReference()).up()
      .ele('SenderReference').txt(senderReference).up()
      .ele('Sender', {'n1:CI_InstanceNumber': '01'}).txt('0070').up()
      .ele('Recipient', {'n1:CI_InstanceNumber': '99'}).txt('0070').up()
      .doc();
    return messageHeaderObj.end({prettyPrint: true});
  }
}
