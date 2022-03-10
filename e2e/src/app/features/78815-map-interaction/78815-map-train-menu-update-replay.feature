@TMVPhase2 @P2.S1
Feature: 78815 - TMV Map Interaction - Map Train Menu Update (Replay)

  As a TMV User
  I want the ability to interact with the schematic maps
  So that I can access additional functions or information

  Background:
    * I have not already authenticated
    * I am on the home page
    * The admin setting defaults are as originally shipped
    * I have cleared out all headcodes

  @bug @bug:91369
  Scenario: 78843-a Map (Train Menu - matched train)
    # Replay setup

    * I reset redis
    * the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | GORASTR     | WTT_pass      | 1F34                | L00014         |
    * I wait until today's train 'L00014' has loaded
    * I am viewing the map GW03reading.v
    * the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 0813    | D1             | 1F34             |
    * berth '0813' in train describer 'D1' contains '1F34' and is visible

    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'GW03reading.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    When I click Play button
    Then berth '0813' in train describer 'D1' contains '1F34' and is visible
    And 'no' toggle is displayed in the title bar
    When I invoke the context menu on the map for train 1F34
    Then the map context menu contains 'Open Timetable' on line 2
    And the map context menu contains '1F34' on line 3
    And the map context menu punctuality is one of On time,+0m 30s,-0m 30s,+1m,-1m,+1m 30s,-1m 30s
    And the map context menu contains 'T813' on line 4
    And the map context menu contains 'D10813' on line 5
    And the map context menu contains 'PADTON - OXFD' on line 6
    When I open timetable from the map context menu
    And I switch to the new tab
    Then the current headcode in the header row is '1F34'

  Scenario: 78843-b Map (Train Menu - unmatched train)
    # Replay setup
    * I reset redis
    * I am viewing the map HDGW04bristolparkway.v
    * the following live berth interpose message is sent from LINX (which won't match anything)
      | toBerth | trainDescriber | trainDescription |
      | 1168    | D7             | 1F38             |
    * berth '1168' in train describer 'D7' contains '1F38' and is visible

    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW04bristolparkway.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    When I click Play button
    Then berth '1168' in train describer 'D7' contains '1F38' and is visible
    When I invoke the context menu on the map for train 1F38
    Then the map context menu contains 'No Timetable' on line 2
    And the map context menu contains '1F38' on line 3
    And the map context menu punctuality is one of Unavailable
    And the map context menu contains 'D71168' on line 4
