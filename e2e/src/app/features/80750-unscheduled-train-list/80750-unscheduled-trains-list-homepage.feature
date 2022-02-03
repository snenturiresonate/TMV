@TMVPhase2 @P2.S4
Feature: 80750 - Unscheduled Trains List - Homepage

  As a TMV User
  I want view a dynamic list of unscheduled trains
  So that I have a central place to determine if manual matching is required

  #  Given the user is authenticated to use TMV
  #  And the user is viewing the homepage
  #  When the user selects the unscheduled train list icon
  #  Then the unscheduled train list is opened in a new browser tab
  #
  #  Comments:
  #  * (To be developed in a later story 80749) - The user can only have one unscheduled trains list open at any time

  Scenario: 81289-1 - Selecting the unscheduled trains list icon from the homepage
    Given I am on the home page
    When I click the app 'unsched-trains'
    Then the number of tabs open is 2
    When I switch to the new tab
    Then the tab title contains 'TMV Unscheduled Trains List'

  @tdd @tdd:80749
  Scenario: 81289-2 - It is only possible to have one unscheduled trains list open
    Given I am on the home page
    When I click the app 'unsched-trains'
    Then the number of tabs open is 2
    When I switch to the new tab
    Then the tab title contains 'TMV Unscheduled Trains List'
    When I switch to the second-newest tab
    When I click the app 'unsched-trains'
    Then the number of tabs open is 2
