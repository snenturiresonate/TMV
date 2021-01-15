@tdd
Feature: 46448 - TMV Trains List
  (From Gherkin for Feature 33764)

  As a TMV User
  I want the ability to have a tabular view of live trains that is filtered
  So that I have tailored list trains that I am interested in

  Background:
    Given the access plan located in CIF file 'access-plan/trains_list_test.cif' is amended so that all services start within the next hour and then received from LINX

  Scenario Outline: 33764-1 Access Trains List (First Time)
#    Given the user is authenticated to use TMV
#    And the user is viewing the home page
#    And the user has not opened the trains list before
#    When the user selects the trains list
#    Then the trains list opened in a new browser tab with all default columns (system) and filters applied
#    And is populated with a selection of services based on activation, unscheduled and cancelled states
    Given I am authenticated to use TMV
    And I have not opened the trains list before
    And I am on the home page
    When I click the app 'trains-list'
    Then the number of tabs open is 2
    When I switch to the new tab
    Then the url contains 'trains-list'
    And The trains list table is visible
    And The default trains list columns are displayed in order
    And A selection of services are shown which match the default filters and settings
    And '<filteredServices>' are then displayed
    And '<filteredOutServices>' are not displayed

    Examples:
      | filteredServices | filteredOutServices |
      | 2P77, 3J41       | 3J41                |

  Scenario Outline: 33764-2 Access Trains List (User Configured)
#    Given the user is authenticated to use TMV
#    And the user is viewing the home page
#    And the user has opened the trains list before
#    And the user applied column selections and filters
#    When the user selects the trains list
#    Then the trains list opened in a new browser tab with column selection and filters applied
#    And is populated with a selection of services based on activation, unscheduled and cancelled states
    Given I am authenticated to use TMV
    And I am on the trains list Config page
    And I set trains list columns to be '<columns>'
    And I have navigated to the 'TOC/FOC' configuration tab
    And I set toc filters to be '<tocs>'
    And I have navigated to the 'Misc' configuration tab
    And I set class filters to be '<classes>'
    And I set 'Ignore PD Cancels' to be '<ignorePDCancelsFlag>'
    And I set 'Uncalled' to be '<uncalledFlag>'
    And I set 'Unmatched' to be '<unmatchedFlag>'
    And I set Time to Appear Before to be '60'
    And I am on the home page
    When I click the app 'trains-list'
    Then the number of tabs open is 2
    When I switch to the new tab
    Then the url contains 'trains-list'
    And The trains list table is visible
    And The configured trains list columns are displayed in order
    And '<filteredServices>' are then displayed
    And '<filteredOutServices>' are not displayed
    And A selection of services are shown which match the configured filters and settings

    Examples:
      | columns                                                                  | tocs                        | classes          | ignorePDCancelsFlag | uncalledFlag | unmatchedFlag | filteredServices | filteredOutServices          |
      | Schedule, Time, Service, Origin, Destination, Punctuality, Last Reported | Great Western Railways (GW) | Class 1, Class 2 | off                 | on           | on            | 2P77             | 5G44, 1M34, 1Z27, 3J41, 2C45 |

