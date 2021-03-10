import {fragment} from 'xmlbuilder2';

export class AdminContactInfo {
  public static adminContactInfo = (adminContactName: string = 'Network Rail') => {
    const adminContactInfo = fragment().ele('AdministrativeContactInformation')
      .ele('Name').txt(adminContactName)
      .doc();
    return adminContactInfo.end({prettyPrint: true});
  }
}
