@TMVPhase2 @P2.S3
Feature: 80183 - TMV Trains List Filtering - Nominated Services - Evens
  As a TMV User
  I want the ability to config separate trains list filtering with enhanced functions
  So that I can set up different trains list for specific operational needs

  Background:
    * I remove all trains from the trains list
    * I am on the home page
    * I restore to default train list config '1'
    * I am on the trains list page 1

  Scenario Outline: 80352 - Nominated Services (Add Service Evens)
    # Given the user is authenticated to use TMV
    # And the user is viewing trains list config nominated services
    # When the user adds a nominated service
    # And has specified evens filtering
    # And has toggled on nominated services
    # Then the trains list will filter the trains list based on the nominated service(s)
    #
    # Additional business logical defined:
    # For TRUST ID added the entry is broken down in to the following elements (order):
    # - First 2 digits are the STANOX area where the train starts from
    # - The next 4 alphanumeric [digit, letter, digit, digit] is the headcode
    # - 7th alphanumeric is the schedule type
    # - 8th is an alphanumeric representing the hour the train departs
    # - The 9th & 10th represents the day of the month, which the train departs.
    # The user can specify either odd or even numbers for the last two digits of the headcode
    # - Odds: will result in filtering based on the last two digits of the headcode being odd numbers
    # - Evens: will result in filtering based on the last two digits of the headcode being even numbers
    # - The filtering will take into account the other fields if specified
    # Validation:
    # - the last two headcode fields has either odds, evens, is specified with digits (1 or 2)
    # - If the both digit fields are blank it means that any value is valid for searching in the last two fields of the headcode
    # - If the the last digit field is blank it means that any value is valid for searching in the last field of the headcode
    * I generate a new trainUID
    * I remove today's train '<trainUid>' from the trainlist
    Given I delete '<trainUid>:today' from hash 'schedule-modifications-today'
    When the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And the following live berth interpose message is sent from LINX
      | toBerth | trainDescriber | trainDescription   |
      | A001    | D3             | <trainDescription> |
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <trainUid> | <trainDescription> | now                    | 73000               | PADTON                 | today         | now                 |
    And I am on the trains list page 1
    And I save the trains list config
    Then train '<trainDescription>' with schedule id '<trainUid>' for today is visible on the trains list
    When I navigate to train list configuration
    And I have navigated to the 'Nominated Services' configuration tab
    And the Nominated Services toggle is enabled
    When I input '<trainDescriptionPart>' in the 'trainIdInput' input box
    And I toggle the odds button
    And I click the add button for Nominated Services Filter
    Then The Nominated Services table contains the following results
      | trustId                                                    |
      | xx<trainDescriptionPart>xxxxxx:ODDS |
    And I save the service filter changes for Nominated Services
    Then train description '<trainDescription>' with schedule type 'LTP' disappears from the trains list
    When I navigate to train list configuration
    And I have navigated to the 'Nominated Services' configuration tab
    And the Nominated Services toggle is enabled
    And I click the clear all button for Nominated Services Filter
    When I input '<trainDescriptionPart>' in the 'trainIdInput' input box
    And I toggle the evens button
    And I click the add button for Nominated Services Filter
    Then The Nominated Services table contains the following results
      | trustId                                                    |
      | xx<trainDescriptionPart>xxxxxx:EVENS |
    And I save the service filter changes for Nominated Services
    Then train '<trainDescription>' with schedule id '<trainUid>' for today is visible on the trains list

    Examples:
      | trainUid  | trainDescription | trainDescriptionPart |
      | generated | 5B62             | 5B                   |
