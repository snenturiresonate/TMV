Feature: 33998 - TMV Train Service - full end to end testing

  As a Tester
  I want end to end tests to be created for the Train Service functionality
  So that there is confidence that it continues to work as expected as more of the system is developed

  Background:
    Given The admin setting defaults are as originally shipped

  @tdd
  Scenario: 33998-1 Punctuality (Matched Service)
  #Given the user is authenticated to use TMV
  #When the user is viewing the service on the map
  #And the service is matched
  #And the service is running or activated (called)
  #Then the train's punctuality is displayed for each part of the journey not yet complete
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | 1F21                | L00001         |
    And I see todays schedule for 'L00001' has loaded by looking at the timetable page
    And I am viewing the map hdgw01paddington.v
    When the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | A007    | D3             | 1F21             |
    Then the headcode displayed for 'A007' is 1F21
    And the train headcode color for berth 'D3A007' is green

  @tdd
  Scenario: 33998-2 Punctuality (Un-matched Service)
  #Given the user is authenticated to use TMV
  #When the user is viewing the service on the map
  #And the service is not matched
  #Then the train's punctuality is not calculated
  #And the headcode will be coloured in blue
    And I am viewing the map hdgw01paddington.v
    When the following live berth interpose message is sent from LINX (which won't match anything)
      | toBerth | trainDescriber | trainDescription |
      | A001    | D3             | 5T78             |
    Then the headcode displayed for 'A001' is 5T78
    And the train headcode color for berth 'D3A001' is blue


  @tdd
  Scenario: 33998-3 Left behind (Headcode)
    #Given the user is viewing a live schematic map
    #And there are services running
    #And the service is match
    #When the user views an individual service that has had its stepping interrupted
    #Then the train's headcode colour represents "left behind"
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | 1F22                | L00002         |
    And I see todays schedule for 'L00002' has loaded by looking at the timetable page
    And I am viewing the map hdgw01paddington.v
    When the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | A007    | D3             | 1F22             |
    And the following live berth interpose message is sent from LINX (causing interrupted stepping)
      | toBerth | trainDescriber | trainDescription |
      | A003    | D3             | 1F22             |
    And the maximum amount of time is allowed for end to end transmission
    Then the headcode displayed for 'D3A007' is 1F22
    And the train headcode color for berth 'D3A007' is grey

  @tdd
  Scenario: 33998-4 Last Berth (Head Code)
  #Given the user is viewing a live schematic map
  #And there are services running
  #When the user views a last berth
  #Then the train's headcode colour represents "last berth"
    And I am viewing the map hdgw01paddington.v
    When the following live berth interpose message is sent from LINX (into a last berth)
      | toBerth | trainDescriber | trainDescription |
      | R011    | D3             | 1D34             |
    Then the headcode displayed for 'D3R011' is 1D34
    And the train headcode color for berth 'D3R011' is stone

  @tdd
  Scenario: 33998-5 Off Planned Path
    #Given the user is viewing a live schematic map
    #And there are services running
    #When the user views an individual service is off planned path
    #Then the train's headcode colour represents "off plan"
    #And the train's path is shown if the train has "path on" (covered in 7b below)
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1S42_PADTON_OXFD.cif | PADTON      | WTT_dep       | 1F23                | L00003         |
    And I see todays schedule for 'L00003' has loaded by looking at the timetable page
    And I am viewing the map hdgw01paddington.v
    When the following live berth interpose message is sent from LINX  (at wrong platform - i.e. off-plan)
      | toBerth | trainDescriber | trainDescription |
      | A029    | D3             | 1F23             |
    Then the headcode displayed for 'D3A029' is 1F23
    And the train headcode color for berth 'D3A029' is blue

  @tdd
  Scenario: 33998-6 Off Route
#    Given the user is viewing a live schematic map
#    And there are services running
#    When the user views an individual service is off route path
#    Then the train's headcode colour represents "off route"
#    And the train's path is not shown if the train has "path on" (covered in 7c below)
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_DIDCOTP.cif | RDNGSTN     | WTT_dep       | 1F24                | L00004         |
    And I see todays schedule for 'L00004' has loaded by looking at the timetable page
    And I am viewing the map hdgw02reading.v
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 1709    | D1             | 1F24             |
    And the following live berth step message is sent from LINX (causing matched service to go off route)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 1709      | 1729    | D1             | 1F24             |
    Then the headcode displayed for 'D11729' is 1F24
    And the train headcode color for berth 'D11729' is blue

  @tdd
  Scenario: 33998-7a Path On Toggle (Matched On-Plan)
#    Given the user is viewing a live schematic map
#    And there are services running
#    And the user has selected a matched service (secondary mouse click)
#    And the user is viewing the trains service menu
#    When the user selects to turn the path on
#    Then the train's predicted path is displayed in blue for the remainder of its journey
#    And the path off toggle is available (single train)
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/2P77_RDNGSTN_PADTON.cif | RDNGSTN     | WTT_dep       | 1F25                | L00005         |
    And I see todays schedule for 'L00005' has loaded by looking at the timetable page
    And I am on the home page
    And I expand the group of maps with name 'Wales & Western'
    And I navigate to the maps view with id hdgw02reading.v
    And I switch to the new tab
    When the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 1698    | D1             | 1F25             |
    And the following live signalling update message is sent from LINX (setting a route)
      | trainDescriber | address | data |
      | D1             | 25      | 02   |
    And the train headcode color for berth 'D11698' is green
    And the tracks 'RGRGLS, RGRGKT, RGRGL3, RGRGL2' are displayed in solid white
    And the tracks 'RGRGLK, RGRGL6, RGRG1I, RGRG8H' are displayed in thin palegrey
    And the tracks 'PNSH8V, PNSH7V, PNSH6V' are displayed in thin palegrey
    When I invoke the context menu on the map for train 1F25
    And I toggle path on from the map context menu
    Then the tracks 'RGRGLS, RGRGKT, RGRGL3, RGRGL2' are displayed in solid blue
    And the tracks 'RGRGLK, RGRGL6, RGRG1I, RGRG8H' are displayed in solid blue
    And the tracks 'PNSH8V, PNSH7V, PNSH6V' are displayed in solid blue
    And 'PATH' toggle is displayed in the title bar
    When I move to map 'HDGW01' via continuation link
    Then the tracks 'PNPN19, PNPN20, PNPN21, PNPN22, PNPN41, PNPN68, PNPN69, PNPN70' are displayed in solid blue
    And 'PATH' toggle is displayed in the title bar
    When I open map 'HDGW02' via the recent map list
    And I switch to the new tab
    And the maximum amount of time is allowed for end to end transmission
    And I invoke the context menu on the map for train 1F25
    Then the map context menu contains 'Path Off' on line 3


  @tdd
  Scenario: 33998-7b Path On Toggle (Matched Off-Plan can show path)
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | 1F26                | L00006         |
    And I see todays schedule for 'L00006' has loaded by looking at the timetable page
    And I am viewing the map hdgw01paddington.v
    When the following live berth interpose message is sent from LINX (at wrong platform - i.e. off-plan)
      | toBerth | trainDescriber | trainDescription |
      | A009    | D3             | 1F26             |
    And the following live signalling update message is sent from LINX (setting a route)
      | trainDescriber | address | data |
      | D3             | 02      | 02   |
    Then the headcode displayed for 'D3A009' is 1F26
    And the train headcode color for berth 'D3A009' is blue
    And the tracks 'PNPNF4, PNPNF5, PNPNK5, PNPNK9, PNPNL1, PNPNL2, PNPNL3' are displayed in solid white
    When I invoke the context menu on the map for train 1F26
    And I toggle path on from the map context menu
    Then the tracks 'PNPNF4, PNPNF5, PNPNK5, PNPNK9, PNPNL1, PNPNL2, PNPNL3' are displayed in solid blue
    And 'PATH' toggle is displayed in the title bar
    When I invoke the context menu on the map for train 1F26
    Then the map context menu contains 'Path Off' on line 3

  @tdd
  Scenario: 33998-7c Path On Toggle (Matched Off-Route cannot show path)
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1B69_PADTON_SWANSEA.cif | WTNBSTJ     | WTT_pass      | 1F27                | L00007         |
    And I see todays schedule for 'L00007' has loaded by looking at the timetable page
    And I am viewing the map gw05swindon.v
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 1235    | D7             | 1F27             |
    And the following live signalling update message is sent from LINX (setting a route)
      | trainDescriber | address | data |
      | D7             | 18      | 20   |
    And the following live berth step message is sent from LINX (causing matched service to go off route)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 1235      | 1353    | D7             | 1F27             |
    Then the headcode displayed for 'D71353' is 1F27
    And the train headcode color for berth 'D71353' is blue
    And the tracks 'SNSNB7, SNSNB8, SNSNB9, SNSNBA, SNSND3, SNSND4' are displayed in solid white
    When I invoke the context menu on the map for train 1F27
    And I toggle path on from the map context menu
    Then the tracks 'SNSNB7, SNSNB8, SNSNB9, SNSNBA, SNSND3, SNSND4' are displayed in solid white
    And 'no' toggle is displayed in the title bar
    When I invoke the context menu on the map for train 1F27
    Then the map context menu contains 'Path On' on line 3

  @tdd
  Scenario: 33998-7d Path On Toggle (Only one train can have path on at a time)
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1B69_PADTON_SWANSEA.cif | ACTONW      | WTT_pass      | 1F28                | L00008         |
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                                    | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/2P04_RDNGSTN_PADTON_STOPPER.cif | EALINGB     | WTT_dep       | 1F29                | L00009         |
    And I see todays schedule for 'L00008' has loaded by looking at the timetable page
    And I see todays schedule for 'L00009' has loaded by looking at the timetable page
    And I am viewing the map hdgw01paddington.v
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 0179    | D3             | 1F28             |
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 0206    | D3             | 1F29             |
    And I invoke the context menu on the map for train 1F28
    And I toggle path on from the map context menu
    And 'PATH' toggle is displayed in the title bar
    And the tracks 'PNPNN9, PNPN4L, PNPN6L' are displayed in solid blue
    And the tracks 'PNPNT2, PNPNW0, PNPNWA' are displayed in thin palegrey
    When I invoke the context menu on the map for train 1F29
    And I toggle path on from the map context menu
    Then 'PATH' toggle is displayed in the title bar
    And the tracks 'PNPNN9, PNPN4L, PNPN6L' are displayed in thin palegrey
    And the tracks 'PNPNT2, PNPNW0, PNPNWA' are displayed in solid blue

  @tdd
  Scenario: 33998-8 Path Off Toggle (Train)
#    Given the user is viewing a live schematic map
#    And the user has applied a path on for a service
#    And the service has not reached its destination
#    And the user selects the service (secondary mouse click)
#    And the user is viewing the trains service menu
#    When the user selects to turn the path off
#    Then the train's predicted path is displayed in white for the remainder of its journey
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/2P77_RDNGSTN_PADTON.cif | TWYFORD     | WTT_pass      | 1F30                | L00010         |
    And I see todays schedule for 'L00010' has loaded by looking at the timetable page
    And I am on the home page
    And I expand the group of maps with name 'Wales & Western'
    And I navigate to the maps view with id hdgw02reading.v
    And I switch to the new tab
    When the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 1630    | D1             | 1F30             |
    And the following live signalling update message is sent from LINX (setting a route)
      | trainDescriber | address | data |
      | D1             | 2D      | 40   |
    And the train headcode color for berth 'D11630' is green
    And the tracks 'RGRG57, RGRG56' are displayed in solid white
    And the tracks 'RGRG55, RGRG54' are displayed in thin palegrey
    When I invoke the context menu on the map for train 1F30
    And I toggle path on from the map context menu
    Then 'PATH' toggle is displayed in the title bar
    And the tracks 'RGRG57, RGRG56, RGRG55, RGRG54' are displayed in solid blue
    When I move to map 'HDGW01' via continuation link
    And the maximum amount of time is allowed for end to end transmission
    Then the tracks 'PNPN19, PNPN20, PNPN21, PNPN22, PNPN41, PNPN68, PNPN69, PNPN70' are displayed in solid blue
    When I open map 'HDGW02' via the recent map list
    And I switch to the new tab
    And the maximum amount of time is allowed for end to end transmission
    And I invoke the context menu on the map for train 1F30
    And I toggle path off from the map context menu
    Then 'no' toggle is displayed in the title bar
    And the tracks 'RGRG57, RGRG56' are displayed in solid white
    And the tracks 'RGRG55, RGRG54' are displayed in thin palegrey
    When I move to map 'HDGW01' via continuation link
    And the maximum amount of time is allowed for end to end transmission
    Then the tracks 'PNPN19, PNPN20, PNPN21, PNPN22, PNPN41, PNPN68, PNPN69, PNPN70' are displayed in thin palegrey
    And 'no' toggle is displayed in the title bar

  @tdd
  Scenario: 33998-9a Path Off Toggle (Nav Bar)
#    Given the user is viewing a live schematic map
#    And the user has applied a path on for a service
#    And the service has not reached its destination
#    When the user selects to turn the path off from the nav bar
#    Then the train's predicted path is displayed in white for the remainder of its journey
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1S42_PADTON_DIDCOTP.cif | TWYFORD     | WTT_pass      | 1F31                | L00011         |
    And I see todays schedule for 'L00011' has loaded by looking at the timetable page
    And I am on the home page
    And I expand the group of maps with name 'Wales & Western'
    And I navigate to the maps view with id hdgw02reading.v
    And I switch to the new tab
    When the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 1637    | D1             | 1F31             |
    And the following live signalling update message is sent from LINX (setting a route)
      | trainDescriber | address | data |
      | D1             | 2E      | 80   |
    And the train headcode color for berth 'D11630' is green
    And the tracks 'RGRG38' are displayed in solid white
    And the tracks 'RGRG39, RGRG40' are displayed in thin palegrey
    When I invoke the context menu on the map for train 1F31
    And I toggle path on from the map context menu
    Then 'PATH' toggle is displayed in the title bar
    And the tracks 'RGRG38, RGRG39, RGRG40' are displayed in solid blue
    When I move to map 'HDGW03' via continuation link
    And the maximum amount of time is allowed for end to end transmission
    Then 'PATH' toggle is displayed in the title bar
    And the tracks 'OXOXAX, OXOXAY, OXOXAZ, OXOXB1, OXOXB7, OXOXBA, OXOXBB, OXOXBC, OXOXBL' are displayed in solid blue
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

  @tdd
  Scenario: 33998-9b Path Off Toggle (remains available on Nav Bar after train leaves map)
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                                    | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/2P04_RDNGSTN_PADTON_STOPPER.cif | IVER        | WTT_dep       | 1F32                | L00012         |
    And I see todays schedule for 'L00012' has loaded by looking at the timetable page
    And I am on the home page
    And I expand the group of maps with name 'Wales & Western'
    And I navigate to the maps view with id hdgw02reading.v
    And I switch to the new tab
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 0478    | D6             | 1F32             |
    When I invoke the context menu on the map for train 1F32
    And I toggle path on from the map context menu
    Then 'PATH' toggle is displayed in the title bar
    And the tracks 'PNSH6U, PNSH4U' are displayed in thin palegrey
    And the tracks 'PNSH3U, PNSHTL' are displayed in solid blue
    When the following live berth step message is sent from LINX (moving train along)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0478      | 0472    | D4             | 1F32             |
    And the following live berth step message is sent from LINX (moving train off the map)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0472      | 0466    | D4             | 1F32             |
    And the following live signalling update message is sent from LINX (setting a route)
      | trainDescriber | address | data |
      | D4             | 23      | 08   |
    And the maximum amount of time is allowed for end to end transmission
    Then the train headcode '1F32' is 'not displayed' on the map
    And the tracks 'PNSH6U, PNSH4U, PNSH3U, PNSHTL' are displayed in thin palegrey
    And 'PATH' toggle is displayed in the title bar
    When I move to map 'HDGW01' via continuation link
    And the maximum amount of time is allowed for end to end transmission
    Then 'PATH' toggle is displayed in the title bar
    Then the train headcode '1F32' is 'displayed' on the map
    And the tracks 'PNSH6U, PNSH4U, PNSH3U, PNSHTL, PNSHTM, PNSHTN, PNSHTP, PNSH2R' are displayed in thin palegrey
    And the tracks 'PNSH1R, PNSH9Q, PNSH8Q' are displayed in solid blue
    When I move to map 'HDGW02' via continuation link
    Then 'PATH' toggle is displayed in the title bar
    When I toggle path off from the nav bar
    Then 'no' toggle is displayed in the title bar
    When I move to map 'HDGW01' via continuation link
    Then 'no' toggle is displayed in the title bar
    And the tracks 'PNSH1R, PNSH9Q, PNSH8Q' are displayed in solid white

  @tdd
  Scenario: 33998-9c Path Off Toggle (available on Nav Bar of unrelated map)
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                                    | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/2P04_RDNGSTN_PADTON_STOPPER.cif | STHALL      | WTT_pass      | 1F33                | L00013         |
    And I see todays schedule for 'L00013' has loaded by looking at the timetable page
    And I am on the home page
    And I expand the group of maps with name 'Wales & Western'
    And I navigate to the maps view with id hdgw02reading.v
    And I switch to the new tab
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 0248    | D4             | 1F33             |
    When I invoke the context menu on the map for train '1F33'
    And I toggle path on from the map context menu
    Then 'PATH' toggle is displayed in the title bar
    And I switch to the second-newest tab
    And I expand the group of maps with name 'North West and Central'
    And I navigate to the maps view with id md03watford.v
    And I switch to the new tab
    Then 'PATH' toggle is displayed in the title bar
    When I toggle path off from the nav bar
    Then 'no' toggle is displayed in the title bar
    When I switch to the second-newest tab
    Then 'no' toggle is displayed in the title bar

  @tdd
  Scenario: 33998-10a Map (Train Menu - matched train, no path on anywhere)
#    Given the user is authenticated to use TMV
#    And the user is viewing the map
#    And there are trains running
#    When the user performs a secondary click using their mouse
#    Then the train's menu is opened
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | GORASTR     | WTT_pass      | 1F34                | L00014         |
    And I see todays schedule for 'L00014' has loaded by looking at the timetable page
    And I am viewing the map gw03reading.v
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 0813    | D1             | 1F34             |
    And 'no' toggle is displayed in the title bar
    When I invoke the context menu on the map for train 1F34
    Then the map context menu contains 'Open Timetable' on line 1
    And the map context menu contains 'Unmatch' on line 2
    And the map context menu contains 'Turn Path On' on line 3
    When I toggle path on from the map context menu
    Then 'PATH' toggle is displayed in the title bar
    When I invoke the context menu on the map for train 1F34
    And I open timetable from the map context menu
    And I switch to the new tab
    Then the headcode in the header row is '1F34'
    When I switch to the second-newest tab
    And I invoke the context menu on the map for train 1F34
    And I click on Unmatch in the context menu
    And I switch to the new tab
    Then the tab title is 'TMV Schedule Matching'
    And the matched service is shown as '1F34'

  @tdd
  Scenario: 33998-10b Map (Train Menu - matched train with path on)
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1B69_PADTON_SWANSEA.cif | CHALLOW     | WTT_pass      | 1F35                | L00015         |
    And I see todays schedule for 'L00015' has loaded by looking at the timetable page
    And I am viewing the map gw04didcot.v
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 1007    | D5             | 1F35             |
    And I invoke the context menu on the map for train 1F35
    And I toggle path on from the map context menu
    And 'PATH' toggle is displayed in the title bar
    When I invoke the context menu on the map for train 1F35
    Then the map context menu contains 'Open Timetable' on line 1
    And the map context menu contains 'Unmatch' on line 2
    And the map context menu contains 'Turn Path Off' on line 3
    When I open timetable from the map context menu
    And I switch to the new tab
    Then the headcode in the header row is '1F35'
    When I switch to the second-newest tab
    And I invoke the context menu on the map for train 1F35
    And I click on Unmatch in the context menu
    And I switch to the new tab
    Then the tab title is 'TMV Schedule Matching'
    And the matched service is shown as '1F35'

  @tdd
  Scenario: 33998-10c Map (Train Menu - matched train with another path on)
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/2P77_RDNGSTN_PADTON.cif | MDNHEAD     | WTT_dep       | 1F36                | L00016         |
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/2P77_RDNGSTN_PADTON.cif | SLOUGH      | WTT_dep       | 1F37                | L00017         |
    And I see todays schedule for 'L00016' has loaded by looking at the timetable page
    And I see todays schedule for 'L00017' has loaded by looking at the timetable page
    And I am viewing the map hdgw02reading.v
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 0574    | D6             | 1F36             |
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 0516    | D6             | 1F37             |
    And I invoke the context menu on the map for train 1F36
    And the map context menu contains 'Turn Path On' on line 3
    And I toggle path on from the map context menu
    And 'PATH' toggle is displayed in the title bar
    When I invoke the context menu on the map for train 1F37
    Then the map context menu contains 'Open Timetable' on line 1
    And the map context menu contains 'Unmatch' on line 2
    And the map context menu contains 'Turn Path On' on line 3
    When I toggle path on from the map context menu
    Then 'PATH' toggle is displayed in the title bar
    When I invoke the context menu on the map for train 1F37
    Then the map context menu contains 'Turn Path Off' on line 3
    When I invoke the context menu on the map for train 1F36
    Then the map context menu contains 'Turn Path On' on line 3
    When I open timetable from the map context menu
    And I switch to the new tab
    Then the headcode in the header row is '1F36'
    When I switch to the second-newest tab
    And I invoke the context menu on the map for train 1F36
    And I click on Unmatch in the context menu
    And I switch to the new tab
    Then the tab title is 'TMV Schedule Matching'
    And the matched service is shown as '1F36'

  @tdd
  Scenario: 33998-10d Map (Train Menu - unmatched train, no path on anywhere)
    And I am viewing the map hdgw04bristolparkway.v
    And the following live berth interpose message is sent from LINX (which won't match anything)
      | toBerth | trainDescriber | trainDescription |
      | 1168    | D7             | 1F38             |
    And 'no' toggle is displayed in the title bar
    When I invoke the context menu on the map for train 1F38
    Then the map context menu contains 'No Timetable' on line 1
    And the map context menu contains 'Match' on line 2
    And the map context menu contains 'Turn Path On' on line 3
    When I toggle path on from the map context menu
    Then 'no' toggle is displayed in the title bar
    When I invoke the context menu on the map for train 1F38
    Then the map context menu contains 'Turn Path On' on line 3
    When I click on Match in the context menu
    And I switch to the new tab
    Then the tab title is 'TMV Schedule Matching'
    And the matched service is shown as ''

  @tdd
  Scenario: 33998-10e Map (Train Menu - unmatched train with another path on)
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | RDLEY       | WTT_dep       | 1F39                | L00019         |
    And I see todays schedule for 'L00019' has loaded by looking at the timetable page
    And I am viewing the map gw04didcot.v
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 2323    | D5             | 1F39             |
    And the following live berth interpose message is sent from LINX (which won't match anything)
      | toBerth | trainDescriber | trainDescription |
      | 2368    | D5             | 1F40             |
    And I invoke the context menu on the map for train 1F39
    And I toggle path on from the map context menu
    And 'PATH' toggle is displayed in the title bar
    When I invoke the context menu on the map for train 1F40
    Then the map context menu contains 'No Timetable' on line 1
    And the map context menu contains 'Match' on line 2
    And the map context menu contains 'Turn Path On' on line 3
    When I toggle path on from the map context menu
    Then 'PATH' toggle is displayed in the title bar
    When I invoke the context menu on the map for train 1F40
    Then the map context menu contains 'Turn Path On' on line 3
    When I click on Match in the context menu
    And I switch to the new tab
    Then the tab title is 'TMV Schedule Matching'
    And the matched service is shown as ''
