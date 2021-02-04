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
  Scenario: Trains list misc config header
    Then the misc class header is displayed as 'Misc'

  Scenario: Trains list misc config header
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
      | Ignore PD Cancels                  | on        |
      | Unmatched                          | on        |
      | Uncalled                           | off        |
      | Time to remain on list             | 5         |
      | Appear before current time on list | 5         |

