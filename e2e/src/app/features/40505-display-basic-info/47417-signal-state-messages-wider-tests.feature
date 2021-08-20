# 48665
Feature: 47417 - Basic UI - Signal State Scenarios
  (From Notes on Gherkin for Feature 40505)
  As a TMV user
  I want the signal aspect to be displayed for signals on the paddington HD map
  So that I can view the current state of the railway for that area

  Scenario: 40505-x1 - Display Signal State - signal state message containing 1s turns all related red signals to green, and leaves others untouched
    Given I am viewing the map HDGW01paddington.v
    And I set up all signals for address 95 in D3 to be not-proceed
    And the signal roundel for signal 'SN215' is red
    And the signal roundel for signal 'SN213' is red
    And the signal roundel for signal 'SN225' is red
    And the signal roundel for signal 'SN219' is red
    And the signal roundel for signal 'SN218' is red
    And the signal roundel for signal 'SN231' is red
    And the signal roundel for signal 'SN232' is red
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 95      | 32   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN215' is red
    And the signal roundel for signal 'SN213' is green
    And the signal roundel for signal 'SN225' is red
    And the signal roundel for signal 'SN219' is red
    And the signal roundel for signal 'SN218' is green
    And the signal roundel for signal 'SN231' is green
    And the signal roundel for signal 'SN232' is red

  Scenario: 40505-x2 - Display Signal State - signal state messages are reflected in all open maps containing relevant signals
    Given I am on the home page
    And I expand the group of maps with name 'Wales & Western'
    And I navigate to the maps view with id HDGW01paddington.v
    And I switch to the second-newest tab
    And I navigate to the maps view with id GW02heathrow.v
    When I switch to the new tab
    And I set up all signals for address 29 in D4 to be proceed
    Then the signal roundel for signal 'SN290' is green
    And the signal roundel for signal 'SN271' is green
    And the signal roundel for signal 'SN300' is green
    When I switch to the second-newest tab
    Then the signal roundel for signal 'SN290' is green
    And the signal roundel for signal 'SN271' is green
    And the signal roundel for signal 'SN300' is green
    And the signal roundel for signal 'SN298' is green
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D4             | 29      | 88   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN290' is red
    And the signal roundel for signal 'SN271' is white
    And the signal roundel for signal 'SN300' is green
    And the signal roundel for signal 'SN298' is red
    When I switch to the new tab
    Then the signal roundel for signal 'SN290' is red
    And the signal roundel for signal 'SN271' is white
    And the signal roundel for signal 'SN300' is green
