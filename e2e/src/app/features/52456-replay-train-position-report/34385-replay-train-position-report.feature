@newSession
Feature: 34385 - TMV Replay Train Position Report

  As a TMV User
  I want the ability generate a train position report in replay mode
  So that I can view all train visible in the current map

  @tdd @replaySetup
  Scenario: 34285-a Train Position Report - data set up
    Given I am viewing the map HDGW01paddington.v
    And the access plan located in CIF file 'access-plan/37659-schedules/9F01.cif' is received from LINX
    And the access plan located in CIF file 'access-plan/1D46_PADTON_OXFD.cif' is received from LINX
    And the following berth interpose messages is sent from LINX
      | timestamp | toBerth | trainDescriber | trainDescription |
      | 10:00:00  | R001    | D3             | 9F01             |
    When the following berth step messages is sent from LINX
      | timestamp | fromBerth | toBerth | trainDescriber | trainDescription |
      | 10:00:00  | R001      | 0212    | D3             | 9F01             |
    And the following live berth interpose message is sent from LINX
      |timwstamp| toBerth | trainDescriber | trainDescription |
      |10:00:00 | R001    | 0A01           | D3               |
    And the following berth step messages is sent from LINX
      | timestamp | fromBerth | toBerth | trainDescriber | trainDescription |
      | 10:00:00  | R001      | 0222    | D3             | 0A01             |

  @tdd @replayTest
  Scenario: 34285-1 Open Train Position Report
    #Given the user is authenticated to use TMV replay
    #And the user is viewing the replay map
    #When the user selects the trains position report icon
    #Then the trains position report is open in a new tab for the map
    #And the trains position report map name is in the title
    Given I load the replay data from scenario '34285-a Train Position Report - data set up'
    And I am on the replay page
    When I have set replay time and date from the recorded session
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I wait for the buffer to fill
    When I Click on the TPR link
    And I switch to the new tab
    Then the tab title is 'TMV Replay TPR HDGW02'

  @tdd @replayTest
  Scenario: 34285-2 Train Position Report View
    #Given the user is authenticated to use TMV replay
    #And the user has opened a train position report
    #When the user is viewing the train position report
    #Then the trains position report is populated with trains that have entered and left the berths forthe timeframe
    Given I load the replay data from scenario '34285-a Train Position Report - data set up'
    And I am on the replay page
    When I have set replay time and date from the recorded session
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I wait for the buffer to fill
    When I Click on the TPR link
    And I switch to the new tab
    And the tab title is 'TMV Replay TPR HDGW02'
    Then the following can be seen on the tpr settings table
      | trainDescription  | operator  |	berth   |  punctuality     |     time               |
      |		9F01            |	LO        |	0212	  |	  +0m            |2020/02/08 10:00	      |
      |		0A01	          |	LI        |	0222	  |	  +0m            |2020/02/08 10:00 (Last) |

  @tdd @replayTest
  Scenario: 342853 Train Position Report Trains List
    #Given the user is authenticated to use TMV replay
    #And the user has opened a train position report
    #And the train position report is populated with trains as and when enter and leave berths for the timeframe
    #When the user enters a character/characters in the train description filter
    #Then the trains position report is filtered accordingly
    Given I load the replay data from scenario '34285-a Train Position Report - data set up'
    And I am on the replay page
    And I have set replay time and date from the recorded session
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I wait for the buffer to fill
    And I Click on the TPR link
    And I switch to the new tab
    And the admin tpr filter placeholder is displayed as 'Filter reports by Train description'
    And the following can be seen on the tpr settings table
      | trainDescription  | operator  |	berth   |  punctuality     |     time               |
      |		9F01            |	LO        |	0212	  |	  +0m            |2020/02/08 10:00	      |
      |		0A01	          |	LI        |	0222	  |	  +0m            |2020/02/08 10:00 (Last) |
    When the user enter the filter value '9F01' for tpr
    Then the following can be seen on the tpr settings table
      | trainDescription  | operator  |	berth   |  punctuality     |     time               |
      |		9F01            |	LO        |	0212	  |	  +0m            |2020/02/08 10:00	      |
      |		0A01	          |	LI        |	0222	  |	  +0m            |2020/02/08 10:00 (Last) |

