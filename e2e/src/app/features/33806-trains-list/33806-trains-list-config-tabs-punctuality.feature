Feature: 33806 - TMV User Preferences - full end to end testing

  As a tester
  I want to verify the train list config tab - punctuality
  So, that I can identify if the build meets the end to end requirements

  #33806 -5 Trains List Config (Punctuality Settings View)
  #Given the user is viewing the trains list config
  #When the user selects the punctuality view
  #Then the user is presented with the punctuality settings view (defaulted to system settings)

  Background:
    Given I am on the trains list Config page
    And I have navigated to the 'Punctuality' configuration tab

  Scenario: Trains list punctuality config header
    Then the punctuality header is displayed as 'Punctuality'

  Scenario: Trains list punctuality config default color and entries
    Then the following can be seen on the punctuality table
      | punctualityColorText | fromTime | toTime | entryValue               |
      | #ffb4b4              |          | -20    | 20 minutes or more early |
      | #e5b4ff              | -20      | -10    | 10 to 19 minutes early   |
      | #78e7ff              | -10      | -5     | 5 to 9 minutes early     |
      | #78ff78              | -5       | -1     | 1 to 4 minutes early     |
      | #00ff00              | -1       | 1      | Right Time               |
      | #ffff00              | 1        | 5      | 1 to 4 minutes late      |
      | #ffa700              | 5        | 10     | 5 to 9 minutes late      |
      | #ff0000              | 10       | 20     | 10 to 19 minutes late    |
      | #ff009c              | 20       |        | 20 minutes or more late  |

  #33806 -6 Trains List Config (Change Punctuality Colour Picker)
    #Given the user is viewing the trains list punctuality view
    #When the user selects a colour from a timeband
    #Then the user is presented with a colour picker defaulted with the colour for the selected timeband

  Scenario: Verify if the colour picker is displayed when user clicks on punctuality colour
    Then I should see the colour picker when any punctuality colour box is clicked

  Scenario: Verify if the colour picker is defaulted with the colour for the selected time-band
    Then I should see the colour picker is defaulted with the colour for the selected time-band

  #33806 -7 Trains List Config (Change Punctuality Select Colour)
    #Given the user is viewing the trains list punctuality colour picker
    #When the user selects a colour or changes the hex value
    #Then the user colour picker is changed accordingly
    #And the user can now save the colour

  #33806 -8 Trains List Config (Change Punctuality Timeband)
    #Given the user is viewing the trains list punctuality view
    #When the user uses the up/down buttons for either the upper or lower timeband minute
    #Then the minutes are changed accordingly

  #33806 -9 Trains List Config (Change Punctuality Text)
    #Given the user is viewing the trains list punctuality view
    #When the user selects the timeband text
    #Then the text is changed accordingly

  Scenario: Trains list punctuality config update
  #This scenario verified the above three FE2E scenarios
    When I update the trains list punctuality settings as
      | punctualityColorText | fromTime | toTime | entryValue                   |
      #End time-bands blanked out
      | #bb2                 |          | -21    | 21 to 22 minutes early-edit  |
      | #cc3                 | -20      | -11    | 11 to 20 minutes early-edit  |
      | #dde                 | -10      | -5     | 5 to 10 minutes early-edit   |
      | #ff7                 | -4       | -1     | 1 to 4 minutes early-edit    |
      | #aac                 | 0        | 0      | Right Time                   |
      | #bbc                 | 1        | 5      | 1 to 5 minutes late-edit     |
      #Time-band overlapping with previous
      | #c4d                 | 3        | 10     | 3 to 10 minutes late-edit    |
      #Time-band With gap of 5 mins from previous
      | #de7                 | 15       | 20     | 15 to 20 minutes late-edit    |
      | #ff6                 | 21       |        | 21 minutes or more late-edit |
    Then the following can be seen on the punctuality table
      | punctualityColorText | fromTime | toTime | entryValue                   |
      | #bbbb22              |          | -21    | 21 to 22 minutes early-edit  |
      | #cccc33              | -20      | -11    | 11 to 20 minutes early-edit  |
      | #ddddee              | -10      | -5     | 5 to 10 minutes early-edit   |
      | #ffff77              | -4       | -1     | 1 to 4 minutes early-edit    |
      | #aaaacc              | 0        | 0      | Right Time                   |
      | #bbbbcc              | 1        | 5      | 1 to 5 minutes late-edit     |
      | #cc44dd              | 3        | 10     | 3 to 10 minutes late-edit    |
      | #ddee77              | 15       | 20     | 15 to 20 minutes late-edit   |
      | #ffff66              | 21       |        | 21 minutes or more late-edit |

  Scenario: Trains list punctuality config update
    When I update the trains list punctuality settings as
      | punctualityColorText | fromTime | toTime | entryValue                   |
      | #bb2                 |          | -21    | 21 to 22 minutes early-edit  |
      | #cc3                 | -20      | -11    | 11 to 20 minutes early-edit  |
      | #dde                 | -10      | -5     | 5 to 10 minutes early-edit   |
      | #ff7                 | -4       | -1     | 1 to 4 minutes early-edit    |
      | #aac                 | 0        | 0      | Right Time                   |
      | #bbc                 | 1        | 5      | 1 to 5 minutes late-edit     |
      | #c4d                 | 6        | 10     | 6 to 10 minutes late-edit    |
      | #de7                 | 11       | 20     | 11 to 20 minutes late-edit   |
      | #ff6                 | 21       |        | 21 minutes or more late-edit |
    And I have navigated to the 'Columns' configuration tab
    And I have navigated to the 'Punctuality' configuration tab
    Then the following can be seen on the punctuality table
      | punctualityColorText | fromTime | toTime | entryValue                   |
      | #bbbb22              |          | -21    | 21 to 22 minutes early-edit  |
      | #cccc33              | -20      | -11    | 11 to 20 minutes early-edit  |
      | #ddddee              | -10      | -5     | 5 to 10 minutes early-edit   |
      | #ffff77              | -4       | -1     | 1 to 4 minutes early-edit    |
      | #aaaacc              | 0        | 0      | Right Time                   |
      | #bbbbcc              | 1        | 5      | 1 to 5 minutes late-edit     |
      | #cc44dd              | 6        | 10     | 6 to 10 minutes late-edit    |
      | #ddee77              | 11       | 20     | 11 to 20 minutes late-edit   |
      | #ffff66              | 21       |        | 21 minutes or more late-edit |


  #33806 -10 Trains List Config (Punctuality Applied)
    #Given the user has made changes to the trains list punctuality
    #When the user views the trains list
    #Then the view is updated to reflect the user's punctuality changes
    @tdd
    Scenario: Verify if the trains list punctuality config update is reflected in trains list table
      When I update the trains list punctuality settings as
        | punctualityColorText | fromTime | toTime | entryValue                   |
      #End time-bands blanked out
        | #bb2                 |          | -21    | 21 to 22 minutes early-edit  |
        | #cc3                 | -20      | -11    | 11 to 20 minutes early-edit  |
        | #dde                 | -10      | -5     | 5 to 10 minutes early-edit   |
        | #ff7                 | -4       | -1     | 1 to 4 minutes early-edit    |
        | #aac                 | 0        | 0      | Right Time                   |
        | #bbc                 | 1        | 5      | 1 to 5 minutes late-edit     |
      #Time-band overlapping with previous
        | #c4d                 | 3        | 5      | 3 to 5 minutes late-edit    |
        | #de7                 | 15       | 20     | 15 to 20 minutes late-edit   |
        | #ff6                 | 21       |        | 21 minutes or more late-edit |
    And I open 'trains list' page in a new tab
    Then I should see the punctuality colour for the time-bands as
      | punctualityColor   | fromTime | toTime |
      #End time-bands blanked out
      | rgb(187, 187, 34)  |          | -21    |
      | rgb(204, 204, 51)  | -20      | -11    |
      | rgb(221, 221, 238) | -10      | -5     |
      | rgb(255, 255, 119) | -4       | -1     |
      | rgb(170, 170, 204) | 0        | 0      |
      | rgb(187, 187, 204) | 1        | 5      |
      #Time-band overlapping with previous
      | rgb(0, 0, 0)       | 3        | 5      |
      #Colour for Time-band gap
      | rgb(0, 0, 0)       | 5        | 15     |
      | rgb(221, 238, 119) | 15       | 20     |
      | rgb(255, 255, 102) | 21       |        |

