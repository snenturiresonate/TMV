# TMVEndToEndTestFramework

This project was generated with [Angular CLI](https://github.com/angular/angular-cli) version 10.0.1.

## Development server

Run `ng serve` for a dev server. Navigate to `http://localhost:4200/`. The app will automatically reload if you change any of the source files.

## Code scaffolding

Run `ng generate component component-name` to generate a new component. You can also use `ng generate directive|pipe|service|class|guard|interface|enum|module`.

## Build

Run `ng build` to build the project. The build artifacts will be stored in the `dist/` directory. Use the `--prod` flag for a production build.

## Running unit tests

Run `ng test` to execute the unit tests via [Karma](https://karma-runner.github.io).

## Running end-to-end tests

Run `ng e2e` to execute the end-to-end tests via [Protractor](http://www.protractortest.org/).

## Running end-to-end tests against CI

Run `npm run e2e-ci --ci_ip=10.5.0.234` to execute the end-to-end tests via [Protractor](http://www.protractortest.org/), targeting the CI IP address.

## Generating the LINX Test Harness models

* Get the swagger JSON from the swagger UI of the LINX Test Harness and place it into the `tools/*/openapi.json` file.
* Execute the `generate-linx-test-harness-api-from-swagger-spec.sh` script to generate the model.
* Copy the model from `tmp/*/models` into the `src/app/api/linx/models` directory

## Further help

To get more help on the Angular CLI use `ng help` or go check out the [Angular CLI README](https://github.com/angular/angular-cli/blob/master/README.md).

## Example commands to resolve chromedriver conflict issues
### Linux
```shell
sudo apt-get --only-upgrade install google-chrome-stable
chromeVersion=$(google-chrome-stable --version | cut -d ' ' -f 3)
node node_modules/protractor/bin/webdriver-manager clean
node node_modules/protractor/bin/webdriver-manager update --versions.chrome=${chromeVersion}
```
### Mac
```shell
chromeVersion=$(/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --version | cut -d ' ' -f 3)
node node_modules/protractor/bin/webdriver-manager status
node node_modules/protractor/bin/webdriver-manager clean
node node_modules/protractor/bin/webdriver-manager update --versions.chrome=${chromeVersion}
```

