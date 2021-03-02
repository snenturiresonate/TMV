Feature: 33998 - TMV Train Service - full end to end testing

  As a Tester
  I want end to end tests to be created for the Train Service functionality
  So that there is confidence that it continues to work as expected as more of the system is developed

  @tdd
  Scenario: 33998-1 Punctuality (Matched Service)
  #Given the user is authenticated to use TMV
  #When the user is viewing the service on the map
  #And the service is matched
  #And the service is running or activated (called)
  #Then the train's punctuality is displayed for each part of the journey not yet complete
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | 1D46                | L00001         |
    And I see todays schedule for 'L00001' has loaded by looking at the timetable page
    And I am viewing the map hdgw01paddington.v
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth   | trainDescriber     | trainDescription   |
      | 10:02:06  | A007      | D3 		             | 1D46  		          |
    And the train headcode color for berth 'D31664' is green

  @tdd
  Scenario: 33998-2 Punctuality (Un-matched Service)
  #Given the user is authenticated to use TMV
  #When the user is viewing the service on the map
  #And the service is not matched
  #Then the train's punctuality is not calculated
  #And the headcode will be coloured in blue
    Given I am viewing the map hdgw01paddington.v
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth   | trainDescriber     | trainDescription   |
      | 10:02:06  | A001      | D3 		             | 5T78  		          |
    Then the headcode displayed for 'A001' is 5T78
    And I right click on berth with id 'D3A001'
    And the berth context menu is displayed with berth name 'D3A001'
    And the berth context menu contains the signal id 'SN1'
    And the train headcode color for berth 'D3A001' is blue


  @tdd
  Scenario: 33998-3 Left behind (Headcode)
    #Given the user is viewing a live schematic map
    #And there are services running
    #And the service is match
    #When the user views an individual service that has had its stepping interrupted
    #Then the train's headcode colour represents "left behind"
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | 1F23                | L00002         |
    And I see todays schedule for 'L00002' has loaded by looking at the timetable page
    And I am viewing the map hdgw01paddington.v
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth   | trainDescriber     | trainDescription   |
      | 10:02:06  | A007      | D3 		             | 1F23  		          |
    And I right click on berth with id 'A001'
    And the berth context menu is displayed with berth name 'D3A007'
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth   | trainDescriber     | trainDescription   |
      | 10:02:06  | A003      | D3 		             | 1F23		          |
    And the maximum amount of time is allowed for end to end transmission
    And the berth context menu is displayed with berth name 'D3A003'
    Then the headcode displayed for 'D3A007' is 1F23
    And the train headcode color for berth 'D3A007' is darkgrey

  @tdd
  Scenario: 33998-4 Last Berth (Head Code)
  #Given the user is viewing a live schematic map
  #And there are services running
  #When the user views a last berth
  #Then the train's headcode colour represents "last berth"
    Given I am viewing the map hdgw01paddington.v
    When the following berth interpose message is sent from LINX
    | timestamp | toBerth   | trainDescriber     | trainDescription   |
    | 10:02:06  | A001      | D3 		             | 1D34 		          |
    And I right click on berth with id 'D3A001'
    And the berth context menu is displayed with berth name '1D34'
    Then the headcode displayed for 'D3A001' is R001
    And the train headcode color for berth 'D3A001' is stone

  @tdd
  Scenario: 33998-5 Off Planned Path
    #Given the user is viewing a live schematic map
    #And there are services running
    #When the user views an individual service is off planned path
    #Then the train's headcode colour represents "off plan"
    #And the train's path that is off plan is a different colour to the on plan portion
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | 1F24                | L00003         |
    And I see todays schedule for 'L00003' has loaded by looking at the timetable page
    And I am viewing the map hdgw01paddington.v
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth   | trainDescriber     | trainDescription   |
      | 10:02:06  | A019      | D3 		             | 1F24		          |
    Then the headcode displayed for 'D3A019' is 1F24
    And the train headcode color for berth 'D3A019' is darkblue
