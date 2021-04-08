import unittest

from model.CognitoClient import CognitoClient


class CognitoClientTest(unittest.TestCase):
    def setUp(self) -> None:
        self.stackName = 'tmv-national-test-perf'
        self.cognitoClient: CognitoClient = CognitoClient(self.stackName)

    def testCanGetUserPoolId(self):
        userPoolId: str = self.cognitoClient.getUserPoolId()
        self.assertTrue(userPoolId.__contains__('eu-west-2'))

    def testNegativeGetUserPoolId(self):
        self.cognitoClient.setStackName('NoneExistentStack')
        self.assertRaises(ValueError, self.cognitoClient.getUserPoolId)

    def testCanGetClientId(self):
        clientId: str = self.cognitoClient.getClientId('Back End Services')
        self.assertNotEqual(clientId, '')

    def testNegativeGetClientId(self):
        self.assertRaises(ValueError, self.cognitoClient.getClientId, 'NoneExistent')

    def testCanGetClientSecret(self):
        clientSecret: str = self.cognitoClient.getClientSecret(
            self.cognitoClient.getUserPoolId(), self.cognitoClient.getClientId('Back End Services'))
        self.assertNotEqual(clientSecret, '')

    def testNegativeGetClientSecret(self):
        self.assertRaises(ValueError,
                          self.cognitoClient.getClientSecret,
                          'eu-west-2_364DPkTL5',
                          'NoneExistentClientId')

    def testCanGetAccessToken(self):
        userPoolId = self.cognitoClient.getUserPoolId()
        clientId = self.cognitoClient.getClientId('Back End Services')
        clientSecret = self.cognitoClient.getClientSecret(userPoolId, clientId)
        accessToken = self.cognitoClient.getAccessToken(self.stackName, 'back-end-services/TMV_Admin', clientId, clientSecret)
        self.assertIsNotNone(accessToken)

    def testNegativeGetAccessToken(self):
        clientId = 'NoneExistentClientId'
        clientSecret = 'NoneExistentSecret'
        self.assertRaises(ValueError, self.cognitoClient.getAccessToken, self.stackName, 'TMV_Admin', clientId, clientSecret)

    def testCanGetAccessTokenAdmin(self):
        self.assertIsNotNone(self.cognitoClient.getAccessTokenAdmin())

if __name__ == '__main__':
    unittest.main()
