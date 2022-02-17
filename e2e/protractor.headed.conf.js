// @ts-check
// Protractor configuration file, see link for more information
// https://github.com/angular/protractor/blob/master/lib/config.ts

/**
 * @type { import("protractor").Config }
 */
const path = require('path');
const downloadsPath = path.resolve(__dirname, 'downloads');

exports.config = {
  allScriptsTimeout: 11000,
  params: {
    test_harness_ci_ip: 'http://tmv',
    operations_redis_port: '8600',
    operations_redis_host: 'redis-operations',
    replay_redis_port: '8700',
    replay_redis_host: 'redis-replay',
    schedules_redis_port: '8800',
    schedules_redis_host: 'redis-schedules',
    trainslist_redis_port: '8082',
    trainslist_redis_host: 'redis-trainslist',
    general_timeout: 60 * 1000,
    replay_timeout: 20 * 1000,
    quick_timeout: 10 * 1000,
    downloads_path: downloadsPath,
    elasticSearch: {
      index_clear: {
        max_attempts: 50,
        retry_delay_ms: 100
      }
    }
  },
  specs: [
    './src/**/features/**/*.feature'
  ],
  capabilities: {
    browserName: 'chrome',
    chromeOptions: {
      args: [ "--disable-gpu", "--window-size=1980,1080" ],
      prefs: {
        download: {
          'prompt_for_download': false,
          'default_directory': downloadsPath
        }
      }
    }
  },
  suites: {
    administration: ['./src/**/features/46474-administration/*.feature', './src/**/features/51351-administration/*.feature'],
    trainsList: ['./src/**/features/33806-trains-list/*.feature']
  },
  directConnect: true,
  baseUrl: 'https://suffix.tmv.resonate.tech',
  framework: 'custom',
  frameworkPath: require.resolve('protractor-cucumber-framework'),
  cucumberOpts: {
    require: ['./src/**/*.steps.ts','./src/**/*.hooks.ts'],
    // Tell CucumberJS to save the JSON report
    format: [require.resolve('cucumber-pretty'), 'json:.tmp/results.json'],
    // To run specific Scenarios marked with the tag @test (for example), uncomment the next line
    //tags: ['@test']
    // To run all scenarios not marked @bug or @tdd, uncomment the next line
    tags: ['not (@bug or @tdd or @manual or @superseded)']
  },
  ignoreUncaughtExceptions: true,
  async onPrepare() {
    require('ts-node').register({
      project: require('path').join(__dirname, './tsconfig.json')
    });
  },
  plugins: [{
    package: require.resolve('protractor-multiple-cucumber-html-reporter-plugin'),
    options:{
      automaticallyGenerateReport: true,
      removeExistingJsonReportFile: true,
      customData: {
        title: 'Run info',
        data: [
          {label: 'Project', value: 'TMV'},
          {label: 'Release', value: '0.1'},
        ]
      }
    }
  }]
};
