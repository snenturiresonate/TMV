import {fragment} from 'xmlbuilder2';

export class TrainActivationTimingAtLocationBuilder {


  public static timingAtLocation = (time: string, offset: string = '0') => {
    const timingAtLocation = fragment().ele('ns0:TimingAtLocation')
      .ele('ns0:Timing').att('TimingQualifierCode', 'ALD')
      .ele('ns0:Time').txt(time).up()
      .ele('ns0:Offset').txt(offset).up()
      .doc();
    return timingAtLocation.end({prettyPrint: true});
  }
}
