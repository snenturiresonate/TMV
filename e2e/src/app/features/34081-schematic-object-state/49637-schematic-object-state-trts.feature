Feature: 40680 - Basic UI - Schematic Object State Scenarios
  (From Gherkin for Feature 40680 and functionality developed in US34081)
  As a TMV User
  I want to schematic objects displayed with the latest state
  So that I have a live view of the railway

  Background:
    Given I am viewing the map hdgw01paddington.v
  @tdd @bug #52832
  Scenario:34081 - 28 Track State (Route Set)
    #Given an S-Class message is received and processed
    #And the S-Class message is a Route Expression Signalling function
    #And the S-Class message is setting the track(s) to route set
    #When a user is viewing a map that contains the track(s)
    #Then the track(s) will be displayed in solid white
    And I set up all signals for address 50 in D3 to be not-proceed
    And the track state width for 'PNPNBD' is '2px'
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 06      | 08   | 10:45:00  |
    Then the track state width for 'PNPNBD' is '3px'
    And the track state class for 'PNPNBD' is 'track_active'

  @tdd @bug #52832
  Scenario:34081 - 29 Track State (Route Not Set)
    #Given an S-Class message is received and processed
    #And the S-Class message is a Route Expression Signalling function
    #And the route is set for that track(s)
    #And the S-Class message is setting the track(s) to route not set
    #When a user is viewing a map that contains the track(s)
    #Then the track(s) will be displayed in thin white
    And I set up all signals for address 50 in D3 to be not-proceed
    And the track state width for 'PNPNBD' is '2px'
    And the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 06      | 08   | 10:45:00  |
    And  the track state width for 'PNPNBD' is '3px'
    And the track state class for 'PNPNBD' is 'track_active'
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 06      | 00   | 10:45:00  |
    And  the track state width for 'PNPNBD' is '2px'

  Scenario: 34081 - 30 Dual Signals
    #Given a signal exists on a map
    #And that signal has multiple bits that are configured for the main signal
    #When a message is received setting any of those bits to 1
    #Then the signal roundel displays green
    And I set up all signals for address 92 in D3 to be not-proceed
    And the signal roundel for signal 'SN212' is red
    When the following signalling update messages are sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 92      | 04   | 10:03:00  |
      | D3             | 92      | 08   | 10:03:00  |
    Then the signal roundel for signal 'SN212' is green

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
