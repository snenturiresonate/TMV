@TMVPhase2 @P2.S4
Feature: 80750 - Unscheduled Trains List - View

  As a TMV User
  I want view a dynamic list of unscheduled trains
  So that I have a central place to determine if manual matching is required

  #  Given the user is authenticated to use TMV
  #  And the user has opened an unscheduled trains list
  #  When the user views the unscheduled trains list
  #  Then the unscheduled train list displays unscheduled trains (nationally)
  #
  #  Comments:
  #  * The columns displayed are:
  #      * Train ID
  #      * Entry time (first step time or first train running information time)
  #      * Entry berth, signal and/or location
  #      * Current berth, signal and/or location.
  #      * Current Train describer
  #  * The list is ordered by entry time (latest first)
  Background:
    * I generate a new trainUID
    * I generate a new train description

  Scenario Outline: 81290-1 - unscheduled trains list displays a single unscheduled train
    Given the following live berth interpose message is sent from LINX (to create an unmatched service)
      | toBerth | trainDescriber | trainDescription   |
      | A007    | D3             | <trainDescription> |
    And the following live berth step message is sent from LINX (to step the train into Royal Oak Junction)
      | fromBerth | toBerth | trainDescriber | trainDescription   |
      | A007      | 0039    | D3             | <trainDescription> |
    When I am on the unscheduled trains list
    Then the following unscheduled trains list entry can be seen
      | trainId            | time | berth  | signal | location           | trainDescriber |
      | <trainDescription> | now  | D30039 | SN39   | Royal Oak Junction | D3             |

    Examples:
      | trainDescription  |
      | generated         |

  Scenario Outline: 81290-2 - unscheduled trains list does not display a scheduled train
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '1' minute, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID       | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid>  | <trainDescription> | now                    | 99999               | PADTON                 | today         | now                 |
    And the following live berth interpose message is sent from LINX (to create a match at Paddington)
      | toBerth | trainDescriber | trainDescription   |
      | A007    | D3             | <trainDescription> |
    And the following live berth step message is sent from LINX (departing from Paddington)
      | fromBerth | toBerth | trainDescriber | trainDescription   |
      | A007      | 0039    | D3             | <trainDescription> |
    And the following train running information message is sent from LINX
      | trainUID      | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType           |
      | <planningUid> | <trainDescription> | today              | 73000               | PADTON                 | Departure from origin |
    When I am on the unscheduled trains list
    Then the following unscheduled trains list entry cannot be seen
      | trainId            | time | berth  | signal | location           | trainDescriber |
      | <trainDescription> | now  | D30039 | SN39   | Royal Oak Junction | D3             |

    Examples:
      | trainDescription          | planningUid       |
      | generatedTrainDescription | generatedTrainUId |

  Scenario Outline: 81290-3 - unscheduled trains list displays the correct columns
    Given the following live berth interpose message is sent from LINX (to create an unmatched service)
      | toBerth | trainDescriber | trainDescription   |
      | A007    | D3             | <trainDescription> |
    And the following live berth step message is sent from LINX (to step the train into Royal Oak Junction)
      | fromBerth | toBerth | trainDescriber | trainDescription   |
      | A007      | 0039    | D3             | <trainDescription> |
    When I am on the unscheduled trains list
    Then the following column section names can be seen in the following order on the unscheduled trains list
      | columnSection  |
      |                |
      | ENTRY          |
      | CURRENT        |
#    @bug @bug:87321
#    And the following table column names can be seen in the following order on the unscheduled trains list
#      | tableColumnName  |
#      | TRAIN ID         |
#      | TIME             |
#      | arrow_upward     |
#      | BERTH            |
#      | SIGNAL           |
#      | LOCATION         |
#      | BERTH            |
#      | SIGNAL           |
#      | LOCATION         |
#      | TRAIN DESCRIBER  |

    Examples:
      | trainDescription  |
      | generated         |

  Scenario Outline: 81290-4 - unscheduled trains list displays the trains ordered by entry time
    Given the following live berth interpose message is sent from LINX (to create the first unmatched service)
      | toBerth | trainDescriber | trainDescription   |
      | A007    | D3             | <trainDescription> |
    And I generate a new train description
    And the following live berth interpose message is sent from LINX (to create the second unmatched service)
      | toBerth | trainDescriber | trainDescription   |
      | 0034    | D3             | <trainDescription> |
    When I am on the unscheduled trains list
    Then the unscheduled trains list is ordered by entry time, most recent first

    Examples:
      | trainDescription  |
      | generated         |
