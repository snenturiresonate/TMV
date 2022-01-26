@TMVPhase2 @P2.S1
Feature: 79622 - TMV Schematic Map Version - Display map version and applicable date

  As a TMV User
  I want to view the version of the schematic maps that is begin displayed
  So that I can be assured that the correct version of the map is being used

  Scenario: 82788 Display map version (Live)
    Given I am viewing the map GW01paddington.v
    When I click on the Help icon
    Then the map version number should be displayed as '1.0'
    And the map date should be displayed as '05/01/2022 00:00'

  @newSession
  Scenario: 82789 Display map version (Replay)
    * I have not already authenticated
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'GW01paddington.v'
    When I click on the Help icon
    Then the map version number should be displayed as '1.0'
    And the map date should be displayed as '05/01/2022 00:00'
