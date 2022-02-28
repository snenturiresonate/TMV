@TMVPhase2 @P2.S1
Feature: 78887 - Timetable Details - Timetable Associations

  As a TMV User
  I want the system to provide the Timetable Details in replay and live
  So that I can view the Timetable Details whether I'm in replay or live

  Scenario Outline: 79138-1 Scheduled associations are displayed in industry standard format
    #  Given the user is authenticated to use TMV
    #  And the user is viewing the Timetable Details
    #  And the Timetable selected has Associations
    #  When the user views the Associations
    #  Then they are displayed in the line with the industry standard format.
    Given I am on the home page
    And the access plan located in CIF file 'access-plan/associations_test.cif' is received from LINX
    And I give the timetable an extra 2 seconds to load
    And I wait until today's train '<trainUid>' has loaded
    And I refresh the Elastic Search indices
    And I search Timetable for '<trainDesc>' and wait for result
      | PlanningUid |
      | <trainUid>  |
    And the search table is shown
    And I open the timetable for the next train with UID <trainUid> from the search results
    And the number of tabs open is 2
    And I switch to the new tab
    When I switch to the timetable details tab
    And The timetable details tab is visible
    Then The timetable associations table contains the following entries
      | location   | type        | trainDescription |
      | <assocLoc> | <assocType> | <assocTrainDesc> |

    Examples:
      | trainDesc | trainUid | assocType | assocLoc       | assocTrainDesc |
      | 2B99      | Y74849   | NP Next   | Swindon        | 2M39           |
      | 2M39      | L78729   | NP Next   | Westbury       | 2F97           |
      | 2G13      | L04499   | JJ Join   | Purley         | 2P13           |
      | 1H63      | G46338   | VV Divide | Haywards Heath | 1H65           |
      | 1H63      | G46338   | VV Divide | Barnham        | 5C92           |
