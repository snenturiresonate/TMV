Feature: 46450 - TMV Train Service - full end to end testing

  As a Tester
  I want end to end tests to be created for the Train Service functionality
  So that there is confidence that it continues to work as expected as more of the system is developed

  @tdd
  Scenario: 1 Punctuality (Matched Service)
  #Given the user is authenticated to use TMV
  #When the user is viewing the service on the map
  #And the service is matched
  #And the service is running or activated (called)
  #Then the train's punctuality is displayed for each part of the journey not yet complete
    Given the access plan located in CIF file 'access-plan/1D46_PADTON_OXFD.cif' is amended so that all services start within the next hour and then received from LINX
    And I am viewing the map hdgw01paddington.v
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth   | trainDescriber     | trainDescription   |
      | 10:02:06  | 1664      | D1 		             | 1D46  		          |
    And the train headcode color for berth '1664' is green

  @tdd
  Scenario: 2 Punctuality (Un-matched Service)
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
    And I right click on berth with id 'A001'
    And the berth context menu is displayed with berth name 'D3A001'
    And the berth context menu contains the signal id 'SN1'
    And the train headcode color for berth 'A001' is blue


  @tdd
  Scenario: 3 Left behind (Headcode)
    #Given the user is viewing a live schematic map
    #And there are services running
    #And the service is match
    #When the user views an individual service that has had its stepping interrupted
    #Then the train's headcode colour represents "left behind"
    Given I am viewing the map hdgw01paddington.v
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth   | trainDescriber     | trainDescription   |
      | 10:02:06  | A001      | D3 		             | 1F23  		          |
    And I right click on berth with id 'A001'
    And the berth context menu is displayed with berth name 'D3A001'
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth   | trainDescriber     | trainDescription   |
      | 10:02:06  | A003      | D3 		             | 1F23		          |
    And the berth context menu is displayed with berth name 'D3A003'
    Then the headcode displayed for 'A003' is 1F23
    And the train headcode color for berth 'A003' is darkgrey

  @tdd
  Scenario: 4 Last Berth (Head Code)
  #Given the user is viewing a live schematic map
  #And there are services running
  #When the user views a last berth
  #Then the train's headcode colour represents "last berth"
    Given I am viewing the map hdgw01paddington.v
    When the following berth interpose message is sent from LINX
    | timestamp | toBerth   | trainDescriber     | trainDescription   |
    | 10:02:06  | A001      | D3 		             | 1D34 		          |
    And I right click on berth with id 'A001'
    And the berth context menu is displayed with berth name '1D34'
    Then the headcode displayed for 'A001' is R001
    And the train headcode color for berth 'A001' is stone

  @tdd
  Scenario: 5 Off Planned Path
    #Given the user is viewing a live schematic map
    #And there are services running
    #When the user views an individual service is off planned path
    #Then the train's headcode colour represents "off plan"
    #And the train's path that is off plan is a different colour to the on plan portion
    Given the access plan located in CIF file 'access-plan/1D46_PADTON_OXFD.cif' is amended so that all services start within the next hour and then received from LINX
    And I am viewing the map hdgw01paddington.v
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth   | trainDescriber     | trainDescription   |
      | 10:02:06  | A019      | D3 		             | 1D46		          |
    Then the headcode displayed for 'A019' is 1D46
    And the train headcode color for berth 'A019' is darkblue
