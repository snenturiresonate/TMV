Feature: 33768-1: TMV User Management - Signing in
  As a TMV user
  I want to be able to log into the TMV application
  so that I can access functionality that the is appropriate for my role

  Background:
    Given I have not already authenticated

  Scenario: 33768 -1 User accessing without being signed in
#Given I have not already authenticated
#When I attempt to access TMV
#Then I am presented with the sign in screen
    When I access the home page without being signed in
    Then I am presented with the sign in screen

  Scenario: 33768 -2 User entering incorrect username or password
  #Given I am on the sign in screen
  #When I enter an invalid username and password combination
  #Then I am informed that the details entered are incorrect
    When I access the home page without valid credentials
    Then I am informed that the details entered are incorrect

  Scenario Outline: 33768 -3 User entering correct username or password
  #Given I am on the sign in screen
  #And I have a valid TMV role
  #When I enter a valid username and password combination
  #Then I am presented with the welcome message
    When I access the homepage as <user>
    Then I am authenticated and see the welcome message
    Examples:
      | user             |
      | admin            |
      | restriction      |
      | standard         |
      | schedulematching |

  Scenario: 33768 -4a Displaying User Profile information- userAdmin
  #Given I am signed in
  #And I have a valid TMV role
  #When I view the user profile menu from the homepage
  #Then I am presented with my name and a list of my assigned roles
    When I access the homepage as admin
    And I open the user profile menu
    Then The user profile shows user roles as
      | roleName              | rowNum |
      | TMV Admin             | 1      |
      | TMV Restrictions      | 2      |
      | TMV Schedule Matching | 3      |
      | TMV Standard          | 4      |

  Scenario: 33768 -4b Displaying User Profile information- userStandard
  #Given I am signed in
  #And I have a valid TMV role
  #When I view the user profile menu from the homepage
  #Then I am presented with my name and a list of my assigned roles
    When I access the homepage as standard
    And I open the user profile menu
    Then The user profile shows user roles as
      | roleName     | rowNum |
      | TMV Standard | 1      |

  Scenario: 33768 -4c Displaying User Profile information- userRestrictions
  #Given I am signed in
  #And I have a valid TMV role
  #When I view the user profile menu from the homepage
  #Then I am presented with my name and a list of my assigned roles
    When I access the homepage as restriction
    And I open the user profile menu
    Then The user profile shows user roles as
      | roleName         | rowNum |
      | TMV Restrictions | 1      |
      | TMV Standard     | 2      |

  Scenario: 33768 -4d Displaying User Profile information- userScheduleMatching
  #Given I am signed in
  #And I have a valid TMV role
  #When I view the user profile menu from the homepage
  #Then I am presented with my name and a list of my assigned roles
    When I access the homepage as schedulematching
    And I open the user profile menu
    Then The user profile shows user roles as
      | roleName              | rowNum |
      | TMV Schedule Matching | 1      |
      | TMV Standard          | 2      |
