Feature: 33750 - Schematic Maps - Render Objects

  As a TMV User
  I want to view a schematic representation of the railway
  So that I can see the signalling infrastructure of the railway nationally

  Scenario Outline: 33750-1 Render specific objects
    When I am viewing the map <map>
    Then <numberOfElements> objects of type <object> are rendered
    And the objects of type <object> are the correct colour

#@bugs 50740, 51010
    Examples:
      | object                       | map                      | numberOfElements |
      | platform                     | md12birminghamsnowhill.v | 58               |
      | WILD_indicator               | nw14eastmanchester.v     | 2                |
      | OHL_limits                   | md03watford.v            | 1                |
#      | HABDS                        | hdhs1boverviewb.v        | 4                |
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
      | dashed_track_section         | ea09stratford.v          | 2                |
      | continuation_button          | so07blackfriars.v        | 18               |
      | limit_of_shunt_static_signal | ne15shipley.v            | 8                |
      | static_signal                | sc05yoker.v              | 22               |
      | static_shunt_signal          | sc11ayr.v                | 1                |
#      | static_markerboard           | hs1nhighspeed1north.v    | 7                |
      | active_track_section         | ne01kingscross.v         | 481              |
      | active_main_signal           | gw03reading.v            | 177              |
      | active_shunters_release      | so38salisbury.v          | 3                |
      | active_markerboard           | so2astrood.v             | 2                |
      | active_shunt_markerboard     | gw15cambrian.v           | 17               |
      | active_shunt_signal          | hdgw05bristoltm.v        | 68               |
      | berth                        | md22hinckleymanton.v     | 158              |
      | last_berth                   | md22hinckleymanton.v     | 4                |
      | manual_trust_berth           | md22hinckleymanton.v     | 35               |
      | aes_boundaries_text_label    | gw15cambrian.v           | 12               |
      | direction_lock_text_label    | gw15cambrian.v           | 11               |
      | connnector_text_label        | gw15cambrian.v           | 2                |
      | other_text_label             | ne30durhamcoast.v        | 188              |

