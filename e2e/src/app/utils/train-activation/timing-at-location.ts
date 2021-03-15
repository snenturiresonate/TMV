import {fragment} from 'xmlbuilder2';

export class TrainActivationTimingAtLocationBuilder {


  public static timingAtLocation = (time: string, offset: string = '0') => {
    const timingAtLocation = fragment().ele('TimingAtLocation')
      .ele('Timing').att('TimingQualifierCode', 'ALD')
      .ele('Time').txt(time).up()
      .ele('Offset').txt(offset).up()
      .doc();
    return timingAtLocation.end({prettyPrint: true});
  }
}
