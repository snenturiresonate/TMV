@TMVPhase2 @P2.S3
Feature: 79730 - TMV Manual Unmatching - Unmatch a service - Timetable

  As a TMV User
  I want the ability to unmatch a service from the timetable
  So that I can unmatch a service whilst viewing the relevant schedule information

  Background:
    * I have not already authenticated
    * I am on the home page
    * The admin setting defaults are as originally shipped
    * I have cleared out all headcodes
    * I logout

  Scenario Outline: 80305 - 1 - Unmatch via Timetable dialogue (option available from timetable screen for schedule matching user)

#    Given the user is authenticated to use TMV
#    And the user is viewing a timetable
#    And the user has the schedule matching privilege
#    And has select the unmatch option
#    And the schedule matching tab is opened
#    When the user selects the unmatch option
#    Then the unmatch confirmation dialogue is displayed

    * I generate a new trainUID
    * I generate a new train description
    Given the train in CIF file below is updated accordingly so time at the reference point is now - '12' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | generated           | generated      |
    And I wait until today's train 'generated' has loaded
    And the following train activation message is sent from LINX
      | trainUID  | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | generated | generated   | now                    | 99999               | PADTON                 | today         | now                 |
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 0519    | D6             | generated        |
    When I access the homepage as <roleType> user
    And I am viewing the map HDGW02reading.v
    And I invoke the context menu on the map for train generated
    And I open timetable from the map context menu
    And I switch to the new tab
    And I wait for the last Signal to populate
    Then the Unmatch/Rematch button <isPresent> present

    # clean up
    * I logout

    Examples:
      | roleType         | isPresent |
      | schedulematching | is        |
      | standard         | isn't     |


  Scenario: 80305 - 2 - Unmatch via Timetable dialogue (option opens the schedule matching screen)

#    Given the user is authenticated to use TMV
#    And the user is viewing a timetable
#    And the user has the schedule matching privilege
#    And has select the unmatch option
#    And the schedule matching tab is opened
#    When the user selects the unmatch option
#    Then the unmatch confirmation dialogue is displayed

    * I generate a new trainUID
    * I generate a new train description
    Given the train in CIF file below is updated accordingly so time at the reference point is now - '20' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | generated           | generated      |
    And I wait until today's train 'generated' has loaded
    And the following train activation message is sent from LINX
      | trainUID  | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | generated | generated   | now                    | 99999               | PADTON                 | today         | now                 |
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 0519    | D6             | generated        |
    And I access the homepage as schedulematching user
    And I am viewing the map HDGW02reading.v
    And I invoke the context menu on the map for train generated
    And I open timetable from the map context menu
    And I switch to the new tab
    When I click on the Unmatch/Rematch button
    And I switch to the new tab
    Then the tab title is 'TMV Schedule Matching generated'
    And a matched service is visible
    When I click unmatch
    Then the Unmatch confirmation dialogue is displayed

    # clean up
    * I logout


  @bug @bug_87441
  Scenario: 80305 - 3 - Unmatch via Timetable dialogue (option available even for unmatched timetable - result is blank)

#  For an unmatched timetable if the user open the scheduled matching tab the list of schedules will be blank and no matched service

    * I generate a new trainUID
    * I generate a new train description
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '20' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | RDNGSTN     | WTT_dep       | generated           | generated      |
    And I wait until today's train 'generated' has loaded
    When I access the homepage as schedulematching user
    And I search Timetable for 'generated'
    And I open the timetable for the next train with UID generated from the search results
    And I switch to the new tab
    Then the Unmatch/Rematch button is present
    When I click on the Unmatch/Rematch button
    And I switch to the new tab
    And the tab title is 'TMV Schedule Matching generated'
    Then no matched service is visible

    # clean up
    * I logout


  Scenario Outline: 80308 - Unmatch via Timetable Dialogue (Cancel)

#    Given the user is authenticated to use TMV
#    And the user is viewing a timetable
#    And the user has the schedule matching privilege
#    And has opted to unmatch the service
#    And is viewing unmatch confirmation dialogue
#    When the user selects to cancel action
#    Then the service remains matched

#    The timetable view remains open until the users closes it

    * I generate a new train description
    * I generate a new trainUID
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1B69_PADTON_SWANSEA.cif | PADTON      | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription   |
      | A007    | D3             | <trainDescription> |
    And I access the homepage as schedulematching user
    And I am viewing the map HDGW01paddington.v
    And berth 'A007' in train describer 'D3' contains '<trainDescription>' and is visible
    And I invoke the context menu on the map for train <trainDescription>
    And I open timetable from the map context menu
    And I switch to the new tab
    When I click on the Unmatch/Rematch button
    And I switch to the new tab
    And the tab title is 'TMV Schedule Matching <trainDescription>'
    And I click unmatch
    And I click the unmatch cancel option
    Then a matched service is visible
    When the following live berth step message is sent from LINX (to move train)
      | fromBerth | toBerth | trainDescriber | trainDescription   |
      | A007      | 0039    | D3             | <trainDescription> |
    And I switch to the second-newest tab
    And I wait for the last Signal to be 'SN39'
    And I click on the Unmatch/Rematch button
    And I switch to the new tab
    Then a matched service is visible

    Examples:
      | trainDescription | trainUid  |
      | generated        | generated |

  @bug @bug_87441
  Scenario Outline: 80307 - Unmatch via Timetable Dialogue (Confirm)

#    Given the user is authenticated to use TMV
#    And the user is viewing a timetable
#    And the user has the schedule matching privilege
#    And has opted to unmatch the service
#    And is viewing unmatch confirmation dialogue
#    When the user selects affirmative action
#    Then the service is unmatched
#    And remains unmatch for the remainder of its journey unless rematched by a user

#    The timetable view remains open until the users closes it

    * I generate a new train description
    * I generate a new trainUID
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1B69_PADTON_SWANSEA.cif | PADTON      | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription   |
      | A007    | D3             | <trainDescription> |
    And I access the homepage as schedulematching user
    And I am viewing the map HDGW01paddington.v
    And berth 'A007' in train describer 'D3' contains '<trainDescription>' and is visible
    And I invoke the context menu on the map for train <trainDescription>
    And I open timetable from the map context menu
    And I switch to the new tab
    When I click on the Unmatch/Rematch button
    And I switch to the new tab
    And the tab title is 'TMV Schedule Matching <trainDescription>'
    And I click unmatch
    And I click the unmatch save option
    Then no matched service is visible
    When the following live berth step message is sent from LINX (to move train)
      | fromBerth | toBerth | trainDescriber | trainDescription   |
      | A007      | 0039    | D3             | <trainDescription> |
    And I switch to the third-newest tab
    And berth '0039' in train describer 'D3' contains 'generated' and is visible on map
    And I switch to the second-newest tab
    And I click on the Unmatch/Rematch button
    And I switch to the new tab
    Then no matched service is visible

    Examples:
      | trainDescription | trainUid  |
      | generated        | generated |
