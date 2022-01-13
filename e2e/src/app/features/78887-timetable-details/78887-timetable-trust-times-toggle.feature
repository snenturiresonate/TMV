@TMVPhase2 @P2.S1
Feature: 78887 - Timetable Details - Timetable TRUST Times Toggle

  As a TMV user
  I want the Live timetable view to have an option to turn the TRUST times off
  So that I can chose to display the internally calculated times only

  Background:
    * I reset redis
    * I am on the home page
    * I generate a new trainUID
    * I generate a new train description

  Scenario Outline: 79139 - Timetable TRUST Times (Live) - Initial Display
    # Given the user is authenticated to use TMV
    # And the user is viewing the Timetable Details in Live
    # When the user views the Timetable Details
    # Then they can see a toggle is displayed in the right hand corner to display 'TRUST Times' with the options 'on/off'
    # And the default selection is set to 'on'
    # And in the ACTUAL/PREDICTED column on the Timetable, the TRUST times are displayed where available
    # And internally calculated times are displayed where a TRUST time is not available
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                                    | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/2P04_RDNGSTN_PADTON_STOPPER.cif | EALINGB     | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And the following live berth step messages is sent from LINX
      | fromBerth | toBerth | trainDescriber | trainDescription   |
      | 0210      | 0206    | D3             | <trainDescription> |
    And I give the berth step 2 seconds to process
    And the following live berth step messages is sent from LINX
      | fromBerth | toBerth | trainDescriber | trainDescription   |
      | 0206      | 0202    | D3             | <trainDescription> |
    And the following train running information message is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType        |
      | <trainUid> | <trainDescription> | today              | 73253               | EALINGB                | Arrival at station |
    And I am on the timetable view for service '<trainUid>'
    Then the TRUST times toggle exists and is on
    And the TRUST times toggle in the on state has the correct text 'on'
    And the TRUST Arrival time for location "Ealing Broadway" instance 1 is shown
    And the calculated Departure time for location "Ealing Broadway" instance 1 is shown
    When I toggle the TRUST times off
    And I give the schedule times 1 second to toggle
    And the TRUST times toggle in the off state has the correct text 'off'

    Examples:
      | trainUid  | trainDescription |
      | generated | generated        |

  Scenario Outline: 79140-1 Display calculated times when TRUST times are toggled off
    #    Given the user is authenticated to use TMV
    #    And the user is viewing the Timetable Details in Live
    #    When the user toggles the 'TRUST Times' selection to 'off'
    #    Then in the ACTUAL/PREDICTED column on the Timetable, the internally calculated times are displayed only.
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                                    | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/2P04_RDNGSTN_PADTON_STOPPER.cif | EALINGB     | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And the following live berth step messages is sent from LINX
      | fromBerth | toBerth | trainDescriber | trainDescription   |
      | 0210      | 0206    | D3             | <trainDescription> |
    And I give the berth step 2 seconds to process
    And the following live berth step messages is sent from LINX
      | fromBerth | toBerth | trainDescriber | trainDescription   |
      | 0206      | 0202    | D3             | <trainDescription> |
    And the following train running information message is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType        |
      | <trainUid> | <trainDescription> | today              | 73253               | EALINGB                | Arrival at station |
    And the following train running information message is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType            |
      | <trainUid> | <trainDescription> | today              | 73253               | EALINGB                | Departure from station |
    And I am on the timetable view for service '<trainUid>'
    Then the TRUST Arrival time for location "Ealing Broadway" instance 1 is shown
    And the TRUST Departure time for location "Ealing Broadway" instance 1 is shown
    When I toggle the TRUST times off
    And I give the schedule times 1 second to toggle
    Then the calculated Arrival time for location "Ealing Broadway" instance 1 is shown
    And the calculated Departure time for location "Ealing Broadway" instance 1 is shown

    Examples:
      | trainUid  | trainDescription |
      | generated | generated        |

  Scenario: 79140-2 Display calculated times where TRUST times are unavailable
    #    Given the user is authenticated to use TMV
    #    And the user is viewing the Timetable Details in Live
    #    When the user toggles the 'TRUST Times' selection to 'off'
    #    Then in the ACTUAL/PREDICTED column on the Timetable, the internally calculated times are displayed only.
    * this replay setup test has been moved to become part of the replay test: 79141 - Initial display should show both TRUST and calculated times
