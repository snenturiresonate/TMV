Feature: 49637 - Schematic State - Track State, Dual Signals, Q berth, TRTS
  (From Gherkin for Feature 34081)
  As a TMV User
  I want to schematic objects displayed with the latest state
  So that I have a live view of the railway

  @replaySetup
  Scenario:34081 - 28 Track State (Route Set)
    #Given an S-Class message is received and processed
    #And the S-Class message is a Route Expression Signalling function
    #And the S-Class message is setting the track(s) to route set
    #When a user is viewing a map that contains the track(s)
    #Then the track(s) will be displayed in solid white
    Given I am viewing the map hdgw01paddington.v
    And I set up all signals for address 06 in D3 to be not-proceed
    And the tracks 'PNPNG2, PNPNG1, PNPNF9, PNPNF8, PNPNF7, PNPNE4, PNPN4I, PNPNF1, PNPNE6, PNPN07' are displayed in thin palegrey
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 06      | 08   | 10:45:00  |
    Then the tracks 'PNPNG2, PNPNG1, PNPNF9, PNPNF8, PNPNF7, PNPNE4, PNPN4I, PNPNF1, PNPNE6, PNPN07' are displayed in solid white

  @replaySetup
  Scenario:34081 - 29 Track State (Route Not Set)
    #Given an S-Class message is received and processed
    #And the S-Class message is a Route Expression Signalling function
    #And the route is set for that track(s)
    #And the S-Class message is setting the track(s) to route not set
    #When a user is viewing a map that contains the track(s)
    #Then the track(s) will be displayed in thin white
    Given I am viewing the map hdgw01paddington.v
    And I set up all signals for address 06 in D3 to be not-proceed
    And the tracks 'PNPNG2, PNPNG1, PNPNF9, PNPNF8, PNPNF7, PNPNE4, PNPN4I, PNPNF1, PNPNE6, PNPN07' are displayed in thin palegrey
    And the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 06      | 08   | 10:45:00  |
    And the tracks 'PNPNG2, PNPNG1, PNPNF9, PNPNF8, PNPNF7, PNPNE4, PNPN4I, PNPNF1, PNPNE6, PNPN07' are displayed in solid white
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 06      | 00   | 10:45:00  |
    Then the tracks 'PNPNG2, PNPNG1, PNPNF9, PNPNF8, PNPNF7, PNPNE4, PNPN4I, PNPNF1, PNPNE6, PNPN07' are displayed in thin palegrey

  @replaySetup
  Scenario: 34081 - 30 Dual Signals
    #Given a signal exists on a map
    #And that signal has multiple bits that are configured for the main signal
    #When a message is received setting any of those bits to 1
    #Then the signal roundel displays green
    Given I am viewing the map hdgw01paddington.v
    And I set up all signals for address 92 in D3 to be not-proceed
    And the signal roundel for signal 'SN212' is red
    When the following signalling update messages are sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 92      | 04   | 10:03:00  |
      | D3             | 92      | 08   | 10:03:00  |
    Then the signal roundel for signal 'SN212' is green

  @replaySetup
  Scenario Outline: 34081 - 31 Q Berth
    #Given An S-Class display berth exists in the Q berth configuration data
    #When a Q berth message is received
    #Then the S Class display code is displayed corresponding to the headcode provided
  # Has type I
    Given I am viewing the map <map>
    When the following berth interpose message is sent from LINX (to indicate train is present)
      | timestamp | toBerth   | trainDescriber     | trainDescription   |
      | <timestamp>  | <toBerth> | <toTrainDescriber> | <trainDescription> |
    Then the s-class-berth '<sClassBerth>' will display '1' Route indication of '<sclassDisplayCode>'
    Examples:
      |map                | trainDescription | toTrainDescriber | toBerth | timestamp | sClassBerth | sclassDisplayCode  |
      |hdgw06gloucester.v | DnDC             | GL               | Q070    | 10:02:06  | GLQ070      | DC                 |

  @replaySetup
  Scenario: 34081 - 32a TRTS (Set - from red)
    #Given a TRTS exists on a map
    #When a message is received setting the corresponding bit to 1
    #Then the TRTS is  displayed for the signal
    Given I am viewing the map hdgw01paddington.v
    When I set up all signals for address 50 in D3 to be not-proceed
    And I set up all signals for address 78 in D3 to be not-proceed
    Then the signal roundel for signal 'SN9' is red
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 50      | 01   | 10:45:00  |
    Then the TRTS status for signal 'SN1' is white
    And the TRTS visibility status for 'SN1' is visible

  @replaySetup
  Scenario: 34081 - 32b TRTS (Set - from green)
    #Given a TRTS exists on a map
    #When a message is received setting the corresponding bit to 1
    #Then the TRTS is  displayed for the signal
    Given I am viewing the map hdgw01paddington.v
    When I set up all signals for address 50 in D3 to be not-proceed
    And I set up all signals for address 78 in D3 to be proceed
    Then the signal roundel for signal 'SN9' is green
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 50      | 01   | 10:45:00  |
    Then the TRTS status for signal 'SN1' is white
    And the TRTS visibility status for 'SN1' is visible

  @replaySetup
  Scenario:34081 - 33a TRTS (Not Set back)
    #Given a TRTS exists on a map
    #When a message is received setting the corresponding bit to 0
    #Then the TRTS is not displayed for the signal
    Given I am viewing the map hdgw01paddington.v
    When I set up all signals for address 50 in D3 to be not-proceed
    And I set up all signals for address 78 in D3 to be not-proceed
    And the signal roundel for signal 'SN9' is red
    #And the TRTS visibility status for 'SN1' is hidden
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

  @replaySetup
  Scenario:34081 - 33b TRTS (Not Set)
    #Given a TRTS exists on a map
    #When a message is received setting the corresponding bit to 0
    #Then the TRTS is not displayed for the signal
    Given I am viewing the map hdgw01paddington.v
    When I set up all signals for address 50 in D3 to be not-proceed
    And I set up all signals for address 78 in D3 to be proceed
    And the signal roundel for signal 'SN9' is green
    #And the TRTS visibility status for 'SN1' is hidden
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
