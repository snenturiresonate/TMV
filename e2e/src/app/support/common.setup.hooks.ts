import {Before} from 'cucumber';
import {LinxRestClient} from '../api/linx/linx-rest-client';

let linxRestClient: LinxRestClient;

Before(async () => {
  linxRestClient = new LinxRestClient();
  await linxRestClient.clearCIFs();
});
