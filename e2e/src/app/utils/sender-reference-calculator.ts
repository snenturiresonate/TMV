import {LocalDate} from '@js-joda/core';

export class SenderReferenceCalculator {

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
    const characterBitLength = 6;
    const amPmIndicatorBitLength = 1;
    const trainIdAlphaBitLength = 5;
    const trainIdNumericBitLength = 18;
    const hourBitLength = 6;
    const dayBitLength = 6;
    const monthBitLength = 5;
    const yearBitLength = 7;

    const binaryBits = amPmIndicatorBitLength +
      trainIdAlphaBitLength +
      trainIdNumericBitLength +
      hourBitLength +
      dayBitLength +
      monthBitLength +
      yearBitLength;

    let runDate: LocalDate;
    if (date === 'today') {
      runDate = LocalDate.now();
    }
    else if (date === 'tomorrow') {
      runDate = LocalDate.now().plusDays(1);
    }

    const year: number = runDate.year() % 100;
    const month: number = runDate.monthValue();
    const day: number = runDate.dayOfMonth();
    const trainIdNumeric: number = Number(trainUid.substring(1));
    const trainIdAlpha: number = SenderReferenceCalculator.TRAIN_ID_ALPHA.indexOf(trainUid.substring(0, 1));
    const amPmIndicator: number = Number(hourDepartFromOrigin) >= 12 ? 1 : 0;

    const binary = amPmIndicator.toString(2).padStart(amPmIndicatorBitLength, '0') +
      trainIdAlpha.toString(2).padStart(trainIdAlphaBitLength, '0') +
      trainIdNumeric.toString(2).padStart(trainIdNumericBitLength, '0') +
      Number(hourDepartFromOrigin).toString(2).padStart(hourBitLength, '0') +
      day.toString(2).padStart(dayBitLength, '0') +
      month.toString(2).padStart(monthBitLength, '0') +
      year.toString(2).padStart(yearBitLength, '0');

    let encoded = '';

    for (let x = 0; x < binaryBits; x = x + characterBitLength) {
      const binarySub = binary.substring(x, x + characterBitLength);
      const char = parseInt(binarySub, 2);
      encoded += SenderReferenceCalculator.XML_VALID_CHARACTER[char];
    }

    return encoded;
  }
}
