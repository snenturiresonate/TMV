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
    './src/**/features/**/41849-berth-state.feature'
  ],
  capabilities: {
    browserName: 'chrome',
    chromeOptions: {
      args: [ "--disable-gpu", "--window-size=1980,1080" ]
      // args: [ "--disable-gpu", "--window-size=1980,1080" ]
    }
  },
  directConnect: true,
  baseUrl: 'http://10.5.0.154',
  framework: 'custom',
  frameworkPath: require.resolve('protractor-cucumber-framework'),
  cucumberOpts: {
    require: ['./src/**/*.steps.ts'],
    // Tell CucumberJS to save the JSON report
    format: 'json:.tmp/results.json',
    // To run or not to run
    // tags: '['~@bug', '@blp']'
    tags: ['~@bug']
  },
  async onPrepare() {
    require('ts-node').register({
      project: require('path').join(__dirname, './tsconfig.json')
    });
  },
  plugins: [{
    package: 'protractor-multiple-cucumber-html-reporter-plugin',
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
