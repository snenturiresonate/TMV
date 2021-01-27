Feature: 34393 - Replay page Schematic Object State Scenarios
  (From Gherkin for Feature 40680 and functionality developed in US34081)
  As a TMV User
  I want the view schematic maps in replay mode
  So that I can view the historic running railway

  @tdd @replayTest
  Scenario: 34393-7 Current Signal State
    #Given the existing state of the signals
    #And at least one signal has a known state
    #When the user opens a new map that contains the signals
    #Then the signal state align with the underlying signal state model
    Given I load the replay data from scenario '34081-1 Current Signal State'
    And I am on the replay page
    When I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I have set replay time and date from the recorded session
    And I select Start
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    And the signal roundel for signal 'SN208' is red
    And I launch a new map 'HDGW02' the new map should have start time from the moment it was opened
    And I switch to the new tab
    Then the signal roundel for signal 'SN200' is red
    And I refresh the browser
    And the signal roundel for signal 'SN200' is red

  @tdd @replayTest
  Scenario:34393-8 Main Signal State (Proceed)
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with a main signal
    #And the S-Class message is setting the main signal to proceed
    #When a user is viewing a map that contains the main signal
    #Then the main signal will display a proceed aspect (green roundel)
    Given I load the replay data from scenario '34081 - 2  Main Signal State Proceed'
    And I am on the replay page
    When I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I have set replay time and date from the recorded session
    And I select Start
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then the signal roundel for signal 'SN128' is green

  @tdd @replayTest
  Scenario:34393-9 Main Signal State (Not Proceed)
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with a main signal
    #And the S-Class message is setting the main signal to not proceed
    #When a user is viewing a map that contains the main signal
    #Then the main signal will display a not proceed aspect (red roundel)
    Given I load the replay data from scenario '34081 - 3 Main Signal State (Not Proceed)'
    And I am on the replay page
    When I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I have set replay time and date from the recorded session
    And I select Start
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then the signal roundel for signal 'SN128' is red

  @tdd @replayTest
  Scenario:34393-10 Main Signal State (Unknown)
    #Given an S-Class message has not ever been received and processed for the main signal
    #When a user is viewing a map that contains the main signal
    #Then the main signal will display an unknown aspect (grey roundel)
    Given I am on the replay page
    When I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I have set replay time and date from the recorded session
    And I select Start
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then the signal roundel for signal 'SN128' is grey

  @tdd @replayTest
  Scenario:34393-32 AES State (AES Applied)
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with an S-Class berth of type AES
    #And the S-Class message is setting the AES to applied
    #When a user is viewing a map that contains an AES indicator
    #Then the AES box will display an AES text (purple) in the box
    Given I load the replay data from scenario '34081 - 26 AES State (AES Applied)'
    And I am on the replay page
    When I expand the replay group of maps with name 'Wales & Western GW15 Cambrian'
    And I have set replay time and date from the recorded session
    And I select Start
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then I should see the AES boundary elements

  @tdd @replayTest
  Scenario:34393-33 AES State (AES Not Applied)
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with an S-Class berth of type AES
    #And the S-Class message is setting the AES to not applied
    #When a user is viewing a map that contains an AES indicator
    #Then the AES box will not display an AES text (purple) in the box
    Given I load the replay data from scenario '34081 - 27 AES State (AES Not Applied)'
    And I am on the replay page
    When I expand the replay group of maps with name 'Wales & Western GW15 Cambrian'
    And I have set replay time and date from the recorded session
    And I select Start
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then I should not see the AES boundary elements

  @tdd @replayTest
  Scenario:34393-34 Track State (Route Set)
    #Given an S-Class message is received and processed
    #And the S-Class message is a Route Expression Signalling function
    #And the S-Class message is setting the track(s) to route set
    #When a user is viewing a map that contains the track(s)
    #Then the track(s) will be displayed in solid white
    Given I load the replay data from scenario '34081 - 28 Track State (Route Set)'
    And I am on the replay page
    When I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I have set replay time and date from the recorded session
    And I select Start
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then the track state width for 'PNPNBD' is '3px'
    And the track state class for 'PNPNBD' is 'track_active'

  @tdd @replayTest
  Scenario : 34393-35 Track State (Route Not Set)
    #Given an S-Class message is received and processed
    #And the S-Class message is a Route Expression Signalling function
    #And the route is set for that track(s)
    #And the S-Class message is setting the track(s) to route not set
    #When a user is viewing a map that contains the track(s)
    #Then the track(s) will be displayed in thin white
    Given I load the replay data from scenario '34081 - 29 Track State (Route Not Set)'
    And I am on the replay page
    When I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I have set replay time and date from the recorded session
    And I select Start
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    And  the track state width for 'PNPNBD' is '2px'

  @tdd @replayTest
  Scenario: 34393-36 Dual Signals
    #Given a signal exists on a map
    #And that signal has multiple bits that are configured for the main signal
    #When a message is received setting any of those bits to 1
    #Then the signal roundel displays green
    Given I load the replay data from scenario '34081 - 30 Dual Signals'
    And I am on the replay page
    When I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I have set replay time and date from the recorded session
    And I select Start
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then the signal roundel for signal 'SN212' is green

  @tdd @replayTest
  Scenario:34393-37b Q Berth
    #Given An S-Class display berth exists in the Q berth configuration data
    #When a Q berth message is received
    #Then the S Class display code is displayed corresponding to the headcode provided
    Given I load the replay data from scenario '34081 - 31 Q Berth'
    And I am on the replay page
    When I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw06gloucester.v'
    And I have set replay time and date from the recorded session
    And I select Start
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then the route indication for 'PHPHBK' is '1'

  @tdd @replayTest
  Scenario: 34393-38a TRTS (Set from red)
    #Given a TRTS exists on a map
    #When a message is received setting the corresponding bit to 1
    #Then the TRTS is  displayed for the signal
    Given I load the replay data from scenario '34081 - 32a TRTS (Set - from red)'
    And I am on the replay page
    When I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I have set replay time and date from the recorded session
    And I select Start
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then the TRTS status for signal 'SN1' is white
    And the TRTS visibility status for 'SN1' is visible

  @tdd @replayTest
  Scenario: 34393-38b TRTS (Set from Green)
    #Given a TRTS exists on a map
    #When a message is received setting the corresponding bit to 1
    #Then the TRTS is  displayed for the signal
    Given I load the replay data from scenario '34081 - 32b TRTS (Set - from green)'
    And I am on the replay page
    When I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I have set replay time and date from the recorded session
    And I select Start
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then the TRTS status for signal 'SN1' is white
    And the TRTS visibility status for 'SN1' is visible

  @tdd @replayTest
  Scenario: 34393-39a TRTS (Not Set from red)
    #Given a TRTS exists on a map
    #When a message is received setting the corresponding bit to 0
    #Then the TRTS is not displayed for the signal
    Given I load the replay data from scenario '34081 - 33a TRTS (Not Set back)'
    And I am on the replay page
    When I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I have set replay time and date from the recorded session
    And I select Start
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then the signal roundel for signal 'SN1' is red
    And the TRTS visibility status for 'SN1' is hidden

  @tdd @replayTest
  Scenario: 34393-39b TRTS (Not Set from red)
    #Given a TRTS exists on a map
    #When a message is received setting the corresponding bit to 0
    #Then the TRTS is not displayed for the signal
    Given I load the replay data from scenario '34081 - 33b TRTS (Not Set)'
    And I am on the replay page
    When I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I have set replay time and date from the recorded session
    And I select Start
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then the signal roundel for signal 'SN1' is green
    And the TRTS visibility status for 'SN1' is hidden
