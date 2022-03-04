import {browser} from 'protractor';
import {Pool} from 'pg';
import {CucumberLog} from '../../logging/cucumber-log';

export class PostgresClient {
  private static databaseHost: string = browser.params.test_harness_ci_ip.replace('http://', '').replace('https://', '');
  private static databasePort: string = browser.params.trainslist_database_port;
  private static databaseName: string = browser.params.trainslist_database_name;
  private static databaseUser: string = browser.params.trainslist_database_user;
  private static databasePassword: string = browser.params.trainslist_database_password;
  private static maxPoolSize: string = browser.params.trainslist_max_pool_size;
  private trainsClient: Pool;

  constructor() {
    this.trainsClient = new Pool({
      user: PostgresClient.databaseUser,
      host: PostgresClient.databaseHost,
      database: PostgresClient.databaseName,
      password: PostgresClient.databasePassword,
      port: PostgresClient.databasePort,
      max: PostgresClient.maxPoolSize
    });
  }

  public async clearAll(): Promise<void> {
    return this.trainsClient.connect()
    .then(client => client.query('TRUNCATE TABLE train')
      .then(() => {
        client.query('TRUNCATE TABLE location');
        client.release();
      })
      .catch(err => {
        CucumberLog.addText(`Error clearing all from trains list ${err}`);
        client.release();
      }));
  }

  public async findScheduledId(scheduleId: string): Promise<string> {
    const query = {
      text: 'SELECT current_plan_schedule_id from train where train.current_plan_schedule_id = $1',
      values: [scheduleId],
      rowMode: 'array',
    };

    return this.trainsClient.connect()
      .then(client => client.query(query)
        .then(res => {
          client.release();
          return res?.rows[0][0] ?? {};
        })
        .catch(err => {
            CucumberLog.addText(`Error finding train ${scheduleId} in the trains list ${err}`);
            client.release();
          }));
  }

  public async removeTrain(scheduleId: string): Promise<void> {
    const train = {
      text: 'DELETE from train where train.current_plan_schedule_id = $1',
      values: [scheduleId],
      rowMode: 'array',
    };
    const location = {
      text: 'DELETE from location where location.current_plan_schedule_id = $1',
      values: [scheduleId],
      rowMode: 'array',
    };

    return this.trainsClient.connect()
      .then(client => client.query(train)
        .then(() => client.query(location))
        .then(() => client.release())
        .catch(err => {
          CucumberLog.addText(`Error removing train ${scheduleId} from trains list ${err}`);
          client.release();
        }));
  }
}
