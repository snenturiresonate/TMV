Feature: 40680 - Basic UI - Schematic Object State Scenarios
  (From Gherkin for Feature 40680 and functionality developed in US34081)
  As a TMV User
  I want to schematic objects displayed with the latest state
  So that I have a live view of the railway

  Background:
    Given I am on the home page
    And I expand the group of maps with name 'Wales & Western'
    And I navigate to the maps view with id hdgw01paddington.v
    And I switch to the new tab

  Scenario: 34081-1 Validating the display of Current Signal State
    Then the signal roundel for signal 'SN128' is grey
    And the static shunt signal state for signal 'SN6142' is grey
    And I refresh the browser
    Then the signal roundel for signal 'SN128' is grey
    And the static shunt signal state for signal 'SN6142' is grey

  Scenario: 34081-2 Validating the display of Unknown Main Signal state
    #Given I am viewing the map HDGW01paddington.v
    Then the signal roundel for signal 'SN128' is grey

  Scenario: 34081-3 Validating the display of Main Proceed Signal state
    #Given I am viewing the map HDGW01paddington.v
    #And I set up all signals for address 80 in D3 to be red
    And I set up all signals for address 80 in D3 to be red
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 80      | 00   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN128' is red
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 80      | FF   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN128' is green

  Scenario: 34081-4 Validating the display of Not Proceed Signal state
    #Given I am viewing the map HDGW01paddington.v
    #And I set up all signals for address 80 in D3 to be red
    And I set up all signals for address 80 in D3 to be green
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 80      | FF   | 10:45:00  |
    Then the signal roundel for signal 'SN128' is green
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 80      | 00   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN128' is red

  Scenario: 34081-5 Validating the display of white Signal state
    #Given I am viewing the map HDGW01paddington.v
    #And I set up all signals for address 80 in D3 to be red
    And I set up all signals for address 80 in D3 to be red
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 92      | 00   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN212' is red
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 92      | FF   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN212' is green
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 92      | 08   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN212' is white

  Scenario: 34081-7 Validating the display of Not Proceed Shunt Signal state
    #Given I am viewing the map HDGW01paddington.v
    #And I set up all signals for address 80 in D3 to be red
    And the shunt signal state for signal 'SN6142' is grey
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 8F      | 00   | 10:02:06  |
    And the maximum amount of time is allowed for end to end transmission
    Then the shunt signal state for signal 'SN6142' is red


  Scenario: 34081-6 Validating the display of Main Proceed Shunt Signal state
    #Given I am viewing the map HDGW01paddington.v
    #And I set up all signals for address 80 in D3 to be red
    And the shunt signal state for signal 'SN6142' is grey
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 8F      | 00   | 10:02:06  |
    And the maximum amount of time is allowed for end to end transmission
    Then the shunt signal state for signal 'SN6142' is red
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 8F      | 03   | 10:02:06  |
    And the maximum amount of time is allowed for end to end transmission
    Then the shunt signal state for signal 'SN6142' is green

