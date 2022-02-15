@TMVPhase2 @P2.S3
Feature: 80183 - TMV Trains List Filtering - Config - Picker Arrows

  As a TMV User
  I want the ability to config separate trains list filtering with enhanced functions
  So that I can set up different trains list for specific operational needs

  #  Given the user is authenticated to use TMV
  #  When the user is viewing the trains list config view
  #  Then for the number control for punctuality settings are clear
  #
  #  Comments:
  #  * check that the class is a plus or minus symbol

  Scenario: 82778-1 - Picker Arrows - Trains List Config View - Punctuality Settings
    Given I have not already authenticated
    And I am on the home page
    And I restore to default train list config '1'
    And I select the trains list 1 button from the home page
    And I switch to the new tab
    And I am on the trains list config 1 page
    When I have navigated to the 'Punctuality' configuration tab
    Then the trains list number controls for the punctuality bands are clear
