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

    Scenario: Verify that columns tab is displayed with the available and selected tables
      Then I see the train list config tab title as 'Columns'
      And the following header can be seen on the columns
        | configColumnName |
        | Available        |
        | Selected         |

  Scenario: Trains list column config tab title with default selected and unselected entries
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

  Scenario: Moving all unselected to selected columns
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


  #33806 -3 Trains List Config (Column De-Selection)
    #Given the user is viewing the trains list config
    #And the user is viewing the column config tab
    #When the user selects a column from selected columns list to remove from the trains list view
    #Then the column item is moved to the un-selected columns list

  Scenario: Moving all selected to un-selected columns
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
  Scenario: Moving all selected to un-selected columns and verifying the changes are reflected in trains list
    When I click on all the selected column entries
    # Making changes to selected columns
    And I open 'trains list' page in a new tab
    Then I should see the trains list columns as
      | header           |
      | SERVICE          |
      | TIME             |
      | PUNCT.           |
