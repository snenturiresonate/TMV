@TMVPhase2 @P2.S2
Feature: 80688 - TMV Punctuality Admin - Picker Arrows

  As a TMV Admin User
  I want the ability to update trains list punctuality
  So that it punctuality is inline with schematic map punctuality overriding the user's TL preference

   Scenario: 82777-1 - Picker Arrows

#    Given the user is authenticated to use TMV
#    And the user the admin privilege
#    When the user is viewing the admin display settings view
#    Then for the number control for punctuality settings are clear

    Given I have not already authenticated
    And I am on the admin page
    And The admin setting defaults are as originally shipped
    And I refresh the browser
    When I have navigated to the 'Display Settings' admin tab
    Then the number controls for the punctuality bands are clear
    When I make a note of the lower value for punctuality band 6
    And I decrease the lower value for punctuality band 6 by 4
    Then the lower value shown for punctuality band 6 is 4 less than before

