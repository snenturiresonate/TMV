Feature: 49635 - Schematic State - route indication state
  (From Gherkin for Feature 34081)
  As a TMV User
  I want to schematic objects displayed with the latest state
  So that I have a live view of the railway

  Background:
    Given I am viewing the map gw01paddington.v

  @replaySetup
  Scenario: 34081-19a - Route Indication State (Set - Main Signal)
#    Given an S-Class message is received and processed
#    And the S-Class message is associated with an S-Class berth of type Route Indication
#    And the S-Class message is setting the Route Indication for a Main or Shunt Signal
#    When a user is viewing a map that contains the Main or Shunt Signal
#    Then the Main or Shunt Signal will display a Route Indication (1-3 alphanumeric char next to the signal)
    And I set up all signals for address 14 in D3 to be not-proceed
    And there is no text indication for s-class-berth 'D30105'
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 14      | 10   | 10:45:00  |
    Then the s-class-berth 'D30105' will display a Route indication of 'DM'

  @replaySetup
  Scenario: 34081-19b - Route Indication State (Set - Shunt Signal)
#    Given an S-Class message is received and processed
#    And the S-Class message is associated with an S-Class berth of type Route Indication
#    And the S-Class message is setting the Route Indication for a Main or Shunt Signal
#    When a user is viewing a map that contains the Main or Shunt Signal
#    Then the Main or Shunt Signal will display a Route Indication (1-3 alphanumeric char next to the signal)
    And I set up all signals for address 10 in D3 to be not-proceed
    And there is no text indication for s-class-berth 'D36003'
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 10      | 02   | 10:45:00  |
    Then the s-class-berth 'D36003' will display a Route indication of 'A'

  @replaySetup @bug @bug_58056
  Scenario: 34081-19c - Route Indication State (Set - Main Signal into platforms with several different indications possible 1-3 alphanumeric)
#    Given an S-Class message is received and processed
#    And the S-Class message is associated with an S-Class berth of type Route Indication
#    And the S-Class message is setting the Route Indication for a Main or Shunt Signal
#    When a user is viewing a map that contains the Main or Shunt Signal
#    Then the Main or Shunt Signal will display a Route Indication (1-3 alphanumeric char next to the signal)
    And I set up all signals for address 10 in D3 to be not-proceed
    And there is no text indication for s-class-berth 'D30032'
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 1B      | 80   | 10:45:00  |
    Then the s-class-berth 'D30032' will display a Route indication of '9'
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 1B      | 40   | 10:45:00  |
    Then the s-class-berth 'D30032' will display a Route indication of '10C'
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 1B      | 20   | 10:45:00  |
    Then the s-class-berth 'D30032' will display a Route indication of '10'

  @replaySetup
  Scenario: 34081-20a - Route Indication State (Not Set - Main Signal)
#    Given an S-Class message is received and processed
#    And the S-Class message is associated with an S-Class berth of type Route Indication
#    And the S-Class message is setting the Route Indication for a Main or Shunt Signal
#    When a user is viewing a map that contains the Main or Shunt Signal
#    Then the Main or Shunt Signal will not display a Route Indication (remove the 1-3 alphanumeric char next to the signal)
    And I set up all signals for address 14 in D3 to be proceed
    And there is a text indication for s-class-berth 'D30105'
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 14      | 00   | 10:45:00  |
    Then the s-class-berth 'D30105' will display no Route indication of 'anything'

  @replaySetup
  Scenario: 34081-20b - Route Indication State (Not Set - Shunt Signal)
#    Given an S-Class message is received and processed
#    And the S-Class message is associated with an S-Class berth of type Route Indication
#    And the S-Class message is setting the Route Indication for a Main or Shunt Signal
#    When a user is viewing a map that contains the Main or Shunt Signal
#    Then the Main or Shunt Signal will not display a Route Indication (remove the 1-3 alphanumeric char next to the signal)
    And I set up all signals for address 10 in D3 to be proceed
    And there is a text indication for s-class-berth 'D36003'
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 10      | 00   | 10:45:00  |
    Then the s-class-berth 'D36003' will display no Route indication of 'anything'
