import {browser} from 'protractor';
import {DynamoDBClient, ListTablesCommand, CreateTableCommand, DeleteTableCommand} from '@aws-sdk/client-dynamodb';

export class DynamodbClient {

  private getClient(): any {
    return new DynamoDBClient({endpoint: `${browser.params.test_harness_ci_ip}:8500`, region: 'eu-west-2'});
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

  public async addTable(tableName: string): Promise<void> {
    const client: DynamoDBClient = this.getClient();
    const command = new CreateTableCommand(
      {TableName: `${tableName}`,
        KeySchema: [{AttributeName: `partitionKey`, KeyType: `HASH`}],
        AttributeDefinitions: [{AttributeName: `partitionKey`, AttributeType: `S`}],
        ProvisionedThroughput: {WriteCapacityUnits: 3, ReadCapacityUnits: 3}
      });
    await client.send(command)
      .then()
      .catch(err => {
        console.error(err);
      });
  }
}
