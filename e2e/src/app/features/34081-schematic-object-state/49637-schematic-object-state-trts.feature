Feature: 40680 - Basic UI - Schematic Object State Scenarios
  (From Gherkin for Feature 40680 and functionality developed in US34081)
  As a TMV User
  I want to schematic objects displayed with the latest state
  So that I have a live view of the railway

  Background:
    Given I am viewing the map hdgw01paddington.v

  Scenario: 34081 - 30 Dual Signals
    #Given a signal exists on a map
    #And that signal has multiple bits that are configured for the main signal
    #When a message is received setting any of those bits to 1
    #Then the signal roundel displays green
    And I set up all signals for address 50 in D3 to be not-proceed
    And the signal roundel for signal 'SN212' is grey
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 92      | 04   | 10:03:00  |
      | D3             | 92      | 08   | 10:03:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN212' is green

  Scenario: 34081 - 32 TRTS (Set)
    #Given a TRTS exists on a map
    #When a message is received setting the corresponding bit to 1
    #Then the TRTS is  displayed for the signal
    And I set up all signals for address 50 in D3 to be not-proceed
    And the signal roundel for signal 'SN1' is grey
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 50      | 01   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN1' is grey
    And the TRTS status for signal 'SN1' is visible

  Scenario:34081 - 33 TRTS (Not Set)
    #Given a TRTS exists on a map
    #When a message is received setting the corresponding bit to 0
    #Then the TRTS is not displayed for the signal
    And I set up all signals for address 80 in D3 to be not-proceed
    And the signal roundel for signal 'SN1' is grey
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 50      | 00   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN1' is grey
    And the TRTS status for signal 'SN1' is hidden
