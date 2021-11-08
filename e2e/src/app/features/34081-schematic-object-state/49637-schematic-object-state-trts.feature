Feature: 49637 - Schematic State - Track State, Dual Signals, Q berth, TRTS
  (From Gherkin for Feature 34081)
  As a TMV User
  I want to schematic objects displayed with the latest state
  So that I have a live view of the railway

  Scenario:34081 - 28 Track State (Route Set)
    #Given an S-Class message is received and processed
    #And the S-Class message is a Route Expression Signalling function
    #And the S-Class message is setting the track(s) to route set
    #When a user is viewing a map that contains the track(s)
    #Then the track(s) will be displayed in solid white
    * this replay setup test has been moved to become part of the replay test: 34393-34 Track State (Route Set)

  @replaySetup
  Scenario:34081 - 29 Track State (Route Not Set)
    #Given an S-Class message is received and processed
    #And the S-Class message is a Route Expression Signalling function
    #And the route is set for that track(s)
    #And the S-Class message is setting the track(s) to route not set
    #When a user is viewing a map that contains the track(s)
    #Then the track(s) will be displayed in thin white
    Given I am viewing the map HDGW01paddington.v
    And I set up all signals for address 06 in D3 to be not-proceed
    And the tracks 'PNPNG2, PNPNG1, PNPNF9, PNPNF8, PNPNF7, PNPNE4, PNPN4I, PNPNF1, PNPNE6, PNPN07' are displayed in thin palegrey
    And the following live signalling update message is sent from LINX
      | trainDescriber | address | data |
      | D3             | 06      | 08   |
    And the tracks 'PNPNG2, PNPNG1, PNPNF9, PNPNF8, PNPNF7, PNPNE4, PNPN4I, PNPNF1, PNPNE6, PNPN07' are displayed in solid white
    When the following live signalling update message is sent from LINX
      | trainDescriber | address | data |
      | D3             | 06      | 00   |
    Then the tracks 'PNPNG2, PNPNG1, PNPNF9, PNPNF8, PNPNF7, PNPNE4, PNPN4I, PNPNF1, PNPNE6, PNPN07' are displayed in thin palegrey

  Scenario: 34081 - 30 Dual Signals
    #Given a signal exists on a map
    #And that signal has multiple bits that are configured for the main signal
    #When a message is received setting any of those bits to 1
    #Then the signal roundel displays green
    * this replay setup test has been moved to become part of the replay test: 34393-36 Dual Signals

  Scenario: 34081 - 31 Q Berth
    #Given An S-Class display berth exists in the Q berth configuration data
    #When a Q berth message is received
    #Then the S Class display code is displayed corresponding to the headcode provided
    # Has type I
    * this replay setup test has been moved to become part of the replay test: 34393-37b Q Berth

  Scenario: 34081 - 32a TRTS (Set - from red)
    #Given a TRTS exists on a map
    #When a message is received setting the corresponding bit to 1
    #Then the TRTS is  displayed for the signal
    * this replay setup test has been moved to become part of the replay test: 34393-38a TRTS (Set from red)

  Scenario: 34081 - 32b TRTS (Set - from green)
    #Given a TRTS exists on a map
    #When a message is received setting the corresponding bit to 1
    #Then the TRTS is  displayed for the signal
    * this replay setup test has been moved to become part of the replay test: 34393-38b TRTS (Set from Green)

  Scenario:34081 - 33a TRTS (Not Set back)
    #Given a TRTS exists on a map
    #When a message is received setting the corresponding bit to 0
    #Then the TRTS is not displayed for the signal
    * this replay setup test has been moved to become part of the replay test: 34393-39a TRTS (Not Set from red)

  Scenario: 34081 - 33b TRTS (Not Set)
    #Given a TRTS exists on a map
    #When a message is received setting the corresponding bit to 0
    #Then the TRTS is not displayed for the signal
    * this replay setup test has been moved to become part of the replay test: 34393-39b TRTS (Not Set from red)
