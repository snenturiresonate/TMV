import {LocalDate} from '@js-joda/core';
import {DateAndTimeUtils} from '../pages/common/utilities/DateAndTimeUtils';

export class SenderReferenceCalculator {

  static characterBitLength = 6;
  static amPmIndicatorBitLength = 1;
  static trainIdAlphaBitLength = 5;
  static trainIdNumericBitLength = 18;
  static hourBitLength = 6;
  static dayBitLength = 6;
  static monthBitLength = 5;
  static yearBitLength = 7;

  static TRAIN_ID_ALPHA = [
    ' ',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];
  static XML_VALID_CHARACTER = [
    '-',
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
    '+',
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z'
  ];

  static encodeToSenderReference(trainUid: string, hourDepartFromOrigin: number, date: string = 'today'): string {
    const binaryBits = SenderReferenceCalculator.amPmIndicatorBitLength +
      SenderReferenceCalculator.trainIdAlphaBitLength +
      SenderReferenceCalculator.trainIdNumericBitLength +
      SenderReferenceCalculator.hourBitLength +
      SenderReferenceCalculator.dayBitLength +
      SenderReferenceCalculator.monthBitLength +
      SenderReferenceCalculator.yearBitLength;

    let runDate: LocalDate;
    if (date === 'today') {
      runDate = DateAndTimeUtils.getCurrentDateTime();
    }
    else if (date === 'tomorrow') {
      runDate = DateAndTimeUtils.getCurrentDateTime().plusDays(1);
    }

    const year: number = runDate.year() % 100;
    const month: number = runDate.monthValue();
    const day: number = runDate.dayOfMonth();
    const trainIdNumeric: number = Number(trainUid.substring(1));
    const trainIdAlpha: number = SenderReferenceCalculator.TRAIN_ID_ALPHA.indexOf(trainUid.substring(0, 1));
    const amPmIndicator: number = Number(hourDepartFromOrigin) >= 12 ? 1 : 0;

    const binary = amPmIndicator.toString(2).padStart(SenderReferenceCalculator.amPmIndicatorBitLength, '0') +
      trainIdAlpha.toString(2).padStart(SenderReferenceCalculator.trainIdAlphaBitLength, '0') +
      trainIdNumeric.toString(2).padStart(SenderReferenceCalculator.trainIdNumericBitLength, '0') +
      Number(hourDepartFromOrigin).toString(2).padStart(SenderReferenceCalculator.hourBitLength, '0') +
      day.toString(2).padStart(SenderReferenceCalculator.dayBitLength, '0') +
      month.toString(2).padStart(SenderReferenceCalculator.monthBitLength, '0') +
      year.toString(2).padStart(SenderReferenceCalculator.yearBitLength, '0');

    let encoded = '';

    for (let x = 0; x < binaryBits; x = x + SenderReferenceCalculator.characterBitLength) {
      const binarySub = binary.substring(x, x + SenderReferenceCalculator.characterBitLength);
      const char = parseInt(binarySub, 2);
      encoded += SenderReferenceCalculator.XML_VALID_CHARACTER[char];
    }
    return encoded;
  }

  static reverseSenderReference(senderReference: string): any {
    let binary = '';
    senderReference = senderReference.substring(4);
    for (let y = 0; y < senderReference.length; y ++) {
      const char = senderReference.split('')[y];
      binary += SenderReferenceCalculator.XML_VALID_CHARACTER.indexOf(char)
        .toString(2)
        .padStart(SenderReferenceCalculator.characterBitLength, '0');
    }

    let currentLastBitIndex = 0;

    const amPmIndicatorBit = binary.substring(currentLastBitIndex, currentLastBitIndex + SenderReferenceCalculator.amPmIndicatorBitLength);
    currentLastBitIndex += SenderReferenceCalculator.amPmIndicatorBitLength;
    const trainIdAlphaBit = binary.substring(currentLastBitIndex, currentLastBitIndex + SenderReferenceCalculator.trainIdAlphaBitLength);
    currentLastBitIndex += SenderReferenceCalculator.trainIdAlphaBitLength;
    // tslint:disable-next-line:max-line-length
    const trainIdNumericBit = binary.substring(currentLastBitIndex, currentLastBitIndex + SenderReferenceCalculator.trainIdNumericBitLength);
    currentLastBitIndex += SenderReferenceCalculator.trainIdNumericBitLength;
    const hourBit = binary.substring(currentLastBitIndex, currentLastBitIndex + SenderReferenceCalculator.hourBitLength);
    currentLastBitIndex += SenderReferenceCalculator.hourBitLength;
    const dayBit = binary.substring(currentLastBitIndex, currentLastBitIndex + SenderReferenceCalculator.dayBitLength);
    currentLastBitIndex += SenderReferenceCalculator.dayBitLength;
    const monthBit = binary.substring(currentLastBitIndex, currentLastBitIndex + SenderReferenceCalculator.monthBitLength);
    currentLastBitIndex += SenderReferenceCalculator.monthBitLength;
    const yearBit = binary.substring(currentLastBitIndex, currentLastBitIndex + SenderReferenceCalculator.yearBitLength);

    return {
      trainUid:  SenderReferenceCalculator.TRAIN_ID_ALPHA[parseInt(trainIdAlphaBit, 2)] + parseInt(trainIdNumericBit, 2),
      date: `20${parseInt(yearBit, 2).toString().padStart(2, '0')}-${parseInt(monthBit, 2).toString().padStart(2, '0')}-${parseInt(dayBit, 2).toString().padStart(2, '0')}`,
      hour: parseInt(hourBit, 2)
    };
  }
}
