Feature: 34393 - Replay page Schematic Object State Scenarios
  (From Gherkin for Feature 40680 and functionality developed in US34081)
  As a TMV User
  I want the view schematic maps in replay mode
  So that I can view the historic running railway

  @replayTest
  Scenario: 34393-7 Current Signal State
    # Replay Setup - 34081-1 Current Signal State
    * I set up all signals for address 80 in D3 to be not-proceed
    * I am viewing the map HDGW01paddington.v
    * the signal roundel for signal 'SN128' is red

    #Given the existing state of the signals
    #And at least one signal has a known state
    #When the user opens a new map that contains the signals
    #Then the signal state align with the underlying signal state model
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    When I click Play button
    Then the signal roundel for signal 'SN128' is red

  @replayTest
  Scenario:34393-8 Main Signal State (Proceed)
    # Replay Setup - 34081 - 2  Main Signal State Proceed
    * I set up all signals for address 80 in D3 to be not-proceed
    * the following live signalling update message is sent from LINX
      | trainDescriber | address | data |
      | D3             | 80      | FF   |
    * I am viewing the map HDGW01paddington.v
    * the signal roundel for signal 'SN128' is green

    #Given an S-Class message is received and processed
    #And the S-Class message is associated with a main signal
    #And the S-Class message is setting the main signal to proceed
    #When a user is viewing a map that contains the main signal
    #Then the main signal will display a proceed aspect (green roundel)
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    When I click Play button
    Then the signal roundel for signal 'SN128' is green

  @replayTest
  Scenario:34393-9 Main Signal State (Not Proceed)
    # Replay Setup - 34081 - 3 Main Signal State (Not Proceed)
    * I set up all signals for address 80 in D3 to be proceed
    * the following live signalling update message is sent from LINX
      | trainDescriber | address | data |
      | D3             | 80      | 00   |
    * I am viewing the map HDGW01paddington.v
    * the signal roundel for signal 'SN128' is red

    #Given an S-Class message is received and processed
    #And the S-Class message is associated with a main signal
    #And the S-Class message is setting the main signal to not proceed
    #When a user is viewing a map that contains the main signal
    #Then the main signal will display a not proceed aspect (red roundel)
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    When I click Play button
    Then the signal roundel for signal 'SN128' is red

  @replayTest
  Scenario:34393-10 Main Signal State (Unknown)
    #Given an S-Class message has not ever been received and processed for the main signal
    #When a user is viewing a map that contains the main signal
    #Then the main signal will display an unknown aspect (grey roundel)
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    When I click Play button
    Then the signal roundel for signal 'SN228' is grey

  @replayTest
  Scenario:34393-34 Track State (Route Set)
    # Replay Setup - 34081 - 28 Track State (Route Set)
    * I am viewing the map HDGW01paddington.v
    * I set up all signals for address 06 in D3 to be not-proceed
    * the tracks 'PNPNG2, PNPNG1, PNPNF9, PNPNF8, PNPNF7, PNPNE4, PNPN4I, PNPNF1, PNPNE6, PNPN07' are displayed in thin palegrey
    * the following live signalling update message is sent from LINX
      | trainDescriber | address | data |
      | D3             | 06      | 08   |
    * the tracks 'PNPNG2, PNPNG1, PNPNF9, PNPNF8, PNPNF7, PNPNE4, PNPN4I, PNPNF1, PNPNE6, PNPN07' are displayed in solid white

    #Given an S-Class message is received and processed
    #And the S-Class message is a Route Expression Signalling function
    #And the S-Class message is setting the track(s) to route set
    #When a user is viewing a map that contains the track(s)
    #Then the track(s) will be displayed in solid white
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    When I click Play button
    Then the tracks 'PNPNG2, PNPNG1, PNPNF9, PNPNF8, PNPNF7, PNPNE4, PNPN4I, PNPNF1, PNPNE6, PNPN07' are displayed in thin palegrey
    And the tracks 'PNPNG2, PNPNG1, PNPNF9, PNPNF8, PNPNF7, PNPNE4, PNPN4I, PNPNF1, PNPNE6, PNPN07' are displayed in solid white

  @replayTest
  Scenario:34393-35 Track State (Route Not Set)
    # Replay Setup - 34081 - 29 Track State (Route Not Set)
    * I am viewing the map HDGW01paddington.v
    * I set up all signals for address 06 in D3 to be not-proceed
    * the tracks 'PNPNG2, PNPNG1, PNPNF9, PNPNF8, PNPNF7, PNPNE4, PNPN4I, PNPNF1, PNPNE6, PNPN07' are displayed in thin palegrey
    * the following live signalling update message is sent from LINX
      | trainDescriber | address | data |
      | D3             | 06      | 08   |
    * the tracks 'PNPNG2, PNPNG1, PNPNF9, PNPNF8, PNPNF7, PNPNE4, PNPN4I, PNPNF1, PNPNE6, PNPN07' are displayed in solid white
    * the following live signalling update message is sent from LINX
      | trainDescriber | address | data |
      | D3             | 06      | 00   |
    * the tracks 'PNPNG2, PNPNG1, PNPNF9, PNPNF8, PNPNF7, PNPNE4, PNPN4I, PNPNF1, PNPNE6, PNPN07' are displayed in thin palegrey

    #Given an S-Class message is received and processed
    #And the S-Class message is a Route Expression Signalling function
    #And the route is set for that track(s)
    #And the S-Class message is setting the track(s) to route not set
    #When a user is viewing a map that contains the track(s)
    #Then the track(s) will be displayed in thin white
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    When I click Play button
    Then the tracks 'PNPNG2, PNPNG1, PNPNF9, PNPNF8, PNPNF7, PNPNE4, PNPN4I, PNPNF1, PNPNE6, PNPN07' are displayed in thin palegrey
    And the tracks 'PNPNG2, PNPNG1, PNPNF9, PNPNF8, PNPNF7, PNPNE4, PNPN4I, PNPNF1, PNPNE6, PNPN07' are displayed in solid white
    And the tracks 'PNPNG2, PNPNG1, PNPNF9, PNPNF8, PNPNF7, PNPNE4, PNPN4I, PNPNF1, PNPNE6, PNPN07' are displayed in thin palegrey

  @replayTest
  Scenario: 34393-36 Dual Signals
    # Replay Setup - 34081 - 30 Dual Signals
    * I am viewing the map HDGW01paddington.v
    * I set up all signals for address 92 in D3 to be not-proceed
    * the signal roundel for signal 'SN212' is red
    * the following live signalling update messages are sent from LINX
      | trainDescriber | address | data |
      | D3             | 92      | 04   |
      | D3             | 92      | 08   |
    * the signal roundel for signal 'SN212' is green

    #Given a signal exists on a map
    #And that signal has multiple bits that are configured for the main signal
    #When a message is received setting any of those bits to 1
    #Then the signal roundel displays green
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    When I click Play button
    Then the signal roundel for signal 'SN212' is red
    And the signal roundel for signal 'SN212' is green

  @replayTest
  Scenario:34393-37b Q Berth
    # Replay Setup - 34081 - 31 Q Berth
    * I am viewing the map HDGW06gloucester.v
    * the following live berth interpose message is sent from LINX (to indicate train is present)
      | toBerth   | trainDescriber     | trainDescription   |
      | Q070      | GL                 | DnDC               |
    * the s-class-berth 'GLQ070' will display '1' Route indication of 'DC'

    #Given An S-Class display berth exists in the Q berth configuration data
    #When a Q berth message is received
    #Then the S Class display code is displayed corresponding to the headcode provided
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW06gloucester.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    When I click Play button
    Then the s-class-berth 'GLQ070' will display '1' Route indication of 'DC'

  @replayTest
  Scenario: 34393-38a TRTS (Set from red)
    # Replay Setup - 34081 - 32a TRTS (Set - from red)
    * I am viewing the map HDGW01paddington.v
    * I set up all signals for address 50 in D3 to be not-proceed
    * I set up all signals for address 78 in D3 to be not-proceed
    * the signal roundel for signal 'SN9' is red
    * the following live signalling update message is sent from LINX
      | trainDescriber | address | data |
      | D3             | 50      | 10   |
    * the TRTS status for signal 'SN8' is white
    * the TRTS visibility status for 'SN9' is visible

    #Given a TRTS exists on a map
    #When a message is received setting the corresponding bit to 1
    #Then the TRTS is  displayed for the signal
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    When I click Play button
    Then the signal roundel for signal 'SN9' is red
    And the TRTS status for signal 'SN8' is white
    And the TRTS visibility status for 'SN9' is visible

  @replayTest
  Scenario: 34393-38b TRTS (Set from Green)
    # Replay Setup - 34081 - 32b TRTS (Set - from green)
    * I am viewing the map HDGW01paddington.v
    * I set up all signals for address 50 in D3 to be not-proceed
    * I set up all signals for address 78 in D3 to be proceed
    * the signal roundel for signal 'SN9' is green
    * the following live signalling update message is sent from LINX
      | trainDescriber | address | data |
      | D3             | 50      | 10   |
    * the TRTS status for signal 'SN9' is white
    * the TRTS visibility status for 'SN9' is visible

    #Given a TRTS exists on a map
    #When a message is received setting the corresponding bit to 1
    #Then the TRTS is  displayed for the signal
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    When I click Play button
    Then the signal roundel for signal 'SN9' is green
    And the TRTS status for signal 'SN9' is white
    And the TRTS visibility status for 'SN9' is visible

  @replayTest
  Scenario: 34393-39a TRTS (Not Set from red)
    # Replay Setup - 34081 - 33a TRTS (Not Set back)
    * I am viewing the map HDGW01paddington.v
    * I set up all signals for address 50 in D3 to be not-proceed
    * I set up all signals for address 78 in D3 to be not-proceed
    * the signal roundel for signal 'SN9' is red
    * the TRTS visibility status for 'SN9' is hidden
    * the following live signalling update message is sent from LINX
      | trainDescriber | address | data |
      | D3             | 50      | 10   |
    * the TRTS status for signal 'SN9' is white
    * the TRTS visibility status for 'SN9' is visible
    * the following live signalling update message is sent from LINX
      | trainDescriber | address | data |
      | D3             | 50      | 00   |
    * the signal roundel for signal 'SN9' is red
    * the TRTS visibility status for 'SN9' is hidden

    #Given a TRTS exists on a map
    #When a message is received setting the corresponding bit to 0
    #Then the TRTS is not displayed for the signal
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    When I click Play button
    Then the TRTS status for signal 'SN9' is white
    And the TRTS visibility status for 'SN9' is visible
    And the signal roundel for signal 'SN9' is red
    And the TRTS visibility status for 'SN9' is hidden

  @replayTest
  Scenario: 34393-39b TRTS (Not Set from red)
    # Replay Setup - 34081 - 33b TRTS (Not Set)
    * I am viewing the map HDGW01paddington.v
    * I set up all signals for address 50 in D3 to be not-proceed
    * I set up all signals for address 78 in D3 to be proceed
    * the signal roundel for signal 'SN9' is green
    * the following live signalling update message is sent from LINX
      | trainDescriber | address | data |
      | D3             | 50      | 10   |
    * the TRTS status for signal 'SN9' is white
    * the TRTS visibility status for 'SN9' is visible
    * the following live signalling update message is sent from LINX
      | trainDescriber | address | data |
      | D3             | 50      | 00   |
    * the signal roundel for signal 'SN9' is green
    * the TRTS visibility status for 'SN9' is hidden

    #Given a TRTS exists on a map
    #When a message is received setting the corresponding bit to 0
    #Then the TRTS is not displayed for the signal
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    When I click Play button
    Then the TRTS status for signal 'SN9' is white
    And the TRTS visibility status for 'SN9' is visible
    And the signal roundel for signal 'SN9' is green
    And the TRTS visibility status for 'SN9' is hidden
