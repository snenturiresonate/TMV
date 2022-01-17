@TMVPhase2 @P2.S1
Feature: 78852 - UI Consistency - Timetable Display 30 seconds

  As a TMV User
  I want the menus and columns to be standardised
  So that I have a consistent UI experience

  Scenario Outline: 82704 - Timetable Display 30 seconds
#   Given the user is authenticated to use TMV
#   And the user is viewing a schematic map
#   And there are train present with timetable
#   When the user selects a train to view the timetable
#   Then the planned, public and predicted arrival and departure times will not display zero seconds
    * I remove today's train '<planningUid>' from the Redis trainlist
    * I generate a new train description
    * I generate a new trainUID
    Given the train in CIF file below is updated accordingly so time at the reference point is now + 2 minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainNum>          | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID      | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid> | <trainNum>  | now                    | 99999               | PADTON                 | today         | now                 |
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 0561    | D6             | <trainNum>       |
    And I am viewing the map HDGW01paddington.v
    And the following live berth step message is sent from LINX (moving the train along)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | A001      | 0037    | D3             | <trainNum>       |
    And the following live berth step message is sent from LINX (moving the train along)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0037      | 0026    | D3             | <trainNum>       |
    And the following live berth step message is sent from LINX (moving the train along)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0026      | 0057    | D3             | <trainNum>       |
    And the following live berth step message is sent from LINX (moving the train along)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0057      | 0081    | D3             | <trainNum>       |
    And the following live berth step message is sent from LINX (moving the train along)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0081      | 0105    | D3             | <trainNum>       |
    And the following live berth step message is sent from LINX (moving the train along)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0105      | 0125    | D3             | <trainNum>       |
    And the following train running info messages with time are sent from LINX
      | trainUID      | trainNumber | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType            | timestamp | hourDepartFromOrigin |
      | <planningUid> | <trainNum>  | today              | 73000               | PADTON                 | Departure from Origin  | now - 3   | now                  |
      | <planningUid> | <trainNum>  | today              | 73108               | ROYAOJN                | Departure from Station | now - 1   | now                  |
    Then berth '0125' in train describer 'D3' contains '<trainNum>' and is visible
    When I wait for the Open timetable option for train description <trainNum> in berth 0125, describer D3 to be available
    And I invoke the context menu on the map for train <trainNum>
    Then the Matched version of the map context menu is displayed
    When I open timetable from the map context menu
    And I switch to the new tab
    Then the planned times are either HH:MM or HH:MM:30 or Blank
    And the public times are either HH:MM or Blank
    And the actual times are either HH:MM or HH:MM c or HH:MM:30 c or N/R or Blank
    And the predicted times do not show zero seconds
    Examples:
      | trainNum  | planningUid |
      | generated | generated   |
