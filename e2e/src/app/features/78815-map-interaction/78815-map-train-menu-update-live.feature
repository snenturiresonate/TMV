@newSession
Feature: 78815 - TMV Map Interaction - Map Train Menu Update (Live)

  As a TMV User
  I want the ability to interact with the schematic maps
  So that I can access additional functions or information

  Background:
    * I have not already authenticated

  Scenario: 78842-1 - Display punctuality, signal, berth on context menu
    # Given the user is authenticated to use TMV
    # And the user is viewing the map
    # And there are trains running
    # When the user performs a secondary click using their mouse
    # Then the train's menu is opened
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
    | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
    | access-plan/1D46_PADTON_OXFD.cif | GORASTR     | WTT_pass      | 1F34                | L00014         |
    And I wait until today's train 'L00014' has loaded
    And I am viewing the map GW03reading.v
    And the following live berth interpose message is sent from LINX (creating a match)
    | toBerth | trainDescriber | trainDescription |
    | 0813    | D1             | 1F34             |
    Then berth '0813' in train describer 'D1' contains '1F34' and is visible
    And 'no' toggle is displayed in the title bar
    When I invoke the context menu on the map for train 1F34
    Then the map context menu contains 'Open Timetable' on line 2
    And the map context menu contains 'Unmatch/Rematch' on line 3
    And the map context menu contains 'Turn Path On' on line 4
    And the map context menu contains 'Highlight' on line 5
    And the map context menu contains '1F34' on line 6
    And the map context menu punctuality is one of On time,+0m 30s,-0m 30s,+1m,-1m,+1m 30s,-1m 30s
    And the map context menu contains 'T813' on line 7
    And the map context menu contains 'D10813' on line 8
    And the map context menu contains 'PADTON - OXFD' on line 9
    When I toggle path on from the map context menu
    Then 'PATH OFF' toggle is displayed in the title bar
    When I am on the timetable view for service 'L00014'
    Then the current headcode in the header row is '1F34'
    And 'no' toggle is displayed in the title bar

  Scenario: 78842-2 - Display punctuality, signal, berth on context menu
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
    | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
    | access-plan/1B69_PADTON_SWANSEA.cif | CHALLOW     | WTT_pass      | 1F35                | L00015         |
    And I wait until today's train 'L00015' has loaded
    And I am viewing the map GW04didcot.v
    And the following live berth interpose message is sent from LINX (creating a match)
    | toBerth | trainDescriber | trainDescription |
    | 1007    | D5             | 1F35             |
    Then berth '1007' in train describer 'D5' contains '1F35' and is visible
    When I invoke the context menu on the map for train 1F35
    And I toggle path on from the map context menu
    Then 'PATH OFF' toggle is displayed in the title bar
    When I invoke the context menu on the map for train 1F35
    Then the map context menu contains 'Open Timetable' on line 2
    And the map context menu contains 'Unmatch/Rematch' on line 3
    And the map context menu contains 'Turn Path Off' on line 4
    And the map context menu contains 'Highlight' on line 5
    And the map context menu contains '1F35' on line 6
    And the map context menu contains 'SB1007, SB1X07' on line 7
    And the map context menu contains 'D51007' on line 8
    And the map context menu contains 'PADTON - SWANSEA' on line 9
    When I am on the timetable view for service 'L00015'
    Then the current headcode in the header row is '1F35'

  Scenario: 78842-3 - Display punctuality, signal, berth on context menu
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
    | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
    | access-plan/2P77_RDNGSTN_PADTON.cif | MDNHEAD     | WTT_dep       | 1F36                | L00016         |
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
    | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
    | access-plan/2P77_RDNGSTN_PADTON.cif | SLOUGH      | WTT_dep       | 1F37                | L00017         |
    And I wait until today's train 'L00016' has loaded
    And I wait until today's train 'L00017' has loaded
    And I am viewing the map HDGW02reading.v
    And the following live berth interpose message is sent from LINX (creating a match)
    | toBerth | trainDescriber | trainDescription |
    | 0574    | D6             | 1F36             |
    And the following live berth interpose message is sent from LINX (creating a match)
    | toBerth | trainDescriber | trainDescription |
    | 0516    | D6             | 1F37             |
    Then berth '0574' in train describer 'D6' contains '1F36' and is visible
    Then berth '0516' in train describer 'D6' contains '1F37' and is visible
    And I invoke the context menu on the map for train 1F36
    And the map context menu contains 'Turn Path On' on line 4
    And the map context menu contains 'Highlight' on line 5
    And the map context menu contains '1F36' on line 6
    And the map context menu contains 'T574' on line 7
    And the map context menu contains 'D60574' on line 8
    And the map context menu contains 'RDNGSTN - PADTON' on line 9
    And I toggle path on from the map context menu
    And 'PATH OFF' toggle is displayed in the title bar
    When I invoke the context menu on the map for train 1F37
    Then the map context menu contains 'Open Timetable' on line 2
    And the map context menu contains 'Unmatch/Rematch' on line 3
    And the map context menu contains 'Turn Path On' on line 4
    And the map context menu contains 'Highlight' on line 5
    And the map context menu contains '1F37' on line 6
    And the map context menu contains 'T516' on line 7
    And the map context menu contains 'D60516' on line 8
    And the map context menu contains 'RDNGSTN - PADTON' on line 9
    When I toggle path on from the map context menu
    Then 'PATH OFF' toggle is displayed in the title bar
    When I invoke the context menu on the map for train 1F37
    Then the map context menu contains 'Turn Path Off' on line 4
    When I invoke the context menu on the map for train 1F36
    Then the map context menu contains 'Turn Path On' on line 4
    And the map context menu contains 'Highlight' on line 5
    And the map context menu contains '1F36' on line 6
    And the map context menu contains 'T574' on line 7
    And the map context menu contains 'D60574' on line 8
    And the map context menu contains 'RDNGSTN - PADTON' on line 9
    When I open timetable from the map context menu
    And I switch to the new tab
    Then the current headcode in the header row is '1F36'

  Scenario: 78842-4 - Display punctuality, signal, berth on context menu
    Given I am viewing the map HDGW04bristolparkway.v
    And the following live berth interpose message is sent from LINX (which won't match anything)
    | toBerth | trainDescriber | trainDescription |
    | 1168    | D7             | 1F38             |
    Then berth '1168' in train describer 'D7' contains '1F38' and is visible
    And 'no' toggle is displayed in the title bar
    When I invoke the context menu on the map for train 1F38
    Then the map context menu contains 'No Timetable' on line 2
    And the map context menu contains 'Match' on line 3
    And the map context menu contains 'Highlight' on line 4
    And the map context menu contains '1F38' on line 5
    And the map context menu punctuality is one of Unavailable
    And the map context menu contains 'D71168' on line 6
    When I click on Match in the context menu
    And I switch to the new tab
    Then the tab title is 'TMV Schedule Matching'

  Scenario: 78842-5 - Display punctuality, signal, berth on context menu
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
    | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
    | access-plan/1D46_PADTON_OXFD.cif | RDLEY       | WTT_dep       | 1F39                | L00019         |
    And I wait until today's train 'L00019' has loaded
    And I am viewing the map GW04didcot.v
    And the following live berth interpose message is sent from LINX (creating a match)
    | toBerth | trainDescriber | trainDescription |
    | 2323    | D5             | 1F39             |
    And the following live berth interpose message is sent from LINX (which won't match anything)
    | toBerth | trainDescriber | trainDescription |
    | 2368    | D5             | 1F40             |
    Then berth '2323' in train describer 'D5' contains '1F39' and is visible
    Then berth '2368' in train describer 'D5' contains '1F40' and is visible
    And I invoke the context menu on the map for train 1F39
    And I toggle path on from the map context menu
    And 'PATH OFF' toggle is displayed in the title bar
    When I invoke the context menu on the map for train 1F40
    Then the map context menu contains 'No Timetable' on line 2
    And the map context menu contains 'Match' on line 3
    And the map context menu contains 'Highlight' on line 4
    And the map context menu contains '1F40' on line 5
    And the map context menu punctuality is one of Unavailable
    And the map context menu contains 'D52368' on line 6
    When I click on Match in the context menu
    And I switch to the new tab
    Then the tab title is 'TMV Schedule Matching'

  Scenario: 78842-6 - Display punctuality, signal, berth on context menu
    Given I am viewing the map HDGW04bristolparkway.v
    And the following live berth interpose message is sent from LINX (which won't match anything)
      | toBerth | trainDescriber | trainDescription |
      | 1168    | D7             | 1F38             |
    Then berth '1168' in train describer 'D7' contains '1F38' and is visible
    And 'no' toggle is displayed in the title bar
    When I click on the map for train 1F38
    Then the tab title is 'TMV Map HDGW04'
    When I invoke the context menu on the map for train 1F38
    Then the map context menu contains 'No Timetable' on line 2
    And the map context menu contains 'Match' on line 3
    And the map context menu contains 'Highlight' on line 4
    And the map context menu contains '1F38' on line 5
    And the map context menu punctuality is one of Unavailable
    And the map context menu contains 'D71168' on line 6
    When I click on Match in the context menu
    And I switch to the new tab
    Then the tab title is 'TMV Schedule Matching'
