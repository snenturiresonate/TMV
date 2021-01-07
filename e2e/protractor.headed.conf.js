// @ts-check
// Protractor configuration file, see link for more information
// https://github.com/angular/protractor/blob/master/lib/config.ts

const { SpecReporter, StacktraceOption } = require('jasmine-spec-reporter');

/**
 * @type { import("protractor").Config }
 */
exports.config = {
  allScriptsTimeout: 11000,
  specs: [
    './src/**/features/**/*.feature'
  ],
  capabilities: {
    browserName: 'chrome',
    chromeOptions: {
      args: [ "--disable-gpu", "--window-size=1980,1080" ]
    }
  },
  suites: {
    administration: ['./src/**/features/46474-administration/*.feature', './src/**/features/51351-administration/*.feature'],
    trainsList: ['./src/**/features/33806-trains-list/*.feature']
  },
  directConnect: true,
  baseUrl: '',
  framework: 'custom',
  frameworkPath: require.resolve('protractor-cucumber-framework'),
  cucumberOpts: {
    require: ['./src/**/*.steps.ts','./src/**/*.hooks.ts'],
    // Tell CucumberJS to save the JSON report
    format: 'json:.tmp/results.json',
    // To run specific Scenarios marked with the tag @test (for example), uncomment the next line
    //tags: ['@test']
    // To run all scenarios not marked @bug or @tdd, uncomment the next line
    tags: ['not (@bug or @tdd)']
  },
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
