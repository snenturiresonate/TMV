@bug @bug_58561
Feature: 34375 - TMV Replay Timetable - Open Timetable

  As a TMV User
  I want to view historic timetable during replay
  So that I can view what timetable the train was running to and its historic actuals

  @tdd @replayTest
  Scenario: 34375-1 Replay - Open Timetable from Map (colour)
#    Given the user is authenticated to use TMV replay
#    And the user is viewing a map
#    When the user selects a timetable to view
#    Then the timetable is rendered in the same colour as the replay map background
    Given I load the replay data from scenario '33753-2a -Open Timetable (from Map - Schedule Matched)'
    And I am on the replay page as existing user
    And I have set replay time and date from the recorded session
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    When I move the replay to the end of the captured scenario
    And I make a note of the main replay map background colour
    And I invoke the context menu on the map for train 1A02
    And I open timetable from the map context menu
    And I switch to the new tab
    Then the timetable background colour is the same as the map background colour

  @tdd @replayTest
  Scenario: 34375-2a Replay - Open Timetable (from Map - Schedule Matched)
#    Given the user is authenticated to use TMV replay
#    And the user is viewing a Replay map
#    When the user selects a train (occupied berth) from the map using the secondary click for a service which has been Schedule Matched
#    And selects the "open timetable" option from the menu
#    Then the train's timetable is opened in a new browser tab
    Given I load the replay data from scenario '33753-2a -Open Timetable (from Map - Schedule Matched)'
    And I am on the replay page as existing user
    And I have set replay time and date from the recorded session
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    When I select skip forward to just after replay scenario step '1'
    And I invoke the context menu on the map for train 1A02
    And I open timetable from the map context menu
    And I switch to the new tab
    And the tab title is 'TMV Replay Timetable 1A02'
#    And The values for the header properties are as follows
#      | schedType | lastSignal | lastReport | trainUid | trustId | lastTJM | headCode |
#      | LTP       |            |            | L10002   |         |         | 1A02     |

  @tdd @replayTest
  Scenario: 34375-2b Replay - Open Timetable (from Map - Unmatched)
#    Given the user is authenticated to use TMV replay
#    And the user is viewing a Replay map
#    When the user selects a train (occupied berth) from the map using the secondary click for a service which has been Schedule Matched
#    And selects the "open timetable" option from the menu
#    Then the train's timetable is opened in a new browser tab
    Given I load the replay data from scenario '33753-2b -Open Timetable (from Map - Unmatched)'
    And I am on the replay page as existing user
    And I have set replay time and date from the recorded session
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    When I select skip forward to just after replay scenario step '1'
    And I invoke the context menu on the map for train 1A03
    Then the map context menu contains 'No timetable' on line 2

  @tdd @replayTest
  Scenario Outline: 34375-3a Replay - Open Timetable (from Search Result - matched service (Train) and matched/unmatched services (Timetable) have timetables)
#    Given the user is authenticated to use TMV replay
#    And the user is viewing a search results list within Replay
#    When the user selects a search result using the secondary click
#    And selects the "open timetable" option from the menu
#    Then the timetable is opened in a new browser tab
    Given I load the replay data from scenario '33753-3a Open Timetable (from Search Result - matched service (Train) and matched/unmatched services (Timetable) have timetables)'
    And I am on the replay page as existing user
    And I have set replay time and date from the recorded session
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I move the replay to the end of the captured scenario
    And I search <searchType> for '<searchVal>'
    And the search table is shown
    When I invoke the context menu from a <serviceStatus> service in the <searchType> list
    And I wait for the '<searchType>' search context menu to display
    And the '<searchType>' context menu is displayed
    And the '<searchType>' search context menu contains 'Open timetable' on line 1
    And the '<searchType>' search context menu contains 'Select maps' on line 2
    And I click on timetable link
    And I switch to the new tab
    And the tab title contains 'TMV Replay Timetable'
    And the tab title contains the selected Train

    Examples:
      | searchType | searchVal | serviceStatus |
      | Train      | 1A        | ACTIVATED     |
      | Timetable  | 1A        | ACTIVATED     |
      | Timetable  | 1A        | UNMATCHED     |

    @tdd @replayTest
    Scenario Outline: 33753-3b Replay - Open Timetable (from Search Result - unmatched service (Train) has no timetable)
    Given I load the replay data from scenario '33753-3b Open Timetable (from Search Result - unmatched service (Train) has no timetable)'
    And I am on the replay page as existing user
    And I have set replay time and date from the recorded session
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I move the replay to the end of the captured scenario
    And I search <searchType> for '<searchVal>'
    And the search table is shown
    When I invoke the context menu from a <serviceStatus> service in the <searchType> list
    Then the '<searchType>' context menu is not displayed
    Examples:
      | searchType | searchVal | serviceStatus |
      | Train      | 1A        | UNMATCHED     |

