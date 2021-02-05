Feature: 46474 - Administration Display Settings - full end to end testing - trains indication

  As a tester
  I want to verify the administration page - Display Settings
  So, that I can identify if the build meet the end to end requirements

  Background:
    Given I am on the admin page

  Scenario: Trains indication table header
    Then the train indication header is displayed as 'Trains List Indication'

  @bug @bug_54385
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

  @bug @bug_54385
  Scenario: Trains indication table - Update and Save
    When I update the train list indication table as
      | name                     | colour | minutes | toggleValue |
      | Change of Origin         | #bb2   |         | on          |
      | Change of Identity       | #cc3   |         | on          |
      | Cancellation             | #dde   |         | off         |
      | Reinstatement            | #ff7   |         | off         |
      | Off-route                | #aac   |         | on          |
      | Next report overdue      | #bbc   | 15      | off         |
      | Origin Called            | #995   | 60      | on          |
      | Origin Departure Overdue | #356   | 10      | on          |
    And I save the punctuality settings
    And I navigate to the 'Login Message' admin tab
    And I navigate to the 'Display Settings' admin tab
    Then the following can be seen on the trains list indication table
      | name                     | colour  | minutes | toggleValue |
      | Change of Origin         | #bbbb22 |         | on          |
      | Change of Identity       | #cccc33 |         | on          |
      | Cancellation             | #ddddee |         | off         |
      | Reinstatement            | #ffff77 |         | off         |
      | Off-route                | #aaaacc |         | on          |
      | Next report overdue      | #bbbbcc | 15      | off         |
      | Origin Called            | #999955 | 60      | on          |
      | Origin Departure Overdue | #335566 | 10      | on          |
