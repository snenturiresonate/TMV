Feature: 33806 - TMV User Preferences - full end to end testing - TL config - columns

  As a tester
  I want to verify the train list config tab - columns
  So, that I can identify if the build meets the end to end requirements

  #33806 -2 Trains List Config (Column Selection)
  #Given the user is viewing the trains list config
  #And the user is viewing the column config tab
  #When the user selects a column from un-selected columns list to add to the trains list view
  #Then the column item is moved to the selected columns list

  Background:
    Given I am on the trains list page 1
    And I restore to default train list config '1'
    And I refresh the browser

  Scenario: 33806 -2a Verify that columns tab is displayed with the available and selected tables
    Then I see the train list config tab title as 'Columns'
    And the following header can be seen on the columns
      | configColumnName |
      | Available        |
      | Selected         |

  Scenario: 33806 -2b Trains list column config tab title with default selected and unselected entries
    Then the following can be seen on the unselected column config
      | unSelectedColumn               | arrowType            |
      | TRUST ID                       | keyboard_arrow_right |
      | Schedule UID                   | keyboard_arrow_right |
      | Cancellation Reason Code       | keyboard_arrow_right |
      | Cancellation Type              | keyboard_arrow_right |
      | GBTT Destination Arrival Time  | keyboard_arrow_right |
      | GBTT Origin Departure Time     | keyboard_arrow_right |
      | Time expected at next Location | keyboard_arrow_right |
      | Last Reported Line             | keyboard_arrow_right |
      | Last Reported Platform         | keyboard_arrow_right |
      | Train Category                 | keyboard_arrow_right |
      | Train Service Code             | keyboard_arrow_right |
    And the following can be seen in the selected column config
      | arrowType           | ColumnName             |
      | keyboard_arrow_left | Schedule Type          |
      |                     | Service                |
      |                     | Last Reported Time     |
      | keyboard_arrow_left | Last Reported Location |
      |                     | Punctuality            |
      | keyboard_arrow_left | Origin                 |
      | keyboard_arrow_left | Destination            |
      | keyboard_arrow_left | Next location          |
      | keyboard_arrow_left | Operator               |

  Scenario: 33806 -2c Moving items within the selected columns
    When I move 'Up' the selected column item 'Service'
    And I move 'Down' the selected column item 'Last Reported Time'
    Then the following can be seen in the selected column config in the given order
      | arrowType           | ColumnName             |
      |                     | Service                |
      | keyboard_arrow_left | Schedule Type          |
      | keyboard_arrow_left | Last Reported Location |
      |                     | Last Reported Time     |
      |                     | Punctuality            |
      | keyboard_arrow_left | Origin                 |
      | keyboard_arrow_left | Destination            |
      | keyboard_arrow_left | Next location          |
      | keyboard_arrow_left | Operator               |

  Scenario: 33806 -2d Moving all unselected to selected columns
    When I click on all the unselected column entries
    Then the following can be seen in the selected column config
      | arrowType           | ColumnName                    |
      | keyboard_arrow_left | Schedule Type                 |
      |                     | Service                       |
      |                     | Last Reported Time            |
      | keyboard_arrow_left | Last Reported Location        |
      |                     | Punctuality                   |
      | keyboard_arrow_left | Origin                        |
      | keyboard_arrow_left | Destination                   |
      | keyboard_arrow_left | Next location                 |
      | keyboard_arrow_left | Operator                      |
      | keyboard_arrow_left | TRUST ID                      |
      | keyboard_arrow_left | Schedule UID                  |
      | keyboard_arrow_left | Cancellation Reason Code      |
      | keyboard_arrow_left | Cancellation Type             |
      | keyboard_arrow_left | GBTT Destination Arrival Time |
      | keyboard_arrow_left | GBTT Origin Departure Time    |
      | keyboard_arrow_left | Last Reported Line            |
      | keyboard_arrow_left | Last Reported Platform        |
      | keyboard_arrow_left | Train Category                |
      | keyboard_arrow_left | Train Service Code            |
    And the unselected column entries should be empty

  #33806 -3 Trains List Config (Column De-Selection)
    #Given the user is viewing the trains list config
    #And the user is viewing the column config tab
    #When the user selects a column from selected columns list to remove from the trains list view
    #Then the column item is moved to the un-selected columns list

  Scenario: 33806 -3 Moving all selected to un-selected columns
    When I click on all the selected column entries
    Then the following can be seen in the selected column config
    #below items cannot be moved from the selected column as they are mandatory
      | arrowType | ColumnName         |
      |           | Service            |
      |           | Last Reported Time |
      |           | Punctuality        |
    Then the following can be seen on the unselected column config
      | unSelectedColumn               | arrowType            |
      | TRUST ID                       | keyboard_arrow_right |
      | Schedule UID                   | keyboard_arrow_right |
      | Cancellation Reason Code       | keyboard_arrow_right |
      | Cancellation Type              | keyboard_arrow_right |
      | GBTT Destination Arrival Time  | keyboard_arrow_right |
      | GBTT Origin Departure Time     | keyboard_arrow_right |
      | Time expected at next Location | keyboard_arrow_right |
      | Last Reported Line             | keyboard_arrow_right |
      | Last Reported Platform         | keyboard_arrow_right |
      | Train Category                 | keyboard_arrow_right |
      | Train Service Code             | keyboard_arrow_right |
      | Schedule Type                  | keyboard_arrow_right |
      | Last Reported Location         | keyboard_arrow_right |
      | Origin                         | keyboard_arrow_right |
      | Destination                    | keyboard_arrow_right |
      | Next location                  | keyboard_arrow_right |
      | Operator                       | keyboard_arrow_right |

        #33806 -4 Trains List Config (Column Applied)
    #Given the user has made changes to the trains list columns selection
    #When the user views the trains list
    #Then the view is updated to reflect the user's column selection
  Scenario: 33806 -4a Moving all selected to un-selected columns and verifying the changes are reflected in trains list
    When I click on all the selected column entries
    And There is an unsaved indicator
    And I save the trains list config
    And There is no unsaved indicator
    And I am on the trains list page 1
    Then I should see the trains list columns as
      | header  |
      | SERVICE |
      | TIME    |
      | PUNCT.  |
    And I restore to default train list config '1'

  Scenario: 33806 -4b Selecting the 'origin' column includes the columns 'Origin', 'Planned' & 'Actual/Predict' columns in trains list
    When I set trains list columns to include 'Origin' along with the mandatory columns
    And There is an unsaved indicator
    And I save the trains list config
    And There is no unsaved indicator
    And I am on the trains list page 1
    Then I should see the trains list columns as
      | header           |
      | SERVICE          |
      | TIME             |
      | PUNCT.           |
      | ORIGIN           |
      | PLANNED          |
      | ACTUAL / PREDICT |
    And I restore to default train list config '1'

  Scenario: 33806 -4c Selecting the 'Destination' column includes the columns 'Dest.', 'Planned' & 'Actual/Predict' columns in trains list
    When I set trains list columns to include 'Destination' along with the mandatory columns
    And There is an unsaved indicator
    And I save the trains list config
    And There is no unsaved indicator
    And I am on the trains list page 1
    Then I should see the trains list columns as
      | header           |
      | SERVICE          |
      | TIME             |
      | PUNCT.           |
      | DEST.            |
      | PLANNED          |
      | ACTUAL / PREDICT |
    And I restore to default train list config '1'

  Scenario: 33806 -4d Changing the order of the selected column items and verifying the changes are reflected in trains list
    When I move 'Up' the selected column item 'Service'
    And I move 'Down' the selected column item 'Last Reported Time'
    And There is an unsaved indicator
    And I save the trains list config
    And There is no unsaved indicator
    And I am on the trains list page 1
    Then I should see the trains list columns as
      | header           |
      | SERVICE          |
      | SCHED.           |
      | REPORT           |
      | TIME             |
      | PUNCT.           |
      | ORIGIN           |
      | PLANNED          |
      | ACTUAL / PREDICT |
      | DEST.            |
      | PLANNED          |
      | ACTUAL / PREDICT |
      | NEXT LOC.        |
      | OPERATOR         |
    And I restore to default train list config '1'

