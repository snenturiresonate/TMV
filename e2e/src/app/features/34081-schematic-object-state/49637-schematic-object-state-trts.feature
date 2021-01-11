Feature: 40680 - Basic UI - Schematic Object State Scenarios
  (From Gherkin for Feature 40680 and functionality developed in US34081)
  As a TMV User
  I want to schematic objects displayed with the latest state
  So that I have a live view of the railway

  Background:
    Given I am viewing the map hdgw01paddington.v

  @bug @bug_52196
  Scenario: 34081 - 32a TRTS (Set - from red)
    #Given a TRTS exists on a map
    #When a message is received setting the corresponding bit to 1
    #Then the TRTS is  displayed for the signal
    When I set up all signals for address 50 in D3 to be not-proceed
    And I set up all signals for address 78 in D3 to be not-proceed
    Then the signal roundel for signal 'SN1' is red
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 50      | 01   | 10:45:00  |
    Then the TRTS status for signal 'SN1' is white
    And the TRTS visibility status for 'SN1' is visible

  @bug @bug_52196
  Scenario: 34081 - 32b TRTS (Set - from green)
    #Given a TRTS exists on a map
    #When a message is received setting the corresponding bit to 1
    #Then the TRTS is  displayed for the signal
    When I set up all signals for address 50 in D3 to be not-proceed
    And I set up all signals for address 78 in D3 to be proceed
    Then the signal roundel for signal 'SN1' is green
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 50      | 01   | 10:45:00  |
    Then the TRTS status for signal 'SN1' is white
    And the TRTS visibility status for 'SN1' is visible

  @bug @bug_52196
  Scenario:34081 - 33a TRTS (Not Set back)
    #Given a TRTS exists on a map
    #When a message is received setting the corresponding bit to 0
    #Then the TRTS is not displayed for the signal
    When I set up all signals for address 50 in D3 to be not-proceed
    And I set up all signals for address 78 in D3 to be not-proceed
    And the signal roundel for signal 'SN1' is red
    And the TRTS visibility status for 'SN1' is hidden
    And the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 50      | 01   | 10:45:00  |
    And the TRTS status for signal 'SN1' is white
    And the TRTS visibility status for 'SN1' is visible
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 50      | 00   | 10:45:00  |
    Then the signal roundel for signal 'SN1' is red
    And the TRTS visibility status for 'SN1' is hidden

  @bug @bug_52196
  Scenario:34081 - 33b TRTS (Not Set)
    #Given a TRTS exists on a map
    #When a message is received setting the corresponding bit to 0
    #Then the TRTS is not displayed for the signal
    When I set up all signals for address 50 in D3 to be not-proceed
    And I set up all signals for address 78 in D3 to be proceed
    And the signal roundel for signal 'SN1' is green
    And the TRTS visibility status for 'SN1' is hidden
    And the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 50      | 01   | 10:45:00  |
    And the TRTS status for signal 'SN1' is white
    And the TRTS visibility status for 'SN1' is visible
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 50      | 00   | 10:45:00  |
    Then the signal roundel for signal 'SN1' is green
    And the TRTS visibility status for 'SN1' is hidden
