Feature: 51351 - Administration Login Message Part 2 - full end to end testing

  As a tester
  I want to verify the administration page - login message
  So, that I can identify if the build meet the end to end requirements

  Background:
    Given I am on the admin page
    And I navigate to the 'Login Message' admin tab

  @bug @bug_54385 @manual
  Scenario: 33767-9 Unsaved changes - Pop Up Menu - Cancel Option
    When I update login settings 'Message' as 'I am a message'
    And I close the current tab
    Then I cancel on browser popup

  @bug @bug_54385 @manual
  Scenario: 33767-9 Unsaved changes - Pop Up Menu - Leave Option
    When I update login settings 'Message' as 'I am a message'
    And I close the current tab
    Then I confirm on browser popup

  @bug @bug_54385 @manual
  Scenario: 33767-10 Closing admin without unsaved changes
    When I close the current tab
    Then The browser popup does not appear
    And The admin view is closed

  @bug @bug_54385 @manual
  Scenario: 33767-11 Discarding unsaved changes
    When I update login settings 'Message' as 'I am a message'
    And I close the current tab
    And I confirm on browser popup
    And The admin view is closed
    Given I am on the admin page
    And I navigate to the 'Login Message' admin tab
    Then I should see the login settings 'Message' as 'Welcome to TMV'

  @bug @bug_54385 @manual
  Scenario: 33767-12 Continuing with unsaved changes
    When I update login settings 'Message' as 'I am a message'
    And I close the current tab
    And I cancel on browser popup
    Then I should see the login settings 'Message' as 'I am a message'
