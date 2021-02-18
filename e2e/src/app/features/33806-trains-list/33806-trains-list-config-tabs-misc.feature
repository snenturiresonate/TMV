Feature: 33806 - TMV User Preferences - full end to end testing

  As a tester
  I want to verify the train list config tab - punctuality
  So, that I can identify if the build meets the end to end requirements

  Background:
    Given I am on the trains list Config page
    And I have navigated to the 'Misc' configuration tab

  #33806 -25 Trains List Config (Misc Settings View)
    #Given the user is viewing the trains list config
    #When the user selects the misc view
    #Then the user is presented with the misc settings view (defaulted to system settings)
  Scenario: 33806 -25 a Trains list misc config header
    Then the misc class header is displayed as 'Misc'

  Scenario: 33806 -25 b Trains list misc config default values
    Then the following can be seen on the class table
      | classValue | toggleValue |
      | Class 0    | on          |
      | Class 1    | on          |
      | Class 2    | off         |
      | Class 3    | on          |
      | Class 4    | on          |
      | Class 5    | off         |
      | Class 6    | on          |
      | Class 7    | off         |
      | Class 8    | on          |
      | Class 9    | on          |
    And the following toggle values can be seen on the right class table
      | classValue                         | toggleValue |
      | Ignore PD Cancels                  | on          |
      | Unmatched                          | on          |
      | Uncalled                           | off         |
      | Time to remain on list             | 5           |
      | Appear before current time on list | 5           |

  #33806 -26 Trains List Config (Misc Train Class On/Off)
    #Given the user is viewing the trains list train indication view
    #When the user uses the On/Off option for each train class
    #Then the options are changed accordingly

  Scenario: 33806 -26 a Trains list misc config Train class update
    When the following class table updates are made
    |classValue|toggleValue|
    |Class 0   |off         |
    | Class 1    | on          |
    | Class 2    | on         |
    | Class 3    | off          |
    | Class 4    | off          |
    Then the following can be seen on the class table
      | classValue | toggleValue |
      | Class 0    | off         |
      | Class 1    | on          |
      | Class 2    | on          |
      | Class 3    | off         |
      | Class 4    | off         |
      | Class 5    | off         |
      | Class 6    | on          |
      | Class 7    | off         |
      | Class 8    | on          |
      | Class 9    | on          |

  Scenario: 33806 -26 b Trains list misc config Train class update using - Select all
    When I click on the Select All button
    Then the following can be seen on the class table
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

  Scenario: 33806 -26 c Trains list misc config Train class update using - Clear all
    When I click on the Clear All button
    Then the following can be seen on the class table
      | classValue | toggleValue |
      | Class 0    | off          |
      | Class 1    | off          |
      | Class 2    | off          |
      | Class 3    | off          |
      | Class 4    | off          |
      | Class 5    | off          |
      | Class 6    | off          |
      | Class 7    | off          |
      | Class 8    | off          |
      | Class 9    | off          |

  #33806 -27 Trains List Config (Misc Ignore PD On/Off)
    #Given the user is viewing the trains list train indication view
    #When the user uses the On/Off option to ignore trains that have a state of PD
    #Then the options are changed accordingly

  #33806 - 28 Trains List Config (Misc Unmatched Train On/Off)
    #Given the user is viewing the trains list train indication view
    #When the user uses the On/Off option omit unmatched trains
    #Then the options are changed accordingly

  #33806 -29 Trains List Config (Misc Uncalled Trains On/Off)
    #Given the user is viewing the trains list train indication view
    #When the user uses the On/Off option to omit uncalled trains
    #Then the options are changed accordingly

  #33806 -30 Trains List Config (Misc Remain on List)
    #Given the user is viewing the trains list train indication view
    #When the user enters a minute value
    #Then the time to remain on the trains list is changed accordingly

  Scenario: 33806 -27, 28, 29, 30 Trains list misc config Ignore PD update
    When I update the following misc options
      | classValue                         | toggleValue |
      | Ignore PD Cancels                  | on          |
      | Unmatched                          | on          |
      | Uncalled                           | off         |
      | Time to remain on list             | 5           |
      | Appear before current time on list | 5           |
    Then the following toggle values can be seen on the right class table
      | classValue                         | toggleValue |
      | Ignore PD Cancels                  | on          |
      | Unmatched                          | on          |
      | Uncalled                           | off         |
      | Time to remain on list             | 5           |
      | Appear before current time on list | 5           |


