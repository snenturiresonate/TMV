Feature: 33751 - Toggle Schematic

  As a TMV User
  I want to toggle map infrastructure
  So that I can focus on a particular type of infrastructure

  Background:
    Given I am viewing the map GW11bristol.v
    And I have cleared out all headcodes

  Scenario:33751-1 Route Set Track (turn on)
    #Given the user is authenticated to use TMV
    #And the user is viewing a live the map
    #And the route set track is toggled off
    #When the user toggles on the route set track to on
    #Then the route set is displayed for the track for all trains that have a route set
    And I set up all signals for address 03 in D0 to be not-proceed
    And I click on the layers icon in the nav bar
    And I toggle the 'Route Set - Track' toggle 'off'
    And the 'Route Set - Track' toggle is 'off'
    And the tracks 'BLBLGV, BLBLGW, BLBLH2' are displayed in thin palegrey
    When the following live signalling update message is sent from LINX
      | trainDescriber | address | data |
      | D0             | 03      | 02   |
    And the tracks 'BLBLGV, BLBLGW, BLBLH2' are displayed in thin palegrey
    And I toggle the 'Route Set - Track' toggle 'on'
    And the 'Route Set - Track' toggle is 'on'
    Then the tracks 'BLBLGV, BLBLGW, BLBLH2' are displayed in solid white
    And I move to map 'GW5A' via continuation link
    And I click on the layers icon in the nav bar
    And the 'Route Set - Track' toggle is 'on'
    And the tracks 'BLBLGV, BLBLGW, BLBLH2' are displayed in solid white


    Scenario:33751-2 Route Set Code (turn on)
      #Given the user is authenticated to use TMV
      #And the user is viewing a live map
      #And the route set code is toggled off
      #When the user toggles on the route set code to on
      #Then the route set code is displayed for the track for all trains that have a route set
      And I set up all signals for address 03 in D0 to be not-proceed
      And I click on the layers icon in the nav bar
      And I toggle the 'Route Set - Code' toggle 'off'
      And the 'Route Set - Code' toggle is 'off'
      And there is no text indication for s-class-berth 'D01855'
      When the following live signalling update message is sent from LINX
         | trainDescriber | address | data |
         | D0             | 03      | 02   |
      And there is no text indication for s-class-berth 'D01855'
      And I toggle the 'Route Set - Code' toggle 'on'
      Then the s-class-berth 'D01855' will display a Route indication of 'DFR'
      When I move to map 'GW5A' via continuation link
      And I click on the layers icon in the nav bar
      Then the 'Route Set - Code' toggle is 'on'
      And the s-class-berth 'D01855' will display a Route indication of 'DFR'


  Scenario:33751-3 Berth (turn on)
    #Given the user is authenticated to use TMV
    #And the user is viewing a live map
    #And the berth is toggled off
    #When the user toggles on the berth to on
    #Then the all berth codes are displayed for all berths
    When I click on the layers icon in the nav bar
    And I toggle the 'Berth' toggle 'off'
    And the following live berth interpose message is sent from LINX (to indicate train is present)
    | toBerth | trainDescriber| trainDescription |
    | 1855    | D0            | 1S22             |
    Then berth '1855' in train describer 'D0' contains '1S22' and is visible
    And I toggle the 'Berth' toggle 'on'
    Then berth '1855' in train describer 'D0' contains '1855' and is visible
    And I move to map 'GW5A' via continuation link
    And berth '1855' in train describer 'D0' contains '1855' and is visible
    And I click on the layers icon in the nav bar
    And I toggle the 'Berth' toggle 'off'
    And berth '1855' in train describer 'D0' contains '1S22' and is visible
    And I toggle the 'Berth' toggle 'on'
    And berth '1855' in train describer 'D0' contains '1855' and is visible


  Scenario:33751-4 Platform (turn on)
    #Given the user is authenticated to use TMV
    #And the user is viewing a live map
    #And the platforms is toggled off
    #When the user toggles on the platform to on
    #Then platforms are not displayed
    When I click on the layers icon in the nav bar
    And I toggle the 'Platform' toggle 'off'
    And the 'Platform' toggle is 'off'
    And the platform layer is not shown
    And I toggle the 'Platform' toggle 'on'
    And the 'Platform' toggle is 'on'
    And the platform layer is shown
    And I move to map 'GW5A' via continuation link
    And I click on the layers icon in the nav bar
    Then the 'Platform' toggle is 'on'
    And the platform layer is shown

  Scenario:33751-5 Additional test case to check Default to Non default and open the new map through search and check the default states
    When I set up all signals for address 03 in D0 to be not-proceed
    And the following live signalling update message is sent from LINX
      | trainDescriber | address | data |
      | D0             | 03      | 02   |
    And the following live berth interpose message is sent from LINX (to indicate train is present)
      | toBerth | trainDescriber| trainDescription |
      | 1855    | D0            | 1S22             |
    And I click on the layers icon in the nav bar
    And I toggle the 'Platform' toggle 'off'
    And I toggle the 'Berth' toggle 'on'
    And I toggle the 'Route Set - Track' toggle 'off'
    And I toggle the 'Route Set - Code' toggle 'off'
    And the tracks 'BLBLGV, BLBLGW, BLBLH2' are displayed in thin palegrey
    And there is no text indication for s-class-berth 'D01855'
    And the platform layer is not shown
    And berth '1855' in train describer 'D0' contains '1855' and is visible
    When I search for map 'GW5A' via the recent map list
    And I click the search icon
    And I select the map at position 1 in the search results list
    And I switch to the new tab
    And I click on the layers icon in the nav bar
    Then the 'Platform' toggle is 'on'
    And the 'Berth' toggle is 'off'
    And the 'Route Set - Track' toggle is 'on'
    And the 'Route Set - Code' toggle is 'on'
    And the tracks 'BLBLGV, BLBLGW, BLBLH2' are displayed in solid white
    And the s-class-berth 'D01855' will display a Route indication of 'DFR'
    And the platform layer is shown
    And berth '1855' in train describer 'D0' contains '1S22' and is visible
