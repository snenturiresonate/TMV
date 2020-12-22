Feature: 40680 - Basic UI - Schematic Object State Scenarios
  (From Gherkin for Feature 40680 and functionality developed in US34081)
  As a TMV User
  I want to schematic objects displayed with the latest state
  So that I have a live view of the railway

  Background:
    Given I am viewing the map hdgw01paddington.v

  Scenario: 34081 - 32 TRTS (Set)
    #Given a TRTS exists on a map
    #When a message is received setting the corresponding bit to 1
    #Then the TRTS is  displayed for the signal
    And the signal roundel for signal 'SN1' is grey
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 50      | 01   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN1' is grey
    And the TRTS status for signal 'SN1' is 'visible'

  Scenario:34081 - 33 TRTS (Not Set )
    #Given a TRTS exists on a map
    #When a message is received setting the corresponding bit to 0
    #Then the TRTS is not displayed for the signal
    And the signal roundel for signal 'SN1' is grey
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 50      | 00   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN1' is grey
    And the TRTS status for signal 'SN1' is 'hidden'
