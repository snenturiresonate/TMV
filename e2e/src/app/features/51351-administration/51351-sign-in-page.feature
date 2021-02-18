Feature: 51351 - Administration Login Message Part 2 - full end to end testing

  As a tester
  I want to verify the administration page - login message
  So, that I can identify if the build meet the end to end requirements

  Background:
    Given I am on the admin page
    And I navigate to the 'Login Message' admin tab

  @bug @bug_54566
  Scenario: 33767-14 Resetting unsaved changes - Message
    When I update login settings 'Message' as 'I am a message'
    And the unsaved indicator is displayed on the sign in message tab
    When I reset the login message settings
    Then I should see the login settings 'Message' as 'Welcome to TMV'
    And the unsaved indicator is not displayed on the sign in message tab

  @bug @bug_54566
  Scenario: 33767-14 Resetting unsaved changes - T&C
    When I update login settings 'Terms and Conditions' as 'I am terms and conditions'
    And the unsaved indicator is displayed on the sign in message tab
    When I reset the login message settings
    And I should see the login settings 'Terms and Conditions' as 'TMV terms of use'
    And the unsaved indicator is not displayed on the sign in message tab

  Scenario: 33767-8 Editing Log in Message using exceeded and special characteristics
    When I update login settings 'Message' as 'I am one hundred and one characters long, I also contain special characteristics such as !"£$%^!$£"!'
    And I update login settings 'Terms and Conditions' as 'I am two hundred and one characters long, I also contain special characteristics such as !"£$%^!$£"!%. I am two hundred and one characters long, I also contain special characteristics such as !"£$%^!$£'
    Then I should see the login settings 'Message' as 'I am one hundred and one characters long, I also contain special characteristics such as !"£$%^!$£"'
    And I should see the login settings 'Terms and Conditions' as 'I am two hundred and one characters long, I also contain special characteristics such as !"£$%^!$£"!%. I am two hundred and one characters long, I also contain special characteristics such as !"£$%^!$'
    And the unsaved indicator is displayed on the sign in message tab
    And I reset the login message settings
