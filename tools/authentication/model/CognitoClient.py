#!/usr/bin/env python3

import boto3
import warnings
import requests
import base64
import json

from botocore import errorfactory


class CognitoClient:
    def __init__(self, stackName: str):
        # this is to work around a known issue with boto: https://github.com/boto/boto3/issues/454
        warnings.filterwarnings("ignore", category=ResourceWarning, message="unclosed.*<ssl.SSLSocket.*>")

        self.stackName = stackName
        self.client = boto3.client('cognito-idp', region_name='eu-west-2')

    def setStackName(self, stackName: str):
        self.stackName = stackName

    def getUserPoolId(self) -> str:
        userPoolId: str = ''
        paginator = self.client.get_paginator('list_user_pools')

        response_iterator = paginator.paginate(
            PaginationConfig={
                'MaxItems': 60,
                'PageSize': 60
            }
        )
        for userPoolsResponse in response_iterator:
            for userPool in userPoolsResponse.get('UserPools'):
                if userPool.get('Name') == self.stackName:
                    return userPool.get('Id')
        if userPoolId == '':
            raise ValueError(f'It was not possible to find a user pool for stack: {self.stackName}')

    def getClientId(self, clientName: str, userPoolId: str='') -> str:
        clientId: str = ''
        if userPoolId == '':
            userPoolId = self.getUserPoolId()

        paginator = self.client.get_paginator('list_user_pool_clients')

        response_iterator = paginator.paginate(
            UserPoolId=userPoolId,
            PaginationConfig={
                'MaxItems': 60,
                'PageSize': 60
            }
        )
        for clientsResponse in response_iterator:
            for client in clientsResponse.get('UserPoolClients'):
                if client.get('ClientName') == clientName:
                    return client.get('ClientId')
        if clientId == '':
            raise ValueError(f'It was not possible to find a client ID for the name provided: {clientName}')

    def getClientSecret(self, userPoolId: str, clientId: str) -> str:
        try:
            descriptionResponse = self.client.describe_user_pool_client(
                UserPoolId=userPoolId,
                ClientId=clientId
            )
            clientSecret: str = descriptionResponse.get('UserPoolClient').get('ClientSecret')
            return clientSecret
        except(errorfactory.ClientError):
            raise ValueError(
                f'It was not possible to get the client secret for user pool: {userPoolId} and client ID: {clientId}')

    def getAccessToken(self, stackName: str, scope: str, clientId: str, clientSecret: str) -> str:
        url = f"https://{stackName}.auth.eu-west-2.amazoncognito.com/oauth2/token"
        payload = {'grant_type': 'client_credentials', 'scope': f"{scope}", 'client_id': clientId}
        encodedCredentials: str = base64.b64encode(f"{clientId}:{clientSecret}".encode('utf-8')).decode("utf-8")
        headers = {'Authorization': f'Basic {encodedCredentials}'}
        tokenResponse = requests.post(url, payload, headers=headers)
        tokenJson = json.loads(tokenResponse.content)
        accessToken = tokenJson.get('access_token')
        if accessToken == None:
            raise ValueError(f'It was not possible to get an access token for: {stackName}, {scope}, {clientId}')
        return accessToken

    def getAccessTokenAdmin(self) -> str:
        userPoolId = self.getUserPoolId()
        clientId = self.getClientId('Back End Services', userPoolId)
        clientSecret = self.getClientSecret(userPoolId, clientId)
        return self.getAccessToken(self.stackName,
                                   'back-end-services/TMV_Admin ' +
                                   'back-end-services/TMV_Standard ' +
                                   'back-end-services/TMV_ScheduleMatching ' +
                                   'back-end-services/TMV_Restrictions', clientId, clientSecret)
