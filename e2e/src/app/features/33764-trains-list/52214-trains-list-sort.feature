@bug @bug_54827
Feature: 52214 - TMV Trains List
  (From Gherkin for Feature 33764)

  As a TMV User
  I want the ability to have a tabular view of live trains that is filtered
  So that I have tailored list trains that I am interested in

  Scenario Outline: 33764-3a Trains List Column (Primary/Secondary Sorting - Initial defaults header indication)
#    Given the user is viewing the trains list
#    And the default columns have a sort (primary and secondary)
#    When the user is selecting a column to primary/secondary sort on
#    Then the trains list is sorted based on the selected primary sort (default descending) with the secondary sort (default descending) applied
    Given I am authenticated to use TMV
    And I have not opened the trains list before
    And I am on the trains list Config page
    And I set trains list columns to include '<columnsToInclude>'
    And I am on the trains list page
    And The trains list table is visible
    And The default trains list columns are displayed in order
    And the columns have a sort (primary and secondary)
    And PUNCT. is the primary sort column with green text and an upward arrow
    And TIME is the secondary sort column with orange text and a downward arrow
    When I select <colA> text
    Then <colA> is the primary sort column with green text and a downward arrow
    And PUNCT. is the secondary sort column with orange text and an upward arrow
    When I select <colB> text
    Then <colB> is the primary sort column with green text and a downward arrow
    And <colA> is the secondary sort column with orange text and a downward arrow

    Examples:
      | columnsToInclude    | colA          | colB    |
      | Origin, Destination | DEST.         | ORIGIN  |
      | Origin              | ORIGIN        | PUNCT.  |
      | Schedule            | SCHED.        | SERVICE |
      | Destination         | DEST.>PLANNED | DEST.   |

  @tdd
  Scenario: 33764-4a Trains List Column (Ascending/Descending Sorting - Initial display list is correctly sorted)
#    Given the user is viewing the trains list
#    And the default columns have a sort (primary and secondary)
#    When the user selects a primary or secondary to sort on (ascending or descending)
#    Then the trains list is sorted based on the selected primary/secondary sort (ascending or descending) with the secondary sort (ascending or descending) applied
    Given I am authenticated to use TMV
    And I have not opened the trains list before
    And I am on the trains list page
    When The trains list table is visible
    Then the entries in PUNCT. column are in descending order
    And the entries in TIME column are in ascending order within each value in PUNCT. column

  @tdd
  Scenario Outline: 33764-4b Trains List Column (Ascending/Descending Sorting - sorting of list updates to reflect selections made)
#    Given the user is viewing the trains list
#    And the default columns have a sort (primary and secondary)
#    When the user selects a primary or secondary to sort on (ascending or descending)
#    Then the trains list is sorted based on the selected primary/secondary sort (ascending or descending) with the secondary sort (ascending or descending) applied
    Given I am authenticated to use TMV
    And I am on the trains list Config page
    And I set trains list columns to include '<columnsToInclude>'
    And I am on the trains list page
    And The trains list table is visible
    When I select <colA> text
    And I select <colB> text
    Then the entries in <colB> column are in ascending order
    And the entries in <colA> column are in ascending order within each value in '<colB>' column
    When I select <colA> text
    Then the entries in <colA> column are in ascending order
    And the entries in '<colB>' column are in ascending order within each value in '<colA>' column
    When I select <colA> arrow
    Then <colA> is the primary sort column with green text and an upward arrow
    And <colB> is the secondary sort column with orange text and a downward arrow
    And the entries in <colA> column are in descending order
    And the entries in <colB>' column are in ascending order within each value in '<colA>' column
    When I select <colB> arrow
    Then <colA> is the primary sort column with green text and an upward arrow
    And <colB> is the secondary sort column with orange text and an upward arrow
    And the entries in <colA> column are in descending order
    And the entries in <colB> column are in descending order within each value in '<colA>' column
    When I select <colC> text
    Then <colC> is the primary sort column with green text and an downward arrow
    And <colA> is the secondary sort column with orange text and an upward arrow
    And the entries in <colC> column are in ascending order
    And the entries in <colA> column are in descending order within each value in '<colA>' column
    When I select <colB> text
    Then <colB> is the primary sort column with green text and an downward arrow
    And <colC> is the secondary sort column with orange text and an downward arrow
    And the entries in <colB> column are in ascending order
    And the entries in <colC> column are in ascending order within each value in '<colA>' column
    When I refresh the browser
    Then PUNCT. is the primary sort column with green text and an upward arrow
    And TIME is the secondary sort column with orange text and an downward arrow
    And the entries in PUNCT. column are in descending order
    And the entries in TIME column are in ascending order within each value in 'PUNCT.' column

    Examples:
      | columnsToInclude              | colA        | colB   | colC   |
      | Origin, Destination, Schedule | DESTINATION | ORIGIN | SCHED. |
