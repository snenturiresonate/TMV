import {browser} from 'protractor';
import {Pool} from 'pg';
import {CucumberLog} from '../../logging/cucumber-log';

export class PostgresClient {
  private static databaseHost: string = browser.params.test_harness_ci_ip.replace('http://', '').replace('https://', '');
  private static databasePortTrains: string = browser.params.trainslist_database_port;
  private static databasePortUnscheduled: string = browser.params.unscheduledtrainslist_database_port;
  private static databaseNameTrains: string = browser.params.trainslist_database_name;
  private static databaseNameUnscheduled: string = browser.params.unscheduledtrainslist_database_name;
  private static databaseUser: string = browser.params.trainslist_database_user;
  private static databasePassword: string = browser.params.trainslist_database_password;
  private static maxPoolSize: string = browser.params.trainslist_max_pool_size;
  private trainsClient: Pool;
  private unscheduledTrainsClient: Pool;

  constructor() {
    this.trainsClient = new Pool({
      user: PostgresClient.databaseUser,
      host: PostgresClient.databaseHost,
      database: PostgresClient.databaseNameTrains,
      password: PostgresClient.databasePassword,
      port: PostgresClient.databasePortTrains,
      max: PostgresClient.maxPoolSize
    });

    this.unscheduledTrainsClient = new Pool({
      user: PostgresClient.databaseUser,
      host: PostgresClient.databaseHost,
      database: PostgresClient.databaseNameUnscheduled,
      password: PostgresClient.databasePassword,
      port: PostgresClient.databasePortUnscheduled,
      max: PostgresClient.maxPoolSize
    });
  }

  public async clearAll(): Promise<void> {
    let released = false;

    return this.trainsClient.connect()
      .then(client => client.query('TRUNCATE TABLE train')
        .then(() => {
          client.query('TRUNCATE TABLE location');
          client.release();
          released = true;
        })
        .catch(err => {
          CucumberLog.addText(`Error clearing all from trains list ${err}`);
          if (!released) {
            client.release();
          }
        }));
  }

  public async clearAllUnscheduled(): Promise<void> {
    let released = false;

    return this.unscheduledTrainsClient.connect()
      .then(client => client.query('DELETE FROM unscheduled_train')
        .then(() => {
          client.release();
          released = true;
        })
        .catch(err => {
          CucumberLog.addText(`Error clearing all from unscheduled trains list ${err}`);
          if (!released) {
            client.release();
          }
        }));
  }

  public async findScheduledId(scheduleId: string): Promise<string> {
    const query = {
      text: 'SELECT current_plan_schedule_id from train where train.current_plan_schedule_id = $1',
      values: [scheduleId],
      rowMode: 'array',
    };

    let released = false;

    return this.trainsClient.connect()
      .then(client => client.query(query)
        .then(res => {
          client.release();
          released = true;
          return res?.rows[0][0] ?? {};
        })
        .catch(err => {
          CucumberLog.addText(`Error finding train ${scheduleId} in the trains list ${err}`);
          if (!released) {
            client.release();
          }
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

    let released = false;

    return this.trainsClient.connect()
      .then(client => client.query(train)
        .then(() => client.query(location))
        .then(() => {
          client.release();
          released = true;
        })
        .catch(err => {
          CucumberLog.addText(`Error removing train ${scheduleId} from trains list ${err}`);
          if (!released) {
            client.release();
          }
        }));
  }
}
