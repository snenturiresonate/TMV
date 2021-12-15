Feature: 78858 - TMV Replay Controls & Display - Replay Duration Dropdown
  As a TMV User
  I want to the replay controls and view updated
  So that it is closer to CCF which I am familiar with

  Scenario: 78871-1 - Replay Duration Dropdown does not have a scroll bar
    # Given the user has open a replay session
    # And is viewing the replay session criteria window
    # When the user selects the duration option
    # Then the list of duration values are displayed without a scroll bar present
    Given I am on the replay page
    When I expand the replay duration dropdown
    Then the replay duration dropdown does not display a scroll bar
