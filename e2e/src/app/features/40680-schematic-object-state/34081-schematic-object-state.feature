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

  Scenario: Validating the display of Unknown Main Signal state
    #Given I am viewing the map HDGW01paddington.v
    Then the signal roundel for signal 'SN128' is grey
    And the signal roundel for signal 'SN130' is grey
    And the signal roundel for signal 'SN140' is grey
    And the signal roundel for signal 'SN123' is grey



  Scenario: Validating the display of Main Proceed Signal state
    #Given I am viewing the map HDGW01paddington.v
    #And I set up all signals for address 80 in D3 to be red
    And I set up all signals for address 80 in D3 to be red
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN128' is red
    And the signal roundel for signal 'SN130' is red
    And the signal roundel for signal 'SN140' is red
    And the signal roundel for signal 'SN123' is red
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 80      | FF   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN128' is green
    And the signal roundel for signal 'SN130' is green
    And the signal roundel for signal 'SN140' is green
    And the signal roundel for signal 'SN123' is green


  Scenario: Validating the display of Not Proceed Signal state
    #Given I am viewing the map HDGW01paddington.v
    #And I set up all signals for address 80 in D3 to be red
    And I set up all signals for address 80 in D3 to be green
    Then the signal roundel for signal 'SN128' is green
    And the signal roundel for signal 'SN130' is green
    And the signal roundel for signal 'SN140' is green
    And the signal roundel for signal 'SN123' is green
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 80      | 00   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN128' is red
    And the signal roundel for signal 'SN130' is red
    And the signal roundel for signal 'SN140' is red
    And the signal roundel for signal 'SN123' is red

