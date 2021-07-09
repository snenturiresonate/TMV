@fixed-time
Feature: 60651 - TMV Manual TRUST Berth - Clearing berths

  As a TMV user
  I want the MTB stacks to only include trains where the last report is at that manual TRUST berth
  So that it is clear which is the last known position on the map

  Background:
    Given I clear all MTBs
    And I remove all trains from the trains list

  Scenario Outline: MTB is cleared when later MTB is received
    Given the access plan located in CIF file '<cif>' is received from LINX
    And I am on the trains list page
    And train description '<trainNumber>' is visible on the trains list with schedule type 'LTP'
    Given I am viewing the map nw05sandhillsnl.v
    And the following train running info message with time is sent from LINX
      | trainUID   | trainNumber   | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType            | timestamp |
      | <trainUID> | <trainNumber> | today              | 85621               | RUFDORD                | Departure from Station | 07:16:30  |
    And headcode '<trainNumber>' is present in manual-trust berth '30155U'
    When the following train running info message with time is sent from LINX
      | trainUID   | trainNumber   | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType            | timestamp |
      | <trainUID> | <trainNumber> | today              | 85621               | CROT                   | Departure from Station | 07:18:30  |
    Then headcode '<trainNumber>' is not present in manual-trust berth '30155U'
    And headcode '<trainNumber>' is present in manual-trust berth '30153U'
    Examples:
      | cif                                     | trainUID | trainNumber |
      | access-plan/34082-schedules/60651-1.cif | C33605   | 2N02        |

  Scenario Outline: Current MTB remains after Other MTB is cleared
    Given the access plan located in CIF file '<cif>' is received from LINX
    And I am on the trains list page
    And train description '<trainNumber>' is visible on the trains list with schedule type 'VAR'
    And train description '<trainNumber2>' is visible on the trains list with schedule type 'VAR'
    Given I am viewing the map gw19penzance.v
    And the following train running info message with time is sent from LINX
      | trainUID    | trainNumber    | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType            | timestamp |
      | <trainUID>  | <trainNumber>  | today              | 85621               | PENZNCE                | Departure from Station | 07:16:30  |
      | <trainUID2> | <trainNumber2> | today              | 85621               | PENZNCE                | Departure from Station | 07:16:30  |
    And headcode '<trainNumber>' is present in manual-trust berth '85734U'
    And headcode '<trainNumber2>' is present in manual-trust berth '85734U'
    When the following train running info message with time is sent from LINX
      | trainUID   | trainNumber   | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType        | timestamp |
      | <trainUID> | <trainNumber> | today              | 85621               | LNGROCK                | Arrival at Station | 07:18:30  |
    Then headcode '<trainNumber>' is not present in manual-trust berth '85734U'
    And headcode '<trainNumber2>' is present in manual-trust berth '85734U'
    Examples:
      | cif                                     | trainUID | trainNumber | trainUID2 | trainNumber2 |
      | access-plan/34082-schedules/60651-5.cif | L79156   | 5F73        | L79157    | 5F74         |


  Scenario Outline: MTB is cleared when later TRI is received (non MTB location)
    Given the access plan located in CIF file '<cif>' is received from LINX
    And I am on the trains list page
    And train description '<trainNumber>' is visible on the trains list with schedule type 'LTP'
    Given I am viewing the map nw05sandhillsnl.v
    And the following train running info message with time is sent from LINX
      | trainUID   | trainNumber   | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType            | timestamp |
      | <trainUID> | <trainNumber> | today              | 85621               | CROT                   | Departure from Station | 07:16:30  |
    And headcode '<trainNumber>' is present in manual-trust berth '30153U'
    When the following train running info message with time is sent from LINX
      | trainUID   | trainNumber   | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType            | timestamp |
      | <trainUID> | <trainNumber> | today              | 85621               | FRNGTNC                | Departure from Station | 07:18:30  |
    Then headcode '<trainNumber>' is not present in manual-trust berth '30153U'
    Examples:
      | cif                                     | trainUID | trainNumber |
      | access-plan/34082-schedules/60651-1.cif | C33605   | 2N02        |

  Scenario Outline: MTB is cleared when later TD stepping is received
    Given I am on the trains list page
    And the access plan located in CIF file '<cif>' is received from LINX
    And train description '<trainNumber>' is visible on the trains list with schedule type 'LTP'
    Given I am viewing the map nw05sandhillsnl.v
    And the following train running info message with time is sent from LINX
      | trainUID   | trainNumber   | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType            | timestamp |
      | <trainUID> | <trainNumber> | today              | 85621               | CROT                   | Departure from Station | 07:16:30  |
    And headcode '<trainNumber>' is present in manual-trust berth '30153U'
    When the following berth interpose messages is sent from LINX
      | timestamp | toBerth | trainDescriber | trainDescription |
      | 07:25:00  | A055    | PX             | <trainNumber>    |
    When the following berth step message is sent from LINX
      | timestamp | fromBerth | toBerth | trainDescriber | trainDescription |
      | 07:27:00  | A055      | 0058    | PX             | <trainNumber>    |
    Then headcode '<trainNumber>' is not present in manual-trust berth '30153U'
    Examples:
      | cif                                     | trainUID | trainNumber |
      | access-plan/34082-schedules/60651-1.cif | C33605   | 2N02        |

  Scenario Outline: Don't show in MTB when later MTB already received
    Given the access plan located in CIF file '<cif>' is received from LINX
    And I am on the trains list page
    And train description '<trainNumber>' is visible on the trains list with schedule type 'LTP'
    Given I am viewing the map nw05sandhillsnl.v
    And the following train running info message with time is sent from LINX
      | trainUID   | trainNumber   | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType            | timestamp |
      | <trainUID> | <trainNumber> | today              | 85621               | CROT                   | Departure from Station | 07:18:30  |
    And headcode '<trainNumber>' is present in manual-trust berth '30153U'
    When the following train running info message with time is sent from LINX
      | trainUID   | trainNumber   | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType            | timestamp |
      | <trainUID> | <trainNumber> | today              | 85621               | RUFDORD                | Departure from Station | 07:16:30  |
    Then headcode '<trainNumber>' is not present in manual-trust berth '30155U'
    And headcode '<trainNumber>' is present in manual-trust berth '30153U'
    Examples:
      | cif                                     | trainUID | trainNumber |
      | access-plan/34082-schedules/60651-1.cif | C33605   | 2N02        |

  # these tests are marked as manual due to the MTB housekeeping scheduler
  # the berth will not be cleared following a cancellation until housekeeping runs (15 minute cycle)
  # to test manually and make the housekeeping run every 30 seconds,
  # add the following 2 environment variables to tmv_manual-trust-berth-state-service via portainer (ci_ip:9000)

  # name = MANUAL_TRUST_BERTH_TERMINATION_CRON_EXPRESSION
  # value = */30 * * * * *
  # name = MANUAL_TRUST_BERTH_TERMINATION_ADDITIONAL_TIME
  # value = 1s
  @manual
  Scenario Outline: MTB is cleared when Cancel at Origin TJM is received
    Given the access plan located in CIF file '<cif>' is received from LINX
    And I am on the trains list page
    And train description '<trainNumber>' is visible on the trains list with schedule type 'VAR'
    Given I am viewing the map gw13exeter.v
    And the following train running info message with time is sent from LINX
      | trainUID   | trainNumber   | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType        | timestamp |
      | <trainUID> | <trainNumber> | today              | 85621               | EXMOUTH                | Arrival at Station | 08:55:00  |
    And headcode '<trainNumber>' is present in manual-trust berth '83475A'
    When the following TJM is received
      | trainUid   | trainNumber   | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time | modificationReason | nationalDelayCode |
      | <trainUID> | <trainNumber> | now           | create | 91        | 91              | 99999       | EXMOUTH        | now  | 12                 | PD                |
    Then headcode '<trainNumber>' is not present in manual-trust berth '83475A'
    Examples:
      | cif                                     | trainUID | trainNumber |
      | access-plan/34082-schedules/60651-2.cif | C13649   | 2T08        |

  # See comment on scenario: MTB is cleared when Cancel at Origin TJM is received
  @manual
  Scenario Outline: MTB is cleared when Cancel at Booked Location TJM is received (current location)
    Given the access plan located in CIF file '<cif>' is received from LINX
    And I am on the trains list page
    And train description '<trainNumber>' is visible on the trains list with schedule type 'LTP'
    Given I am viewing the map nw05sandhillsnl.v
    And the following train running info message with time is sent from LINX
      | trainUID   | trainNumber   | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType            | timestamp |
      | <trainUID> | <trainNumber> | today              | 85621               | RUFDORD                | Departure from Station | 07:16:30  |
    And headcode '<trainNumber>' is present in manual-trust berth '30155U'
    When the following TJM is received
      | trainUid   | trainNumber   | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time | modificationReason | nationalDelayCode |
      | <trainUID> | <trainNumber> | now           | create | 92        | 92              | 99999       | RUFDORD        | now  | 12                 | PD                |
    Then headcode '<trainNumber>' is not present in manual-trust berth '30155U'

    Examples:
      | cif                                     | trainUID | trainNumber |
      | access-plan/34082-schedules/60651-3.cif | C33606   | 2N03        |

  # See comment on scenario: MTB is cleared when Cancel at Origin TJM is received
  @manual
  Scenario Outline: MTB is cleared when Cancel at Booked Location TJM is received (next location)
    Given the access plan located in CIF file '<cif>' is received from LINX
    And I am on the trains list page
    And train description '<trainNumber>' is visible on the trains list with schedule type 'LTP'
    Given I am viewing the map nw05sandhillsnl.v
    And the following train running info message with time is sent from LINX
      | trainUID   | trainNumber   | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType            | timestamp |
      | <trainUID> | <trainNumber> | today              | 85621               | RUFDORD                | Departure from Station | 07:16:30  |
    And headcode '<trainNumber>' is present in manual-trust berth '30155U'
    When the following TJM is received
      | trainUid   | trainNumber   | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time | modificationReason | nationalDelayCode |
      | <trainUID> | <trainNumber> | now           | create | 92        | 92              | 99999       | CROT           | now  | 12                 | PD                |
    Then headcode '<trainNumber>' is not present in manual-trust berth '30155U'

    Examples:
      | cif                                     | trainUID | trainNumber |
      | access-plan/34082-schedules/60651-4.cif | C33607   | 2N04        |

  # See comment on scenario: MTB is cleared when Cancel at Origin TJM is received
  @manual
  Scenario Outline: MTB is cleared following a termination at destination
    Given the access plan located in CIF file '<cif>' is received from LINX
    And I am on the trains list page
    And train description '<trainNumber>' is visible on the trains list with schedule type 'LTP'
    Given I am viewing the map hdgw09penzance.v
    And the following train running info message with time is sent from LINX
      | trainUID   | trainNumber   | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType            | timestamp |
      | <trainUID> | <trainNumber> | today              | 85621               | PRKADIL                | Arrival at Termination | 07:16:30  |
    And headcode '<trainNumber>' is present in manual-trust berth '85423A'
    Then headcode '<trainNumber>' is not present in manual-trust berth '85423A'

    Examples:
      | cif                                     | trainUID | trainNumber |
      | access-plan/34082-schedules/60651-6.cif | H06771   | 6P07        |

