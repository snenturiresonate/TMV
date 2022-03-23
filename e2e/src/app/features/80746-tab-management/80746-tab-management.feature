@TMVPhase2 @P2.S4
Feature: 80746 - TMV Tab Management

  As a TMV Admin User
  I want the ability to manage the number of tabs that can be open
  So that the system is not unduly having to serve large numbers of open tabs

#  Given the user is authenticated to use TMV
#  When the user attempts to open tab or app that have restrictions on the maximum number allowed open at any one time
#  Then the system will not allow the tab/app to open displaying a message to this effect

#  The following tab types will be enforced:
#  Live maps - max 16
#  Replay maps - max 16,
#  Replay session - max 2
#  Live Trains List - max 3 named and no duplicates
#  Live Timetable - max 16
#  Replay Timetable - max 16
#  Enquires - max 3
#  Unscheduled Trains List - max 1
#  Log Viewer - max 3

  Background:
    Given I have not already authenticated
    And I am on the admin page
    And The admin setting defaults are as originally shipped

  Scenario: 81205 - 1 Tab Management - default settings and values

    Given I navigate to the 'System Defaults' admin tab
    Then the system default settings display as follows
      | setting                                                       | value   |
      | Replay Background Colour                                      | #016e01 |
      | Maximum Number of Replays                                     | 2       |
      | Maximum Number of Maps Per Replay Session                     | 16      |
      | Maximum Number of Timetables Per Replay Session               | 16      |
      | Maximum Number of Live Schematic Map Display Instances        | 16      |
      | Maximum Number of Live Timetable Instances                    | 16      |
      | Maximum Number of Live Enquiries View Instances               | 3       |
      | Maximum Number of Live Unscheduled Trains List View Instances | 1       |
      | Maximum Number of Log Viewer Instances                        | 3       |
      | Maximum Number of Admin Instances                             | 1       |


  Scenario Outline: 81205 - 2 Tab Management - can alter default setting <setting>

    Given I navigate to the 'System Defaults' admin tab
    When I make a note of the value for setting <setting>
    And I <incDec> the value for setting <setting> by <value>
    Then the value shown for setting <setting> is <value> <lessMore> than before
    And there is an unsaved indicator on the Admin Settings

#    Close down
    * I reset the system default settings
    * The admin setting defaults are as originally shipped

    Examples:
      | setting                                                       | incDec   | value | lessMore |
      | Maximum Number of Replays                                     | increase | 2     | more     |
      | Maximum Number of Maps Per Replay Session                     | decrease | 2     | less     |
      | Maximum Number of Timetables Per Replay Session               | increase | 2     | more     |
      | Maximum Number of Live Schematic Map Display Instances        | decrease | 2     | less     |
      | Maximum Number of Live Timetable Instances                    | increase | 2     | more     |
      | Maximum Number of Live Enquiries View Instances               | decrease | 2     | less     |
      | Maximum Number of Live Unscheduled Trains List View Instances | increase | 2     | more     |
      | Maximum Number of Log Viewer Instances                        | decrease | 2     | less     |
      | Maximum Number of Admin Instances                             | increase | 2     | more     |


  Scenario Outline: 81205 - 3 Tab Management - limits apply (<tabType> from Home Screen access only)

    Given I navigate to the 'System Defaults' admin tab
    And I update the following system default settings
      | setting       | value |
      | <settingName> | 2     |
    And I save the system default settings
    And I logout
    When I access the homepage as <userRole> user
    And I click the app '<app>'
    And I switch to the new tab
    And there is no message about having too many <tabType> <tabsOrSessions> open
    And I switch to the second-newest tab
    And I click the app '<app>'
    And I switch to the new tab
    And there is no message about having too many <tabType> <tabsOrSessions> open
    And I switch to the third-newest tab
    And I click the app '<app>'
    And I switch to the new tab
    Then there is a message about having too many <tabType> <tabsOrSessions> open

  #    Close down
    * I logout
    * I am on the admin page
    * The admin setting defaults are as originally shipped

    Examples:
      | tabType                 | settingName                                                   | userRole | app            | tabsOrSessions |
      | Admin                   | Maximum Number of Admin Instances                             | admin    | admin          | tabs           |
      | Log Viewer              | Maximum Number of Log Viewer Instances                        | standard | logs           | tabs           |
      | Enquiries               | Maximum Number of Live Enquiries View Instances               | standard | enquiries      | tabs           |
      | Unscheduled Trains List | Maximum Number of Live Unscheduled Trains List View Instances | standard | unsched-trains | tabs           |
      | Replay                  | Maximum Number of Replays                                     | standard | replay         | sessions       |


  Scenario: 81205 - 4 Tab Management - limits apply (Enquiries from Trains List)

    Given The admin setting defaults are as in tab-limits-test-data-admin-settings.json
    And I logout
    When I access the homepage as standard user
    And I click the app 'trains-list-1'
    And I switch to the new tab
    And I click on the Enquiries button
    And I switch to the new tab
    And there is no message about having too many Enquiries tabs open
    And I switch to the second-newest tab
    And I click on the Enquiries button
    And I switch to the new tab
    And there is no message about having too many Enquiries tabs open
    And I switch to the third-newest tab
    And I click on the Enquiries button
    And I switch to the new tab
    Then there is a message about having too many Enquiries tabs open

  #    Close down
    * I logout
    * I am on the admin page
    * The admin setting defaults are as originally shipped


  Scenario: 81205 - 5a Tab Management - limits apply (Live Timetable from Live map click and menu and Schedule Matching screen)

    Given The admin setting defaults are as in tab-limits-test-data-admin-settings.json
    And I logout
    And I generate a new trainUID
    And I generate a new train description
    When I access the homepage as schedulematching user
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | GORASTR     | WTT_pass      | generated           | generated      |
    And I wait until today's train 'generated' has loaded
    And I am viewing the map GW03reading.v
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 0813    | D1             | generated        |
    And berth '0813' in train describer 'D1' contains 'generated' and is visible
    And I wait for the Open timetable option for train description generated in berth 0813, describer D1 to be available
    When I click on the map for train generated
    And I switch to the new tab
    Then there is no message about having too many Live Timetable tabs open
    When I switch to the second-newest tab
    And I click on the map for train generated
    And I switch to the new tab
    Then there is no message about having too many Live Timetable tabs open
    When I switch to the third-newest tab
    And I click on the map for train generated
    And I switch to the new tab
    Then there is a message about having too many Live Timetable tabs open
    When I close the last tab
    And I switch to the third-newest tab
    And I invoke the context menu on the map for train generated
    And I open timetable from the map context menu
    And I switch to the new tab
    Then there is a message about having too many Live Timetable tabs open
    When I close the last tab
    And I switch to the third-newest tab
    And I invoke the context menu on the map for train generated
    And I open schedule matching screen from the map context menu
    And I switch to the new tab
    And I open today's timetable with planning UID generated from the match table
    And I switch to the new tab
    Then there is a message about having too many Live Timetable tabs open

    #    Close down
    * I logout
    * I am on the admin page
    * The admin setting defaults are as originally shipped


  Scenario: 81205 - 5b Tab Management - limits apply (Live Timetable from Search - Timetable and Train)

    Given The admin setting defaults are as in tab-limits-test-data-admin-settings.json
    And I logout
    When I access the homepage as standard user
    And I generate a new train description
    And I generate a new trainUID
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | GORASTR     | WTT_pass      | generated           | generated      |
    And I wait until today's train 'generated' has loaded
    And I give the train 2 seconds to get into elastic search
    And I refresh the Elastic Search indices
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 0813    | D1             | generated        |
    And I search Timetable for 'generated'
    And I open today's timetable with planning UID generated from the search results
    And I switch to the new tab
    Then there is no message about having too many Live Timetable tabs open
    When I switch to the second-newest tab
    And I open today's timetable with planning UID generated from the search results
    And I switch to the new tab
    Then there is no message about having too many Live Timetable tabs open
    When I switch to the third-newest tab
    And I open today's timetable with planning UID generated from the search results
    And I switch to the new tab
    Then there is a message about having too many Live Timetable tabs open
    When I close the last tab
    And I switch to the third-newest tab
    And I click close button at the bottom of table
    And I search Train for 'generated'
    And I open today's timetable with planning UID generated from the search results
    And I switch to the new tab
    Then there is a message about having too many Live Timetable tabs open

    #    Close down
    * I logout
    * I am on the admin page
    * The admin setting defaults are as originally shipped


  Scenario: 81205 - 5c Tab Management - limits apply (Live Timetable from Log Viewer)

    Given The admin setting defaults are as in tab-limits-test-data-admin-settings.json
    And I logout
    When I access the homepage as standard user
    And I click the app 'logs'
    And I switch to the new tab
    And I generate a new train description
    And I generate a new trainUID
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | generated           | generated      |
    And I wait until today's train 'generated' has loaded
    And I give the train 2 seconds to get into elastic search
    And I search for Timetable logs with
      | trainDescription | planningUid |
      | generated        | generated   |
    And there is 1 row returned in the log results
    And I primary click for the record for 'generated' schedule uid 'generated' from the timetable results
    And I switch to the new tab
    Then there is no message about having too many Live Timetable tabs open
    When I switch to the second-newest tab
    And I primary click for the record for 'generated' schedule uid 'generated' from the timetable results
    And I switch to the new tab
    Then there is no message about having too many Live Timetable tabs open
    When I switch to the third-newest tab
    And I primary click for the record for 'generated' schedule uid 'generated' from the timetable results
    And I switch to the new tab
    Then there is a message about having too many Live Timetable tabs open

    #    Close down
    * I logout
    * I am on the admin page
    * The admin setting defaults are as originally shipped

  Scenario: 81205 - 5d Tab Management - limits apply (Live Timetable from Trains List and Enquiries click and menu)

    Given The admin setting defaults are as in tab-limits-test-data-admin-settings.json
    And I have cleared out all headcodes
    And I remove all trains from the trains list
    And I logout
    When I access the homepage as standard user
    And I restore to default train list config '1'
    And I set up a train with TRI that reports +2 late originating from PADTON code 73780 using access-plan/1D46_PADTON_OXFD.cif
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | A007    | D3             | generated        |
    And I click the app 'trains-list-1'
    And I switch to the new tab
    And I save the trains list config
    And I primary click for todays train 'generated' schedule uid 'generated' from the trains list
    Then there is no message about having too many Live Timetable tabs open
    When I switch to the second-newest tab
    And I primary click for todays train 'generated' schedule uid 'generated' from the trains list
    And I switch to the new tab
    Then there is no message about having too many Live Timetable tabs open
    When I switch to the third-newest tab
    And I primary click for todays train 'generated' schedule uid 'generated' from the trains list
    And I switch to the new tab
    Then there is a message about having too many Live Timetable tabs open
    When I close the last tab
    And I switch to the third-newest tab
    And I invoke the context menu for todays train 'generated' schedule uid 'generated' from the trains list
    And I wait for the trains list context menu to display
    And I open timetable from the context menu
    And I switch to the new tab
    Then there is a message about having too many Live Timetable tabs open
    When I close the last tab
    And I switch to the third-newest tab
    And I click on the Enquiries button
    And I switch to the new tab
    And I type 'PADTON' into the enquiries location search box
    And I click the enquiries view button
    And I select the location at position 1 in the enquiries location auto suggest search results list
    And I click the enquiries view button
    And I primary click for todays train 'generated' schedule uid 'generated' from the enquiries page
    And I switch to the new tab
    Then there is a message about having too many Live Timetable tabs open
    When I switch to the second-newest tab
    And I invoke the context menu for todays train 'generated' schedule uid 'generated' from the enquiries page
    And I wait for the enquiries page context menu to display
    And I open timetable from the context menu
    And I switch to the new tab
    Then there is a message about having too many Live Timetable tabs open

        #    Close down
    * I logout
    * I am on the admin page
    * The admin setting defaults are as originally shipped


  Scenario: 81205 - 6a Tab Management - limits apply (Live maps from Home page)

    Given The admin setting defaults are as in tab-limits-test-data-admin-settings.json
    And I logout
    When I access the homepage as standard user
    And I expand the group of maps with name 'Wales & Western'
    And I navigate to the maps view with id HDGW01paddington.v
    And I switch to the new tab
    And there is no message about having too many Live Maps tabs open
    And I switch to the second-newest tab
    And I navigate to the maps view with id HDGW02reading.v
    And I switch to the new tab
    And there is no message about having too many Live Maps tabs open
    And I switch to the third-newest tab
    And I navigate to the maps view with id HDGW03oxford.v
    And I switch to the new tab
    Then there is a message about having too many Live Maps tabs open
    When I close the last tab
    And I switch to the third-newest tab
    And I select the recent map HDGW02reading.v
    And I switch to the new tab
    Then there is a message about having too many Live Maps tabs open
    When I close the last tab
    And I switch to the third-newest tab
    And I type 'GW05' into the map search box
    And I click the search icon
    And I select the map at position 1 in the search results list
    And I switch to the new tab
    Then there is a message about having too many Live Maps tabs open

  #    Close down
    * I logout
    * I am on the admin page
    * The admin setting defaults are as originally shipped


  Scenario: 81205 - 6b Tab Management - limits apply (Live maps from Open map)

    Given The admin setting defaults are as in tab-limits-test-data-admin-settings.json
    And I logout
    When I access the homepage as standard user
    And I expand the group of maps with name 'Wales & Western'
    And I navigate to the maps view with id GW01paddington.v
    And I switch to the new tab
    And there is no message about having too many Live Maps tabs open
    And I open the context menu for the continuation button 'GW02'
    And I open the next map in a new tab from the continuation button context menu
    And I switch to the new tab
    And there is no message about having too many Live Maps tabs open
    And I open the context menu for the continuation button 'GW2A'
    And I open the next map in a new tab from the continuation button context menu
    And I switch to the new tab
    Then there is a message about having too many Live Maps tabs open
    When I switch to the second-newest tab
    And I open map 'GW01paddington.v' via the recent map list
    And I switch to the new tab
    Then there is a message about having too many Live Maps tabs open
    When I switch to the third-newest tab
    And I refresh the browser
    And I search for map 'GW02' via the recent map list
    And I click the search icon
    And I select the map at position 1 in the search results list
    And I switch to the new tab
    Then there is a message about having too many Live Maps tabs open

  #    Close down
    * I logout
    * I am on the admin page
    * The admin setting defaults are as originally shipped


  Scenario Outline: 81205 - 6c Tab Management - limits apply (Live Map from Search - Timetable and Train)

    Given The admin setting defaults are as in tab-limits-test-data-admin-settings.json
    And I logout
    When I access the homepage as standard user
    And I have cleared out all headcodes
    And I generate a new train description
    And I generate a new trainUID
    And the train in CIF file below is updated accordingly so time at the reference point is now - 10 minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUID>  |
    And I wait until today's train 'generated' has loaded
    And the following train activation message is sent from LINX
      | trainUID      | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUID> | <trainDescription> | now                    | 99999               | PADTON                 | today         | now                 |
    And the following live berth interpose message is sent from LINX (creating a train)
      | toBerth | trainDescriber | trainDescription   |
      | A007    | D3             | <trainDescription> |
    And I give the train 2 seconds to get into elastic search
    And I refresh the Elastic Search indices
    And I search Timetable for 'generated'
    When I invoke the context menu from train with planning UID 'generated' and schedule date 'today' from the search results
    And I wait for the timetable search context menu to display
    And I open the Map 'HDGW01'
    And I switch to the new tab
    Then there is no message about having too many Live Maps tabs open
    When I search Timetable for 'generated'
    And I invoke the context menu from train with planning UID 'generated' and schedule date 'today' from the search results
    And I wait for the timetable search context menu to display
    And I open the Map 'GW01'
    And I switch to the new tab
    Then there is no message about having too many Live Maps tabs open
    When I search Timetable for 'generated'
    And I invoke the context menu from train with planning UID 'generated' and schedule date 'today' from the search results
    And I wait for the timetable search context menu to display
    And I open the Map 'HDGW01'
    And I switch to the new tab
    Then there is a message about having too many Live Maps tabs open
    When I switch to the second-newest tab
    And I click close button at the bottom of table
    And I search Train for 'generated'
    And I invoke the context menu from train with planning UID 'generated' and schedule date 'today' from the search results
    And I wait for the train search context menu to display
    And I open the Map 'HDGW01'
    And I switch to the new tab
    Then there is a message about having too many Live Maps tabs open

    #    Close down
    * I logout
    * I am on the admin page
    * The admin setting defaults are as originally shipped

  Examples:
    | trainDescription | planningUID | mapGroup               | map                |
    | generated        | generated   | Wales & Western        | HDGW02reading.v    |


  Scenario: 81205 - 6d Tab Management - limits apply (Live Maps from Trains List and Enquiries click and menu)

    Given The admin setting defaults are as in tab-limits-test-data-admin-settings.json
    And I have cleared out all headcodes
    And I remove all trains from the trains list
    And I set up a train with TRI that reports +7 late originating from WDRYTON code 73780 using access-plan/2R73_WDRYTON_DIDCOTP.cif
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 0469    | D4             | generated        |
    And I logout
    And I access the homepage as standard user
    And I restore to default train list config '1'
    And I click the app 'trains-list-1'
    And I switch to the new tab
    And I save the trains list config
    And I invoke the context menu for todays train 'generated' schedule uid 'generated' from the trains list
    And I wait for the trains list context menu to display
    And I open map GW02 from the context menu
    And I switch to the new tab
    Then there is no message about having too many Live Maps tabs open
    When I switch to the second-newest tab
    And I invoke the context menu for todays train 'generated' schedule uid 'generated' from the trains list
    And I wait for the trains list context menu to display
    And I open map GW2A from the context menu
    And I switch to the new tab
    Then there is no message about having too many Live Maps tabs open
    When I switch to the third-newest tab
    And I invoke the context menu for todays train 'generated' schedule uid 'generated' from the trains list
    And I wait for the trains list context menu to display
    And I open map HDGW01 from the context menu
    And I switch to the new tab
    Then there is a message about having too many Live Maps tabs open
    When I close the last tab
    And I switch to the third-newest tab
    And I click on the Enquiries button
    And I switch to the new tab
    And I type 'WDRYTON' into the enquiries location search box
    And I select the location at position 1 in the enquiries location auto suggest search results list
    And I click the enquiries view button
    And I invoke the context menu for todays train 'generated' schedule uid 'generated' from the enquiries page
    And I wait for the trains list context menu to display
    And I open map HDGW01 from the context menu
    And I switch to the new tab
    Then there is a message about having too many Live Maps tabs open

    #    Close down
    * I logout
    * I am on the admin page
    * The admin setting defaults are as originally shipped


  Scenario: 81205 - 6e Tab Management - limits apply (Live Maps from Unscheduled Trains List)

    Given The admin setting defaults are as in tab-limits-test-data-admin-settings.json
    And I remove all trains from the unscheduled trains list
    And I generate a new train description
    And the following live berth interpose message is sent from LINX (to create an unmatched service)
      | toBerth | trainDescriber | trainDescription |
      | 0467    | D4             | generated        |
    And I logout
    When I access the homepage as standard user
    And I click the app 'unsched-trains'
    And I switch to the new tab
    And I give the unscheduled trains list 1 seconds to render completely
    And I right click on the following unscheduled train
      | trainId   | entryTime | entryBerth | entrySignal | entryLocation | currentBerth | currentSignal | currentLocation | currentTrainDescriber |
      | generated | now       | D40467     | T467        | West Drayton  | D40467       | T467          | West Drayton    | D4                    |
    And I hover over the trains list context menu on line 3
    And I click the first map on the sub-menu
    And I switch to the new tab
    Then there is no message about having too many Live Maps tabs open
    When I switch to the second-newest tab
    And I right click on the following unscheduled train
      | trainId   | entryTime | entryBerth | entrySignal | entryLocation | currentBerth | currentSignal | currentLocation | currentTrainDescriber |
      | generated | now       | D40467     | T467        | West Drayton  | D40467       | T467          | West Drayton    | D4                    |
    And I hover over the trains list context menu on line 3
    And I click the first map on the sub-menu
    And I switch to the new tab
    Then there is no message about having too many Live Maps tabs open
    When I switch to the third-newest tab
    And I right click on the following unscheduled train
      | trainId   | entryTime | entryBerth | entrySignal | entryLocation | currentBerth | currentSignal | currentLocation | currentTrainDescriber |
      | generated | now       | D40467     | T467        | West Drayton  | D40467       | T467          | West Drayton    | D4                    |
    And I hover over the trains list context menu on line 3
    And I click the first map on the sub-menu
    And I switch to the new tab
    Then there is a message about having too many Live Maps tabs open

    #    Close down
    * I logout
    * I am on the admin page
    * The admin setting defaults are as originally shipped


  Scenario: 81205 - 6f Tab Management - limits apply (Live Map from Search - Signal)

    Given The admin setting defaults are as in tab-limits-test-data-admin-settings.json
    And I logout
    When I access the homepage as standard user
    And I search Signal for 'SN259'
    Then results are returned with that signal ID 'SN259'
    And the window title is displayed as 'Signal Search Results'
    When I invoke the context menu for signal with ID 'SN259'
    And I wait for the signal search context menu to display
    And I placed the mouseover on signal map option
    And I open the Map 'GW02'
    And I switch to the new tab
    Then there is no message about having too many Live Maps tabs open
    And I search Signal for 'SN259'
    Then results are returned with that signal ID 'SN259'
    And the window title is displayed as 'Signal Search Results'
    When I invoke the context menu for signal with ID 'SN259'
    And I wait for the signal search context menu to display
    And I placed the mouseover on signal map option
    And I open the Map 'HDGW01'
    And I switch to the new tab
    Then there is no message about having too many Live Maps tabs open
    And I search Signal for 'SN259'
    Then results are returned with that signal ID 'SN259'
    And the window title is displayed as 'Signal Search Results'
    When I invoke the context menu for signal with ID 'SN259'
    And I wait for the signal search context menu to display
    And I placed the mouseover on signal map option
    And I open the Map 'HDGW01'
    And I switch to the new tab
    Then there is a message about having too many Live Maps tabs open
    When I switch to the second-newest tab
    And I click close button at the bottom of table
    And I search Signal for 'SN259'
    Then results are returned with that signal ID 'SN259'
    And the window title is displayed as 'Signal Search Results'
    When I invoke the context menu for signal with ID 'SN259'
    And I wait for the signal search context menu to display
    And I placed the mouseover on signal map option
    And I open the Map 'GW02'
    And I switch to the new tab
    Then there is a message about having too many Live Maps tabs open

    #    Close down
    * I logout
    * I am on the admin page
    * The admin setting defaults are as originally shipped


  Scenario Outline: 81205 - 7a Tab Management - limits apply (Replay Map from Search - Timetable and Train)
    * The admin setting defaults are as in tab-limits-test-data-admin-settings.json
    * I logout
    * I access the homepage as standard user
    * I have cleared out all headcodes
    * I generate a new train description
    * I generate a new trainUID
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUID>  |
    And I wait until today's train '<planningUID>' has loaded
    And the following train activation message is sent from LINX
      | trainUID      | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUID> | <trainDescription> | now                    | 99999               | PADTON                 | today         | now                 |
    And the following live berth interpose message is sent from LINX (creating a train)
      | toBerth | trainDescriber | trainDescription   |
      | A007    | D3             | <trainDescription> |
    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name '<mapGroup>'
    And I select the map '<map>'
    When I wait for the buffer to fill
    And I click Skip forward button '5' times
    And I search Train for '<trainDescription>'
    Then results are returned with that planning UID '<planningUID>'
    And the window title is displayed as 'Train Search Results'
    When I invoke the context menu from train with planning UID '<planningUID>' and schedule date 'today' from the search results
    And I wait for the train search context menu to display
    Then the trains context menu is displayed
    And the train search context menu contains 'Open Timetable' on line 1
    And the train search context menu contains 'Select Maps' on line 2
    When I place the mouseover on map arrow link
    Then the following map names can be seen
      | mapName |
      | HDGW01  |
      | GW01    |
    When I open the Map 'HDGW01'
    Then the number of tabs open is 2
    When I switch to the new tab
    Then there is no message about having too many Replay Map tabs open
    When I switch to the second-newest tab
    And I search Train for '<trainDescription>'
    Then results are returned with that planning UID '<planningUID>'
    And the window title is displayed as 'Train Search Results'
    When I invoke the context menu from train with planning UID '<planningUID>' and schedule date 'today' from the search results
    And I wait for the train search context menu to display
    Then the trains context menu is displayed
    And the train search context menu contains 'Open Timetable' on line 1
    And the train search context menu contains 'Select Maps' on line 2
    When I place the mouseover on map arrow link
    Then the following map names can be seen
      | mapName |
      | HDGW01  |
      | GW01    |
    When I open the Map 'GW01'
    And I switch to the new tab
    Then there is a message about having too many Replay Map tabs open

    #    Close down
    * I logout
    * I am on the admin page
    * The admin setting defaults are as originally shipped

    Examples:
      | trainDescription | planningUID | mapGroup               | map                |
      | generated        | generated   | Wales & Western        | HDGW02reading.v    |


  Scenario: 81205 - 7b Tab Management - limits apply (Replay Map from Search - Signal)
      * The admin setting defaults are as in tab-limits-test-data-admin-settings.json
      * I logout
      * I access the homepage as standard user
      * I have not already authenticated
      * I remove today's train 'L10006' from the trainlist
      * the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
        | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
        | access-plan/1D46_PADTON_OXFD.cif | SLOUGH      | WTT_arr       | 1A06                | L10006         |
      * I wait until today's train 'L10006' has loaded
      * the following train activation message is sent from LINX
        | trainUID  | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
        | L10006    | 1A06        | now                    | 99999               | PADTON                 | today         | now                 |
      * the following live berth interpose message is sent from LINX (creating a match)
        | toBerth | trainDescriber | trainDescription |
        | 0519    | D6             | 1A06             |
      * I am on the replay page
      * I select Next
      * I expand the replay group of maps with name 'Wales & Western'
      * I select the map 'HDGW02reading.v'
      * I wait for the buffer to fill
      * I click Skip forward button '4' times
      * I increase the replay speed at position 15
      * I click Play button
      When I search Signal for 'SN15'
      And the signal search table is shown
      And I invoke the context menu for signal with ID 'SN15'
      And I wait for the signal search context menu to display
      And I placed the mouseover on signal map option
      And I open the Map 'GW01'
      And I switch to the new tab
      Then there is no message about having too many Replay Map tabs open
      When I search Signal for 'SN259'
      And the signal search table is shown
      And I invoke the context menu for signal with ID 'SN259'
      And I wait for the signal search context menu to display
      And I placed the mouseover on signal map option
      And I open the Map 'HDGW01'
      And I switch to the new tab
      Then there is a message about having too many Replay Map tabs open
      When I switch to the second-newest tab
      And I click close button at the bottom of table
      When I search Signal for 'SN15'
      And the signal search table is shown
      And I invoke the context menu for signal with ID 'SN15'
      And I wait for the signal search context menu to display
      And I placed the mouseover on signal map option
      And I open the Map 'GW01'
      And I switch to the new tab
      Then there is a message about having too many Replay Map tabs open

      #    Close down
      * I logout
      * I am on the admin page
      * The admin setting defaults are as originally shipped


  Scenario: 81205 - 7c Tab Management - limits apply (Replay Map from Open Replay Map)
    * The admin setting defaults are as in tab-limits-test-data-admin-settings.json
    * I logout
    * I access the homepage as standard user
    * I have not already authenticated
    * I am on the replay page
    * I select Next
    * I expand the replay group of maps with name 'Wales & Western'
    * I select the map 'GW01paddington.v'
    When I open the context menu for the continuation button 'GW02'
    And I open the next map in a new tab from the continuation button context menu
    And I switch to the new tab
    Then there is no message about having too many Replay Map tabs open
    When I switch to the second-newest tab
    When I open the context menu for the continuation button 'GW02'
    And I open the next map in a new tab from the continuation button context menu
    And I switch to the new tab
    Then there is a message about having too many Replay Map tabs open

  #    Close down
    * I logout
    * I am on the admin page
    * The admin setting defaults are as originally shipped

  Scenario Outline: 81205 - 8a Tab Management - limits apply (Replay Timetable from Search - Timetable and Train)
      * The admin setting defaults are as in tab-limits-test-data-admin-settings.json
      * I logout
      * I access the homepage as standard user
      * I have not already authenticated
      * I have cleared out all headcodes
      * I generate a new train description
      * I generate a new trainUID
      Given the train in CIF file below is updated accordingly so time at the reference point is now + '1' minute, and then received from LINX
        | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
        | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
      And I wait until today's train '<planningUid>' has loaded
      And the following live berth interpose message is sent from LINX (to create a match at Paddington)
        | toBerth | trainDescriber | trainDescription   |
        | A007    | D3             | <trainDescription> |
      And I am viewing the map HDGW01paddington.v
      And berth 'A007' in train describer 'D3' contains '<trainDescription>' and is visible
      And I invoke the context menu on the map for train <trainDescription>
      And the Matched version of the Schedule-matching map context menu is displayed
      And I open schedule matching screen from the map context menu
      And I switch to the new tab
      And the tab title is 'TMV Schedule Matching <trainDescription>'
      When I un-match the currently matched schedule
      And the following live berth step message is sent from LINX (departing from Paddington and manifesting the scheduling changes)
        | fromBerth | toBerth | trainDescriber | trainDescription   |
        | A007      | 0039    | D3             | <trainDescription> |
      And I give the replay data a further 2 seconds to be recorded
      And I refresh the Elastic Search indices
      And I am on the replay page
      And I select Next
      And I expand the replay group of maps with name 'Wales & Western'
      And I select the map 'HDGW01paddington.v'
      And I wait for the buffer to fill
      And I click Skip forward button '5' times
      And I search Timetable for '<planningUid>' and wait for result
        | PlanningUid   |
        | <planningUid> |
      And the search table is shown
      And I open today's timetable with planning UID <planningUid> from the search results
      And I switch to the new tab
      Then there is no message about having too many Replay Timetable tabs open
      When I switch to the second-newest tab
      And I open today's timetable with planning UID <planningUid> from the search results
      And I switch to the new tab
      Then there is no message about having too many Replay Timetable tabs open
      When I switch to the third-newest tab
      And I open today's timetable with planning UID <planningUid> from the search results
      And I switch to the new tab
      Then there is a message about having too many Replay Timetable tabs open

      #    Close down
      * I logout
      * I am on the admin page
      * The admin setting defaults are as originally shipped

      Examples:
        | trainDescription          | planningUid       |
        | generatedTrainDescription | generatedTrainUId |


  Scenario Outline: 81205 - 8b Tab Management - limits apply (Replay Timetable from Map Context Menu)
      * The admin setting defaults are as in tab-limits-test-data-admin-settings.json
      * I logout
      * I access the homepage as standard user
      * I have not already authenticated
      * I have cleared out all headcodes
      * I generate a new train description
      * I generate a new trainUID
      Given the train in CIF file below is updated accordingly so time at the reference point is now + '1' minute, and then received from LINX
        | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
        | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
      And I wait until today's train '<planningUid>' has loaded
      And the following train activation message is sent from LINX
        | trainUID       | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
        | <planningUid>  | <trainDescription> | now                    | 99999               | PADTON                 | today         | now                 |
      And the following live berth interpose message is sent from LINX (to create a match at Paddington)
        | toBerth | trainDescriber | trainDescription   |
        | A007    | D3             | <trainDescription> |
      And the following live berth step message is sent from LINX (departing from Paddington)
        | fromBerth | toBerth | trainDescriber | trainDescription   |
        | A007      | 0039    | D3             | <trainDescription> |
      And the following train running information message is sent from LINX
        | trainUID      | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType           |
        | <planningUid> | <trainDescription> | today              | 73000               | PADTON                 | Departure from origin |
      And I give the replay data a further 2 seconds to be recorded
      And I refresh the Elastic Search indices
      When I am on the replay page
      And I select Next
      And I expand the replay group of maps with name 'Wales & Western'
      And I select the map 'HDGW01paddington.v'
      And I wait for the buffer to fill
      And I click Skip forward button '5' times
      And I invoke the context menu on the map for train <trainDescription>
      And I open timetable from the map context menu
      And I switch to the new tab
      Then there is no message about having too many Replay Timetable tabs open
      When I switch to the second-newest tab
      And I invoke the context menu on the map for train <trainDescription>
      And I open timetable from the map context menu
      And I switch to the new tab
      Then there is no message about having too many Replay Timetable tabs open
      When I switch to the third-newest tab
      And I invoke the context menu on the map for train <trainDescription>
      And I open timetable from the map context menu
      And I switch to the new tab
      Then there is a message about having too many Replay Timetable tabs open

      #    Close down
      * I logout
      * I am on the admin page
      * The admin setting defaults are as originally shipped

      Examples:
        | trainDescription          | planningUid       |
        | generatedTrainDescription | generatedTrainUId |


  Scenario: 81205 - 8c Tab Management - limits apply (Multiple Replay Sessions)
    * The admin setting defaults are as in tab-limits-test-data-admin-settings.json
    * I logout
    * I access the homepage as standard user
    * I have not already authenticated
    * I have cleared out all headcodes
    Given I am on the home page
    And I click the app 'replay'
    And I switch to the new tab
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '5' times
    And I switch to the new tab
    Then there is no message about having too many Replay sessions open
    When I switch to the second-newest tab
    And I click the app 'replay'
    And I switch to the new tab
    Then there is no message about having too many Replay sessions open
    When I switch to the third-newest tab
    And I click the app 'replay'
    And I switch to the new tab
    Then there is a message about having too many Replay sessions open

    #    Close down
    * I logout
    * I am on the admin page
    * The admin setting defaults are as originally shipped
