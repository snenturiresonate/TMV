Feature: 56052 - TMV Trains List - User Configuration Applied (Service Called)

  As a user
  I want the trains list to hide certain service based on their state
  so that I have a trains list tailored to my operation needs

  Background:
    * I am on the home page
    * I restore to default train list config
    * I remove all trains from the trains list

  @bug @bug:66288
  # Origin Called - trains that have been Called 15 (user config - default 15) minutes before their origin departure
  # time (planned) are not displayed (results) if toggled off
  Scenario Outline: 56052-AC2 - A train that has been Called <departsInMinutes> minutes before its origin departure time <visibility> visible if toggled <toggle>
    Given I delete '<trainUID>:today' from hash 'schedule-modifications'
    When the train in CIF file below is updated accordingly so time at the reference point is now + '<departsInMinutes>' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <trainUID>     |
    And I am on the trains list page
    Then train '<trainDescription>' with schedule id '<trainUID>' for today is visible on the trains list
    When I am on the trains list Config page
    * I have navigated to the 'Train Indication' configuration tab
    * I update only the below train list indication config settings as
      | name                     | colour | toggleValue |
      | Origin Called            | #6a6   | <toggle>    |
    * I save the trains list config
    * I am on the trains list page
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <trainUID> | <trainDescription> | now                    | 99999               | PADTON                 | today         | now                 |
    And The trains list table is visible
    Then train '<trainDescription>' with schedule id '<trainUID>' for today <visibility> visible on the trains list
    # clean up
    * I restore to default train list config

    Examples:
    | trainUID | departsInMinutes | trainDescription | toggle | visibility |
    | B11001   | 15               | 3B01             | off    | is not     |
    | B11002   | 15               | 3B02             | on     | is         |
    | B11003   | 2                | 3B03             | off    | is         |
    | B11004   | 2                | 3B04             | on     | is         |

  # The train will be displayed if it has received a train running information report as it is currently running
  # also used as setup for AC4
  Scenario Outline: 56052-AC2a - A train that has been Called <departsInMinutes> minutes before its origin departure time and received a TRI <visibility> visible if toggled <toggle>
    * I remove today's train '<trainUID>' from the Redis trainlist
    Given I delete '<trainUID>:today' from hash 'schedule-modifications'
    When the train in CIF file below is updated accordingly so time at the reference point is now + '<departsInMinutes>' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <trainUID>     |
    And I wait until today's train '<trainUID>' has loaded
    When I am on the trains list Config page
    * I have navigated to the 'Train Indication' configuration tab
    * I update only the below train list indication config settings as
      | name                     | colour | toggleValue |
      | Origin Called            | #6a6   | <toggle>    |
    * I save the trains list config
    * I am on the trains list page
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <trainUID> | <trainDescription> | now                    | 73000               | PADTON                 | today         | now                 |
    And the following live berth interpose messages is sent from LINX (to indicate train is present)
      | toBerth | trainDescriber   | trainDescription   |
      | A007    | D3               | <trainDescription> |
    When the following train running information message is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType           |
      | <trainUID> | <trainDescription> | today              | 73000               | PADTON                 | Departure from origin |
    And The trains list table is visible
    Then train '<trainDescription>' with schedule id '<trainUID>' for today <visibility> visible on the trains list
    # clean up
    * I restore to default train list config

    Examples:
      | trainUID | departsInMinutes | trainDescription | toggle | visibility |
      | B11007   | 14               | 3B07             | off    | is         |
      | B11008   | 2                | 3B08             | on     | is         |

  @bug @bug:66317
  # Origin Departure Overdue - trains that are overdue by 1 (user config - default) minutes to depart from origin
  # (planned time) are not displayed unless overdue and when toggled off it is not displayed (results)
  Scenario Outline: 56052-AC3 - A train that is overdue by <overdueMinutes> minutes <visibility> visible if origin departure overdue is toggled <toggle>
    Given I delete '<trainUID>:today' from hash 'schedule-modifications'
    When the train in CIF file below is updated accordingly so time at the reference point is now - '<overdueMinutes>' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <trainUID>     |
    And I am on the trains list page
    Then train '<trainDescription>' with schedule id '<trainUID>' for today is visible on the trains list
    When I am on the trains list Config page
    * I have navigated to the 'Train Indication' configuration tab
    * I update only the below train list indication config settings as
      | name                     | colour | toggleValue |
      | Origin Departure Overdue | #6a6   | <toggle>    |
    * I save the trains list config
    * I am on the trains list page
    And The trains list table is visible
    Then train '<trainDescription>' with schedule id '<trainUID>' for today <visibility> visible on the trains list
    # clean up
    * I restore to default train list config

    Examples:
      | trainUID | overdueMinutes | trainDescription | toggle | visibility |
      | B11009   |  2             | 3B09             | on     | is         |
      | B11010   |  2             | 3B10             | off    | is not     |
      | B11011   | -2             | 3B11             | off    | is         |

