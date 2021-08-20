Feature: 33806 - TMV User Preferences - full end to end testing - TL config - train indication

  As a tester
  I want to verify the train list config tab - train indication
  So, that I can identify if the build meets the end to end requirements

  Background:
    * I remove all trains from the trains list
    * I have cleared out all headcodes
    * I am on the trains list Config page
    * I restore to default train list config
    * I have navigated to the 'Train Indication' configuration tab

  Scenario: Trains list punctuality config header
    Then the train indication config header is displayed as 'Trains List Indication'

  #33806 -19 Trains List Config (Train Indication Settings View)
    #Given the user is viewing the trains list config
    #When the user selects the trains indication view
    #Then the user is presented with the train indication settings view (defaulted to system settings)
  Scenario: 33806 -19 Trains indication table default settings
    Then the following can be seen on the trains indication table of trains list config
      | name                     | colour  | minutes | toggleValue |
      | Change of Origin         | #ffffff |         | on          |
      | Change of Identity       | #ffffff |         | on          |
      | Cancellation             | #ffffff |         | on          |
      | Reinstatement            | #ffffff |         | on          |
      | Off-Route                | #ffffff |         | on          |
      | Next Report Overdue      | #0000ff | 15      | off         |
      | Origin Called            | #ffb578 | 15      | on          |
      | Origin Departure Overdue | #ffffff | 1       | on          |

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
      | Off-Route                | #aac   |         | on          |
      | Next Report Overdue      | #bbc   | 15      | off         |
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
      | Off-Route                | #aaaacc |         | on          |
      | Next Report Overdue      | #bbbbcc | 15      | off         |
      | Origin Called            | #999955 | 60      | on          |
      | Origin Departure Overdue | #335566 | 10      | on          |

  Scenario: 33806 -24-a Trains indication table - Train Cancellation - Train cancelled before it has started
    #Given the user has made changes to the trains list train indication
    #When the user views the trains list
    #Then the view is updated to reflect the user's train indication changes
    * I remove today's train 'B21001' from the Redis trainlist
    * I delete 'B21001:today' from hash 'schedule-modifications'
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | 1B21                | B21001         |
    And I wait until today's train 'B21001' has loaded
    When the following train activation message is sent from LINX
      | trainUID      | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | B21001        | 1B21        | now                    | 99999               | PADTON                 | today         | now                 |
    And I am on the trains list page
    Then train '1B21' with schedule id 'B21001' for today is visible on the trains list
    When the following TJM is received
        #tjmType-Cancel at origin
      | trainUid | trainNumber | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | B21001   | 1B21        | 12            | create | 91        | 91              | 99999       | PADTON         | 12:00:00 | 91                 | PG                |
    Then the service is displayed in the trains list with the following row colour
      | rowType                     | trainUID   | rowColour              |
      | Default Cancelled at origin | B21001     | rgba(255, 255, 255, 1) |
    When I am on the trains list Config page
    And I have navigated to the 'Train Indication' configuration tab
    And I update only the below train list indication config settings as
      | name         | colour | toggleValue |
      | Cancellation | #dde   | on          |
    And I save the trains list config
    And I am on the trains list page
    Then the service is displayed in the trains list with the following row colour
      | rowType                | trainUID   | rowColour              |
      | Cancellation at origin | B21001     | rgba(221, 221, 238, 1) |
    # cleanup
    * I restore to default train list config

  Scenario: 33806 -24-b Trains indication table - Train Cancellation - Train terminates short of planned destination
    #Given the user has made changes to the trains list train indication
    #When the user views the trains list
    #Then the view is updated to reflect the user's train indication changes
    * I remove today's train 'B21002' from the Redis trainlist
    * I delete 'B21002:today' from hash 'schedule-modifications'
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | 1B22                | B21002         |
    And I wait until today's train 'B21002' has loaded
    When the following train activation message is sent from LINX
      | trainUID      | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | B21002        | 1B22        | now                    | 99999               | PADTON                 | today         | now                 |
    And I am on the trains list page
    Then train '1B22' with schedule id 'B21002' for today is visible on the trains list
    When the following TJM is received
        #tjmType-Cancel en route
      | trainUid | trainNumber | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | B21002   | 1B22        | 12            | create | 92        | 92              | 99999       | PADTON         | 12:00:00 | 92                 | PG                |
    Then the service is displayed in the trains list with the following row colour
      | rowType                    | trainUID   | rowColour              |
      | Default Cancelled on route | B21002     | rgba(255, 255, 255, 1) |
    When I am on the trains list Config page
    And I have navigated to the 'Train Indication' configuration tab
    And I update only the below train list indication config settings as
      | name         | colour | toggleValue |
      | Cancellation | #dde   | on          |
    And I save the trains list config
    And I am on the trains list page
    Then the service is displayed in the trains list with the following row colour
      | rowType                | trainUID   | rowColour              |
      | Cancellation on route  | B21002     | rgba(221, 221, 238, 1) |
    # cleanup
    * I restore to default train list config

  Scenario: 33806 -24-c Trains indication table - Train Reinstatement - Train terminates at a location not in the plan
    #Given the user has made changes to the trains list train indication
    #When the user views the trains list
    #Then the view is updated to reflect the user's train indication changes
    * I remove today's train 'B21003' from the Redis trainlist
    * I delete 'B21003:today' from hash 'schedule-modifications'
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | 1B23                | B21003         |
    And I wait until today's train 'B21003' has loaded
    When the following train activation message is sent from LINX
      | trainUID      | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | B21003        | 1B23        | now                    | 99999               | PADTON                 | today         | now                 |
    And I am on the trains list page
    And train '1B23' with schedule id 'B21003' for today is visible on the trains list
    When the following TJM is received
        #tjmType-Out of plan cancellation
      | trainUid | trainNumber | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | B21003   | 1B23        | 12            | create | 93        | 93              | 99999       | BALLOCH        | 12:00:00 | 93                 | TB                |
    Then the service is displayed in the trains list with the following row colour
      | rowType                       | trainUID   | rowColour              |
      | Default Cancelled out of plan | B21003     | rgba(255, 255, 255, 1) |
    And I am on the trains list Config page
    And I have navigated to the 'Train Indication' configuration tab
    And I update only the below train list indication config settings as
      | name         | colour | toggleValue |
      | Cancellation | #dde   | on          |
    And I save the trains list config
    And I am on the trains list page
    Then the service is displayed in the trains list with the following row colour
      | rowType                  | trainUID   | rowColour              |
      | Cancellation out of plan | B21003     | rgba(221, 221, 238, 1) |
    # cleanup
    * I restore to default train list config

  Scenario: 33806 -24-d Trains indication table - Change of Origin - Train has origin changed
    #Given the user has made changes to the trains list train indication
    #When the user views the trains list
    #Then the view is updated to reflect the user's train indication changes
    * I remove today's train 'B21004' from the Redis trainlist
    * I delete 'B21004:today' from hash 'schedule-modifications'
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | 1B24                | B21004         |
    And I wait until today's train 'B21004' has loaded
    When the following train activation message is sent from LINX
      | trainUID      | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | B21004        | 1B24        | now                    | 99999               | PADTON                 | today         | now                 |
    And I am on the trains list page
    And train '1B24' with schedule id 'B21004' for today is visible on the trains list
    And the following TJM is received
        #tjmType-Change of Origin
      | trainUid | trainNumber | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time | modificationReason | nationalDelayCode |
      | B21004   | 1B24        | now           | create | 94        | 94              | 99999       | PADTON         | now  | 94                 | PL                |
    Then the service is displayed in the trains list with the following row colour
      | rowType                  | trainUID   | rowColour              |
      | Default change of origin | B21004     | rgba(255, 255, 255, 1) |
    And I am on the trains list Config page
    And I have navigated to the 'Train Indication' configuration tab
    And I update only the below train list indication config settings as
      | name             | colour | toggleValue |
      | Change of Origin | #dde   | on          |
    And I save the trains list config
    And I am on the trains list page
    Then the service is displayed in the trains list with the following row colour
      | rowType          | trainUID   | rowColour              |
      | Change of Origin | B21004     | rgba(221, 221, 238, 1) |
    # cleanup
    * I restore to default train list config

  Scenario: 33806 -24-e Trains reinstatement - Whole train has been reinstated
    #Given the user has made changes to the trains list train indication
    #When the user views the trains list
    #Then the view is updated to reflect the user's train indication changes
    * I remove today's train 'B21005' from the Redis trainlist
    * I delete 'B21005:today' from hash 'schedule-modifications'
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | 1B25                | B21005         |
    And I wait until today's train 'B21005' has loaded
    When the following train activation message is sent from LINX
      | trainUID      | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | B21005        | 1B25        | now                    | 99999               | PADTON                 | today         | now                 |
    And I am on the trains list page
    And train '1B25' with schedule id 'B21005' for today is visible on the trains list
    When the following TJM is received
        #tjmType-Trains reinstatement - Whole train
      | trainUid | trainNumber | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | B21005   | 1B25        | 12            | create | 96        | 96              | 99999       | PADTON         | 12:00:00 | 96                 | PG                |
    Then the service is displayed in the trains list with the following row colour
      | rowType                  | trainUID   | rowColour              |
      | Default reinstatement    | B21005     | rgba(255, 255, 255, 1) |
    When I am on the trains list Config page
    And I have navigated to the 'Train Indication' configuration tab
    And I update only the below train list indication config settings as
      | name          | colour | toggleValue |
      | Reinstatement | #dde   | on          |
    And I save the trains list config
    And I am on the trains list page
    Then the service is displayed in the trains list with the following row colour
      | rowType          | trainUID   | rowColour              |
      | Reinstatement    | B21005     | rgba(221, 221, 238, 1) |
    # cleanup
    * I restore to default train list config

  Scenario: 33806 -24-f Change Of Origin - Train starts at a different planned location (start forward)
    #Given the user has made changes to the trains list train indication
    #When the user views the trains list
    #Then the view is updated to reflect the user's train indication changes
    * I remove today's train 'B21006' from the Redis trainlist
    * I delete 'B21006:today' from hash 'schedule-modifications'
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | 1B26                | B21006         |
    And I wait until today's train 'B21006' has loaded
    When the following train activation message is sent from LINX
      | trainUID      | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | B21006        | 1B26        | now                    | 99999               | PADTON                 | today         | now                 |
    And I am on the trains list page
    And train '1B26' with schedule id 'B21006' for today is visible on the trains list
    When the following TJM is received
        #tjmType-Change of Origin
      | trainUid | trainNumber | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | B21006   | 1B26        | 12            | create | 94        | 94              | 99999       | PADTON         | 12:00:00 | 94                 | PL                |
    Then the service is displayed in the trains list with the following row colour
      | rowType                  | trainUID   | rowColour              |
      | Default start forward    | B21006     | rgba(255, 255, 255, 1) |
    And I am on the trains list Config page
    And I have navigated to the 'Train Indication' configuration tab
    And I update only the below train list indication config settings as
      | name             | colour | toggleValue |
      | Change of Origin | #dde   | on          |
    And I save the trains list config
    And I am on the trains list page
    Then the service is displayed in the trains list with the following row colour
      | rowType          | trainUID   | rowColour              |
      | Start forward    | B21006     | rgba(221, 221, 238, 1) |
    # cleanup
    * I restore to default train list config

  Scenario: 33806 -24-g Off route - Train has moved off route
    #Given the user has made changes to the trains list train indication
    #When the user views the trains list
    #Then the view is updated to reflect the user's train indication changes
    * I remove today's train 'B21007' from the Redis trainlist
    * I delete 'B21007:today' from hash 'schedule-modifications'
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | 1B27                | B21007         |
    And I wait until today's train 'B21007' has loaded
    When the following train activation message is sent from LINX
      | trainUID      | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | B21007        | 1B27        | now                    | 99999               | PADTON                 | today         | now                 |
    And I am on the trains list page
    And train '1B27' with schedule id 'B21007' for today is visible on the trains list
    When the following live berth step message is sent from LINX (to match the service)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0089      | 0117    | D3             | 1B27             |
    When the following live berth step message is sent from LINX (causing service to go off route)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0117      | 0129    | D3             | 1B27             |
    Then the service is displayed in the trains list with the following row colour
      | rowType                  | trainUID   | rowColour              |
      | Default off route        | B21007     | rgba(255, 255, 255, 1) |
    When I am on the trains list Config page
    And I have navigated to the 'Train Indication' configuration tab
    And I update only the below train list indication config settings as
      | name      | colour | toggleValue |
      | Off-Route | #dde   | on          |
    And I save the trains list config
    And I am on the trains list page
    Then the service is displayed in the trains list with the following row colour
      | rowType          | trainUID   | rowColour              |
      | Off route        | B21007     | rgba(221, 221, 238, 1) |
    # cleanup
    * I restore to default train list config

  Scenario: 33806 -24-h Change Of Identity - Train running has a change of Train Id
    #Given the user has made changes to the trains list train indication
    #When the user views the trains list
    #Then the view is updated to reflect the user's train indication changes
    * I remove today's train 'B21008' from the Redis trainlist
    * I delete 'B21008:today' from hash 'schedule-modifications'
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | 1B28                | B21008         |
    And I wait until today's train 'B21008' has loaded
    When the following train activation message is sent from LINX
      | trainUID      | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | B21008        | 1B28        | now                    | 99999               | PADTON                 | today         | now                 |
    And I am on the trains list page
    And train '1B28' with schedule id 'B21008' for today is visible on the trains list
    When the following change of ID TJM is received
      | trainUid | newTrainNumber | oldTrainNumber | departureHour | modificationTime | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     |
      | B21008   | 1B28           | 1S42           | 12            | 10:00:00         | create | 07        | 07              | 99999       | PADTON         | 12:00:00 |
    Then the service is displayed in the trains list with the following row colour
      | rowType                  | trainUID   | rowColour              |
      | Default change of ID     | B21008     | rgba(255, 255, 255, 1) |
    And I am on the trains list Config page
    And I have navigated to the 'Train Indication' configuration tab
    And I update only the below train list indication config settings as
      | name               | colour | toggleValue |
      | Change of Identity | #dde   | on          |
    And I save the trains list config
    And the following service is displayed on the trains list
      | trainId | trainUId |
      | 1B28    | B21008   |
    Then the service is displayed in the trains list with the following row colour
      | rowType          | trainUID   | rowColour              |
      | Change of ID     | B21008     | rgba(221, 221, 238, 1) |
    # cleanup
    * I restore to default train list config
