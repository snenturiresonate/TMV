Feature: 34393 - Replay page Schematic Object State Scenarios - Level Crossing, Direction Lock and AES
  (From Gherkin for Feature 40680 and functionality developed in US34081)
  As a TMV User
  I want the view schematic maps in replay mode
  So that I can view the historic running railway

  @bug @bug:78878
  @replayTest
  Scenario: 34393 - 27 Level Crossing State (Up)
    # Replay Setup - 34081 - 21 Level Crossing State (Up)
    * I am viewing the map GW08cardiffswml.v
    * I set up all signals for address 7D in C2 to be not-proceed
    * the following live signalling update message is sent from LINX
      | trainDescriber | address | data |
      | C2             | 7D      | 30   |
    * the level crossing barrier status of 'C2LXPN' is Up
    * the level crossing barrier status of 'C2PNWK' is Wk

    # Given an S-Class message is received and processed
    # And the S-Class message is associated with an S-Class berth of type Level Crossing
    # And the S-Class message is setting the Level Crossing to "Proved up"
    # When a user is viewing a map that contains the Level Crossing
    # Then the Level Crossing will display an "Up" lefthand side
    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'GW08cardiffswml.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 5
    When I click Play button
    Then the level crossing barrier status of 'C2LXPN' is Up
    And the level crossing barrier status of 'C2PNWK' is Wk

  @bug @bug:78878
  @replayTest
  Scenario: 34393 - 28 Level Crossing State (Down)
    # Replay Setup - 34081 - 22 Level Crossing State (Down)
    * I am viewing the map MD19marstonvale.v
    * I set up all signals for address 1E in RT to be not-proceed
    * the following live signalling update message is sent from LINX
      | trainDescriber | address | data |
      | RT             | 1E      | 02   |
    * the level crossing barrier status of 'RTFSUD' is Dn

    # Given an S-Class message is received and processed
    # And the S-Class message is associated with an S-Class berth of type Level Crossing
    # And the S-Class message is setting the Level Crossing to "Down"
    # When a user is viewing a map that contains the Level Crossing
    # Then the Level Crossing will display a "Dn" on the left side and a "Wk" for the working on the right side
    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'North West and Central'
    And I select the map 'MD19marstonvale.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 5
    When I click Play button
    Then the level crossing barrier status of 'RTFSUD' is Dn

  @bug @bug:78878
  @replayTest
  Scenario: 34393 - 29 Level Crossing State (Failed)
    # Replay Setup - 34081 - 23 Level Crossing State - verification of non-working state display
    * I am viewing the map MD19marstonvale.v
    * I set up all signals for address 24 in RT to be proceed
    * the following live signalling update message is sent from LINX
      | trainDescriber | address | data   |
      | RT             | 24      | 80     |
    * the level crossing barrier status of 'RTLLFL' is Fal

    # Given an S-Class message is received and processed
    # And the S-Class message is associated with an S-Class berth of type Level Crossing
    # And the S-Class message is setting the Level Crossing to "Failed"
    # When a user is viewing a map that contains the Level Crossing
    # Then the Level Crossing will display an "F" righthand side
    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'North West and Central'
    And I select the map 'MD19marstonvale.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 5
    When I click Play button
    Then the level crossing barrier status of 'RTLLUD' is Dn
    Then the level crossing barrier status of 'RTLLFL' is Fal

  @bug @bug:78878
  @replayTest
  Scenario: 34393 - 30a Direction Lock State (Locked)
    # Replay Setup - 34081 - 24a Direction Lock State (Locked)
    * I am viewing the map GW15cambrian.v
    * I set up all signals for address 36 in MH to be not-proceed
    * the following live signalling update message is sent from LINX
      | trainDescriber | address | data |
      | MH             | 36      | 02   |
    * the direction lock chevron of 'MHSBWP' is <

    # Given an S-Class message is received and processed
    # And the S-Class message is associated with an S-Class berth of type Direction Lock
    # And the S-Class message is setting the Direction Lock to not locked
    # When a user is viewing a map that contains the Direction Lock
    # Then the Direction Lock will display a chevron in the direction of the lock
    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'GW15cambrian.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 5
    When I click Play button
    Then the direction lock chevron of 'MHSBWP' is <

  @bug @bug:78878
  @replayTest
  Scenario: 34393 - 30b Direction Lock State (Locked) both directions
    # Replay Setup - 34081 - 24b Direction Lock State (Locked) both directions
    * I am viewing the map gw15cambrian.v
    * I set up all signals for address 37 in MH to be not-proceed
    * the following live signalling update message is sent from LINX
      | trainDescriber | address | data |
      | MH             | 37      | 03   |
    * the direction lock chevron of 'MHDJMH' is >
    * the direction lock chevron of 'MHMHDJ' is <

    # Replay Test
    Given I load the replay data from scenario '34081 - 24b Direction Lock State (Locked) both directions'
    And I am on the replay page
    When I have set replay time and date from the recorded session
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'gw15cambrian.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 5
    When I click Play button
    Then the direction lock chevron of 'MHDJMH' is >
    And the direction lock chevron of 'MHMHDJ' is <

  @replayTest
  Scenario: 34393 - 31 Direction Lock State (Not Locked)
    # Replay Setup - 34081 - 25 Direction Lock State (Not Locked)
    * I am viewing the map gw15cambrian.v
    * I set up all signals for address 37 in MH to be not-proceed
    * I set up all signals for address 38 in MH to be not-proceed
    * I set up all signals for address 36 in MH to be proceed
    * the following live signalling update message is sent from LINX
      | trainDescriber | address | data |
      | MH             | 36      | 00   |
    * the direction lock chevrons are not displayed

    # Given an S-Class message is received and processed
    # And the S-Class message is associated with an S-Class berth of type Direction Lock
    # And the S-Class message is setting the Direction Lock to not locked
    # When a user is viewing a map that contains the Direction Lock
    # Then the Direction Lock will not display a chevron
    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'GW15cambrian.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 5
    When I click Play button
    Then the direction lock chevrons are not displayed

  @bug @bug:78878
  @replayTest
  Scenario:34393 - 32 AES State (AES Applied)
    # Replay Setup - 34081 - 26 AES State (AES Applied)
    * I am viewing the map GW15cambrian.v
    * I set up all signals for address 35 in MH to be not-proceed
    * the following live signalling update message is sent from LINX
      | trainDescriber | address | data |
      | MH             | 35      | 02   |
    * the AES box containing s-class-berth 'MHAES2' will display purple aes text of 'ES2'

    #Given an S-Class message is received and processed
    #And the S-Class message is associated with an S-Class berth of type AES
    #And the S-Class message is setting the AES to applied
    #When a user is viewing a map that contains an AES indicator
    #Then the AES box will display an AES text (purple) in the box
    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'GW15cambrian.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 5
    When I click Play button
    Then the AES box containing s-class-berth 'MHAES2' will display purple aes text of 'ES2'

  @bug @bug:78878
  @replayTest
  Scenario:34393 - 33 AES State (AES Not Applied)
    # Replay Setup - 34081 - 27 AES State (AES Not Applied)
    * I am viewing the map GW15cambrian.v
    * I set up all signals for address 35 in MH to be proceed
    * the following live signalling update message is sent from LINX
      | trainDescriber | address | data |
      | MH             | 35      | 0D   |
    * the AES box containing s-class-berth 'MHAES1' will display purple aes text of 'ES1'
    * the AES box containing s-class-berth 'MHAES3' will display purple aes text of 'ES3'
    * the AES box containing s-class-berth 'MHAES4' will display purple aes text of 'ES4'
    * the AES box containing s-class-berth 'MHAES2' will display no aes text of 'ES2'

    # Given an S-Class message is received and processed
    # And the S-Class message is associated with an S-Class berth of type AES
    # And the S-Class message is setting the AES to not applied
    # When a user is viewing a map that contains an AES indicator
    # Then the AES box will not display an AES text (purple) in the box
    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'GW15cambrian.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 5
    When I click Play button
    Then the AES box containing s-class-berth 'MHAES1' will display purple aes text of 'ES1'
    And the AES box containing s-class-berth 'MHAES3' will display purple aes text of 'ES3'
    And the AES box containing s-class-berth 'MHAES4' will display purple aes text of 'ES4'
    And the AES box containing s-class-berth 'MHAES2' will display no aes text of 'ES2'
