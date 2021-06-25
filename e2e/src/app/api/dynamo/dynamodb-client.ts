import {promisify} from 'util';

import {browser} from 'protractor';
import {DateTimeFormatter, LocalDate} from '@js-joda/core';
import {DynamoDBClient, BatchExecuteStatementCommand, ListTablesCommand, DeleteTableCommand} from '@aws-sdk/client-dynamodb';

export class DynamodbClient {

  private getClient(): any {
    return new DynamoDBClient({endpoint: `http://${browser.params.redis_host}:8500`});
  }

  public async getTables(): Promise<any> {
    const client: DynamoDBClient = this.getClient();
    const command = new ListTablesCommand({});
    await client.send(command)
      .then(results => {
        return results.TableNames;
      })
      .catch(err => {
      console.error(err);
    });
  }

  public async deleteTable(tableName: string): Promise<void> {
    const client: DynamoDBClient = this.getClient();
    const command = new DeleteTableCommand({TableName: `${tableName}`});
    await client.send(command)
      .then()
      .catch(err => {
        console.error(err);
      });
  }
}
