# 48665
@bug
Feature: 41717 - Basic UI - Signal State Scenarios
  (From Gherkin for Feature 40505 and functionality developed in US41851)
  As a TMV user
  I want the signal aspect to be displayed for signals on the paddington HD map
  So that I can view the current state of the railway for that area

  Background:
    Given I am viewing the map HDGW01paddington.v
    And I set up all signals for address 92 in D3 to be red

  Scenario: 40505-6a - Display Signal State - signal state message containing 1 turns red main signal (with no subsidiary aspect) to green
    And the signal roundel for signal 'SN211' is red
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 92      | 20   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN211' is green

  Scenario: 40505-6b - Display Signal State - signal state message containing 1 leaves green main signal (with no subsidiary aspect) as green
    And the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 92      | FF   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    And the signal roundel for signal 'SN211' is green
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 92      | 20   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN211' is green

  Scenario: 40505-6c - Display Signal State - signal state message containing 1 turns red call-on signal to green
    And the signal roundel for signal 'SN212' is red
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 92      | 04   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN212' is green

  Scenario: 40505-6d - Display Signal State - signal state message containing 1 turns white call-on signal to green
    And the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 92      | 08   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    And the signal roundel for signal 'SN212' is white
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 92      | 04   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN212' is green

  Scenario: 40505-6e - Display Signal State - signal state message containing 1 turns leaves green main signal (with subsidiary aspect) as green
    And the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 92      | 04   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    And the signal roundel for signal 'SN212' is green
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 92      | 04   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN212' is green

  Scenario: 40505-7a - Display Signal State - signal state message containing 0 turns green main signal (with no subsidiary aspect) to red
    And the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 92      | 20   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    And the signal roundel for signal 'SN211' is green
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 92      | 00   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN211' is red

  Scenario: 40505-7b - Display Signal State - signal state message containing 0 leaves red main signal (with no subsidiary aspect) as red
    And the signal roundel for signal 'SN211' is red
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 92      | 00   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN211' is red

  Scenario: 40505-7c - Display Signal State - signal state message containing 0 (for both main and subsidiary aspects) turns white call-on signal to red
    And the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 92      | 08   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    And the signal roundel for signal 'SN212' is white
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 92      | 00   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN212' is red

  Scenario: 40505-7d - Display Signal State - signal state message containing 0 (for both main and subsidiary aspects) leaves red call-on signal as red
    And the signal roundel for signal 'SN212' is red
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 92      | 00   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN212' is red

  Scenario: 40505-8a - Display Signal State - signal state message containing 0 for main aspect and 1 for subsidiary aspect turns red call-on signal to white
    And the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 92      | 00   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    And the signal roundel for signal 'SN212' is red
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 92      | 08   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN212' is white

  Scenario: 40505-8b - Display Signal State - signal state message containing 0 for main aspect and 1 for subsidiary aspect leaves white call-on signal as white
    And the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 92      | 08   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    And the signal roundel for signal 'SN212' is white
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 92      | 08   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN212' is white

  Scenario: 40505-8c - Display Signal State - signal state message containing 1 for main aspect and 1 for subsidiary aspect turns red call-on signal green by preference (unlikely case)
    And the signal roundel for signal 'SN212' is red
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 92      | 0C   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN212' is green
