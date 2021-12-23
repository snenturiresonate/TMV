Feature: 50561 - Unmatch a service

  Background:
    * I remove all trains from the trains list
    * I am on the trains list Config page
    * I restore to default train list config
    * I have navigated to the 'TOC/FOC' configuration tab

    @bug
    @82329
  Scenario: 80312 - Unmatch via Trains List dialogue
#    Given the user is authenticated to use TMV
#    And the user is viewing the trains list
#    And the has the schedule matching privilege
#    And has select a matched service to unmatch
#    When the user selects the unmatch option
#    Then the unmatch confirmation dialogue is displayed
    * I generate a new trainUID
    * I generate a new train description
    * I delete 'generatedTrainUId:today' from hash 'schedule-modifications'
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | generated           | generated      |
    And I wait until today's train 'generated' has loaded
    When the following train activation message is sent from LINX
      | trainUID  | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | generated | generated   | now                    | 99999               | PADTON                 | today         | now                 |
    And I am on the trains list page
    And The trains list table is visible
    When I invoke the context menu for todays train 'generated' schedule uid 'generated' from the trains list
    And I wait for the trains list context menu to display
    And I click on Unmatch in the context menu
    And I switch to the new tab
    And the tab title is 'TMV Schedule Matching generated'
    When I un-match the currently matched schedule
    Then the Unmatch confirmation dialogue is displayed

    @bug
    @82329
  Scenario: 80312 - Unmatch via Trains List dialogue
#    Given the user is authenticated to use TMV
#    And the user is viewing the trains list
#    And the has the schedule matching privilege
#    And has select a matched service to unmatch
#    When the user selects the unmatch option
#    Then the unmatch confirmation dialogue is displayed
    * I generate a new trainUID
    * I generate a new train description
    * I delete 'generatedTrainUId:today' from hash 'schedule-modifications'
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | generated           | generated      |
    And I wait until today's train 'generated' has loaded
    When the following train activation message is sent from LINX
      | trainUID  | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | generated | generated   | now                    | 99999               | PADTON                 | today         | now                 |
    And I am on the trains list page
    And The trains list table is visible
    When I invoke the context menu for todays train 'generated' schedule uid 'generated' from the trains list
    And I wait for the trains list context menu to display
    And I click on Unmatch in the context menu
    And I switch to the new tab
    And the tab title is 'TMV Schedule Matching generated'
    And I un-match the currently matched schedule
    And I click the unmatch cancel option
    Then a matched service is visible
