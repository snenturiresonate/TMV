import { CloudFormationClient, ListStacksCommand, DescribeStacksCommand } from '@aws-sdk/client-cloudformation';
import { Command } from 'commander';

const program = new Command();
const cloudFormationClient = new CloudFormationClient({ region: 'eu-west-2' });

type StackList = {
  stackCount: number,
  stacks: [
  {
    stackId: string,
    stackName: string,
    stackIP: string
  }
]};

(async () => {
  program
    .option('-d, --debug', 'output extra debugging')
    .requiredOption('-s, --stack <stack>', 'base stack')
    .option('-l, --list', 'list the stacks containing the given stack');

  program.parse(process.argv);
  const options = program.opts();

  if (options.debug) {
    console.log(options);
  }
  if (options.stack) {
    debug(`Using stack: ${options.stack}`);
  }
  if (options.list) {
    debug(`Listing stacks containing: ${options.stack}`);
    const stacks: StackList = await listStacksContaining(`${options.stack}`);
    console.log(JSON.stringify(stacks, null, 2));
  }

  function debug(message: any): void {
    if (options.debug) {
      console.log(message);
    }
  }
})();

async function listStacksContaining(baseStack: string): Promise<StackList> {
  const command = new ListStacksCommand({StackStatusFilter: ['CREATE_COMPLETE']});
  const response = await cloudFormationClient.send(command);

  const stackArray: any = [];
  for (const summary of response.StackSummaries) {
    const regEx = new RegExp(`^(${baseStack}-[0-9])$`);
    if (summary.StackName === baseStack || regEx.test(summary.StackName)) {
      stackArray.push({stackId: summary.StackId, stackName: summary.StackName, stackIP: await getIPAddressForStack(summary.StackName)});
    }
  }
  return {stackCount: stackArray.length, stacks: stackArray};
}

async function getIPAddressForStack(stack: string): Promise<string> {
  const command = new DescribeStacksCommand({StackName: stack});
  const response = await cloudFormationClient.send(command);
  return response.Stacks[0].Outputs[0].OutputValue;
}
