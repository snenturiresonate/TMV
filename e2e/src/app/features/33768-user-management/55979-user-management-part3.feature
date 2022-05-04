Feature: 33768-3: TMV User Management
  As a TMV user
  I want to be able to log into the TMV application
  so that I can access functionality that the is appropriate for my role

  Background:
    Given I have not already authenticated

  Scenario Outline: 11. Hiding map sections for user without Standard Role - <roleType> role - <adverb> displayed
    #  Given I am on the sign in screen
    #  And I have a valid TMV role of <roleType>
    #  When I enter a valid username and password combination
    #  Then I the following are not displayed 'Find your map', 'Recent Map', 'All Maps'
    When I access the homepage as <roleType> user
    Then I am authenticated and see the welcome message
    When I dismiss the welcome message
    * the map search box <adverb> displayed
    * the recent maps section <adverb> displayed
    * the all maps section <adverb> displayed
    # clean up
    * I have not already authenticated

    Examples:
      | roleType  | adverb |
      | standard  | is     |
      | adminOnly | is not |

  Scenario: 12 Displaying search for user with Standard Role
    #  Given I am on the sign in screen
    #  And I have a valid TMV role of Standard
    #  When I enter a valid username and password combination
    #  Then I the search box is displayed
    When I access the homepage as standard user
    Then I am authenticated and see the welcome message
    When I dismiss the welcome message
    * the train search box is visible
    # clean up
    * I have not already authenticated

  Scenario Outline: 13 Hiding icons for user without Standard Role - <roleType>
    #  Given I am on the sign in screen
    #  And I have a valid TMV role of <roleType>
    #  When I enter a valid username and password combination
    #  Then I the following are not displayed Trains List, Enquiries, Replay, Log viewer
    When I access the homepage as <roleType> user
    Then I am authenticated and see the welcome message
    When I dismiss the welcome message
    Then the app list does not contain the following apps
      | app         |
      | Trains List |
      | Enquiries   |
      | Replay      |
      | Logs        |
    # clean up
    * I have not already authenticated

    Examples:
      | roleType  |
      | adminOnly |

  Scenario Outline: 14 Hiding search for user without Standard Role - <roleType>
    #  Given I am on the sign in screen
    #  And I have a valid TMV role of <roleType>
    #  When I enter a valid username and password combination
    #  Then I the search box is not displayed
    When I access the homepage as <roleType> user
    Then I am authenticated and see the welcome message
    When I dismiss the welcome message
    * the train search box is not visible
    # clean up
    * I have not already authenticated

    Examples:
      | roleType  |
      | adminOnly |

  Scenario Outline: 15 Displaying matching for user with Schedule Matching Role - <matchType>
    #  Given I have signed in
    #  And I have a valid TMV role of Schedule Matching
    #  And I'm viewing the trains list
    #  When I view the context menu for a <matchType> train
    #  Then I the <matchMenuOption> is displayed
    * I generate a new trainUID
    * I generate a new train description
    * I delete '<planningUid>:today' from hash 'schedule-modifications-today'
    * I remove all trains from the trains list
    Given I access the homepage as schedulematching user
    And I am authenticated and see the welcome message
    And I dismiss the welcome message
    And I restore to default train list config '1'
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID      | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid> | <trainDescription> | now                    | 99999               | PADTON                 | today         | now                 |
    And I am on the trains list page 1
    And I save the trains list config
    And the following live berth interpose message is sent from LINX <description>
      | toBerth | trainDescriber | trainDescription   |
      | A001    | D3             | <trainDescription> |
    And train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list
    When I invoke the context menu for todays train '<trainDescription>' schedule uid '<planningUid>' from the trains list
    And I wait for the trains list context menu to display
    Then the <matchType> version of the Schedule-matching trains list context menu is displayed
    # clean up
    * I have not already authenticated

    Examples:
      | matchType | trainDescription | planningUid | description        |
      | Matched   | generated        | generated   | (creating a match) |

  Scenario Outline: 16a Displaying matching for user without Schedule Matching Role - trains list
    #    Given I have signed in
    #    And I have a valid TMV role of <roleType>
    #    And I'm viewing the trains list
    #    When I view the context menu for a <matchType> train
    #    Then I the <Match Menu Option> is not displayed

    * I reset redis
    * I generate a new trainUID
    * I generate a new train description
    * I delete 'generated:today' from hash 'schedule-modifications-today'
    * I remove all trains from the trains list
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/2P77_RDNGSTN_PADTON.cif | RDNGSTN     | WTT_dep       | <trainDescription1> | <planningUid1> |
    And I wait until today's train '<planningUid1>' has loaded
    And the following train activation message is sent from LINX
      | trainUID       | trainNumber         | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid1> | <trainDescription1> | now                    | 99999               | RDNGSTN                | today         | now                 |
    And the following live berth interpose messages is sent from LINX
      | toBerth   | trainDescriber   | trainDescription    |
      | <toBerth> | <trainDescriber> | <trainDescription2> |
    And the following train running information message is sent from LINX
      | trainUID       | trainNumber         | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType           |
      | <planningUid2> | <trainDescription2> | today              | 74237               | RDNGSTN                | Departure from origin |
    When I access the homepage as <roleType> user
    Then I am authenticated and see the welcome message
    When I dismiss the welcome message
    And I restore to default train list config '1'
    And I am on the trains list page 1
    And I save the trains list config
    And I invoke the context menu for todays train '<trainDescription2>' schedule uid '<planningUid2>' from the trains list
    And I wait for the trains list context menu to display
    Then the <matchType> version of the Non-Schedule-matching trains list context menu is displayed
    # clean up
    * I have not already authenticated

    Examples:
      | matchType | roleType    | trainDescription1 | planningUid1 | trainDescriber | toBerth | trainDescription2 | planningUid2 |
      | Matched   | restriction | generated         | generated    | D1             | 1698    | generated         | generated    |
      | Matched   | standard    | generated         | generated    | D1             | 1698    | generated         | generated    |

  Scenario Outline: 16b Displaying matching for user without Schedule Matching Role - map - <matchType> - <roleType>
    * I reset redis
    * I generate a new trainUID
    * I generate a new train description
    * I delete 'generated:today' from hash 'schedule-modifications-today'
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/2P77_RDNGSTN_PADTON.cif | RDNGSTN     | WTT_dep       | <trainDescription1> | <planningUid1> |
    And I wait until today's train '<planningUid1>' has loaded
    And the following train activation message is sent from LINX
      | trainUID       | trainNumber         | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid1> | <trainDescription1> | now                    | 99999               | RDNGSTN                | today         | now                 |
    When I access the homepage as <roleType> user
    And I am authenticated and see the welcome message
    And I dismiss the welcome message
    And I restore to default train list config '1'
    And I am viewing the map HDGW02reading.v
    And I have cleared out all headcodes
    And the following live berth interpose messages is sent from LINX
      | toBerth   | trainDescriber   | trainDescription    |
      | <toBerth> | <trainDescriber> | <trainDescription2> |
    And I invoke the context menu on the map for train <trainDescription2>
    Then the <matchType> version of the Non-Schedule-matching map context menu is displayed
    # clean up
    * I have not already authenticated

    Examples:
      | matchType | roleType    | trainDescription1 | planningUid1 | trainDescriber | toBerth | trainDescription2 |
      | Matched   | restriction | generated         | generated    | D1             | 1698    | generated         |
      | Matched   | standard    | generated         | generated    | D1             | 1698    | generated         |
      | Unmatched | restriction | generated         | generated    | D1             | 1777    | 2V46              |
      | Unmatched | standard    | generated         | generated    | D1             | 1777    | 2V46              |

  Scenario Outline: 16c Displaying matching for user without Schedule Matching Role - Enquiries - <matchType> - <roleType>
    * I reset redis
    * I generate a new trainUID
    * I generate a new train description
    * I delete 'generated:today' from hash 'schedule-modifications-today'
#    * I remove all trains from the trains list
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/2P77_RDNGSTN_PADTON.cif | RDNGSTN     | WTT_dep       | <trainDescription1>  | <planningUid1>  |
    And the following train activation message is sent from LINX
      | trainUID      | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid1> | <trainDescription1> | now                    | 99999               | RDNGSTN                | today         | now                 |
    And I wait until today's train '<planningUid1>' has loaded
    And the following live berth interpose messages is sent from LINX
      | toBerth   | trainDescriber   | trainDescription   |
      | <toBerth> | <trainDescriber> | <trainDescription2> |
    And the following train running information message is sent from LINX
      | trainUID       | trainNumber         | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType           |
      | <planningUid2> | <trainDescription2> | today              | 74237               | RDNGSTN                | Departure from origin |
    When I access the homepage as <roleType> user
    Then I am authenticated and see the welcome message
    When I dismiss the welcome message
    Given I am on the enquiries page
    And I type 'RDNGSTN' into the enquiries location search box
    And I select the location at position 1 in the enquiries location auto suggest search results list
    And I click the enquiries view button
    And I invoke the context menu for todays train '<trainDescription2>' schedule uid '<planningUid2>' from the enquiries page
    And I wait for the enquiries page context menu to display
    Then the <matchType> version of the Non-Schedule-matching enquiries view context menu is displayed
    # clean up
    * I have not already authenticated

    Examples:
      | matchType | roleType    | trainDescription1 | planningUid1 | trainDescriber | toBerth | trainDescription2 | planningUid2 |
      | Matched   | restriction | generated         | generated    | D1             | 1698    | generated         | generated    |
      | Matched   | standard    | generated         | generated    | D1             | 1698    | generated         | generated    |
