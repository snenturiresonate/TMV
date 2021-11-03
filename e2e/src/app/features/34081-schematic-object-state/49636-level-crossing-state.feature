Feature: 49636 - Schematic State - Level Crossing, Direction Lock and AES
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
    * this replay setup test has been moved to become part of the replay test: 34393 - 27 Level Crossing State (Up)

  @replaySetup
  Scenario: 34081 - 22 Level Crossing State (Down)
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with an S-Class berth of type Level Crossing
    #And the S-Class message is setting the Level Crossing to "Down"
    #When a user is viewing a map that contains the Level Crossing
    #Then the Level Crossing will display a "Dn" on the left side and a "Wk" for the working on the right side
    * this replay setup test has been moved to become part of the replay test: 34393 - 28 Level Crossing State (Down)

  @replaySetup
  Scenario Outline: 34081 - 23 Level Crossing State - <significance>
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with an S-Class berth of type Level Crossing
    #And the S-Class message is setting the Level Crossing to "Failed"
    #When a user is viewing a map that contains the Level Crossing
    #Then the Level Crossing will display an "F" righthand side
    Given I am viewing the map md19marstonvale.v
    And I set up all signals for address 24 in RT to be proceed
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data   | timestamp |
      | RT             | 24      | <hex>  | 10:45:00  |
    Then the level crossing barrier status of '<barrierID>' is <barrierState>

    Examples:
    | hex | barrierID | barrierState | significance                 |
    | 8   | RTLLUD    | Dn           | Barrier Down                 |
    | 80  | RTLLFL    | Fal          | Barrier non-working          |
    | 88  | RTLLFL    | Fal          | Barrier Down and non-working |

  @replaySetup
  Scenario: 34081 - 24a Direction Lock State (Locked)
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with an S-Class berth of type Direction Lock
    #And the S-Class message is setting the Direction Lock to not locked
    #When a user is viewing a map that contains the Direction Lock
    #Then the Direction Lock will display a chevron in the direction of the lock
    * this replay setup test has been moved to become part of the replay test: 34393 - 30a Direction Lock State (Locked)

  @replaySetup
  Scenario: 34081 - 24b Direction Lock State (Locked) both directions
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with an S-Class berth of type Direction Lock
    #And the S-Class message is setting the Direction Lock to not locked
    #When a user is viewing a map that contains the Direction Lock
    #Then the Direction Lock will display a chevron in the direction of the lock
    * this replay setup test has been moved to become part of the replay test: 34393 - 30b Direction Lock State (Locked) both directions

  @replaySetup
  Scenario: 34081 - 25 Direction Lock State (Not Locked)
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with an S-Class berth of type Direction Lock
    #And the S-Class message is setting the Direction Lock to not locked
    #When a user is viewing a map that contains the Direction Lock
    #Then the Direction Lock will not display a chevron
    * this replay setup test has been moved to become part of the replay test: 34393 - 31 Direction Lock State (Not Locked)

  @replaySetup
  Scenario: 34081 - 26 AES State (AES Applied)
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with an S-Class berth of type AES
    #And the S-Class message is setting the AES to applied
    #When a user is viewing a map that contains an AES indicator
    #Then the AES box will display an AES text (purple) in the box
    * this replay setup test has been moved to become part of the replay test: 34393 - 32 AES State (AES Applied)

  @replaySetup
  Scenario: 34081 - 27 AES State (AES Not Applied)
      #Given an S-Class message is received and processed
      #And the S-Class message is associated with an S-Class berth of type AES
      #And the S-Class message is setting the AES to not applied
      #When a user is viewing a map that contains an AES indicator
      #Then the AES box will not display an AES text (purple) in the box
    * this replay setup test has been moved to become part of the replay test: 34393 - 33 AES State (AES Not Applied)
