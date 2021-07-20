Feature: 37659 - Basic Schedule matching framework
  As a TMV user
  I want C-class data on running services to be matched to the planned train schedule from the CIF
  So that I can system can build and update a train models to allow schematic maps to display trains and their timetables

  Background:
    * I have cleared out all headcodes
    * The admin setting defaults are as originally shipped

  Scenario: 37659 -1  Display when no matching schedule (berth, location or subdivision)
    # Given a TD update with the type <Step Type> has been received
    # And the berth included doesn't match a schedule at berth, location or sub division
    # When the user views the map containing that berth
    # Then train description is displayed in the berth in a coloured box (no timetable from admin for unmatched)
    # Examples:
    #  | Step Type |
    #  | Interpose |
    #  | Step |
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | 0A01                | M00001         |
    And I am on the trains list page
    And the following service is displayed on the trains list
      | trainId | trainUId |
      | 0A01    | M00001   |
    And the following live berth interpose message is sent from LINX (which won't match anything as the train description is not in the timetable)
      | toBerth | trainDescriber | trainDescription |
      | A001    | D3             | 0B01             |
    When I am viewing the map hdgw01paddington.v
    Then berth 'A001' in train describer 'D3' contains '0B01' and is visible
    And the rectangle colour for berth D3A001 is lightgrey meaning unmatched

  Scenario: 37659 -2 Context menu when no matching schedule (berth, location or subdivision)
    # Given a TD update with the type <Step Type> has been received
    # And the berth included doesn't match a schedule at berth, location or sub division
    # And the user is viewing the map that contains that berth
    # When the user opens the context menu for the train description
    # Then the unmatched version of the context menu is displayed
    # Examples:
    #  | Step Type |
    #  | Interpose |
    #  | Step |
    Given the following live berth step message is sent from LINX (to move train)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | A001      | 6003    | D3             | 0B01             |
    And I am viewing the map hdgw01paddington.v
    Then berth '6003' in train describer 'D3' contains '0B01' and is visible
    When I invoke the context menu on the map for train 0B01
    Then the map context menu does not contain 'Open timetable' on line 2

  Scenario Outline: 37659 -3a Display when single matching schedule / 37659 - 4a Context menu when single matching schedule - Step Type - Interpose
    # Given a TD update with the type <Step Type> has been received
    # And the berth included  matches a single schedule at <match level>
    # When the user views the map containing that berth
    # Then train description is displayed in the berth and colour reflects punctuality (not no timetable colour)

    # Given a TD update with the type <Step Type> has been received
    # And the berth included  matches a single schedule at <match level>
    # And the user is viewing the map that contains that berth
    # When the user opens the context menu for the train description
    # Then the matched version of the context menu is displayed
    # Examples:
      # | Step Type |
      # | Interpose |
      # | Step |

      # | Match level |
      # | berth |
      # | location |
      # | sub division |
    Given the access plan located in CIF file 'access-plan/33805-schedules/schedule-matching.cif' is received from LINX
    And I am viewing the map HDGW01paddington.v
    And I have cleared out all headcodes
    And I am on the trains list page
    And train '<origTrainDesc>' with schedule id '<trainUid>' for today is visible on the trains list
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber   | trainDescription |
      | <berth> | <trainDescriber> | <origTrainDesc>  |
    And I am viewing the map HDGW01paddington.v
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<origTrainDesc>' and is visible
    When I wait for the Open timetable option for train description <origTrainDesc> in berth <berth>, describer <trainDescriber> to be available
    And I invoke the context menu on the map for train <origTrainDesc>
    Then the Matched version of the map context menu is displayed
    And the rectangle colour for berth <trainDescriber><berth> is not lightgrey meaning 'no timetable'

    Examples:
      | trainDescriber | berth | origTrainDesc | trainUid | location | subdivision | matchLevel   |
      | D3             | A001  | 1B11          | B11111   | PADTON   | 401         | berth        |
      | D3             | A011  | 1B11          | B11111   | PADTON   | 401         | location     |
      | D3             | 0106  | 1B11          | B11111   | PRTOBJP  | 401         | sub-division |

  Scenario Outline: 37659 -3b Display when single matching schedule  / 37659 - 4b Context menu when single matching schedule - Step Type - Step
    # Given a TD update with the type <Step Type> has been received
    # And the berth included  matches a single schedule at <match level>
    # When the user views the map containing that berth
    # Then train description is displayed in the berth and colour reflects punctuality (not no timetable colour)

    # Given a TD update with the type <Step Type> has been received
    # And the berth included  matches a single schedule at <match level>
    # And the user is viewing the map that contains that berth
    # When the user opens the context menu for the train description
    # Then the matched version of the context menu is displayed
    # Examples:
      # | Step Type |
      # | Interpose |
      # | Step |

      # | Match level |
      # | berth |
      # | location |
    Given the access plan located in CIF file 'access-plan/33805-schedules/schedule-matching.cif' is received from LINX
    And I am on the trains list page
    And train description '<origTrainDesc>' is visible on the trains list with schedule type 'STP'
    And the following live berth step message is sent from LINX (creating a match)
      | fromBerth | toBerth       | trainDescriber   | trainDescription |
      | <berth>   | <secondBerth> | <trainDescriber> | <origTrainDesc>  |
    And I am viewing the map HDGW01paddington.v
    Then berth '<secondBerth>' in train describer '<trainDescriber>' contains '<origTrainDesc>' and is visible
    When I wait for the Open timetable option for train description <origTrainDesc> in berth <secondBerth>, describer <trainDescriber> to be available
    And I invoke the context menu on the map for train <origTrainDesc>
    Then the Matched version of the map context menu is displayed
    And the rectangle colour for berth <trainDescriber><secondBerth> is not lightgrey meaning 'no timetable'

    Examples:
      | trainDescriber | berth | secondBerth | origTrainDesc | trainUid | location | subdivision | matchLevel   |
      | D3             | A001  | 6003        | 1B11          | B11111   | PADTON   | 401         | berth        |
      | D3             | A011  | 0041        | 1B11          | B11111   | PADTON   | 401         | location     |
      | D3             | 0107  | 0125        | 1B11          | B11111   | PRTOBJP  | 401         | sub-division |

  Scenario Outline: 37659 -5 Display when consistent stepping /  37659 -5  Context menu when consistent stepping

    # Given a TD update with the type <Step Type> has been received
    # And a prior TD update has been matched to the service in the last 20 mins (configurable value)
    # When the user views the map containing the berth in the latest message
    # Then train description is displayed in the berth and colour reflects punctuality (not no timetable colour)

    # Given a TD update with the type <Step Type> has been received
    # And a prior TD update has been matched to the service in the last 20 mins
    # And the user is viewing the map that contains that berth
    # When the user opens the context menu for the train description
    # Then the matched version of the context menu is displayed

    # Examples:
     # | Step Type |
     # | Step |
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <origTrainDesc>     | <trainUid>     |
    And I am viewing the map HDGW01paddington.v
    And I have cleared out all headcodes
    And I am on the trains list page
    And train description '<origTrainDesc>' is visible on the trains list with schedule type 'STP'
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber   | trainDescription |
      | <berth> | <trainDescriber> | <origTrainDesc>  |
    And I am viewing the map HDGW01paddington.v
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<origTrainDesc>' and is visible
    When I wait for the Open timetable option for train description <origTrainDesc> in berth <berth>, describer <trainDescriber> to be available
    And the following live berth step message is sent from LINX
      | fromBerth | toBerth       | trainDescriber   | trainDescription |
      | <berth>   | <secondBerth> | <trainDescriber> | <origTrainDesc>  |
    Then berth '<secondBerth>' in train describer '<trainDescriber>' contains '<origTrainDesc>' and is visible
    And I invoke the context menu on the map for train <origTrainDesc>
    Then the Matched version of the map context menu is displayed
    And the rectangle colour for berth <trainDescriber><secondBerth> is not lightgrey meaning 'no timetable'

    Examples:
      | trainDescriber | berth | secondBerth | origTrainDesc | trainUid | location |
      | D3             | A007  | 0037        | 1B11          | B11111   | PADTON   |
