#!/usr/bin/env python3

import argparse
import sys
import time
from typing import List
from model.CognitoClient import CognitoClient
from os import chdir, path


class Authenticator:
    @staticmethod
    def main(args: List[str]) -> None:
        # change to the directory of the script
        chdir(path.dirname(path.realpath(__file__)))

        parser = argparse.ArgumentParser(description='Get an access token for a TMV CI stack')
        parser.add_argument(
            '--stack-name',
            dest='stackName',
            default='tmv-national-test-perf',
            help='the name of a TMV stack, for which to get an access token')
        parser.add_argument(
            '--users',
            dest='users',
            default=1,
            help='the number of TMV users, for which to create access tokens')
        cmdArgs = parser.parse_args()
        cognitoClient: CognitoClient = CognitoClient(cmdArgs.stackName)
        for i in range(int(cmdArgs.users)):
            # Cognito has a maximum allowed rate of 30 requests per second
            time.sleep(0.1)
            print(cognitoClient.getAccessTokenAdmin())


if __name__ == "__main__":
    Authenticator.main(sys.argv[1:])
