@bug @bug_55994
Feature: 33806 - TMV User Preferences - full end to end testing - TL config - train indication

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

  #33806 -24 Trains List Config (Train Indication Applied)
    #Given the user has made changes to the trains list train indication
    #When the user views the trains list
    #Then the view is updated to reflect the user's train indication changes
  @tdd
  Scenario: 33806 -24-a Trains indication table - Train Cancellation - Train cancelled before it has started
    Given the access plan located in CIF file 'access-plan/IS42_PADTON_DIDCOTP.cif' is amended so that all services start within the next hour and then received from LINX
    When a TJM is received for train modification
      | tjmType          | trainNumber | locationPrimaryCode | locationSubsidiaryCode |
      | Cancel at origin | IS42        | 99999               | PADTON                 |
    And I update only the below train list indication config settings as
      | name         | colour |  toggleValue |
      | Cancellation | #dde   |  on          |
    And I open 'trains list' page in a new tab
    Then I should see the train list row coloured as
    #Below colour will have to be verified/changed once integration is done
    |trainDescriberId|backgroundColour|
    |IS42            |rgb(221, 221, 238)|

  @tdd
  Scenario: 33806 -24-b Trains indication table - Train Cancellation - Train terminates short of planned destination
    Given the access plan located in CIF file 'access-plan/IS42_PADTON_DIDCOTP.cif' is amended so that all services start within the next hour and then received from LINX
    When a TJM is received for train modification
      | tjmType          | trainNumber | locationPrimaryCode | locationSubsidiaryCode |
      | Cancel en route | IS42        | 99999               | PADTON                 |
    And I update only the below train list indication config settings as
      | name         | colour |  toggleValue |
      | Cancellation | #dde   |  on          |
    And I open 'trains list' page in a new tab
    Then I should see the train list row coloured as
    #Below colour will have to be verified/changed once integration is done
      |trainDescriberId|backgroundColour|
      |IS42            |rgb(221, 221, 238)|

  @tdd
  Scenario: 33806 -24-c Trains indication table - Train Reinstatement - Train terminates at a location not in the plan
    Given the access plan located in CIF file 'access-plan/IS42_PADTON_DIDCOTP.cif' is amended so that all services start within the next hour and then received from LINX
    When a TJM is received for train modification
      | tjmType                  | trainNumber | locationPrimaryCode | locationSubsidiaryCode |
      | Out of plan cancellation | IS42        | 99999               | PADTON                 |
    And I update only the below train list indication config settings as
      | name         | colour |  toggleValue |
      | Cancellation | #dde   |  on          |
    And I open 'trains list' page in a new tab
    Then I should see the train list row coloured as
    #Below colour will have to be verified/changed once integration is done
      |trainDescriberId|backgroundColour|
      |IS42            |rgb(221, 221, 238)|

  @tdd
  Scenario: 33806 -24-d Train Activation for a valid service with a change of origin matching current origin
    And the service '0F00' is not active
    And there is a Schedule for '0F00'
    And it has Origin Details
      | tiploc | scheduledDeparture             | line |
      | PADTON | 10:15 SAME AS CURRENT ORIGIN   |      |
    And it has Intermediate Details
      | tiploc  | scheduledArrival | scheduledDeparture | path | line |
      | ROYAOJN | 10:00            | 10:01              |      |      |
    And it has Terminating Details
      | tiploc  | scheduledArrival | path |
      | OLDOXRS | 10:13            |      |
    And that service has the cancellation status 'F'
    When the schedule is received from LINX
    And the following train activation messages is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode |
      | W15214   | 0A00        | 09:59                  | 99999               | PADTON                 |
    Then The trains list table is visible
    And the service is displayed in the trains list with the following indication
      | rowType                   | rowId      | rowColFill            | trainDescriptionFill   |
      | Origin called             | 0A00       | rgba(153, 153, 255, 1)| rgba(0, 255, 0, 1)     |

  @tdd
  Scenario: 33806 -24-e Trains reinstatement - Whole train has been reinstated
    Given the access plan located in CIF file 'access-plan/IS42_PADTON_DIDCOTP.cif' is amended so that all services start within the next hour and then received from LINX
    When a TJM is received for train modification
      | tjmType                            | trainNumber | locationPrimaryCode | locationSubsidiaryCode |
      | Trains reinstatement - Whole train | IS42        | 99999               | PADTON                 |
    And I update only the below train list indication config settings as
      | name         | colour |  toggleValue |
      | Reinstatement | #dde   |  on          |
    And I open 'trains list' page in a new tab
    Then I should see the train list row coloured as
    #Below colour will have to be verified/changed once integration is done
      |trainDescriberId|backgroundColour|
      |IS42            |rgb(221, 221, 238)|

  @tdd
  Scenario: 33806 -24-f Change Of Origin - Train starts at a different planned location (start forward)
    Given the access plan located in CIF file 'access-plan/IS42_PADTON_DIDCOTP.cif' is amended so that all services start within the next hour and then received from LINX
    When a TJM is received for train modification
      | tjmType          | trainNumber | locationPrimaryCode | locationSubsidiaryCode |
      | Change of Origin | IS42        | 99999               | PADTON                 |
    And I update only the below train list indication config settings as
      | name         | colour |  toggleValue |
      | Change of Origin | #dde   |  on          |
    And I open 'trains list' page in a new tab
    Then I should see the train list row coloured as
    #Below colour will have to be verified/changed once integration is done
      |trainDescriberId|backgroundColour|
      |IS42            |rgb(221, 221, 238)|

  @tdd
  Scenario: 33806 -24-g Off route - Train has moved off route
    Given the access plan located in CIF file 'access-plan/IS42_PADTON_DIDCOTP.cif' is amended so that all services start within the next hour and then received from LINX
    When the following live berth step message is sent from LINX
       | fromBerth | toBerth | trainDescriber| trainDescription |
       | 0099      | 9999    | GW            | IS42             |
    And I update only the below train list indication config settings as
      | name      | colour |  toggleValue |
      | Off-route | #dde   |  on          |
    And I open 'trains list' page in a new tab
    Then I should see the train list row coloured as
    #Below colour will have to be verified/changed once integration is done
      |trainDescriberId|backgroundColour|
      |IS42            |rgb(221, 221, 238)|

  @tdd
  Scenario: 33806 -24-h Change Of Identity - Train running has a change of Train Id
    Given the access plan located in CIF file 'access-plan/IS42_PADTON_DIDCOTP.cif' is amended so that all services start within the next hour and then received from LINX
    When a TJM is received for train modification
      | tjmType          | trainNumber | locationPrimaryCode | locationSubsidiaryCode |
      | Change of Identity | IS42        | 99999               | PADTON                 |
    And I update only the below train list indication config settings as
      | name         | colour |  toggleValue |
      | Change of Identity | #dde   |  on          |
    And I open 'trains list' page in a new tab
    Then I should see the train list row coloured as
    #Below colour will have to be verified/changed once integration is done
      |trainDescriberId|backgroundColour|
      |IS42            |rgb(221, 221, 238)|
