@bug @bug_55994
Feature: 33806 - TMV User Preferences - full end to end testing

  As a tester
  I want to verify the train list config tab - columns
  So, that I can identify if the build meets the end to end requirements

  #33806 -2 Trains List Config (Column Selection)
  #Given the user is viewing the trains list config
  #And the user is viewing the column config tab
  #When the user selects a column from un-selected columns list to add to the trains list view
  #Then the column item is moved to the selected columns list

  Background:
    Given I am on the trains list Config page

    Scenario: 33806 -2a Verify that columns tab is displayed with the available and selected tables
      Then I see the train list config tab title as 'Columns'
      And the following header can be seen on the columns
        | configColumnName |
        | Available        |
        | Selected         |

  Scenario: 33806 -2b Trains list column config tab title with default selected and unselected entries
    Then the following can be seen on the unselected column config
      | unSelectedColumn        |arrowType            |
      | TRUST UID               |keyboard_arrow_right |
      | Schedule UID            |keyboard_arrow_right |
      | Cancellation Reason Code|keyboard_arrow_right |
      | Last Reported           |keyboard_arrow_right |
      | Cancellation Type       |keyboard_arrow_right |
      | Train Category          |keyboard_arrow_right |
      | Train Service Code      |keyboard_arrow_right |
    And the following can be seen in the selected column config
      | arrowType           | ColumnName      |
      | keyboard_arrow_left | Schedule        |
      |                     | Service         |
      |                     | Time            |
      | keyboard_arrow_left | Report          |
      |                     | Punctuality     |
      | keyboard_arrow_left | Origin          |
      | keyboard_arrow_left | Destination     |
      | keyboard_arrow_left | Next location   |
      | keyboard_arrow_left | TOC/FOC         |

  Scenario: 33806 -2c Moving all unselected to selected columns
    When I click on all the unselected column entries
    Then the following can be seen in the selected column config
      | arrowType           | ColumnName               |
      | keyboard_arrow_left | Schedule                 |
      |                     | Service                  |
      |                     | Time                     |
      | keyboard_arrow_left | Report                   |
      |                     | Punctuality              |
      | keyboard_arrow_left | Origin                   |
      | keyboard_arrow_left | Destination              |
      | keyboard_arrow_left | Next location            |
      | keyboard_arrow_left | TOC/FOC                  |
      | keyboard_arrow_left | TRUST UID                |
      | keyboard_arrow_left | Schedule UID             |
      | keyboard_arrow_left | Cancellation Reason Code |
      | keyboard_arrow_left | Last Reported            |
      | keyboard_arrow_left | Cancellation Type        |
      | keyboard_arrow_left | Train Category           |
      | keyboard_arrow_left | Train Service Code       |
    And the unselected column entries should be empty

  Scenario: 33806 -2d Moving items within the selected columns
  When I move 'Up' the selected column item 'Service'
    And I move 'Down' the selected column item 'Time'
    Then the following can be seen in the selected column config in the given order
      | arrowType           | ColumnName      |
      |                     | Service         |
      | keyboard_arrow_left | Schedule        |
      | keyboard_arrow_left | Report          |
      |                     | Time            |
      |                     | Punctuality     |
      | keyboard_arrow_left | Origin          |
      | keyboard_arrow_left | Destination     |
      | keyboard_arrow_left | Next location   |
      | keyboard_arrow_left | TOC/FOC         |

  #33806 -3 Trains List Config (Column De-Selection)
    #Given the user is viewing the trains list config
    #And the user is viewing the column config tab
    #When the user selects a column from selected columns list to remove from the trains list view
    #Then the column item is moved to the un-selected columns list

  Scenario: 33806 -3 Moving all selected to un-selected columns
    When I click on all the selected column entries
    Then the following can be seen in the selected column config
    #below items cannot be moved from the selected column as they are mandatory
      | arrowType | ColumnName  |
      |           | Service     |
      |           | Time        |
      |           | Punctuality |
    Then the following can be seen on the unselected column config
      | unSelectedColumn         | arrowType            |
      | TRUST UID                | keyboard_arrow_right |
      | Schedule UID             | keyboard_arrow_right |
      | Cancellation Reason Code | keyboard_arrow_right |
      | Last Reported            | keyboard_arrow_right |
      | Cancellation Type        | keyboard_arrow_right |
      | Train Category           | keyboard_arrow_right |
      | Train Service Code       | keyboard_arrow_right |
      | Schedule                 | keyboard_arrow_right |
      | Report                   | keyboard_arrow_right |
      | Origin                   | keyboard_arrow_right |
      | Destination              | keyboard_arrow_right |
      | Next location            | keyboard_arrow_right |
      | TOC/FOC                  | keyboard_arrow_right |

        #33806 -4 Trains List Config (Column Applied)
    #Given the user has made changes to the trains list columns selection
    #When the user views the trains list
    #Then the view is updated to reflect the user's column selection

  @tdd
  Scenario: 33806 -4a Moving all selected to un-selected columns and verifying the changes are reflected in trains list
    When I click on all the selected column entries
    # Making changes to selected columns
    And I open 'trains list' page in a new tab
    Then I should see the trains list columns as
      | header           |
      | SERVICE          |
      | TIME             |
      | PUNCT.           |

  @tdd
  Scenario: 33806 -4b Changing the order of the selected column items and verifying the changes are reflected in trains list
    When I move 'Up' the selected column item 'Service'
    And I move 'Down' the selected column item 'Time'
    And I open 'trains list' page in a new tab
    Then I should see the trains list columns as
      | header        |
      | Service       |
      | Schedule      |
      | Report        |
      | Time          |
      | Punctuality   |
      | Origin        |
      | Destination   |
      | Next location |
      | TOC/FOC       |

  @tdd
  Scenario: 33806 -4c Selecting the 'origin' column includes the columns 'Origin', 'Planned' & 'Actual/Predict' columns in trains list
  When I set trains list columns to include 'Origin' along with the mandatory columns
    And I open 'trains list' page in a new tab
    Then I should see the trains list columns as
      | header         |
      | SERVICE        |
      | TIME           |
      | PUNCT.         |
      | ORIGIN         |
      | PLANNED        |
      | ACTUAL/PREDICT |

  @tdd
  Scenario: 33806 -4d Selecting the 'Destination' column includes the columns 'Dest.', 'Planned' & 'Actual/Predict' columns in trains list
    When I set trains list columns to include 'Destination' along with the mandatory columns
    And I open 'trains list' page in a new tab
    Then I should see the trains list columns as
      | header         |
      | SERVICE        |
      | TIME           |
      | PUNCT.         |
      | DEST.          |
      | PLANNED        |
      | ACTUAL/PREDICT |

