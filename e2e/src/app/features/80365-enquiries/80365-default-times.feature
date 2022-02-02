@TMVPhase2 @P2.S3
Feature: 80365 - TMV Enquiries - Default Times

  As a TMV User
  When I open the enquiries page
  The dates and times in the select criteria view will contain appropriate defaults

#  Given the user is authenticated to use TMV
#  When the user selects an enquiry
#  And is viewing the selection criteria view
#  Then the date and times will contain default values

  Background:
    Given I am authenticated to use TMV

  Scenario: 81200-1 - TMV Enquiries - Default Times
    When I navigate to Enquiries page
    Then the enquiries start time is about 20 minutes ago
    And the enquiries end time is in about 100 minutes
