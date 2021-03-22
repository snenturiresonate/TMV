Feature: 46474 - Administration Display Settings - full end to end testing - trains indication

  As a tester
  I want to verify the administration page - Display Settings
  So, that I can identify if the build meet the end to end requirements

  Background:
    Given I am on the admin page
    And The admin setting defaults are as originally shipped

  Scenario: Trains indication table header
    Then the train indication header is displayed as 'Trains List Indication'

  Scenario: Trains indication table
    Then the following can be seen on the trains list indication table
      | name                     | colour  | minutes | toggleValue |
      | Change of Origin         | #ffffff |         | on          |
      | Change of Identity       | #ffffff |         | on          |
      | Cancellation             | #ffffff |         | on          |
      | Reinstatement            | #ffffff |         | on          |
      | Off-route                | #ffffff |         | on          |
      | Next report overdue      | #0000ff | 15      | off         |
      | Origin Called            | #ffb578 | 15      | on          |
      | Origin Departure Overdue | #ffffff | 1       | on          |

  Scenario: Trains indication table - Update and Save
    When I update the train list indication table as
      | name                     | colour  | minutes | toggleValue |
      | Change of Origin         | #bb2    |         | on          |
    And I save the punctuality settings
    And I navigate to the 'Login Message' admin tab
    And I navigate to the 'Display Settings' admin tab
    Then the following can be seen on the trains list indication table
      | name                     | colour  | minutes | toggleValue |
      | Change of Origin         | #bbbb22 |         | on          |
      | Change of Identity       | #ffffff |         | on          |
      | Cancellation             | #ffffff |         | on          |
      | Reinstatement            | #ffffff |         | on          |
      | Off-route                | #ffffff |         | on          |
      | Next report overdue      | #0000ff | 15      | off         |
      | Origin Called            | #ffb578 | 15      | on          |
      | Origin Departure Overdue | #ffffff | 1       | on          |
