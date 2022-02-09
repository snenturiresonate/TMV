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
    And I access the homepage as <roleType>
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
    And I access the homepage as <roleType>
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
#    @bug @bug:84999
#    And I am viewing the map HDGW02reading.v
#    And the train headcode color for berth 'D11676' has hex value '<hex1_def>'
#    And I am viewing the map HDGW01paddington.v
#    And the train headcode color for berth 'D30037' has hex value '<hex2_def>'
#    And the train headcode color for berth 'D30043' has hex value '<hex3_def>'
#    And the train headcode color for berth 'D30045' has hex value '<hex4_def>'
    And I logout
    And I am on the admin page
    And The admin setting defaults are as in <settingsFile>
    And I logout
    When I access the homepage as <roleType>
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
#    @bug @bug:84999
#    And I am viewing the map HDGW02reading.v
#    And the train headcode color for berth 'D11676' has hex value '<hex1_new>'
#    And I am viewing the map HDGW01paddington.v
#    And the train headcode color for berth 'D30037' has hex value '<hex2_new>'
#    And the train headcode color for berth 'D30043' has hex value '<hex3_new>'
#    And the train headcode color for berth 'D30045' has hex value '<hex4_new>'

    # clean up
    And I restore to default train list config '<trainslistNum>'
    * I logout

    Examples:
      | settingsFile              | roleType         | trainslistNum | lateness1 | lateness2 | lateness3 | lateness4 | hex1_def | hex2_def | hex3_def | hex4_def | hex1_new | hex2_new | hex3_new | hex4_new |
      | edited-punc-settings.json | standard         | 1             | +4        | +18       | -12       | -1        | #ffff00  | #ff0000  | #e5b4ff  | #78ff78  | #d0ff00  | #9c3373  | #6bbdcf  | #afeb67  |
      | edited-punc-settings.json | restriction      | 2             | +0        | +2        | +28       | -7        | #00ff00  | #ffff00  | #ff009c  | #78e7ff  | #afeb67  | #d0ff00  | #9c3373  | #6bbdcf  |
      | edited-punc-settings.json | schedulematching | 3             | -16       | -30       | +1        | +9        | #e5b4ff  | #ffb4b4  | #ffff00  | #ffa700  | #365f87  | #c253fc  | #d0ff00  | #dbb109  |

  Scenario Outline: 81204-3 - Non-punctuality update to Admin punctuality settings leaves user trains list settings untouched

    Given I have not already authenticated
    And I access the homepage as <roleType>
    And I restore to default train list config '1'
    And I am on the trains list page 1
    And I set up a train that is <lateness1> late at RDNGSTN using access-plan/2P77_RDNGSTN_PADTON.cif TD D1 interpose into 1698 step to 1676
    And I set up a train that is <lateness2> late at PADTON using access-plan/1B69_PADTON_SWANSEA.cif TD D3 interpose into C007 step to 0039
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
    When I access the homepage as <roleType>
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
    * I logout
    And I am on the admin page
    And The admin setting defaults are as originally shipped

    Examples:
      | settingsFile                  | roleType | lateness1 | lateness2 | lateness3 | lateness4 |
      | edited-non-punc-settings.json | standard | +4        | +18       | -12       | -1        |

