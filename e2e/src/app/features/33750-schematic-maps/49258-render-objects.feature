Feature: 33750 - Schematic Maps - Render Objects

  As a TMV User
  I want to view a schematic representation of the railway
  So that I can see the signalling infrastructure of the railway nationally

  Background:
    Given I am on the home page

  Scenario Outline: 33750-1 Render specific objects
    When I am viewing the map <map>
    Then <numberOfElements> objects of type <object> are rendered
    And the objects of type <object> are the correct colour

    Examples:
      | object                       | map                      | numberOfElements |
      | platform                     | md12birminghamsnowhill.v | 58               |
      | WILD_indicator               | nw14eastmanchester.v     | 2                |
      | OHL_limits                   | md03watford.v            | 1                |
      | HABDS                        | hs1bhdoverviewb.v        | 4                |
      | signal_box                   | gw21hereford.v           | 14               |
      | direction_arrows             | ea04norwich.v            | 91               |
      | end_of_line_indication       | gw15cambrian.v           | 2                |
      | OHNS                         | sc01cowlairs.v           | 15               |
      | tripcock                     | ne01kingscross.v         | 2                |
      | flight_path                  | ne18gainsborough.v       | 2                |
      | train_washer_indicator       | ne15shipley.v            | 1                |
      | AES_boundaries_line_group    | gw15cambrian.v           | 10               |
      | alarm_box                    | gw15cambrian.v           | 1                |
      | tunnel_bridge_viaduct        | sc16aberdeen.v           | 32               |
      | cut_bar                      | ea9ceastlondon.v         | 14               |
      | level_crossing               | ne24spalding.v           | 79               |
      | dashed_track_section         | ea09stratford.v          | 6                |
      | continuation_button          | so07blackfriars.v        | 36               |
      | limit_of_shunt_static_signal | ne15shipley.v            | 8                |
      | static_signal                | sc05yoker.v              | 22               |
      | static_shunt_signal          | sc11ayr.v                | 1                |
      | static_markerboard           | hs1nhighspeed1north.v    | 157              |
      | active_track_section         | ne01kingscross.v         | 481              |
      | active_main_signal           | gw03reading.v            | 177              |
      | active_shunters_release      | so38salisbury.v          | 3                |
      | active_markerboard           | so2astrood.v             | 2                |
      | active_shunt_markerboard     | gw15cambrian.v           | 17               |
      | active_shunt_signal          | hdgw05bristoltm.v        | 68               |
      | berth                        | md22hinckleymanton.v     | 162              |
      | manual_trust_berth           | md22hinckleymanton.v     | 35               |
      | aes_boundaries_text_label    | gw15cambrian.v           | 12               |
      | direction_lock_text_label    | gw15cambrian.v           | 11               |
      | connector_text_label         | ne08darlington.v         | 8                |
      | other_text_label             | ne30durhamcoast.v        | 188              |


  Scenario: 33750-2 Continuation Button (Primary Click)
    Given I am authenticated to use TMV
    And I view a schematic that contains a continuation button
    When I use the primary mouse click on a continuation button
    Then the view is refreshed with the linked map

  Scenario: 33750-3a Continuation Button (Secondary Click - Open)
    Given I am authenticated to use TMV
    And I view a schematic that contains a continuation button
    When I use the secondary mouse click on a continuation button
    Then I am presented with a menu which I choose to open the map within to the same view or new tab
    When I select "Open" map from the menu
    Then the view is refreshed with the linked map

  Scenario: 33750-3b Continuation Button (Secondary Click - Open new tab)
    Given I am authenticated to use TMV
    And I view a schematic that contains a continuation button
    When I use the secondary mouse click on a continuation button
    And I am presented with a menu which I choose to open the map within to the same view or new tab
    And I select "Open new tab" map from the menu
    Then a new tab opens showing the linked map
    And the previous tab still displays the original map

  Scenario Outline: 33750-4a Berth Menu (Secondary Click - berths with main signals)
    Given I am authenticated to use TMV
    And I am viewing the map gw16shrewsbury.v
    And I click on the layers icon in the nav bar
    And I toggle the 'Berth' toggle 'on'
    When I use the secondary mouse on normal berth <berthId>
    Then I am presented with a set of information about the berth
    And the berth information for <berthId> contains <TDandBerthId>
    And the berth information for <berthId> contains <signalPlatedName>

    Examples:
      | berthId | TDandBerthId | signalPlatedName |
      | C38466  | C38466       | SC8466           |
      | C38466  | C38466       | SC8475           |
      | C38410  | C38410       | SC8410           |


  Scenario Outline: 33750-4b Berth Menu (Secondary Click - berths with static signals)
    Given I am authenticated to use TMV
    And I am viewing the map gw16shrewsbury.v
    And I click on the layers icon in the nav bar
    And I toggle the 'Berth' toggle 'on'
    When I use the secondary mouse on normal berth <berthId>
    Then I am presented with a set of information about the berth
    And the berth information for <berthId> only contains <TDandBerthId>

    Examples:
      | berthId | TDandBerthId |
      | CSCNUW  | CSCNUW       |
      | MHSB11  | MHSB11       |

  Scenario Outline: 33750-4c Berth Menu (Secondary Click - manual berths)
    Given I am authenticated to use TMV
    And I am viewing the map gw13exeter.v
    And I click on the layers icon in the nav bar
    And I toggle the 'Berth' toggle 'on'
    When I use the secondary mouse on manual-trust berth <berthId>
    Then I am presented with a set of information about the berth
    And the manual trust berth information for <berthId> only contains "<berthIdnoTD>"
    Examples:
      | berthId | berthIdnoTD        |
      | 83311X  | 311X Dep Off Route |
      | 83232D  | 232D Dep           |
      | 83475A  | 475A Arr           |

    Scenario Outline: 78845a Signal Menu (Primary Click)
#    Given a user is viewing a schematic map
#    And there are signals visible
#    When user select a signal with the primary click
#    Then the signal's information is displayed
    Given I am authenticated to use TMV
    And I am viewing the map <mapId>
    When I use the primary mouse on <signalType> signal <signalId>
    Then I am presented with a set of information about the signal
    And the signal information for <signalId> contains <signalPlatedName>

    Examples:
      | mapId           | signalType               | signalId | signalPlatedName |
      | hdgw02reading.v | active_main_vertical     | T3570   | T3570           |
      | gw04didcot.v    | active_shunt_horizontal  | OD6980   | OD6980           |
      | gw11bristol.v   | active_yellow_shunt      | BL6618   | BL6618           |
      | gw15cambrian.v  | active_markerboard       | MH1242   | MH1242           |
      | gw15cambrian.v  | active_shunt_markerboard | MH1072   | MH1072           |

    Scenario Outline: 78845b Signal Menu (Secondary Click)
    Given I am authenticated to use TMV
    And I am viewing the map <mapId>
    When I use the secondary mouse on <signalType> signal <signalId>
    Then I am presented with a set of information about the signal
    And the signal information for <signalId> contains <signalPlatedName>

    Examples:
      | mapId           | signalType               | signalId | signalPlatedName |
      | hdgw02reading.v | active_main_vertical     | T3570   | T3570           |
      | gw04didcot.v    | active_shunt_horizontal  | OD6980   | OD6980           |
      | gw11bristol.v   | active_yellow_shunt      | BL6618   | BL6618           |
      | gw15cambrian.v  | active_markerboard       | MH1242   | MH1242           |
      | gw15cambrian.v  | active_shunt_markerboard | MH1072   | MH1072           |
