@TMVPhase2 @P2.S2
Feature: 80688 - TMV Punctuality Admin - Override Trains List Punctuality

  As a TMV Admin User
  I want the ability to update trains list punctuality
  So that it punctuality is inline with schematic map punctuality overriding the user's TL preference

  Background:
    * I reset redis
    * I have cleared out all headcodes
    * I remove all trains from the trains list
    * I have not already authenticated
    * I am on the admin page
    * I restore to default train list config '1'
    * I restore to default train list config '2'
    * I restore to default train list config '3'
    * The admin setting defaults are as originally shipped
    * I refresh the browser

  Scenario Outline: 81204-1 - Update to Admin punctuality settings is seen on Trains List Load (no previous user settings)

#    Given the user is authenticated to use TMV
#    And the user the admin privilege
#    And is viewing the admin display settings view
#    When the user updates the punctuality setting
#    And saves the setting
#    Then for all TMV users the trains list punctuality is overrridden with the updated punctuality settings

    Given The admin setting defaults are as in <settingsFile>
    And I have not already authenticated
    And I access the homepage as <roleType> user
    And I restore to default train list config '1'
    And I am on the trains list page 1
    And I have navigated to the 'Punctuality' configuration tab
    Then the following can be seen on the punctuality table
      | punctualityColorText | fromTime | toTime | entryValue       | include |
      | #c253fc              |          | -20    | 20 or more early | on      |
      | #365f87              | -20      | -15    | 15 to 19 early   | on      |
      | #6bbdcf              | -15      | -5     | 5 to 14 early    | on      |
      | #afeb67              | -5       | -1     | 1 to 4 early     | on      |
      | #00ff5e              | -1       | 1      | On Time          | on      |
      | #d0ff00              | 1        | 5      | 1 to 4 late      | on      |
      | #dbb109              | 5        | 10     | 5 to 9 late      | on      |
      | #9c3373              | 15       |        | 15 or more late  | on      |

    # clean up
    * I logout


    Examples:
      | settingsFile              | roleType         |
      | edited-punc-settings.json | restriction      |
      | edited-punc-settings.json | standard         |
      | edited-punc-settings.json | admin            |
      | edited-punc-settings.json | schedulematching |


  Scenario Outline: 81204-2 - Update to Admin punctuality settings overwrites existing trains list settings - colour, text, boundary changes, different number of timebands

    Given I have not already authenticated
    And I access the homepage as <roleType> user
    And I restore to default train list config '<trainslistNum>'
    And I am on the trains list page <trainslistNum>
    And I have navigated to the 'Punctuality' configuration tab
    And I update the trains list punctuality settings as
      | punctualityColorText | fromTime | toTime | entryValue                    | include |
      | #798                 |          | -20    | 20 or more minutes early-edit | on      |
      | #f4a                 | -20      | -10    | 10 to 19 minutes early-edit   | on      |
      | #aff                 | -10      | -5     | 5 to 9 minutes early-edit     | off     |
      | #1a5                 | -5       | -1     | 1 to 4 minutes early-edit     | on      |
      | #22a                 | -1       | 1      | On Time                       | on      |
      | #aa1                 | 1        | 5      | 1 to 4 minutes late-edit      | on      |
      | #a71                 | 5        | 10     | 5 to 9 minutes late-edit      | on      |
      | #82e                 | 10       | 20     | 10 to 19 minutes late-edit    | on      |
      | #bbb                 | 20       |        | 20 minutes or more late-edit  | on      |
    And I set up a train that is <lateness1> late at RDNGSTN using access-plan/2P77_RDNGSTN_PADTON.cif TD D1 interpose into 1698 step to 1676
    And I set up a train that is <lateness2> late at PADTON using access-plan/1B69_PADTON_SWANSEA.cif TD D3 interpose into C007 step to 0037
    And I set up a train that is <lateness3> late at PADTON using access-plan/1L24_PADTON_RDNGSTN.cif TD D3 interpose into C029 step to 0043
    And I set up a train that is <lateness4> late at PADTON using access-plan/2F35_PADTON_DIDCOTP.cif TD D3 interpose into C031 step to 0045
    And I save the trains list config
    And The trains list table is visible
    And I should see the punctuality colour for the time-bands as
      | punctualityColor       | fromTime | toTime |
      | rgba(119, 153, 136, 1) |          | -20    |
      | rgba(255, 68, 170, 1)  | -20      | -10    |
#      Punctuality group not shown
#      | rgb(170, 255, 255, 1)  | -10      | -5     |
      | rgba(17, 170, 85, 1)   | -5       | -1     |
      | rgba(34, 34, 170, 1)   | -1       | 1      |
      | rgba(170, 170, 17, 1)  | 1        | 5      |
      | rgba(170, 119, 17, 1)  | 5        | 10     |
      | rgba(136, 34, 238, 1)  | 10       | 20     |
      | rgba(187, 187, 187, 1) | 20       |        |
    And I logout
    And I am on the admin page
    And The admin setting defaults are as in <settingsFile>
    And I logout
    When I access the homepage as <roleType> user
    And I am on the trains list page <trainslistNum>
    Then I should see the punctuality colour for the time-bands as
      | punctualityColor       | fromTime | toTime |
      | rgba(194, 83, 252, 1)  |          | -20    |
      | rgba(54, 95, 135, 1)   | -20      | -15    |
      | rgba(107, 189, 207, 1) | -15      | -5     |
      | rgba(175, 235, 103, 1) | -5       | -1     |
      | rgba(0, 255, 94, 1)    | -1       | 1      |
      | rgba(208, 255, 0, 1)   | 1        | 5      |
      | rgba(219, 177, 9, 1)   | 5        | 10     |
      | rgba(156, 51, 115, 1)  | 15       |        |
    When I navigate to train list configuration
    And I have navigated to the 'Punctuality' configuration tab
    Then the following can be seen on the punctuality table
      | punctualityColorText | fromTime | toTime | entryValue       | include |
      | #c253fc              |          | -20    | 20 or more early | on      |
      | #365f87              | -20      | -15    | 15 to 19 early   | on      |
      | #6bbdcf              | -15      | -5     | 5 to 14 early    | on      |
      | #afeb67              | -5       | -1     | 1 to 4 early     | on      |
      | #00ff5e              | -1       | 1      | On Time          | on      |
      | #d0ff00              | 1        | 5      | 1 to 4 late      | on      |
      | #dbb109              | 5        | 10     | 5 to 9 late      | on      |
      | #9c3373              | 15       |        | 15 or more late  | on      |

    # clean up
    And I restore to default train list config '<trainslistNum>'
    * I logout

    Examples:
      | settingsFile              | roleType         | trainslistNum | lateness1 | lateness2 | lateness3 | lateness4 |
      | edited-punc-settings.json | standard         | 1             | +4        | +18       | -12       | -1        |
      | edited-punc-settings.json | restriction      | 2             | +0        | +2        | +28       | -7        |
      | edited-punc-settings.json | schedulematching | 3             | -16       | -30       | +1        | +9        |

  Scenario Outline: 81204-3 - Non-punctuality update to Admin punctuality settings leaves user trains list settings untouched

    Given I have not already authenticated
    And I access the homepage as <roleType> user
    And I restore to default train list config '1'
    And I restore to default train list config '2'
    And I am on the trains list page 1
    And I set up a train that is <lateness1> late at RDNGSTN using access-plan/2P77_RDNGSTN_PADTON.cif TD D1 interpose into 1698 step to 1676
    And I set up a train that is <lateness2> late at PADTON using access-plan/1B69_PADTON_SWANSEA.cif TD D3 interpose into C007 step to 0037
    And I set up a train that is <lateness3> late at PADTON using access-plan/1L24_PADTON_RDNGSTN.cif TD D3 interpose into C029 step to 0043
    And I set up a train that is <lateness4> late at PADTON using access-plan/2F35_PADTON_DIDCOTP.cif TD D3 interpose into C031 step to 0045
    And I have navigated to the 'Punctuality' configuration tab
    And I update the trains list punctuality settings as
      | punctualityColorText | fromTime | toTime | entryValue                    | include |
      | #798                 |          | -20    | 20 or more minutes early-edit | on      |
      | #f4a                 | -20      | -10    | 10 to 19 minutes early-edit   | on      |
      | #aff                 | -10      | -5     | 5 to 9 minutes early-edit     | off     |
      | #1a5                 | -5       | -1     | 1 to 4 minutes early-edit     | on      |
      | #22a                 | -1       | 1      | On Time                       | on      |
      | #aa1                 | 1        | 5      | 1 to 4 minutes late-edit      | on      |
      | #a71                 | 5        | 10     | 5 to 9 minutes late-edit      | on      |
      | #82e                 | 10       | 20     | 10 to 19 minutes late-edit    | on      |
      | #bbb                 | 20       |        | 20 minutes or more late-edit  | on      |
    And I save the trains list config
    And The trains list table is visible
    And I should see the punctuality colour for the time-bands as
      | punctualityColor       | fromTime | toTime |
      | rgba(119, 153, 136, 1) |          | -20    |
      | rgba(255, 68, 170, 1)  | -20      | -10    |
#      Punctuality group not shown
#      | rgb(170, 255, 255, 1)  | -10      | -5     |
      | rgba(17, 170, 85, 1)   | -5       | -1     |
      | rgba(34, 34, 170, 1)   | -1       | 1      |
      | rgba(170, 170, 17, 1)  | 1        | 5      |
      | rgba(170, 119, 17, 1)  | 5        | 10     |
      | rgba(136, 34, 238, 1)  | 10       | 20     |
      | rgba(187, 187, 187, 1) | 20       |        |
    And I logout
    And I am on the admin page
    And The admin setting defaults are as in <settingsFile>
    And I logout
    When I access the homepage as <roleType> user
    And I am on the trains list page 1
    Then I should see the punctuality colour for the time-bands as
      | punctualityColor       | fromTime | toTime |
      | rgba(119, 136, 153, 1) |          | -20    |
      | rgba(255, 68, 170, 1)  | -20      | -10    |
#      Punctuality group not shown
#      | rgb(170, 255, 255, 1)  | -10      | -5     |
      | rgba(17, 170, 85, 1)   | -5       | -1     |
      | rgba(34, 34, 170, 1)   | -1       | 1      |
      | rgba(170, 170, 17, 1)  | 1        | 5      |
      | rgba(170, 119, 17, 1)  | 5        | 10     |
      | rgba(136, 34, 238, 1)  | 10       | 20     |
      | rgba(187, 187, 187, 1) | 20       |        |
    When I navigate to train list configuration
    And I have navigated to the 'Punctuality' configuration tab
    Then the following can be seen on the punctuality table
      | punctualityColorText | fromTime | toTime | entryValue                    | include |
      | #779988              |          | -20    | 20 or more minutes early-edit | on      |
      | #ff44aa              | -20      | -10    | 10 to 19 minutes early-edit   | on      |
      | #aaffff              | -10      | -5     | 5 to 9 minutes early-edit     | off     |
      | #11aa55              | -5       | -1     | 1 to 4 minutes early-edit     | on      |
      | #2222aa              | -1       | 1      | On Time                       | on      |
      | #aaaa11              | 1        | 5      | 1 to 4 minutes late-edit      | on      |
      | #aa7711              | 5        | 10     | 5 to 9 minutes late-edit      | on      |
      | #8822ee              | 10       | 20     | 10 to 19 minutes late-edit    | on      |
      | #bbbbbb              | 20       |        | 20 minutes or more late-edit  | on      |
    When I am on the trains list page 2
    And I have navigated to the 'Punctuality' configuration tab
    Then the following can be seen on the punctuality table
      | punctualityColorText | fromTime | toTime | entryValue               | include |
      | #ffb4b4              |          | -20    | 20 minutes or more early | on      |
      | #e5b4ff              | -20      | -10    | 10 to 19 minutes early   | on      |
      | #78e7ff              | -10      | -5     | 5 to 9 minutes early     | on      |
      | #78ff78              | -5       | -1     | 1 to 4 minutes early     | on      |
      | #00ff00              | -1       | 1      | On Time                  | on      |
      | #ffff00              | 1        | 5      | 1 to 4 minutes late      | on      |
      | #ffa700              | 5        | 10     | 5 to 9 minutes late      | on      |
      | #ff0000              | 10       | 20     | 10 to 19 minutes late    | on      |
      | #ff009c              | 20       |        | 20 minutes or more late  | on      |

    # clean up
    And I restore to default train list config '1'
    And I restore to default train list config '2'
    * I logout
    And I am on the admin page
    And The admin setting defaults are as originally shipped

    Examples:
      | settingsFile                  | roleType | lateness1 | lateness2 | lateness3 | lateness4 |
      | edited-non-punc-settings.json | standard | +4        | +18       | -12       | -1        |


  #  Given the user is authenticated to use TMV
  #  And the user the admin privilege
  #  And is viewing the admin display settings view
  #  When the user updates the punctuality setting
  #  And saves the setting
  #  Then for all TMV users the settings will update the punctuality displayed on the schematic maps
  Scenario Outline: 81204-4 - Admin Punctuality Settings Update is reflected on the Map - <roleType> user
    * I generate a new trainUID
    * I generate a new train description
    * I have not already authenticated

    # Setup a service that is over 20 minutes early
    Given I access the homepage as <roleType> user
    And the train in CIF file below is updated accordingly so time at the reference point is now + '25' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUID>  |
    And I wait until today's train '<planningUID>' has loaded
    And I give the cif a further 2 seconds to fully process
    And I am viewing the map HDGW01paddington.v
    And the following live berth interpose messages are sent from LINX (to match the first part of the step)
      | toBerth | trainDescriber | trainDescription   |
      | A007    | D3             | <trainDescription> |
    Then the train headcode color for berth 'D3A007' has hex value '<defaultPunctualityColour>'

    # Change the punctuality colour in the admin settings
    * I have not already authenticated
    When I am on the admin page
    And I have navigated to the 'Display Settings' admin tab
    And I take a screenshot
    And I update the admin punctuality settings as
      | punctualityColorText | fromTime | toTime | entryValue               |
      | <updatedColour>      |          | -20    | 20 minutes or more early |
    And the following can be seen on the admin punctuality settings table
      | punctualityColorText | fromTime | toTime | entryValue               |
      | <updatedColour>      |          | -20    | 20 minutes or more early |
      | #e5b4ff              | -20      | -10    | 10 to 19 minutes early   |
      | #78e7ff              | -10      | -5     | 5 to 9 minutes early     |
      | #78ff78              | -5       | -1     | 1 to 4 minutes early     |
      | #00ff00              | -1       | 1      | On Time                  |
      | #ffff00              | 1        | 5      | 1 to 4 minutes late      |
      | #ffa700              | 5        | 10     | 5 to 9 minutes late      |
      | #ff0000              | 10       | 20     | 10 to 19 minutes late    |
      | #ff009c              | 20       |        | 20 minutes or more late  |
    And I save the punctuality settings
    And I take a screenshot
    And I give the settings 2 seconds to be stored

    # Check that the updated settings are reflected upon the map's punctuality
    * I have not already authenticated
    And I access the homepage as <roleType> user
    And I am viewing the map HDGW01paddington.v
    Then the train headcode color for berth 'D3A007' has hex value '<updatedColour>'

    # clean up
    * I have not already authenticated
    * I am on the admin page
    * The admin setting defaults are as originally shipped
    * I logout

    Examples:
      | roleType         | trainDescription | planningUID | defaultPunctualityColour | updatedColour |
      | admin            | generated        | generated   | #ffb4b4                  | #ffffff       |
      | standard         | generated        | generated   | #ffb4b4                  | #ffff00       |
      | restriction      | generated        | generated   | #ffb4b4                  | #ffff66       |
      | schedulematching | generated        | generated   | #ffb4b4                  | #ffff99       |
