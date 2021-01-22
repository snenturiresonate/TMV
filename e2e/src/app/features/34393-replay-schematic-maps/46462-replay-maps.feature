Feature: 34393 - TMV replay - Schematic Maps - Render Objects

  As a TMV User
  I want the view schematic maps in replay mode
  So that I can view the historic running railway
  
  Scenario Outline: 33750-1 Render specific objects
    Given I am on the replay page
    And I expand the replay group of maps with name '<mapGroup>'
    And I select the map '<map>'
    And I select Start
    Then <numberOfElements> objects of type <object> are rendered
    And the objects of type <object> are the correct colour

    Examples:
      | mapGroup                     | map                          | object                       | numberOfElements |
      | North West and Central       | md12birminghamsnowhill.v     | platform                     | 58               |
      | North West and Central       | nw14eastmanchester.v         | WILD_indicator               | 2                |
      | North West and Central       | md03watford.v                | OHL_limits                   | 1                |
      | Southern                     | hs1bhdoverviewb.v            | HABDS                        | 4                |
      | Wales & Western              | gw21hereford.v               | signal_box                   | 14               |
      | Eastern                      | ea04norwich.v                | direction_arrows             | 91               |
      | Wales & Western              | gw15cambrian.v               | end_of_line_indication       | 2                |
      | Scotland\'s Railway          | sc01cowlairs.v               | OHNS                         | 15               |
      | Eastern                      | ne01kingscross.v             | tripcock                     | 2                |
      | Eastern                      | ne18gainsborough.v           | flight_path                  | 2                |
      | Eastern                      | ne15shipley.v                | train_washer_indicator       | 1                |
      | Wales & Western              | gw15cambrian.v               | AES_boundaries_line_group    | 10               |
      | Wales & Western              | gw15cambrian.v               | alarm_box                    | 1                |
      | Scotland\'s Railway          | sc16aberdeen.v               | tunnel_bridge_viaduct        | 32               |
      | Eastern                      | ea9ceastlondon.v             | cut_bar                      | 14               |
      | Eastern                      | ne24spalding.v               | level_crossing               | 79               |
      | Eastern                      | ea09stratford.v              | dashed_track_section         | 2                |
      | Southern                     | so07blackfriars.v            | continuation_button          | 18               |
      | Eastern                      | ne15shipley.v                | limit_of_shunt_static_signal | 8                |
      | Scotland\'s Railway          | sc05yoker.v                  | static_signal                | 22               |
      | Scotland\'s Railway          | sc11ayr.v                    | static_shunt_signal          | 1                |
      | Southern                     | hs1nhighspeed1north.v        | static_markerboard           | 157              |
      | Eastern                      | ne01kingscross.v             | active_track_section         | 481              |
      | Wales & Western              | gw03reading.v                | active_main_signal           | 177              |
      | Southern                     | so38salisbury.v              | active_shunters_release      | 3                |
      | Southern                     | so2astrood.v                 | active_markerboard           | 2                |
      | Wales & Western              | gw15cambrian.v               | active_shunt_markerboard     | 17               |
      | Wales & Western              | hdgw05bristoltm.v            | active_shunt_signal          | 68               |
      | Eastern                      | md22hinckleymanton.v         | berth                        | 162              |
      | Eastern                      | md22hinckleymanton.v         | manual_trust_berth           | 35               |
      | Wales & Western              | gw15cambrian.v               | aes_boundaries_text_label    | 12               |
      | Wales & Western              | gw15cambrian.v               | direction_lock_text_label    | 11               |
      | Eastern                      | ne08darlington.v             | connector_text_label         | 4                |
      | Eastern                      | ne30durhamcoast.v            | other_text_label             | 188              |
