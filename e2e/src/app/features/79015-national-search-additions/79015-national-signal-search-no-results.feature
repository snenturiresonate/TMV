@TMVPhase2 @P2.S2
Feature: 79015 - TMV National Search Additions - signal search, no results
  As a TMV User
  I want an appropriate message when I search for items that do not exist

  Scenario Outline:82785-1 National Signal Search, no results - <pageName>
    #Given the user is authenticated to use TMV
    #And the user is viewing TMV screen with a national search in the title bar
    #When the user selects a signal search option
    #And the user enters at least two alphanumeric characters
    #And the user submits the search
    #And the number of results is zero
    #Then the No results found message is displayed
    Given I navigate to <pageName> page
    When I search Signal for 'XX'
    Then the signal search table is shown
    And the window title is displayed as 'Signal Search Results'
    And the signal results window shows no results found

    Examples:
      | pageName         |
      | Home             |
      | TrainsList       |
      | TimeTable        |
      | Maps             |
      | LogViewer        |
      | Admin            |
