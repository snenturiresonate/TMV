import {TrainsListConfigCommonPage} from '../../pages/trains-list-config/trains.list.config.common.page';
import {When} from 'cucumber';

const page: TrainsListConfigCommonPage = new TrainsListConfigCommonPage();

When('I save the trains list config', async () => {
  await page.saveTrainListConfig();
});

When('I reset the trains list config', async () => {
  await page.saveTrainListConfig();
});
