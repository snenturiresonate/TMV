Feature: 49635 - Schematic State - shunters release state
  (From Gherkin for Feature 34081)
  As a TMV User
  I want to schematic objects displayed with the latest state
  So that I have a live view of the railway

  Background:
    Given I am viewing the map gw5abristolparkway.v

  Scenario: 34081-15 - Active Shunters Release State (Given)
#    Given an S-Class message is received and processed
#    And the S-Class message is an update to Latch
#    And the Latch is associated with a Shunters release
#    And the Shunters release is given
#    When a user is viewing a map that contains the Shunters Release
#    Then the Shunters Release will display a given state (white cross in the white box)
    And I set up all signals for address 53 in D0 to be not-proceed
    And the cross indication for shunters-release 'BL7023' is not visible
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D0             | 53      | 02   | 10:45:00  |
    Then the shunters-release 'BL7023' will display a given state [a white cross in the white box]

  Scenario: 34081-16 - Active Shunters Release State (Not Given)
#    Given an S-Class message is received and processed
#    And the S-Class message is an update to Latch
#    And the Latch is associated with a Shunters release
#    And the Shunters release is not given
#    When a user is viewing a map that contains the Shunters Release
#    Then the Shunters Release will display a not given state (removal of the white cross in the white box)
    And I set up all signals for address 53 in D0 to be proceed
    And the cross indication for shunters-release 'BL7023' is visible
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D0             | 53      | 02   | 10:45:00  |
    Then the shunters-release 'BL7023' will display a not-given state [no white cross in the white box]
