Feature: 46476 - Toggle Schematic

  As a TMV User
  I want to toggle map infrastructure
  So that I can focus on a particular type of infrastructure

  Background:
    Given I am viewing the map gw01paddington.v

    @bug @bug_58090
  Scenario:46476-1 Route Set Track (turn on)
  #Given the user is authenticated to use TMV
  #And the user is viewing a live the map
  #And the route set track is toggled off
  #When the user toggles on the route set track to on
  #Then the route set is displayed for the track for all trains that have a route set
      And I click on the layers icon in the nav bar
      And I toggle the 'Route Set - Track' toggle 'off'
      And the 'Route Set - Track' toggle is 'off'
      And the tracks 'PNPNQ3' are displayed in thin palegrey
      And I set up all signals for address 06 in D3 to be not-proceed
      When the following signalling update message is sent from LINX
        | trainDescriber | address | data | timestamp |
        | D3             | 48      | 10   | 10:45:00  |
      And I click on the layers icon in the nav bar
      And the tracks 'PNPNQ3' are displayed in thin palegrey
      And I toggle the 'Route Set - Track' toggle 'on'
      And the 'Route Set - Track' toggle is 'on'
      Then the tracks 'PNPNQ3' are displayed in solid white
      And I move to map 'GW02' via continuation link
      And I click on the layers icon in the nav bar
      And the 'Route Set - Track' toggle is 'on'
      And the tracks 'PNPNQ3' are displayed in solid white


     @bug @bug_58090
    Scenario:46476-2 Route Set Code (turn on)
    #Given the user is authenticated to use TMV
    #And the user is viewing a live the map
    #And the route set code is toggled off
    #When the user toggles on the route set code to on
    #Then the route set code is displayed for the track for all trains that have a route set
       And I click on the layers icon in the nav bar
       And I toggle the 'Route Set - Code' toggle 'off'
       And the 'Route Set - Code' toggle is 'off'
       And I set up all signals for address 06 in D3 to be not-proceed
       And the route set code on the track 'PNPNQ3' is ''
       And the following signalling update message is sent from LINX
         | trainDescriber | address | data | timestamp |
         | D3             | 48      | 10   | 10:45:00  |
       And I click on the layers icon in the nav bar
       And the 'Route Set - Code' toggle is 'on'
       Then the route set code on the track 'PNPNQ3' is 'CXR'
       And I move to map 'GW02' via continuation link
       And I click on the layers icon in the nav bar
       And the 'Route Set - Code' toggle is 'on'
       And the route set code on the track 'PNPNQ3' is 'CXR'


  Scenario: 3 Berth (turn on)
     #Given the user is authenticated to use TMV
     #And the user is viewing a live the map
     #And the berth is toggled off
     #When the user toggles on the berth to on
     #Then the all berth codes are displayed for all berths
      When I click on the layers icon in the nav bar
      And I toggle the 'Berth' toggle 'off'
      And the following berth interpose message is sent from LINX (to indicate train is present)
      | timestamp | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0209    | D3            | 1G69             |
      Then berth '0209' in train describer 'D3' contains '1G69' and is visible
      And I toggle the 'Berth' toggle 'on'
      Then berth '0209' in train describer 'D3' contains '0209' and is visible
      And I move to map 'GW02' via continuation link
      And berth '0209' in train describer 'D3' contains '0209' and is visible
      And I click on the layers icon in the nav bar
      And I toggle the 'Berth' toggle 'off'
      And berth '0209' in train describer 'D3' contains '1G69' and is visible
      And I toggle the 'Berth' toggle 'on'
      And berth '0209' in train describer 'D3' contains '0209' and is visible


  Scenario:4 Platform (turn on)
      #Given the user is authenticated to use TMV
      #And the user is viewing a live the map
      #And the platforms is toggled off
      #When the user toggles on the platform to on
      #Then platforms are not displayed
      When I click on the layers icon in the nav bar
      And I toggle the 'Platform' toggle 'off'
      And the 'Platform' toggle is 'off'
      And the platform layer is not shown
      And I click on the layers icon in the nav bar
      And I click on the layers icon in the nav bar
      And I toggle the 'Platform' toggle 'On'
      And the 'Platform' toggle is 'on'
      And the platform layer is shown
      And I move to map 'HDGW02' via continuation link
      And I click on the layers icon in the nav bar
      Then the 'Platform' toggle is 'on'
      And the platform layer is shown

  @bug @bug_58090
  Scenario:46476- Addtional test case to check Default to Non default and open the new map through search and check the default states
  #Given the user is authenticated to use TMV
  #And the user is viewing a live the map
  #And the route set track is toggled off
  #When the user toggles on the route set track to on
  #Then the route set is displayed for the track for all trains that have a route set
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 48      | 10   | 10:45:00  |
    And the following berth interpose message is sent from LINX (to indicate train is present)
      | timestamp | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0209    | D3            | 1G69             |
    And I click on the layers icon in the nav bar
    And I toggle the 'Platform' toggle 'off'
    And I toggle the 'Berth' toggle 'on'
    And I toggle the 'Route Set - Track' toggle 'on'
    And I toggle the 'Route Set - Code' toggle 'on'
    Then the tracks 'PNPNQ3' are displayed in solid white
    And the platform layer is not shown
    And berth '0209' in train describer 'D3' contains '0209' and is visible
    And the route set code on the track 'PNPNQ3' is 'CXR'
    And I type 'GW02' into the map search box
    And I click the search icon
    And I select the map at position 1 in the search results list
    And I switch to the new tab
    And I click on the layers icon in the nav bar
    And the 'Platform' toggle is 'on'
    And the 'Berth' toggle is 'off'
    And the 'Route Set - Track' toggle is 'off'
    And the 'Route Set - Code' toggle is 'off'
    And the tracks 'PNPNQ3' are displayed in solid white
    And the platform layer is shown
    And berth '0209' in train describer 'D3' contains '1G69' and is visible
    And the route set code on the track 'PNPNQ3' is 'CXR'
