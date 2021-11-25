import {
  CognitoIdentityProviderClient,
  DescribeUserPoolClientCommand,
  ListUserPoolsCommand,
  ListUserPoolsCommandOutput,
  ListUserPoolClientsCommand
} from '@aws-sdk/client-cognito-identity-provider';
import { Command } from 'commander';

const program = new Command();
const cognitoIdentityProviderClient = new CognitoIdentityProviderClient({ region: 'eu-west-2' });

type CognitoStackDetails = {
  stackName: string,
  userPoolId: string,
  clientId: string,
  logoutUrl: string
};

(async () => {
  program
    .option('-d, --debug', 'output extra debugging')
    .requiredOption('-s, --stack <stack>', 'base stack');

  program.parse(process.argv);
  const options = program.opts();

  if (options.debug) {
    console.log(options);
  }
  if (options.stack) {
    debug(`Using stack: ${options.stack}`);
    const stackDetails = await getCognitoStackDetails(options.stack);
    console.log(JSON.stringify(stackDetails, null, 2));
  }

  function debug(message: any): void {
    if (options.debug) {
      console.log(message);
    }
  }
})();

async function listUserPools(): Promise<ListUserPoolsCommandOutput> {
  const command = new ListUserPoolsCommand({ MaxResults: 60 });
  return cognitoIdentityProviderClient.send(command);
}

async function getUserPoolId(stackName: string): Promise<string> {
  const userPools = await listUserPools();
  const pool = await userPools.UserPools.find(userPool => userPool.Name === stackName);
  return pool.Id;
}

async function getClientId(userPoolId: string): Promise<string> {
  const command = new ListUserPoolClientsCommand({ UserPoolId: userPoolId });
  const clientList = await cognitoIdentityProviderClient.send(command);
  const tmvClient = await clientList.UserPoolClients.find(client => client.ClientName === 'Tmv Client');
  return tmvClient.ClientId;
}

async function getCognitoStackDetails(stackName: string): Promise<CognitoStackDetails> {
  const userPoolId = await getUserPoolId(stackName);
  const clientId = await getClientId(userPoolId);

  const params = {
    ClientId: `${clientId}`, /* required */
    UserPoolId: `${userPoolId}` /* required */
  };
  const command = new DescribeUserPoolClientCommand(params);
  const response = await cognitoIdentityProviderClient.send(command);
  const logoutUrl = response.UserPoolClient.LogoutURLs[1];
  return {
    stackName,
    userPoolId,
    clientId,
    logoutUrl
  };
}
