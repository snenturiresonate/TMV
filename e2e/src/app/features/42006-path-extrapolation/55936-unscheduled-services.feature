Feature: 42006 - Path Extrapolation - Unscheduled services

  As a TMV user
  I want the actual train movements to be incorporated into the schedule
  So that they can be displayed in the UI and used to predict future timings and punctuality

  Background:
    Given I am on the trains list page 1
    And I restore to default train list config '1'
    And I refresh the browser
    And I have navigated to the 'Columns' configuration tab
    And I click on all the unselected column entries
    And I have navigated to the 'Train Class & MISC' configuration tab
    And I set 'Include unmatched' to be 'on'
    And I save the trains list config

  # unmatched services from stepping is part of CCN1
  @tdd
  Scenario Outline: 42006-13a Unscheduled service is displayed when an unmatched interpose is received
#    Given no valid schedule exists
#    When a berth stepping message of the <Type> is received
#    Then a corresponding unscheduled service is displayed in the trains list
    When the following live berth interpose message is sent from LINX (creating an unmatched service)
      | toBerth | trainDescriber | trainDescription |
      | 1224    | D7             | <trainDesc>      |
    And I am on the trains list page 1
    And I see all the available trains list columns with defaults first
    Then Train description '<trainDesc>' is visible on the trains list
    And all grid entries for <case> train <trainDesc> are blank except for SERVICE, PUNCT.
    And the PUNCT. entry for <case> train <trainDesc> is UNKNOWN
    And the service is displayed in the trains list with the indication for an unscheduled service
      | rowId       |
      | <trainDesc> |
    # clean up
    * I restore to default train list config '1'

    Examples:
      | case                | trainDesc |
      | unmatched interpose | 2P01      |

  # unmatched services from stepping is part of CCN1
  @tdd
  Scenario Outline: 42006-13b Unscheduled service is displayed when an unmatched step is received
    When the following live berth step messages is sent from LINX (creating an unmatched service)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 1577      | 1583    | D9             | <trainDesc>      |
    And I am on the trains list page 1
    And I see all the available trains list columns with defaults first
    Then Train description '<trainDesc>' is visible on the trains list
    And all grid entries for <case> train <trainDesc> are blank except for SERVICE, PUNCT.
    And the PUNCT. entry for <case> train <trainDesc> is UNKNOWN
    And the service is displayed in the trains list with the indication for an unscheduled service
      | rowId       |
      | <trainDesc> |
    # clean up
    * I restore to default train list config '1'

    Examples:
      | case           | trainDesc |
      | unmatched step | 2P02      |

    Scenario Outline: 42006-14  Unscheduled service is displayed when an unmatched TRI is received - <triType>
    # Given no valid schedule exists
    # And a TRI timing has been received for a location with the <TRI type>
    # Then a corresponding unscheduled service is displayed in the trains list
    When the following train running information message is sent from LINX
      | trainUID   | trainNumber | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType |
      | <trainUID> | <trainDesc> | today              | <locCode>           | <locSubCode>           | <triType>   |
    And I am on the trains list page 1
    And I see all the available trains list columns with defaults first
    Then train '<trainDesc>' with schedule id '<trainUID>' for today is visible on the trains list
    And all grid entries for <case> train <trainUID> are blank except for SERVICE, TIME, REPORT, PUNCT., REPORT (TPL), TRUST ID, SCHED. UID
    And the service is displayed in the trains list with the indication for an unscheduled service
      | rowId       |
      | <trainDesc> |
    # clean up
    * I restore to default train list config '1'


    Examples:
      | case          | trainDesc | trainUID | triType                | locCode | locSubCode |
      | unmatched TRI | 2P03      | P77803   | Arrival at Termination | 84139   | PLYMTH     |
      | unmatched TRI | 2P04      | P77804   | Departure from Origin  | 63631   | STPANCI    |
      | unmatched TRI | 2P05      | P77805   | Arrival at Station     | 15220   | WCROYDN    |
      | unmatched TRI | 2P06      | P77806   | Departure from Station | 87613   | STRETHM    |
      | unmatched TRI | 2P07      | P77807   | Passing Location       | 73775   | HTRWAJN    |

