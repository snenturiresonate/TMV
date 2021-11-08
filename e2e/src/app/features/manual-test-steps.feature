@manual
Feature: Manual test steps
  The idea of this file is to easily perform single manual actions by adding a tag to the step that needs to be ran.
  It will also be necessary to comment out the '@manual' tag at the top of the file, or remove the manual exclusion
  tag from the headed protractor conf file at runtime.

  Scenario Outline: Load a timetable
    * I remove today's train '<trainUID>' from the Redis trainlist
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <file>   | <location>  | <timing>      | <trainNum>          | <trainUID>  |
    Then I wait until today's train '<trainUID>' has loaded

    Examples:
      | file                                       | trainNum | trainUID | location | timing   |
      | access-plan/schedules_to_penzance_temp.cif | 1B01     | L11001   | PARR     | WTT_arr  |

  Scenario Outline: Activate a train
    * I delete '<trainUID>:today' from hash 'schedule-modifications'
    When the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <trainUID> | <trainDescription> | now                    | 99999               | PADTON                 | today         | now                 |
    And I am on the trains list page
    And The trains list table is visible
    Then the service is displayed in the trains list with the following row colour
      | rowType        | trainUID   | rowColour              |
      | Origin called  | <trainUID> | rgba(255, 181, 120, 1) |

    Examples:
      | trainUID | trainDescription |
      | L11001   | 1B01             |

  Scenario: Interpose a train
    And the following live berth interpose message is sent from LINX
      | toBerth | trainDescriber | trainDescription |
      | A007    | D3             | 1B01             |

  Scenario Outline: Send TRI - Departure from origin
    Given the following train running information message is sent from LINX
      | trainUID      | trainNumber | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType           |
      | <planningUid> | <trainDesc>  | today              | 73000               | PADTON                 | Departure from Origin |

    Examples:
      | trainDesc | planningUid |
      | 1B01      | L11001      |

  Scenario Outline: Send berth step
    And the following live berth step message is sent from LINX (creating a match)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | A007      | 0039    | D3             | <trainDesc>       |

    Examples:
      | trainDesc |
      | 1B01      |

  Scenario: Change train identity
    Given the following change of ID TJM is received
      | trainUid | newTrainNumber | oldTrainNumber | departureHour | status | indicator | statusIndicator | primaryCode | time     |
      | L11001   | 1B03           | 1B01           | 13            | create | 07        | 07              | 99999       | 14:29:00 |

  Scenario: TRI - Arrival at station
    Given the following train running information message is sent from LINX
      | trainUID | trainNumber | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType        |
      | L11001   | 1B01        | today              | 15220               | PARR                   | Arrival at Station |

  Scenario: TRI - Departure from station
    Given the following train running information message is sent from LINX
      | trainUID | trainNumber | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType            |
      | L11001   | 1B01        | today              | 15220               | PARR                   | Departure from Station |
