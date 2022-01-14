@TMVPhase2 @P2.S1
Feature: 78852 - Column Header Name - Trains List

  # Given a user is viewing a trains list
  # When the user the column header names
  # Then they are consistently named

  #  TMV Trains List
  #     Change column name "PUB. ARR." to "GBTT ARR"
  #     Change column name "PUB. DEPT." to "GBTT DEP"

  Background:
    Given I am on the trains list page 1
    And I restore to default train list config '1'
    And I refresh the browser

  Scenario: 83102 - Column Header Name - Trains Lists
    Given I set trains list columns to be 'GBTT Destination Arrival Time, GBTT Origin Departure Time'
    And There is an unsaved indicator
    And I save the trains list config
    And There is no unsaved indicator
    And I am on the trains list page 1
    Then I should see the trains list columns as
      | header           |
      | GBTT ARR         |
      | GBTT DEP         |
      | SERVICE          |
      | TIME             |
      | PUNCT.           |
    And I restore to default train list config '1'
