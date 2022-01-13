@TMVPhase2 @P2.S1
Feature: 78852 - Column Header Name - Enquiries

  # Given a user is viewing an enquiries
  # When the user views the column header names
  # Then they are consistently named

  #  TMV Enquiries
  #     Change column name "Planned ARR." to "Planned ARR"
  #     Change column name "Planned DEPT." to "Planned DEP"
  #     Change column name "ACTUAL/PREDICTED ARR." to "ACTUAL/PREDICT ARR"
  #     Change column name "ACTUAL/PREDICTED DEPT." to "ACTUAL/PREDICT DEP"

  Scenario: 83103 - Column Header Name - Enquiries
    Given I am on the enquiries page
    And I type 'Padd' into the enquiries location search box
    And I select the location at position 1 in the enquiries location auto suggest search results list
    When I click the enquiries view button
    Then I should see the enquiries columns as
    | header |
    | SERVICE |
    | TIME |
    | REPORT |
    | PUNCT. |
    | PLANNED ARR |
    | PLANNED DEP |
    | ACTUAL / PREDICT ARR |
    | ACTUAL / PREDICT DEP |
    | LINE |
    | PLATFORM |
    | OPERATOR |

