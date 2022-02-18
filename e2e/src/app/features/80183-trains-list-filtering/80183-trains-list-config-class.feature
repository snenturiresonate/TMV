@TMVPhase2 @P2.S3
Feature: 80183 - TMV Trains List Filtering - Config - Class Validation

  As a TMV User
  I want the ability to config separate trains list filtering with enhanced functions
  So that I can set up different trains list for specific operational needs

  #  Given the user is authenticated to use TMV
  #  When the user views the trains list config
  #  And adjust the classes to filter against
  #  Then the system will require at least one class to be selected
  #
  #  Comments:
  #    * Change the Class config so that the user must select at least one

  Background:
    * I have not already authenticated
    Given I am on the home page
    And I restore to default train list config '1'
    And I am on the trains list page 1
    And I have navigated to the 'Train Class & MISC' configuration tab

  Scenario: 80344-1 - warning message is produced if the user selects no classes
    When I click on the Clear All button
    And the following can be seen on the class table
      | classValue | toggleValue |
      | Class 0    | off         |
      | Class 1    | off         |
      | Class 2    | off         |
      | Class 3    | off         |
      | Class 4    | off         |
      | Class 5    | off         |
      | Class 6    | off         |
      | Class 7    | off         |
      | Class 8    | off         |
      | Class 9    | off         |
    Then a validation error is displayed
    # cleanup
    * I click the reset button


  Scenario: 80344-2 - save button disappears if the user selects no classes
    When I click on the Clear All button
    And the following can be seen on the class table
      | classValue | toggleValue |
      | Class 0    | off         |
      | Class 1    | off         |
      | Class 2    | off         |
      | Class 3    | off         |
      | Class 4    | off         |
      | Class 5    | off         |
      | Class 6    | off         |
      | Class 7    | off         |
      | Class 8    | off         |
      | Class 9    | off         |
    Then the save button is not displayed
    # cleanup
    * I click the reset button


  Scenario: 80344-3 - no warning message is produced if the user selects one class
    When I click on the Clear All button
    And I set class filters to be 'Class 9'
    Then no validation error is displayed
    # cleanup
    * I click the reset button


  Scenario: 80344-4 - save button is displayed if the user selects one class
    When I click on the Clear All button
    And I set class filters to be 'Class 9'
    Then the save button is displayed
    # cleanup
    * I click the reset button


  Scenario: 80344-5 - no warning message is produced if the user selects all classes
    When I click on the Clear All button
    And the following can be seen on the class table
      | classValue | toggleValue |
      | Class 0    | off         |
      | Class 1    | off         |
      | Class 2    | off         |
      | Class 3    | off         |
      | Class 4    | off         |
      | Class 5    | off         |
      | Class 6    | off         |
      | Class 7    | off         |
      | Class 8    | off         |
      | Class 9    | off         |
    When I click on the Select All button
    And the following can be seen on the class table
      | classValue | toggleValue |
      | Class 0    | on          |
      | Class 1    | on          |
      | Class 2    | on          |
      | Class 3    | on          |
      | Class 4    | on          |
      | Class 5    | on          |
      | Class 6    | on          |
      | Class 7    | on          |
      | Class 8    | on          |
      | Class 9    | on          |
    Then no validation error is displayed
    # cleanup
    * I click the reset button


  Scenario: 80344-6 - save button is displayed if the user selects all classes
    When I click on the Clear All button
    And the following can be seen on the class table
      | classValue | toggleValue |
      | Class 0    | off         |
      | Class 1    | off         |
      | Class 2    | off         |
      | Class 3    | off         |
      | Class 4    | off         |
      | Class 5    | off         |
      | Class 6    | off         |
      | Class 7    | off         |
      | Class 8    | off         |
      | Class 9    | off         |
    When I click on the Select All button
    And the following can be seen on the class table
      | classValue | toggleValue |
      | Class 0    | on          |
      | Class 1    | on          |
      | Class 2    | on          |
      | Class 3    | on          |
      | Class 4    | on          |
      | Class 5    | on          |
      | Class 6    | on          |
      | Class 7    | on          |
      | Class 8    | on          |
      | Class 9    | on          |
    Then the save button is displayed
    # cleanup
    * I click the reset button
