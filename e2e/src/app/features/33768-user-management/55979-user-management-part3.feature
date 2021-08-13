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
    When I access the homepage as <roleType>
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
    When I access the homepage as standard
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
    When I access the homepage as <roleType>
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

  @bug @bug:60066
  Scenario Outline: 14 Hiding search for user without Standard Role - <roleType>
    #  Given I am on the sign in screen
    #  And I have a valid TMV role of <roleType>
    #  When I enter a valid username and password combination
    #  Then I the search box is not displayed
    When I access the homepage as <roleType>
    Then I am authenticated and see the welcome message
    When I dismiss the welcome message
    * the train search box is not visible
    # clean up
    * I have not already authenticated

    Examples:
      | roleType         |
      | adminOnly        |
      | restriction      |
      | schedulematching |

  Scenario Outline: 15 Displaying matching for user with Schedule Matching Role - <matchType>
    #  Given I have signed in
    #  And I have a valid TMV role of Schedule Matching
    #  And I'm viewing the trains list
    #  When I view the context menu for a <matchType> train
    #  Then I the <matchMenuOption> is displayed
    Given I remove all trains from the trains list
    And the access plan located in CIF file 'access-plan/33805-schedules/schedule-matching.cif' is received from LINX
    And the following train activation message is sent from LINX
      | trainUID      | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid> | <trainDescription> | now                    | 99999               | PADTON                 | today         | now                 |
    When I access the homepage as schedulematching
    Then I am authenticated and see the welcome message
    When I dismiss the welcome message
    And I restore to default train list config
    And I am viewing the map HDGW01paddington.v
    And I have cleared out all headcodes
    And I am on the trains list page
    When the following live berth interpose message is sent from LINX <description>
      | toBerth | trainDescriber | trainDescription   |
      | A001    | D3             | <trainDescription> |
    And I am on the trains list page
    And train description '<trainDescription>' is visible on the trains list with schedule type '<scheduleType>'
    When I invoke the context menu for todays train '<trainDescription>' schedule uid '<planningUid>' from the trains list
    And I wait for the trains list context menu to display
    Then the <matchType> version of the trains list context menu is displayed

    Examples:
      | matchType | trainDescription | planningUid | description            | scheduleType |
      | Matched   | 1B13             | B33333      | (creating a match)     | STP          |
