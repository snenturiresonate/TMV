import {fragment} from 'xmlbuilder2';

export class AdminContactInfo {
  public static adminContactInfo = (adminContactName: string = 'Network Rail') => {
    const adminContactInfo = fragment().ele('ns0:AdministrativeContactInformation')
      .ele('ns0:Name').txt(adminContactName)
      .doc();
    return adminContactInfo.end({prettyPrint: true});
  }
}
