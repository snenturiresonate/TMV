@TMVPhase2 @P2.S3
Feature: 80365 - TMV Enquiries - Date Picker Validation - End Date
  As a TMV User
  I want the ability update the enquires selection criteria
  So that I can filter the enquires trains to my business needs

  #  Given the user is authenticated to use TMV
  #  When the user selects an enquiry
  #  And is viewing the selection criteria view
  #  And attempts to change the end date
  #  Then the system will only allow the current or next date to be selected
  #  And with start date time before end date time
  #
  #  Comments:
  #  * The end date can be the current or next date ("today or tomorrow")
  #  * Start date time must be before end date time

  Scenario: 91954-1 - Enquiries - Date Picker Validation - end date - current date and time is allowed
    Given I am on the enquiries page
    And I give the system and enquiry times 2 seconds to synchronise
    When I set the end time to now - 0 minutes
    Then no validation error is displayed

  Scenario: 91954-2a - Enquiries - Date Picker Validation - end date - future time is allowed
    Given I am on the enquiries page
    When I set the end time to now + 60 minutes
    Then no validation error is displayed

  Scenario: 91954-2b - Enquiries - Date Picker Validation - end date - tomorrow date is allowed
    Given I am on the enquiries page
    When I set the end date to tomorrow
    Then no validation error is displayed

  Scenario: 91954-3 - Enquiries - Date Picker Validation - end date - yesterday date is not allowed
    Given I am on the enquiries page
    When I set the end date to yesterday
    Then a validation error is displayed

  Scenario: 91954-4 - Enquiries - Date Picker Validation - end date - time before start time is not allowed
    Given I am on the enquiries page
    When I set the end time to now - 120 minutes
    Then a validation error is displayed
