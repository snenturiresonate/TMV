@newSession
Feature: 34393 - TMV replay - Schematic Maps - Render Objects

  As a TMV User
  I want the view schematic maps in replay mode
  So that I can view the historic running railway

  Background:
    * I have not already authenticated

  Scenario Outline: 33750-1 Render specific objects
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name '<mapGroup>'
    And I select the map '<map>'
    Then <numberOfElements> objects of type <object> are rendered
    And the objects of type <object> are the correct colour

    Examples:
      | mapGroup               | map                      | object                       | numberOfElements |
      | North West and Central | MD12birminghamsnowhill.v | platform                     | 58               |
      | North West and Central | NW14eastmanchester.v     | WILD_indicator               | 2                |
      | North West and Central | MD03watford.v            | OHL_limits                   | 1                |
      | Southern               | HS1Bhdoverviewb.v        | HABDS                        | 4                |
      | Wales & Western        | GW21hereford.v           | signal_box                   | 14               |
      | Eastern                | EA04norwich.v            | direction_arrows             | 91               |
      | Wales & Western        | GW15cambrian.v           | end_of_line_indication       | 2                |
      | Scotland\'s Railway    | SC01cowlairs.v           | OHNS                         | 15               |
      | Eastern                | NE01kingscross.v         | tripcock                     | 2                |
      | Eastern                | NE18gainsborough.v       | flight_path                  | 2                |
      | Eastern                | NE15shipley.v            | train_washer_indicator       | 1                |
      | Wales & Western        | GW15cambrian.v           | AES_boundaries_line_group    | 10               |
      | Wales & Western        | GW15cambrian.v           | alarm_box                    | 1                |
      | Scotland\'s Railway    | SC16aberdeen.v           | tunnel_bridge_viaduct        | 32               |
      | Eastern                | EA9Ceastlondon.v         | cut_bar                      | 14               |
      | Eastern                | NE24spalding.v           | level_crossing               | 79               |
      | Eastern                | EA09stratford.v          | dashed_track_section         | 6                |
      | Southern               | SO07blackfriars.v        | continuation_button          | 36               |
      | Eastern                | NE15shipley.v            | limit_of_shunt_static_signal | 8                |
      | Scotland\'s Railway    | SC05yoker.v              | static_signal                | 22               |
      | Scotland\'s Railway    | SC11ayr.v                | static_shunt_signal          | 1                |
      | Southern               | HS1Nhighspeed1north.v    | static_markerboard           | 157              |
      | Eastern                | NE01kingscross.v         | active_track_section         | 481              |
      | Wales & Western        | GW03reading.v            | active_main_signal           | 177              |
      | Southern               | SO38salisbury.v          | active_shunters_release      | 3                |
      | Southern               | SO2Astrood.v             | active_markerboard           | 2                |
      | Wales & Western        | GW15cambrian.v           | active_shunt_markerboard     | 17               |
      | Wales & Western        | HDGW05bristoltm.v        | active_shunt_signal          | 68               |
      | Eastern                | MD22hinckleymanton.v     | berth                        | 162              |
      | Eastern                | MD22hinckleymanton.v     | manual_trust_berth           | 35               |
      | Wales & Western        | GW15cambrian.v           | aes_boundaries_text_label    | 12               |
      | Wales & Western        | GW15cambrian.v           | direction_lock_text_label    | 11               |
      | Eastern                | NE08darlington.v         | connector_text_label         | 8                |
      | Eastern                | NE30durhamcoast.v        | other_text_label             | 188              |


  Scenario: 34393-4 Replay - Continuation Button (Primary Click)
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'GW01paddington.v'
    When I select the continuation button 'GW02'
    And the tab title is 'TMV Replay GW02'

  Scenario: 34393-5 Replay - Continuation Button (Secondary Click)
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'GW01paddington.v'
    When I open the context menu for the continuation button 'GW02'
    Then the context menu for the continuation button has options to open the map within to the same view or new tab

  Scenario: 34393-5 Replay - Continuation Button (Secondary Click - Open)
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'GW01paddington.v'
    And I open the context menu for the continuation button 'GW02'
    When I open the next map from the continuation button context menu
    And the tab title is 'TMV Replay GW02'

  Scenario: 34393-5 Replay - Continuation Button (Secondary Click - Open new tab)
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'GW01paddington.v'
    When I open the context menu for the continuation button 'GW02'
    And I open the next map in a new tab from the continuation button context menu
    And the tab title is 'TMV Replay GW01'
    And I switch to the new tab
    And the tab title is 'TMV Replay GW02'

  Scenario: 34393-6 Replay - Berth Menu (Secondary Click)
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'GW01paddington.v'
    And I click on the layers icon in the nav bar
    And I toggle the 'Berth' toggle 'on'
    When I use the secondary mouse on normal berth D3A001
    Then the context menu for the berth has a berth name of 'D3A001'
    And the context menu for the berth has a signal plated name of 'SN1'

    Scenario Outline: 78845c Signal Menu Replay (Primary Click)
#    Given a user is viewing a schematic map
#    And there are signals visible
#    When user select a signal with the primary click
#    Then the signal's information is displayed
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map '<mapId>'
    When I use the primary mouse on <signalType> signal <signalId>
    Then I am presented with a set of information about the signal
    And the signal information for <signalId> contains <signalPlatedName>

    Examples:
      | mapId           | signalType               | signalId | signalPlatedName |
      | HDGW02reading.v | active_main_vertical     | T3570    | T3570            |
      | GW04didcot.v    | active_shunt_horizontal  | OD6980   | OD6980           |
      | GW11bristol.v   | active_yellow_shunt      | BL6618   | BL6618           |
      | GW15cambrian.v  | active_markerboard       | MH1242   | MH1242           |
      | GW15cambrian.v  | active_shunt_markerboard | MH1072   | MH1072           |

    Scenario Outline: 78845b Signal Menu Replay (Secondary Click)
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map '<mapId>'
    When I use the secondary mouse on <signalType> signal <signalId>
    Then I am presented with a set of information about the signal
    And the signal information for <signalId> contains <signalPlatedName>

    Examples:
      | mapId           | signalType               | signalId | signalPlatedName |
      | HDGW02reading.v | active_main_vertical     | T3570    | T3570            |
      | GW04didcot.v    | active_shunt_horizontal  | OD6980   | OD6980           |
      | GW11bristol.v   | active_yellow_shunt      | BL6618   | BL6618           |
      | GW15cambrian.v  | active_markerboard       | MH1242   | MH1242           |
      | GW15cambrian.v  | active_shunt_markerboard | MH1072   | MH1072           |
