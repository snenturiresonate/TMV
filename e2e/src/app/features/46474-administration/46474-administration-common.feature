Feature: 46474 - Administration Common - full end to end testing

  As a tester
  I want to verify the administration page - landing page
  So, that I can identify if the build meets the end to end requirements

  #33767-1 Opening the admin screen
  #Given that I am on the home page
  #When I select the admin option
  #Then the admin view is opened with the display settings displayed as default

  Background:
    Given I am on the home page

  Scenario: Administration page tabs
    When I click the app 'admin'
    And I switch to the new tab
    Then the tab title is 'TMV Administration'

  Scenario: Administration page tabs
    When I click the app 'admin'
    And I switch to the new tab
    Then the following tabs can be seen on the administration
      | tabName             |
      | Display Settings    |
      | Sign In Message     |
      | System Defaults     |
