Feature: 46474 - Administration Login Message - full end to end testing

  As a tester
  I want to verify the administration page - login message
  So, that I can identify if the build meet the end to end requirements

  Background:
    Given I have not already authenticated
    And I am on the admin page
    And The admin setting defaults are as originally shipped
    And I navigate to the 'Login Message' admin tab

  Scenario: Login message view
    Then I should see the login settings 'Message' as 'Welcome to TMV'
    And I should see the login settings 'Terms and Conditions' as 'TMV terms of use'

  Scenario: Login message update and reset
    When I update login settings 'Message' as 'Login Message'
    And I update login settings 'Terms and Conditions' as 'Login Terms and Conditions'
    And I reset the login message settings
    Then I should see the login settings 'Message' as 'Welcome to TMV'
    And I should see the login settings 'Terms and Conditions' as 'TMV terms of use'

  Scenario: Login message save and verify
    When I update login settings 'Message' as 'Login Message'
    And I update login settings 'Terms and Conditions' as 'Login Terms and Conditions'
    And I should be able to save the login message settings
    And I navigate to the 'Display Settings' admin tab
    And I navigate to the 'Login Message' admin tab
    Then I should see the login settings 'Message' as 'Login Message'
    And I should see the login settings 'Terms and Conditions' as 'Login Terms and Conditions'

  Scenario: User should see the unsaved dialogue when refreshing the page without saving the changes
    When I update login settings 'Message' as 'Login Message-Edit'
    And I update login settings 'Terms and Conditions' as 'Login Terms and Conditions-Edit'
    And I should be able to save the login message settings
    When I update login settings 'Message' as 'Login Message-Unsaved'
    And I update login settings 'Terms and Conditions' as 'Login Terms and Conditions-Unsaved'
    And I refresh the browser
    And I confirm on browser popup
    And I navigate to the 'Login Message' admin tab
    Then I should see the login settings 'Message' as 'Login Message-Edit'
    And I should see the login settings 'Terms and Conditions' as 'Login Terms and Conditions-Edit'
    And The admin setting defaults are as originally shipped
