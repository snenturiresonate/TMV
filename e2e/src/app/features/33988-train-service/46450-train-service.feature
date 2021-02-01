Feature: 46450 - TMV Train Service - full end to end testing

  As a Tester
  I want end to end tests to be created for the Train Service functionality
  So that there is confidence that it continues to work as expected as more of the system is developed

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
      | 10:02:06  | A001      | D3 		             | D3A003		          |
    And I right click on berth with id 'A003'
    And the berth context menu is displayed with berth name 'D3A003'
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth   | trainDescriber     | trainDescription   |
      | 10:02:06  | A001      | D3 		             | D3A005		          |
    And the berth context menu is displayed with berth name 'D3A003'
    Then the train headcode color for berth 'A003' is darkgrey

  @tdd
  Scenario: 4 Last Berth (Head Code)
  #Given the user is viewing a live schematic map
  #And there are services running
  #When the user views a last berth
  #Then the train's headcode colour represents "last berth"
    Given I am viewing the map hdgw01paddington.v
    When the following berth interpose message is sent from LINX
    | timestamp | toBerth   | trainDescriber     | trainDescription   |
    | 10:02:06  | A001      | D3 		             | D3R001		          |
    And I right click on berth with id 'R001'
    And the berth context menu is displayed with berth name 'D3R001'
    Then the train headcode color for berth 'R001' is stone

