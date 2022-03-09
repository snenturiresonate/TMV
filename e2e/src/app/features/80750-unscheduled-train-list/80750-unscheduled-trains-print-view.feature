@TMVPhase2 @P2.S4
Feature: 80750 - unscheduled trains print view

  As a TMV User
  I want to view unscheduled trains
  So that I can determine if print view is available

  Background:
    * I generate a new train description
    * I generate a new trainUID

#    Given the user is authenticated to use TMV
#    And the user has opened an unscheduled trains list
#    And the user views the unscheduled trains list
#    When the user selects the print option
#    Then the user is presented with the print view of the unscheduled trains list
#
#    Comments:
#         The print option is the browser specific print function

  Scenario Outline: 81291-1 Print a unscheduled trains page
    Given the following live berth interpose message is sent from LINX (to indicate train is present)
      | toBerth | trainDescriber | trainDescription |
      | 0523    | D6             | <trainNum>       |
    When I navigate to UnscheduledTrains page
    Then I click on Print view button of unscheduledTrains page
#    The following step to check the content will be done via manual test
#    And the print dialog box is displayed with <trainNum> data
    Examples:
      | trainNum |
      | 2B01     |
