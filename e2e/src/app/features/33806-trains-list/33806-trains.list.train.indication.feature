Feature: 33806 - TMV User Preferences - full end to end testing

  As a tester
  I want to verify the train list config tab - train indication
  So, that I can identify if the build meets the end to end requirements

  Background:
    Given I am on the trains list Config page
    And I have navigated to the 'Train Indication' configuration tab

  Scenario: Trains list punctuality config header
    Then the train indication config header is displayed as 'Trains List Indication'

  #33806 -19 Trains List Config (Train Indication Settings View)
    #Given the user is viewing the trains list config
    #When the user selects the trains indication view
    #Then the user is presented with the train indication settings view (defaulted to system settings)
  Scenario: 33806 -19 Trains indication table default settings
    Then the following can be seen on the trains indication table of trains list config
      | name                      | colour  | minutes | toggleValue |
      | Change of Origin          | #cccc00 |         | on          |
      | Change of Identity        | #ccff66 |         | off         |
      | Cancellation              | #00ff00 |         | on          |
      | Reinstatement             | #00ffff |         | off         |
      | Off-route                 | #cc6600 |         | on          |
      | Next report overdue       | #ffff00 | 10      | off         |
      | Origin Called             | #9999ff | 50      | on          |
      | Origin Departure Overdue  | #339966 | 20      | on          |

  #33806 -20 Trains List Config (Change Trains Indication Colour Picker)
    #Given the user is viewing the trains list train indication view
    #When the user selects a colour from a timeband
    #Then the user is presented with a colour picker defaulted with the colour for the selected train indication type
  Scenario: 33806 -20 Trains indication table display of colour picker
  Then I should see the colour picker when any trains list colour box is clicked

  #33806 -21 Trains List Config (Change Trains Indication Select Colour)
    #Given the user is viewing the trains list train indication colour picker
    #When the user selects a colour or changes the hex value
    #Then the user colour picker is changed accordingly
    #And the user can now save the colour

  #33806 -22 Trains List Config (Change Train Indication On/Off)
    #Given the user is viewing the trains list train indication view
    #When the user uses the On/Off option for each of the train indication
    #Then the options are changed accordingly

  #33806 -23 Trains List Config (Change Train Indication Thresholds)
    #Given the user is viewing the trains list punctuality view
    #When the user selects the train indication thresholds
    #Then the minutes are changed accordingly
  Scenario: 33806 -21, 22, 23 Trains indication table settings update
    When I update the train list indication config settings as
    #Update to colour minutes & toggle to verify 33806 -21, 22 & 23
    | name                     | colour | minutes | toggleValue |
    | Change of Origin         | #bb2   |         | on          |
    | Change of Identity       | #cc3   |         | on          |
    | Cancellation             | #dde   |         | off         |
    | Reinstatement            | #ff7   |         | off         |
    | Off-route                | #aac   |         | on          |
    | Next report overdue      | #bbc   | 15      | off         |
    | Origin Called            | #995   | 60      | on          |
    | Origin Departure Overdue | #356   | 10      | on          |
    And I have navigated to the 'Columns' configuration tab
    And I have navigated to the 'Train Indication' configuration tab
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
