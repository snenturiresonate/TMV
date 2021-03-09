@newSession
Feature: 34380 - TMV Replay National Search

  As a TMV User
  I want the ability to search for schematic objects, trains and schedules within a replay session
  So that I can focus on a particular area of the railway or train

  Background:
    Given I am on the replay page as existing user
    And I load the replay data from scenario '33753-4 - View Timetable (Schedule Matched - Trains List)'
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw02reading.v'
    And I have set replay time and date from the recorded session
    And I select Start
    And I wait for the buffer to fill
@tdd @replayTest
    Scenario: 34380-1a Train search window shown - Train Search entering trainUid
      #Given the user is authenticated to use TMV replay
      #And the user is viewing TMV screen with a national search in the title bar
      #When the user selects a train search option (default)
      #And the user enters at least two alphanumeric characters
      #And the user submits the search
      #Then the trains search results list is displayed with zero or many results
      When I search Train for 'A'
      And Warning Message is displayed for minimum characters
      And I search Train for '#'
      And Warning Message is displayed for minimum characters
      And I search Train for 'A82345'
      Then results are returned with that planning UID 'A82345'
      And the Train search table is shown
      And the window title is displayed as 'Train Search Results'
      And I click close button at the bottom of table
      Then the Train search table is not shown
  @tdd @replayTest
  Scenario: 33757-2a Timetable search window shown - Warning message
    #Given the user is authenticated to use TMV replay
    #And the user is viewing TMV screen with a national search in the title bar
    #When the user selects a timetable search option
    #And the user enters at least two alphanumeric characters
    #And the user submits the search
    #Then the timetable search results list is displayed with zero or many results
    And the access plan located in CIF file 'access-plan/schedules_BS_type_O.cif' is received from LINX
    When I search Timetable for '1'
    Then Warning Message is displayed for minimum characters
    And I search Timetable for '&'
    And Warning Message is displayed for minimum characters

  @tdd @replayTest
  Scenario: 33757-2b Timetable search - all days
    And there is a Schedule for '4F07'
    And the schedule has schedule identifier characteristics
      | trainUid   | stpIndicator   | dateRunsFrom   |
      | A12345     | P              | 2020-01-01     |
    And the schedule has a Date Run to of '2050-01-01'
    And the schedule has a Days Run of all Days
    And the schedule is received from LINX
    When I search Timetable for '4F07'
    Then results are returned with that planning UID 'A12345'
  @tdd @replayTest
  Scenario: 33757-3 Signal search window shown
    #Given the user is authenticated to use TMV replay
    #And the user is viewing TMV screen with a national search in the title bar
    #When the user selects a signal search option
    #And the user enters at least two alphanumeric characters
    #And the user submits the search
    #Then the signal search results list is displayed with zero or many results
    When I search Signal for 'A'
    And Warning Message is displayed for minimum characters
    And I search Signal for '#'
    And Warning Message is displayed for minimum characters
    And I search Signal for 'SN259'
    Then results are returned with that signal ID 'SN259'
    And the window title is displayed as 'Signal Search Results'
    And I click close button at the bottom of table
  @tdd @replayTest
 Scenario: 34380-4 National Train Search Selection
  #Given the user is authenticated to use TMV replay
  #And the user is viewing the train search results pop-up
  #When the user selects a train from search result by using the secondary mouse click
  #Then the user is presented with a menu to either view the timetable or open a map(s) that contains the train
   And the access plan located in CIF file 'access-plan/schedules_BS_type_O.cif' is received from LINX
   And the following berth interpose message is sent from LINX
     | timestamp | toBerth   | trainDescriber     | trainDescription   |
     | 10:02:06  | 0209      | D3 		             | 1F23  		          |
   And I search Train for 'A82345'
   And results are returned with that planning UID 'A82345'
   And the Train search table is shown
   And the window title is displayed as 'Train Search Results'
   And I invoke the context menu from trains '1'
   And I wait for the train search context menu to display
   And the trains context menu is displayed
   And the train search context menu contains 'Open timetable' on line 1
   And the train search context menu contains 'Select maps' on line 2
   Then the following map names can be seen
     |mapName|
     |HDGW02 |
  @tdd @replayTest
  Scenario: 34380-5 National Timetable Search Selection
#    Given the user is authenticated to use TMV replay
#    And the user is viewing the timetable search results pop-up
#    When the user selects a timetable from search result by using the secondary mouse click
#    Then the user is presented with a menu to either view the timetable or open a map(s) that contains the train (if running)
    And the access plan located in CIF file 'access-plan/schedules_BS_type_O.cif' is received from LINX
    And the following berth interpose message is sent from LINX
      | timestamp | toBerth   | trainDescriber     | trainDescription   |
      | 10:02:06  | 0209      | D3 		             | 1F23  		          |
    And I search Timetable for 'A82345'
    And results are returned with that planning UID 'A82345'
    And the timetable search table is shown
    And the window title is displayed as 'Timetable Search Results'
    And I invoke the context menu from an Active service in the Timetable list
    And I wait for the timetable search context menu to display
    And the timetable context menu is displayed
    And the train search context menu contains 'Open timetable' on line 1
    And the train search context menu contains 'Select maps' on line 2
    Then the following map names can be seen
      |mapName|
      |EA02   |
      |EA2A   |
      |EA03   |
  @tdd @replayTest
  Scenario: 34380-6 National Signal Search Selection
#    Given the user is authenticated to use TMV replay
#    And the user is viewing the signal search results pop-up
#    When the user selects a train from search result by using the secondary mouse click
#    Then the user is presented with a menu open a map(s) that contains the signal
    And the access plan located in CIF file 'access-plan/schedules_BS_type_O.cif' is received from LINX
    And the following berth interpose message is sent from LINX
      | timestamp | toBerth   | trainDescriber     | trainDescription   |
      | 10:02:06  | 0209      | D3 		             | 1F23  		          |
    And I search Signal for 'A82345'
    And results are returned with that planning UID 'A82345'
    And the signal search table is shown
    And the window title is displayed as 'Signal Search Results'
    And I invoke the context menu from signal 1
    And I wait for the signal search context menu to display
    And the signal context menu is displayed
    And the 'signal' search context menu contains 'Select maps' on line 1
    Then the following map names can be seen
      |mapName|
      |EA02   |
      |EA2A   |
      |EA03   |
  @tdd @replayTest
  Scenario: 34380-7 National Train Search Highlight
#    Given the user is authenticated to use TMV replay
#    And the user is viewing the train search results
#    When the user selects a map from the train search results
#    Then the user is presented with a map that contains the train
#    And the train is highlighted for a brief period
    And the access plan located in CIF file 'access-plan/schedules_BS_type_O.cif' is received from LINX
    And the following berth interpose message is sent from LINX
      | timestamp | toBerth   | trainDescriber     | trainDescription   |
      | 10:02:06  | 0209      | D3 		             | 1F23  		          |
    And I search Signal for 'A82345'
    And results are returned with that planning UID 'A82345'
    And the signal search table is shown
    And the window title is displayed as 'Signal Search Results'
    And I invoke the context menu from signal 1
    And I wait for the signal search context menu to display
    And the signal context menu is displayed
    And the 'signal' search context menu contains 'Select maps' on line 1
    Then the following map names can be seen
      |mapName|
      |EA02   |
      |EA2A   |
      |EA03   |
