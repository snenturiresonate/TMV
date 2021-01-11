Feature: 40680 - Basic UI - Schematic Object State Scenarios
  (From Gherkin for Feature 40680 and functionality developed in US34081)
  As a TMV User
  I want to schematic objects displayed with the latest state
  So that I have a live view of the railway

  Background:
    Given I am viewing the map hdgw01paddington.v

    @tdd
  Scenario:34081 - 28 Track State (Route Set)
    #Given an S-Class message is received and processed
    #And the S-Class message is a Route Expression Signalling function
    #And the S-Class message is setting the track(s) to route set
    #When a user is viewing a map that contains the track(s)
    #Then the track(s) will be displayed in solid white
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 06      | 08   | 10:03:00  |
    #Then the track for signal 'SN1' is solid white


  Scenario: 34081 - 30 Dual Signals
    #Given a signal exists on a map
    #And that signal has multiple bits that are configured for the main signal
    #When a message is received setting any of those bits to 1
    #Then the signal roundel displays green
    And I set up all signals for address 92 in D3 to be not-proceed
    And the signal roundel for signal 'SN212' is red
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 92      | 04   | 10:03:00  |
      | D3             | 92      | 08   | 10:03:00  |
    Then the signal roundel for signal 'SN212' is green

  Scenario: 34081 - 32 TRTS (Set)
    #Given a TRTS exists on a map
    #When a message is received setting the corresponding bit to 1
    #Then the TRTS is  displayed for the signal
      When I set up all signals for address 50 in D3 to be not-proceed
    And the TRTS status for signal 'SN1' is red
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 50      | 01   | 10:45:00  |
      Then the TRTS status for signal 'SN1' is white

  Scenario:34081 - 33 TRTS (Not Set)
    #Given a TRTS exists on a map
    #When a message is received setting the corresponding bit to 0
    #Then the TRTS is not displayed for the signal
    When I set up all signals for address 50 in D3 to be proceed
    And the TRTS status for signal 'SN1' is red
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 50      | 00   | 10:45:00  |
    Then the TRTS status for signal 'SN1' is grey
