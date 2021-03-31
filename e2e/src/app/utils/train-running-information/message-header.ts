import { fragment } from 'xmlbuilder2';
import {SenderReferenceCalculator} from '../sender-reference-calculator';
import {LocalDateTime} from '@js-joda/core';

export class TrainRunningInformationMessageHeader {
  public static runDateTime = LocalDateTime.now();

  static calculateSenderReference(trainNumber: string, trainUid: string, hourDepartFromOrigin: number): string {
    return (trainNumber + SenderReferenceCalculator.encodeToSenderReference(trainUid, hourDepartFromOrigin));
  }

  static calculateSenderReferenceTime(trainNumber: string, trainUid: string, hourDepartFromOrigin: any): string {
    return (trainNumber + SenderReferenceCalculator.encodeToSenderReference(trainUid, hourDepartFromOrigin));
  }

  public static messageReference = (messageDateTime: any = TrainRunningInformationMessageHeader.runDateTime) => {
    const messageReferenceObj = fragment().ele('MessageReference')
      .ele('MessageType').txt('4005').up()
      .ele('MessageTypeVersion').txt('5.3.1.GB').up()
      .ele('MessageIdentifier').txt('414d51204e52504230303920202020205e504839247eb882').up()
      .ele('MessageDateTime').txt(messageDateTime)
      .doc();
    return messageReferenceObj.end({prettyPrint: true});

  }
  public static messageHeader = (trainNumber: string, trainUid: string, hourDepartFromOrigin: number) => {
    const senderReference = TrainRunningInformationMessageHeader.calculateSenderReference(trainNumber, trainUid, hourDepartFromOrigin);
    const messageHeaderObj = fragment().ele('MessageHeader')
      .ele('SenderReference').txt(senderReference).up()
      .ele('Sender', {'ns0:CI_InstanceNumber': '01'}).txt('0070').up()
      .ele('Recipient', {'ns0:CI_InstanceNumber': '99'}).txt('9999').up()
      .ele(TrainRunningInformationMessageHeader.messageReference()).up()
      .doc();
    return messageHeaderObj.end({prettyPrint: true});
  }

 public static messageHeaderTime = (trainNumber: string, trainUid: string, hourDepartFromOrigin: number) => {
    const senderReference = TrainRunningInformationMessageHeader.calculateSenderReferenceTime(trainNumber, trainUid, hourDepartFromOrigin);
    const messageHeaderObj = fragment().ele('MessageHeader')
      .ele(TrainRunningInformationMessageHeader.messageReference()).up()
      .ele('SenderReference').txt(senderReference).up()
      .ele('Sender', {'ns0:CI_InstanceNumber': '01'}).txt('0070').up()
      .ele('Recipient', {'ns0:CI_InstanceNumber': '99'}).txt('9999').up()
      .doc();
    return messageHeaderObj.end({prettyPrint: true});
  }
}
