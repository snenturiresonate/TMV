Feature: 34393 - Replay page Schematic Object State Scenarios
  (From Gherkin for Feature 40680 and functionality developed in US34081)
  As a TMV User
  I want the view schematic maps in replay mode
  So that I can view the historic running railway

  @tdd @ReplaySetup
  Scenario: 34393-7a Setting up initial state
    Given I am viewing the map hdgw01paddington.v
    When I set up all signals for address 80 in D3 to be not-proceed
    And the maximum amount of time is allowed for end to end transmission

  @tdd @ReplayTest
  Scenario: 34393-7b Current Signal State
    #Given the existing state of the signals
    #And at least one signal has a known state
    #When the user opens a new map that contains the signals
    #Then the signal state align with the underlying signal state model
    Given I am on the replay page
    When I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I select Start
    And the signal roundel for signal 'SN208' is red
    And I launch a new map 'HDGW02' the new map should have start time from the moment it was opened
    And I switch to the new tab
    Then the signal roundel for signal 'SN200' is red
    And I refresh the browser
    And the signal roundel for signal 'SN200' is red

  @tdd @ReplaySetup
  Scenario: 34393-8a Setting up the map state from Not procced to Procced
    Given I am viewing the map hdgw01paddington.v
    And I set up all signals for address 80 in D3 to be not-proceed
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 80      | FF   | 10:45:00  |


  @tdd @ReplayTest
  Scenario:34393-8b Main Signal State (Proceed)
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with a main signal
    #And the S-Class message is setting the main signal to proceed
    #When a user is viewing a map that contains the main signal
    #Then the main signal will display a proceed aspect (green roundel)
    Given I am on the replay page
    When I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I select Start
    Then the signal roundel for signal 'SN128' is green

  @tdd @ReplaySetup
  Scenario: 34393-9a Setting up the map state from proceed to Not proceed
    Given I am viewing the map hdgw01paddington.v
    When I set up all signals for address 80 in D3 to be Proceed
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 80      | 00   | 10:45:00  |

  @tdd @ReplayTest
  Scenario:34393-9b Main Signal State (Not Proceed)
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with a main signal
    #And the S-Class message is setting the main signal to not proceed
    #When a user is viewing a map that contains the main signal
    #Then the main signal will display a not proceed aspect (red roundel)
    Given I am on the replay page
    When I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I select Start
    Then the signal roundel for signal 'SN128' is red

  @tdd @ReplaySetup
  Scenario: 34393-10a Setting up initial state
    Given I am viewing the map hdgw01paddington.v
    When I set up all signals for address 80 in D3 to be not-proceed
    And the maximum amount of time is allowed for end to end transmission

  @tdd @ReplayTest
  Scenario:34393-10b Main Signal State (Unknown)
    #Given an S-Class message has not ever been received and processed for the main signal
    #When a user is viewing a map that contains the main signal
    #Then the main signal will display an unknown aspect (grey roundel)
    Then the signal roundel for signal 'SN128' is grey
