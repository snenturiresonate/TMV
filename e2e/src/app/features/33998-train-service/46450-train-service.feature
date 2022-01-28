Feature: 33998 - TMV Train Service - full end to end testing

  As a Tester
  I want end to end tests to be created for the Train Service functionality
  So that there is confidence that it continues to work as expected as more of the system is developed

  Background:
    * I have not already authenticated
    * I am on the home page
    * The admin setting defaults are as originally shipped
    * I have cleared out all headcodes

  Scenario: 33998-1 Punctuality (Matched Service)
    # Given the user is authenticated to use TMV
    # When the user is viewing the service on the map
    # And the service is matched
    # And the service is running or activated (called)
    # Then the train's punctuality is displayed for each part of the journey not yet complete
    * I generate a new train description
    * I generate a new trainUID
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | generated           | generated      |
    And I wait until today's train 'generated' has loaded
    And I am viewing the map HDGW01paddington.v
    When the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | A007    | D3             | generated        |
    Then berth 'A007' in train describer 'D3' contains 'generated' and is visible
    And the train headcode color for berth 'D3A007' is lightgreen or green

  Scenario: 33998-2 Punctuality (Un-matched Service)
    # Given the user is authenticated to use TMV
    # When the user is viewing the service on the map
    # And the service is not matched
    # Then the train's punctuality is not calculated
    # And the headcode will be coloured in 'no timetable' colour
    Given I am viewing the map HDGW01paddington.v
    When the following live berth interpose message is sent from LINX (which won't match anything)
      | toBerth | trainDescriber | trainDescription |
      | A001    | D3             | 5T78             |
    Then berth 'A001' in train describer 'D3' contains '5T78' and is visible
    And the train headcode color for berth 'D3A001' is lightgrey

  Scenario: 33998-3 Left behind (Headcode)
    # Given the user is viewing a live schematic map
    # And there are services running
    # And the service is matched
    # When the user views an individual service that has had its stepping interrupted
    # Then the train's headcode colour represents "left behind"
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | 1F22                | L00002         |
    And I wait until today's train 'L00002' has loaded
    And I am viewing the map HDGW01paddington.v
    When the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | A007    | D3             | 1F22             |
    And the following live berth interpose message is sent from LINX (causing interrupted stepping)
      | toBerth | trainDescriber | trainDescription |
      | A003    | D3             | 1F22             |
    And the maximum amount of time is allowed for end to end transmission
    Then berth 'A007' in train describer 'D3' contains '1F22' and is visible
    And the train headcode color for berth 'D3A007' is grey

  Scenario: 33998-4 Last Berth (Head Code)
    # Given the user is viewing a live schematic map
    # And there are services running
    # When the user views a last berth
    # Then the train's headcode colour represents "last berth"
    Given I am viewing the map HDGW01paddington.v
    When the following live berth interpose message is sent from LINX (into a last berth)
      | toBerth | trainDescriber | trainDescription |
      | R011    | D3             | 1D34             |
    Then berth 'R011' in train describer 'D3' contains '1D34' and is visible
    And the train headcode color for berth 'D3R011' is white

  Scenario: 33998-5 Off Planned Path
    # Given the user is viewing a live schematic map
    # And there are services running
    # When the user views an individual service is off planned path
    # Then the train's headcode colour represents "off plan"
    # And the train's path is shown if the train has "path on" (covered in 7b below)
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | 1F23                | L00003         |
    And I wait until today's train 'L00003' has loaded
    And I am viewing the map HDGW01paddington.v
    When the following live berth interpose message is sent from LINX  (at wrong platform - i.e. off-plan)
      | toBerth | trainDescriber | trainDescription |
      | A029    | D3             | 1F23             |
    Then berth 'A029' in train describer 'D3' contains '1F23' and is visible
    And the train headcode color for berth 'D3A029' is blue

  Scenario: 33998-6 Off Route
    # Given the user is viewing a live schematic map
    # And there are services running
    # When the user views an individual service is off route path
    # Then the train's headcode colour represents "off route"
    # And the train's path is not shown if the train has "path on" (covered in 7c below)
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1S42_PADTON_DIDCOTP.cif | RDNGSTN     | WTT_dep       | 1F24                | L00004         |
    And I wait until today's train 'L00004' has loaded
    And I am viewing the map HDGW02reading.v
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 1709    | D1             | 1F24             |
    And the following live berth step message is sent from LINX (causing matched service to go off route)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 1709      | 1729    | D1             | 1F24             |
    Then berth '1729' in train describer 'D1' contains '1F24' and is visible
    And the train headcode color for berth 'D11729' is blue

  Scenario: 33998-7a Path On Toggle (Matched On-Plan)
    # Given the user is viewing a live schematic map
    # And there are services running
    # And the user has selected a matched service (secondary mouse click)
    # And the user is viewing the trains service menu
    # When the user selects to turn the path on
    # Then the train's predicted path is displayed in blue for the remainder of its journey
    # And the path off toggle is available (single train)
    * I generate a new train description
    * I generate a new trainUID
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/2P77_RDNGSTN_PADTON.cif | RDNGSTN     | WTT_dep       | generated           | generated      |
    And I wait until today's train 'generated' has loaded
    And I am viewing the map HDGW02reading.v
    When the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 1698    | D1             | generated        |
    And the following live signalling update message is sent from LINX (clearing any existing state)
      | trainDescriber | address | data |
      | D1             | 25      | 00   |
    And the following live signalling update message is sent from LINX (setting a route)
      | trainDescriber | address | data |
      | D1             | 25      | 02   |
    And the train headcode color for berth 'D11698' is lightgreen or green
    And the tracks 'RGRGLS, RGRGKT, RGRGL3, RGRGL2' are displayed in solid white
    And the tracks 'RGRGLK, RGRGL6, RGRG1I, RGRG8H' are displayed in thin palegrey
    And the tracks 'PNSH8V, PNSH7V, PNSH6V' are displayed in thin palegrey
    When I invoke the context menu on the map for train generated
    And I toggle path on from the map context menu
    Then the tracks 'RGRGLS, RGRGKT, RGRGL3, RGRGL2' are displayed in solid paleblue
    And the tracks 'RGRGLK, RGRGL6, RGRG1I, RGRG8H' are displayed in solid paleblue
    And the tracks 'PNSH8V, PNSH7V, PNSH6V' are displayed in solid paleblue
    And 'PATH OFF' toggle is displayed in the title bar
    When I move to map 'HDGW01' via continuation link
    Then the tracks 'PNPN69, PNPN70' are displayed in solid paleblue
    And 'PATH OFF' toggle is displayed in the title bar
    When I search for map 'HDGW02' via the recent map list
    And I click the search icon
    And I select the map at position 1 in the search results list
    And I switch to the new tab
    And the maximum amount of time is allowed for end to end transmission
    And I invoke the context menu on the map for train generated
    Then the map context menu contains 'Path Off' on line 4

  Scenario: 33998-7b Path On Toggle (Matched Off-Plan can show path)
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | 1F26                | L00006         |
    And I wait until today's train 'L00006' has loaded
    And I am viewing the map HDGW01paddington.v
    When the following live berth interpose message is sent from LINX (at wrong platform - i.e. off-plan)
      | toBerth | trainDescriber | trainDescription |
      | A009    | D3             | 1F26             |
    And the following live signalling update message is sent from LINX (clearing any existing state)
      | trainDescriber | address | data |
      | D3             | 02      | 00   |
    And the following live signalling update message is sent from LINX (setting a route)
      | trainDescriber | address | data |
      | D3             | 02      | 02   |
    Then berth 'A009' in train describer 'D3' contains '1F26' and is visible
    And the train headcode color for berth 'D3A009' is blue
    And the tracks 'PNPNF5, PNPNK5, PNPNK9, PNPNL1, PNPNL2, PNPNL3' are displayed in solid white
    When I invoke the context menu on the map for train 1F26
    And I toggle path on from the map context menu
    Then the tracks 'PNPNF5, PNPNK5, PNPNK9, PNPNL1, PNPNL2, PNPNL3' are displayed in solid paleblue
    And 'PATH OFF' toggle is displayed in the title bar
    When I invoke the context menu on the map for train 1F26
    Then the map context menu contains 'Path Off' on line 4

  Scenario: 33998-7c Path On Toggle (Matched Off-Route cannot show path)
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1B69_PADTON_SWANSEA.cif | WTNBSTJ     | WTT_pass      | 1F27                | L00007         |
    And I wait until today's train 'L00007' has loaded
    And I am viewing the map GW05swindon.v
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 1235    | D7             | 1F27             |
    And the following live signalling update message is sent from LINX (clearing any existing state)
      | trainDescriber | address | data |
      | D7             | 18      | 00   |
    And the following live signalling update message is sent from LINX (setting a route)
      | trainDescriber | address | data |
      | D7             | 18      | 20   |
    And the following live berth step message is sent from LINX (causing matched service to go off route)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 1235      | 1241    | D7             | 1F27             |
    Then berth '1241' in train describer 'D7' contains '1F27' and is visible
    And the train headcode color for berth 'D71241' is blue
    And the tracks 'SNSNB7, SNSNB8, SNSNB9, SNSNBA, SNSND3, SNSND4' are displayed in solid white
    When I invoke the context menu on the map for train 1F27
    And I toggle path on from the map context menu
    * I disable waiting for angular
    Then 'no' toggle is displayed in the title bar
    And the tracks 'SNSNB7, SNSNB8, SNSNB9, SNSNBA, SNSND3, SNSND4' are displayed in solid white
    When I invoke the context menu on the map for train 1F27
    Then the map context menu contains 'Turn Path On' on line 4
    * I enable waiting for angular

  Scenario: 33998-7d Path On Toggle (Only one train can have path on at a time)
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1B69_PADTON_SWANSEA.cif | ACTONW      | WTT_pass      | 1F28                | L00008         |
    And the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                                    | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/2P04_RDNGSTN_PADTON_STOPPER.cif | EALINGB     | WTT_dep       | 1F29                | L00009         |
    And I wait until today's train 'L00008' has loaded
    And I wait until today's train 'L00009' has loaded
    And I am viewing the map HDGW01paddington.v
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 0179    | D3             | 1F28             |
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 0206    | D3             | 1F29             |
    And I invoke the context menu on the map for train 1F28
    And I toggle path on from the map context menu
    And 'PATH OFF' toggle is displayed in the title bar
    And the tracks 'PNPNN9, PNPN4L, PNPN6L' are displayed in solid paleblue
    And the tracks 'PNPNT2, PNPNW0, PNPNWB' are displayed in thin palegrey
    When I invoke the context menu on the map for train 1F29
    And I toggle path on from the map context menu
    Then 'PATH OFF' toggle is displayed in the title bar
    And the tracks 'PNPNN9, PNPN4L, PNPN6L' are displayed in thin palegrey
    And the tracks 'PNPNT2, PNPNW0, PNPNWB' are displayed in solid paleblue

  Scenario: 33998-8 Path Off Toggle (Train)
    # Given the user is viewing a live schematic map
    # And the user has applied a path on for a service
    # And the service has not reached its destination
    # And the user selects the service (secondary mouse click)
    # And the user is viewing the trains service menu
    # When the user selects to turn the path off
    # Then the train's predicted path is displayed in white for the remainder of its journey
    * I generate a new train description
    * I generate a new trainUID
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/2P77_RDNGSTN_PADTON.cif | TWYFORD     | WTT_arr       | generated           | generated      |
    And I wait until today's train 'generated' has loaded
    And I am viewing the map HDGW02reading.v
    When the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 1630    | D1             | generated        |
    And the following live signalling update message is sent from LINX (clearing existing state)
      | trainDescriber | address | data |
      | D1             | 2D      | FF   |
    And the following live signalling update message is sent from LINX (clearing existing state)
      | trainDescriber | address | data |
      | D1             | 2D      | 00   |
    And the following live signalling update message is sent from LINX (setting a route)
      | trainDescriber | address | data |
      | D1             | 2D      | 40   |
    Then berth '1630' in train describer 'D1' contains 'generated' and is visible
    And the train headcode color for berth 'D11630' is lightgreen or green
    And the tracks 'RGRG57, RGRG56' are displayed in solid white
    And the tracks 'RGRG55, RGRG54' are displayed in thin palegrey
    When I invoke the context menu on the map for train generated
    And I toggle path on from the map context menu
    Then 'PATH OFF' toggle is displayed in the title bar
    And the tracks 'RGRG57, RGRG56, RGRG55, RGRG54' are displayed in solid paleblue
    When I move to map 'HDGW01' via continuation link
    And the maximum amount of time is allowed for end to end transmission
    Then the tracks 'PNPN04, PNPN2I, PNPN67, PNPN68, PNPN69, PNPN70' are displayed in solid paleblue
    When I search for map 'HDGW02' via the recent map list
    And I click the search icon
    And I select the map at position 1 in the search results list
    And I switch to the new tab
    And the maximum amount of time is allowed for end to end transmission
    And I invoke the context menu on the map for train generated
    And I toggle path off from the map context menu
    Then 'no' toggle is displayed in the title bar
    And the tracks 'RGRG57, RGRG56' are displayed in solid white
    And the tracks 'RGRG55, RGRG54' are displayed in thin palegrey
    When I move to map 'HDGW01' via continuation link
    And the maximum amount of time is allowed for end to end transmission
    Then the tracks 'PNPN19, PNPN20, PNPN21, PNPN22, PNPN41, PNPN68, PNPN69, PNPN70' are displayed in thin palegrey
    And 'no' toggle is displayed in the title bar

  @bug @bug:80006
  Scenario: 33998-9a Path Off Toggle (Nav Bar)
    # Given the user is viewing a live schematic map
    # And the user has applied a path on for a service
    # And the service has not reached its destination
    # When the user selects to turn the path off from the nav bar
    # Then the train's predicted path is displayed in white for the remainder of its journey
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1S42_PADTON_DIDCOTP.cif | TWYFORD     | WTT_pass      | 1F31                | L00011         |
    And I wait until today's train 'L00011' has loaded
    And I am viewing the map HDGW02reading.v
    When the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 1637    | D1             | 1F31             |
    And the following live signalling update message is sent from LINX (clearing any existing state)
      | trainDescriber | address | data |
      | D1             | 2E      | 00   |
    And the following live signalling update message is sent from LINX (setting a route)
      | trainDescriber | address | data |
      | D1             | 2E      | 80   |
    Then berth '1637' in train describer 'D1' contains '1F31' and is visible
    And the train headcode color for berth 'D11637' is lightgreen or green
    And the tracks 'RGRG38' are displayed in solid white
    And the tracks 'RGRG39, RGRG40' are displayed in thin palegrey
    When I invoke the context menu on the map for train 1F31
    And I toggle path on from the map context menu
    Then 'PATH OFF' toggle is displayed in the title bar
    And the tracks 'RGRG38, RGRG39, RGRG40' are displayed in solid lightblue
    When I move to map 'HDGW03' via continuation link
    And the maximum amount of time is allowed for end to end transmission
    Then 'PATH OFF' toggle is displayed in the title bar
    And the tracks 'OXOXAX, OXOXAY, OXOXAZ, OXOXB1, OXOXB7, OXOXBA, OXOXBB, OXOXBC, OXOXBL' are displayed in solid lightblue
    When I toggle path off from the nav bar
    Then 'no' toggle is displayed in the title bar
    And the tracks 'OXOXAX, OXOXAY, OXOXAZ, OXOXB1, OXOXB7, OXOXBA, OXOXBB, OXOXBC, OXOXBL' are displayed in thin palegrey
    When I open map 'HDGW02' via the recent map list
    And the maximum amount of time is allowed for end to end transmission
    And I switch to the new tab
    Then 'no' toggle is displayed in the title bar
    And the tracks 'RGRG38' are displayed in solid white
    And the tracks 'RGRG39, RGRG40' are displayed in thin palegrey
    When I invoke the context menu on the map for train 1F31
    Then the map context menu contains 'Path On' on line 3

  Scenario: 33998-9b Path Off Toggle (remains available on Nav Bar after train leaves map)
    * I generate a new train description
    * I generate a new trainUID
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                                    | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/2P04_RDNGSTN_PADTON_STOPPER.cif | IVER        | WTT_dep       | generated           | generated      |
    And I wait until today's train 'generated' has loaded
    And I am viewing the map HDGW02reading.v
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 0478    | D6             | generated        |
    When I invoke the context menu on the map for train generated
    And I toggle path on from the map context menu
    Then 'PATH OFF' toggle is displayed in the title bar
    And the tracks 'PNSH3U, PNSHTL' are displayed in solid paleblue
    When the following live berth step message is sent from LINX (moving train along)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0478      | 0472    | D6             | generated        |
    And the following live berth step message is sent from LINX (moving train off the map)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0472      | 0466    | D4             | generated        |
    And the following live signalling update message is sent from LINX (clearing any existing state)
      | trainDescriber | address | data |
      | D4             | 23      | 00   |
    And the following live signalling update message is sent from LINX (setting a route)
      | trainDescriber | address | data |
      | D4             | 23      | 08   |
    And the maximum amount of time is allowed for end to end transmission
    Then the train headcode 'generated' is 'not displayed' on the map
    And the tracks 'PNSH3U, PNSHTL' are displayed in solid paleblue
    And 'PATH OFF' toggle is displayed in the title bar
    When I move to map 'HDGW01' via continuation link
    And the maximum amount of time is allowed for end to end transmission
    Then 'PATH OFF' toggle is displayed in the title bar
    And berth '0466' in train describer 'D4' contains 'generated' and is visible
    And the tracks 'PNSH6U, PNSH4U, PNSH3U, PNSHTL, PNSHTM, PNSHTN, PNSHTP' are displayed in thin palegrey
    And the tracks 'PNSH1R, PNSH9Q, PNSH8Q' are displayed in solid paleblue
    When I move to map 'HDGW02' via continuation link
    Then 'PATH OFF' toggle is displayed in the title bar
    When I toggle path off from the nav bar
    Then 'no' toggle is displayed in the title bar
    When I move to map 'HDGW01' via continuation link
    Then 'no' toggle is displayed in the title bar
    And the tracks 'PNSH1R, PNSH9Q, PNSH8Q' are displayed in solid white

  Scenario: 33998-9c Path Off Toggle (available on Nav Bar of unrelated map)
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                                    | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/2P04_RDNGSTN_PADTON_STOPPER.cif | STHALL      | WTT_pass      | 1F33                | L00013         |
    And I wait until today's train 'L00013' has loaded
    And I am viewing the map HDGW01paddington.v
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 0248    | D4             | 1F33             |
    Then berth '0248' in train describer 'D4' contains '1F33' and is visible
    When I invoke the context menu on the map for train 1F33
    And I toggle path on from the map context menu
    Then 'PATH OFF' toggle is displayed in the title bar
    And I am viewing the map MD03watford.v
    Then 'PATH OFF' toggle is displayed in the title bar
    When I toggle path off from the nav bar
    Then 'no' toggle is displayed in the title bar
    When I am viewing the map HDGW01paddington.v
    Then 'no' toggle is displayed in the title bar

  Scenario: 33998-10a Map (Train Menu - matched train, no path on anywhere)
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
    And the map context menu contains 'Turn Path On' on line 4
    When I toggle path on from the map context menu
    Then 'PATH OFF' toggle is displayed in the title bar
    When I am on the timetable view for service 'L00014'
    Then the current headcode in the header row is '1F34'
    And 'no' toggle is displayed in the title bar

  Scenario: 33998-10b Map (Train Menu - matched train with path on)
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
    And the map context menu contains 'Turn Path Off' on line 4
    When I am on the timetable view for service 'L00015'
    Then the current headcode in the header row is '1F35'

  Scenario: 33998-10c Map (Train Menu - matched train with another path on)
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
    And I toggle path on from the map context menu
    And 'PATH OFF' toggle is displayed in the title bar
    When I invoke the context menu on the map for train 1F37
    Then the map context menu contains 'Open Timetable' on line 2
    And the map context menu contains 'Turn Path On' on line 4
    When I toggle path on from the map context menu
    Then 'PATH OFF' toggle is displayed in the title bar
    When I invoke the context menu on the map for train 1F37
    Then the map context menu contains 'Turn Path Off' on line 4
    When I invoke the context menu on the map for train 1F36
    Then the map context menu contains 'Turn Path On' on line 4
    When I open timetable from the map context menu
    And I switch to the new tab
    Then the current headcode in the header row is '1F36'

  Scenario: 33998-10d Map (Train Menu - unmatched train, no path on anywhere)
    #
    Given I am viewing the map HDGW04bristolparkway.v
    And the following live berth interpose message is sent from LINX (which won't match anything)
      | toBerth | trainDescriber | trainDescription |
      | 1168    | D7             | 1F38             |
    Then berth '1168' in train describer 'D7' contains '1F38' and is visible
    And 'no' toggle is displayed in the title bar
    When I invoke the context menu on the map for train 1F38
    Then the map context menu contains 'No Timetable' on line 2
    And the map context menu contains 'Match' on line 3
    When I click on Match in the context menu
    And I switch to the new tab
    Then the tab title is 'TMV Schedule Matching 1F38'

  Scenario: 33998-10e Map (Train Menu - unmatched train with another path on)
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
    When I click on Match in the context menu
    And I switch to the new tab
    Then the tab title is 'TMV Schedule Matching 1F40'
