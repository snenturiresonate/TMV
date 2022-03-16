@TMVPhase2 @P2.S1
Feature: 78815 - TMV Map Interaction - Map Signal Primary Click

  As a TMV User
  I want the ability to interact with the schematic maps
  So that I can access additional functions or information

  Background:
    Given I am on the home page

  Scenario Outline: 78845a Signal Menu (Primary Click) - <signalType>
    # Given a user is viewing a schematic map
    # And there are signals visible
    # When user select a signal with the primary click
    # Then the signal's information is displayed
    Given I am authenticated to use TMV
    And I am viewing the map <mapId>
    When I use the primary mouse on <signalType> signal <signalId>
    Then I am presented with a set of information about the signal
    And the signal information for <signalId> contains <signalPlatedName>

    Examples:
      | mapId           | signalType               | signalId | signalPlatedName |
      | hdgw02reading.v | active_main_vertical     | T3570    | T3570            |
      | gw04didcot.v    | active_shunt_horizontal  | OD6980   | OD6980           |
      | gw11bristol.v   | active_yellow_shunt      | BL6618   | BL6618           |
      | gw15cambrian.v  | active_markerboard       | MH1242   | MH1242           |
      | gw15cambrian.v  | active_shunt_markerboard | MH1072   | MH1072           |

  Scenario Outline: 78845b Signal Menu (Secondary Click) - <signalType>
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

  Scenario Outline: 78845c Signal Menu Replay (Primary Click) - <signalType>
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

  Scenario Outline: 78845b Signal Menu Replay (Secondary Click) - <signalType>
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
