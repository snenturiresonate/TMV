import {Given, Then, When} from 'cucumber';
import {AuthenticationModalDialoguePage} from '../pages/authentication-modal-dialogue.page';
import {AppPage} from '../pages/app.po';

const authPage: AuthenticationModalDialoguePage = new AuthenticationModalDialoguePage();
const appPage: AppPage = new AppPage();

Given('I sign back in as existing user', async (role: string) => {
  await authPage.signBackIntoCurrentRole();
});
