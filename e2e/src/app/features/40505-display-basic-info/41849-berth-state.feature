Feature: 41849 - Basic UI - Display berth state
  As a user
  I want to view berth state information in the UI
  So, that I can prove that stepping information is being processed correctly

  @bug #47181
  Scenario: 47116 - Display Berth State - berth interpose is displayed upon the UI
    Given I am viewing the map GW01paddington.v
    When I click on the layers icon in the nav bar
    And I toggle the 'Berth' toggle 'on'
    And I toggle the 'Berth' toggle 'off'
    And the following berth interpose message is sent from LINX
      | timestamp | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099    | D3            | 1G69             |
    And the maximum amount of time is allowed for end to end transmission
    Then berth '0099' in train describer 'D3' contains '1G69'

  @bug #47181, 47120
  Scenario: 47117 - Display Berth State - berth cancel removes train description from UI
    Given I am viewing the map GW01paddington.v
    When I click on the layers icon in the nav bar
    And I toggle the 'Berth' toggle 'on'
    And I toggle the 'Berth' toggle 'off'
    And the following berth interpose message is sent from LINX
      | timestamp | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099    | D3            | 1G69             |
    And the maximum amount of time is allowed for end to end transmission
    And the following berth cancel message is sent from LINX
      | timestamp | fromBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099      | D3            | 1G69             |
    And the maximum amount of time is allowed for end to end transmission
    Then berth '0099' in train describer 'D3' does not contain '1G69'
    And I toggle the 'Berth' toggle 'on'
    Then berth '0099' in train describer 'D3' contains '0099'

  @bug #47181
  Scenario: 47119 - Display Berth State - berth step causes train description to step to the next berth
    Given I am viewing the map GW01paddington.v
    When I click on the layers icon in the nav bar
    And I toggle the 'Berth' toggle 'on'
    And I toggle the 'Berth' toggle 'off'
    And the following berth interpose message is sent from LINX
      | timestamp | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099    | D3            | 1G69             |
    And the maximum amount of time is allowed for end to end transmission
    And the following berth step message is sent from LINX
      | timestamp | fromBerth | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099      | 0092    | D3            | 1G69             |
    And the maximum amount of time is allowed for end to end transmission
    Then berth '0099' in train describer 'D3' does not contain '1G69'
    And berth '0092' in train describer 'D3' contains '1G69'

  @bug #47181, 47327
  Scenario: 47121 - Display Berth State - berth interpose whilst berth IDs are displayed
    Given I am viewing the map GW01paddington.v
    When I click on the layers icon in the nav bar
    And I toggle the 'Berth' toggle 'on'
    And the following berth interpose message is sent from LINX
      | timestamp | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099    | D3            | 1G69             |
    And the maximum amount of time is allowed for end to end transmission
    And the following berth interpose message is sent from LINX
      | timestamp | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0092    | D3            | 1G70             |
    And the maximum amount of time is allowed for end to end transmission
    Then berth '0099' in train describer 'D3' does not contain '1G69'
    And berth '0092' in train describer 'D3' does not contain '1G70'
    When I click on the layers icon in the nav bar
    And I toggle the 'Berth' toggle 'off'
    Then berth '0099' in train describer 'D3' contains '1G69'
    And berth '0092' in train describer 'D3' contains '1G70'
