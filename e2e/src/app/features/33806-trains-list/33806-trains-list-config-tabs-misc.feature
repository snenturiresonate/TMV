Feature: 33806 - TMV User Preferences - full end to end testing - TL config - misc

  As a tester
  I want to verify the train list config tab - punctuality
  So, that I can identify if the build meets the end to end requirements

  Background:
    Given the access plan located in CIF file 'access-plan/trains_list_test.cif' is received from LINX
    And I remove all trains from the trains list
    And I am on the home page
    And I restore to default train list config
    And I am on the trains list Config page
    And I have navigated to the 'Misc' configuration tab

  #33806 -25 Trains List Config (Misc Settings View)
    #Given the user is viewing the trains list config
    #When the user selects the misc view
    #Then the user is presented with the misc settings view (defaulted to system settings)
  Scenario: 33806 -25 a Trains list misc config header
    Then the misc class header is displayed as 'Misc'

  #Step to reset to defaults using the delete end point needs to be implemented and added before the validations
  Scenario: 33806 -25 b Trains list misc config default values
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
    And the following toggle values can be seen on the right class table
      | classValue                         | toggleValue |
      | Ignore PD Cancels                  | on          |
      | Include unmatched                  | on          |
      | Time to remain on list             | 5           |
    # clean up
    * I restore to default train list config

  #33806 -26 Trains List Config (Misc Train Class On/Off)
    #Given the user is viewing the trains list train indication view
    #When the user uses the On/Off option for each train class
    #Then the options are changed accordingly

  Scenario: 33806 -26 a Trains list misc config Train class update
    When the following class table updates are made
      | classValue | toggleValue |
      | Class 0    | off         |
      | Class 1    | on          |
      | Class 2    | on          |
      | Class 3    | off         |
      | Class 4    | off         |
      | Class 5    | on          |
      | Class 6    | off         |
      | Class 7    | on          |
      | Class 8    | off         |
      | Class 9    | off         |
    Then the following can be seen on the class table
      | classValue | toggleValue |
      | Class 0    | off         |
      | Class 1    | on          |
      | Class 2    | on          |
      | Class 3    | off         |
      | Class 4    | off         |
      | Class 5    | on          |
      | Class 6    | off         |
      | Class 7    | on          |
      | Class 8    | off         |
      | Class 9    | off         |
    # clean up
    * I restore to default train list config

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
    # clean up
    * I restore to default train list config

  Scenario: 33806 -26 c Trains list misc config Train class update using - Clear all
    When I click on the Clear All button
    Then the following can be seen on the class table
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
    # clean up
    * I restore to default train list config

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
      | Include unmatched                  | on          |
      | Time to remain on list             | 5           |
    Then the following toggle values can be seen on the right class table
      | classValue                         | toggleValue |
      | Ignore PD Cancels                  | on          |
      | Include unmatched                  | on          |
      | Time to remain on list             | 5           |
    # clean up
    * I restore to default train list config

  #33806 -32 Trains List Config (Train Misc Settings Applied)
    #Given the user has made changes to the trains list misc settings
    #When the user views the trains list
    #Then the view is updated to reflect the user's train misc changes
  @bug @bug:66859
  Scenario: 33806 -32a Trains List Config (Train Misc Settings Applied) - Misc Class settings
    When the following class table updates are made
      | classValue | toggleValue |
      | Class 0    | off         |
      | Class 1    | off         |
      | Class 2    | on          |
      | Class 3    | off         |
      | Class 4    | off         |
      | Class 5    | off         |
      | Class 6    | off         |
      | Class 7    | off         |
      | Class 8    | off         |
      | Class 9    | off         |
    And I save the service filter changes
    And I am on the trains list page
    Then I should see the trains list table to only display the following trains
      | trainDescription |
      | 2P77             |
      | 2C45             |
    # clean up
    * I restore to default train list config


  Scenario: 33806 -32b Trains List Config (Train Misc Settings Applied) - Ignore PD cancel toggle on
    Given the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | Y95686   | 2P77        | 12:00                  | 99999               | RDNGSTN                | today         | now                 |
    When the following TJM is received
      | trainUid | trainNumber | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | Y95686   | 2P77        | 12            | create | 91        | 91              | 99999       | RDNGSTN        | 12:00:00 | PD                 | DL                |
    When I click on the Select All button
    And I update the following misc options
      | classValue        | toggleValue |
      | Ignore PD Cancels | on          |
      | Include unmatched | off         |
    And I save the service filter changes
    And I am on the trains list page
    Then train 2P77 with schedule id Y95686 for today is not visible on the trains list
    # clean up
    * I restore to default train list config


  @bug @bug_64709
  Scenario: 33806 -32c Trains List Config (Train Misc Settings Applied) - Ignore PD cancel toggle off
    Given the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | Y95686   | 2P77        | 12:00                  | 99999               | RDNGSTN                | today         | now                 |
    When the following TJM is received
      | trainUid | trainNumber | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | Y95686   | 2P77        | 12            | create | 91        | 91              | 99999       | RDNGSTN        | 12:00:00 | PD                 | PD                |
    When I click on the Select All button
    And I update the following misc options
      | classValue        | toggleValue |
      | Ignore PD Cancels | off         |
      | Include unmatched | off         |
    And I save the service filter changes
    And I am on the trains list page
    Then train 2P77 with schedule id Y95686 for today is visible on the trains list
    # clean up
    * I restore to default train list config

  # unmatched services from stepping is part of CCN1
  @tdd
  Scenario: 33806 -32d Trains List Config (Train Misc Settings Applied) - Unmatched toggle on
    #Schedule is not available for the train IG65
    When the following live berth step message is sent from LINX (to move train)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | S307      | S308    | D4             | 1G65             |
    When I update the following misc options
      | classValue        | toggleValue |
      | Include unmatched | on          |
    And I save the service filter changes
    And I am on the trains list page
    Then I should see the trains list table to display the following trains
      | trainDescription |
      | 1G65             |
    # clean up
    * I restore to default train list config


  Scenario: 33806 -32e Trains List Config (Train Misc Settings Applied) - Unmatched toggle off
    #Schedule is not available for the train IG65
    Given the following live berth step message is sent from LINX (to move train)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | S307      | S308    | D4             | 1G65             |
    When I update the following misc options
      | classValue        | toggleValue |
      | Include unmatched | on          |
    And I save the service filter changes
    And I am on the trains list page
    Then I should see the trains list table to not display the following trains
      | trainDescription |
      | 1G65             |
    # clean up
    * I restore to default train list config

  Scenario: 33806 -32g Trains List Config (Train Misc Settings Applied) - Uncalled toggle off
    #Services not activated from the loaded access plan - 5G44
    When I am on the trains list page
    Then train '5G44' with schedule id 'V30603' for today is not visible on the trains list
    # clean up
    * I restore to default train list config
