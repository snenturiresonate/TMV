Feature: 49634 - Schematic State - Level Crossing, Direction Lock and AES
  (From Gherkin for Feature 34081)
  As a TMV User
  I want to schematic objects displayed with the latest state
  So that I have a live view of the railway

  @replaySetup
  Scenario: 34081 - 21 Level Crossing State (Up)
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with an S-Class berth of type Level Crossing
    #And the S-Class message is setting the Level Crossing to "Proved up"
    #When a user is viewing a map that contains the Level Crossing
    #Then the Level Crossing will display an "Up" lefthand side
    Given I am viewing the map gw08cardiffswml.v
    And I set up all signals for address 7D in C2 to be not-proceed
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | C2             | 7D      | 30   | 10:45:00  |
    Then the level crossing barrier status of 'C2LXPN' is Up
    And the level crossing barrier status of 'C2PNWK' is Wk


  @replaySetup
  Scenario: 34081 - 22 Level Crossing State (Down)
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with an S-Class berth of type Level Crossing
    #And the S-Class message is setting the Level Crossing to "Down"
    #When a user is viewing a map that contains the Level Crossing
    #Then the Level Crossing will display a "Dn" on the left side and a "Wk" for the working on the right side
    Given I am viewing the map md19marstonvale.v
    And I set up all signals for address 1E in RT to be not-proceed
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | RT             | 1E      | 02   | 10:45:00  |
    Then the level crossing barrier status of 'RTFSUD' is Dn

  @replaySetup
  Scenario: 34081 - 23 Level Crossing State - verification of non-working state display
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with an S-Class berth of type Level Crossing
    #And the S-Class message is setting the Level Crossing to "Failed"
    #When a user is viewing a map that contains the Level Crossing
    #Then the Level Crossing will display an "F" righthand side
    Given I am viewing the map md19marstonvale.v
    And I set up all signals for address 26 in RT to be not-proceed
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | RT             | 24      | 88   | 10:45:00  |
    Then the level crossing barrier status of 'RTLLUD' is Dn
    Then the level crossing barrier status of 'RTLLFL' is Fal

  @replaySetup
  Scenario: 34081 - 24a Direction Lock State (Locked)
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with an S-Class berth of type Direction Lock
    #And the S-Class message is setting the Direction Lock to not locked
    #When a user is viewing a map that contains the Direction Lock
    #Then the Direction Lock will display a chevron in the direction of the lock
    Given I am viewing the map gw15cambrian.v
    And I set up all signals for address 36 in MH to be not-proceed
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | MH             | 36      | 02   | 10:45:00  |
    Then the direction lock chevron of 'MHSBWP' is <

  @replaySetup
  Scenario: 34081 - 24b Direction Lock State (Locked) both directions
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with an S-Class berth of type Direction Lock
    #And the S-Class message is setting the Direction Lock to not locked
    #When a user is viewing a map that contains the Direction Lock
    #Then the Direction Lock will display a chevron in the direction of the lock
    Given I am viewing the map gw15cambrian.v
    And I set up all signals for address 37 in MH to be not-proceed
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | MH             | 37      | 03   | 10:45:00  |
    Then the direction lock chevron of 'MHDJMH' is >
    And the direction lock chevron of 'MHMHDJ' is <

  @replaySetup   @bug @bug_54269
  Scenario: 34081 - 25 Direction Lock State (Not Locked)
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with an S-Class berth of type Direction Lock
    #And the S-Class message is setting the Direction Lock to not locked
    #When a user is viewing a map that contains the Direction Lock
    #Then the Direction Lock will not display a chevron
    Given I am viewing the map gw15cambrian.v
    And I set up all signals for address 37 in MH to be not-proceed
    And I set up all signals for address 38 in MH to be not-proceed
    And I set up all signals for address 36 in MH to be proceed
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | MH             | 36      | 00   | 10:45:00  |
    Then the direction lock chevrons are not displayed

  Scenario: 34081 - 26 AES State (AES Applied)
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with an S-Class berth of type AES
    #And the S-Class message is setting the AES to applied
    #When a user is viewing a map that contains an AES indicator
    #Then the AES box will display an AES text (purple) in the box
    Given I am viewing the map gw15cambrian.v
    And I set up all signals for address 36 in MH to be not-proceed
    Then I should see the AES boundary elements

  Scenario: 34081 - 27 AES State (AES Not Applied)
      #Given an S-Class message is received and processed
      #And the S-Class message is associated with an S-Class berth of type AES
      #And the S-Class message is setting the AES to not applied
      #When a user is viewing a map that contains an AES indicator
      #Then the AES box will not display an AES text (purple) in the box
    Given I am viewing the map gw08cardiffswml.v
    And I set up all signals for address 36 in MH to be not-proceed
    Then I should not see the AES boundary elements
