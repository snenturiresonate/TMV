@newSession
Feature: 52214 - TMV Trains List - sort
  (From Gherkin for Feature 33764)

  As a TMV User
  I want the ability to have a tabular view of live trains that is filtered
  So that I have tailored list of trains that I am interested in

  Background:
    * I remove all trains from the trains list
    * the access plan located in CIF file 'access-plan/trains_list_sort_test.cif' is amended so that all services start within the next hour and then received from LINX
    * the following train running information messages with delay against booked time are sent from LINX
      | trainUID | trainNumber | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType            | delay  | hourDepartFromOrigin |
      | V30607   | 5G14        | today              | 73000               | PADTON                 | Departure from Origin  | +01:20 | 9                    |
      | C74257   | 2M34        | today              | 74237               | RDNGSTN                | Departure from station | -00:17 | 9                    |
      | V77798   | 1Z37        | today              | 73000               | DIDCOTP                | Arrival at station     | +00:00 | 19                   |
      | Y95687   | 1P77        | today              | 73000               | STHALL                 | Passing Location       | +02:08 | 21                   |
    * I am authenticated to use TMV
    * I restore to default train list config '1'


  Scenario Outline: 33764-3a Trains List Column (Primary/Secondary Sorting - Initial defaults header indication)
    # Given the user is viewing the trains list
    # And the default columns have a sort (primary and secondary)
    # When the user is selecting a column to primary/secondary sort on
    # Then the trains list is sorted based on the selected primary sort (default descending) with the secondary sort (default descending) applied
    Given I am on the trains list page 1
    And I set trains list columns to include '<columnsToInclude>'
    And I save the trains list config
    Then The trains list table is visible
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
    * the access plan located in CIF file 'access-plan/trains_list_sort_cancelled.cif' is received from LINX

    Examples:
      | columnsToInclude    | colA          | colB    |
      | Origin, Destination | DEST.         | ORIGIN  |
      | Origin              | ORIGIN        | PUNCT.  |
      | Schedule Type       | SCHED.        | SERVICE |
      | Destination         | DEST.>PLANNED | DEST.   |

  @tdd
  Scenario: 33764-4a Trains List Column (Ascending/Descending Sorting - Initial display list is correctly sorted)
    # Given the user is viewing the trains list
    # And the default columns have a sort (primary and secondary)
    # When the user selects a primary or secondary to sort on (ascending or descending)
    # Then the trains list is sorted based on the selected primary/secondary sort (ascending or descending) with the secondary sort (ascending or descending) applied
    Given I am on the trains list page 1
    And I save the trains list config
    When The trains list table is visible
    Then the entries in PUNCT. column are in descending order
    And the entries in TIME column are in ascending order within each value in PUNCT. column
    * the access plan located in CIF file 'access-plan/trains_list_sort_cancelled.cif' is received from LINX

  
  @bug
  @87596
  # Schedule column is sorting is failing
  Scenario Outline: 33764-4b Trains List Column (Ascending/Descending Sorting - sorting of list updates to reflect selections made)
    # Given the user is viewing the trains list
    # And the default columns have a sort (primary and secondary)
    # When the user selects a primary or secondary to sort on (ascending or descending)
    # Then the trains list is sorted based on the selected primary/secondary sort (ascending or descending) with the secondary sort (ascending or descending) applied
    Given I am on the trains list page 1
    And I set trains list columns to include '<columnsToInclude>'
    And I save the trains list config
    Then The trains list table is visible
    When I select <colA> text
    And I select <colB> text
    Then the entries in <colB> column are in ascending order
    And the entries in <colA> column are in ascending order within each value in <colB> column
    When I select <colA> text
    Then the entries in <colA> column are in ascending order
    And the entries in <colB> column are in ascending order within each value in <colA> column
    When I select <colA> arrow
    Then <colA> is the primary sort column with green text and an upward arrow
    And <colB> is the secondary sort column with orange text and a downward arrow
    And the entries in <colA> column are in descending order
    And the entries in <colB> column are in ascending order within each value in <colA> column
    When I select <colB> arrow
    Then <colA> is the primary sort column with green text and an upward arrow
    And <colB> is the secondary sort column with orange text and an upward arrow
    And the entries in <colA> column are in descending order
    And the entries in <colB> column are in descending order within each value in <colA> column
    When I select <colC> text
    Then <colC> is the primary sort column with green text and an downward arrow
    And <colA> is the secondary sort column with orange text and an upward arrow
    And the entries in <colC> column are in ascending order
    And the entries in <colA> column are in descending order within each value in <colA> column
    When I select <colB> text
    Then <colB> is the primary sort column with green text and an downward arrow
    And <colC> is the secondary sort column with orange text and an downward arrow
    And the entries in <colB> column are in ascending order
    And the entries in <colC> column are in ascending order within each value in <colA> column
    When I refresh the browser
    And The trains list table is visible
    Then PUNCT. is the primary sort column with green text and an upward arrow
    And TIME is the secondary sort column with orange text and an downward arrow
    And the entries in PUNCT. column are in descending order
    And the entries in TIME column are in ascending order within each value in PUNCT. column
    * the access plan located in CIF file 'access-plan/trains_list_sort_cancelled.cif' is received from LINX

    Examples:
      | columnsToInclude                   | colA  | colB   | colC   |
      | Origin, Destination, Schedule Type | DEST. | ORIGIN | SCHED. |
