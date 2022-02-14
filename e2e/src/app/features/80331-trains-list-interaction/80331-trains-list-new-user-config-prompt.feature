@TMVPhase2 @P2.S3
Feature: 80331 - TMV Trains List Interaction - New User Config Prompt

  As a TMV User
  I want the ability to interact with the trains list
  So that I can access additional functions or information

  Background:
    * I have not already authenticated
    * I access the homepage as standard user
    * I restore all train list configs for current user to the default

  Scenario Outline: 80338 - 1 Trains List Interaction - New User Config Prompt

#    Given the user is authenticated to use TMV
#    When the user opts to access a named trains list for the first time
#    Then the user is presented with the trains list config

#  There will be three named trains list with config saved against each

    When I select the trains list <listNum> button from the home page
    And I switch to the new tab
    Then I am on the trains list config <listNum> page

    Examples:
      | listNum |
      | 1       |
      | 2       |
      | 3       |


  Scenario: 80338 - 2 Trains List Interaction - New User Config Prompt save without edit takes to trains list

#    Given the user is authenticated to use TMV
#    When the user opts to access a named trains list for the first time
#    Then the user is presented with the trains list config

#   the user may decide not to make any changes and view the trains list as is by simply saving the config

    Given I set up a train that is +6 late at PADTON using access-plan/1B69_PADTON_SWANSEA.cif TD D3 interpose into C007 step to 0037
    When I select the trains list 1 button from the home page
    And I switch to the new tab
    And I am on the trains list config 1 page
    And I save the trains list config
    Then The trains list table is visible

