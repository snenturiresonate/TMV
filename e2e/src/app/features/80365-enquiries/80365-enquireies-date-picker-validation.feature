@TMVPhase2 @P2.S3
Feature: 80365 - TMV Enquiries - Date Picker Validation - Start Date
  As a TMV User
  I want the ability update the enquires selection criteria
  So that I can filter the enquires trains to my business needs

  #  Given the user is authenticated to use TMV
  #  When the user selects an enquiry
  #  And is viewing the selection criteria view
  #  And attempts to change the start date
  #  Then the system will only allow the current or previous date to be selected
  #  And with start date time before end date time
  #
  #  Comments:
  #    * The start date can be the current or previous date
  #    * Start date time must be before end date time

  Scenario: 81202-1 - Enquiries - Date Picker Validation - start date - current date and time is allowed
    Given I am on the enquiries page
    And I give the system and enquiry times 2 seconds to synchronise
    When I set the start time to now - 0 minutes
    Then no validation error is displayed

  Scenario: 81202-2a - Enquiries - Date Picker Validation - start date - past time is allowed
    Given I am on the enquiries page
    When I set the start time to now - 60 minutes
    Then no validation error is displayed

  Scenario: 81202-2b - Enquiries - Date Picker Validation - start date - previous date is allowed
    Given I am on the enquiries page
    When I set the start date to yesterday
    Then no validation error is displayed

  Scenario: 81202-3a - Enquiries - Date Picker Validation - start date - future time is allowed
    Given I am on the enquiries page
    When I set the start time to now + 60 minutes
    Then no validation error is displayed

  Scenario: 81202-3b - Enquiries - Date Picker Validation - start date - future date is not allowed
    Given I am on the enquiries page
    When I set the start date to tomorrow
    Then a validation error is displayed

  Scenario: 81202-4 - Enquiries - Date Picker Validation - start date - start time after end time is not allowed
    Given I am on the enquiries page
    When I set the start time to now + 120 minutes
    Then a validation error is displayed
