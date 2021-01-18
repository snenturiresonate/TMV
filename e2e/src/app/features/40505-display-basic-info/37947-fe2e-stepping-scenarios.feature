Feature: 37947 - Basic UI - full end to end testing - stepping scenarios

  As a tester
  I want to perform integration testing on slice 1
  So, that I can identify if the slice meets the requirements

  Background: # prepare and clean up for each test
    Given I am viewing the map HDGW01paddington.v
    When I click on the layers icon in the nav bar
    And I toggle the 'Berth' toggle 'on'
    And I toggle the 'Berth' toggle 'off'
    And the following berth cancel message is sent from LINX
      | timestamp | fromBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099      | D3            | 1G69             |
      | 09:59:00  | 0095      | D3            | 1G69             |
      | 09:59:00  | 0115      | D3            | 1G69             |
      | 09:59:00  | 0129      | D3            | 1G69             |

  # 47656 - getting initial state (for second map)
  Scenario: 40505-1 - interpose is displayed in the berth, which is not a Q berth
    # a berth that exists on the map is empty
    #  it is not a Q berth
    Given berth '0099' in train describer 'D3' contains '' and is visible
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099    | D3            | 1G69             |
    Then berth '0099' in train describer 'D3' contains '1G69' and is visible
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0095    | D3            | 1G69             |
    Then berth '0095' in train describer 'D3' contains '1G69' and is visible
    # same map open twice - contains the existing interposes
    When I am viewing the map HDGW01paddington.v
    When I click on the layers icon in the nav bar
    And I toggle the 'Berth' toggle 'on'
    And I toggle the 'Berth' toggle 'off'
    Then berth '0099' in train describer 'D3' contains '1G69' and is visible
    Then berth '0095' in train describer 'D3' contains '1G69' and is visible

  # Negative test - interpose into a Q-berth
  # Q-berth Q070 is translated to become berth DC
  # expect message to be treated as an S class message. s class display would show DC
  @bug @53318
  Scenario: 40505-1 - interpose is not displayed in the berth, which is a Q berth
    Given I am viewing the map hdgw06gloucester.v
    When I click on the layers icon in the nav bar
    And I toggle the 'Berth' toggle 'on'
    And I toggle the 'Berth' toggle 'off'
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | Q070    | GL            | DnDC             |
    Then it is 'false' that berth 'Q070' in train describer 'GL' is present

  Scenario: 40505-2 - interpose into berth that already contains a train description
    #    Given a berth that exists on the map is displaying a train description
    #    And it is not a Q berth
    #    When an interpose message is published from LINX for that berth for a different Train Description
    #    Then the new Train Description from the interpose message is displayed in the berth
    #    But the old Train Description is not displayed in the berth
    Given berth '0099' in train describer 'D3' contains '' and is visible
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099    | D3            | 1G69             |
    Then berth '0099' in train describer 'D3' contains '1G69' and is visible
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099    | D3            | 9Z99             |
    Then berth '0099' in train describer 'D3' contains '9Z99' and is visible
    But berth '0099' in train describer 'D3' does not contain '1G69'

  Scenario: 40505-3a - cancellation of train description
    #    Given a berth that exists on the map is displaying a train description
    #    And it is not a Q berth
    #    When a cancel message is published from LINX for that berth
    #    Then no Train Description is displayed in the berth
    Given berth '0099' in train describer 'D3' contains '' and is visible
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099    | D3            | 1G69             |
    Then berth '0099' in train describer 'D3' contains '1G69' and is visible
    When the following berth cancel message is sent from LINX
      | timestamp | fromBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099      | D3            | 1G69             |
    Then berth '0099' in train describer 'D3' contains '' and is visible

  # 48780 - berth cancellation succeeds if the wrong train description is provided
  @bug @bug_48780
  Scenario: 40505-3b - cancellation of train description for a train description that isn't in the berth, but the berth is occupied
    Given berth '0099' in train describer 'D3' contains '' and is visible
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099    | D3            | 1G69             |
    Then berth '0099' in train describer 'D3' contains '1G69' and is visible
    When the following berth cancel message is sent from LINX
      | timestamp | fromBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099      | D3            | 9Z99             |
    Then berth '0099' in train describer 'D3' contains '1G69' and is visible
    But berth '0099' in train describer 'D3' does not contain '9Z99'

  Scenario: 40505-3c - cancellation of a duplicate train description
    Given berth '0099' in train describer 'D3' contains '' and is visible
    And berth '0095' in train describer 'D3' contains '' and is visible
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099    | D3            | 1G69             |
    Then berth '0099' in train describer 'D3' contains '1G69' and is visible
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0095    | D3            | 1G69             |
    Then berth '0095' in train describer 'D3' contains '1G69' and is visible
    When the following berth cancel message is sent from LINX
      | timestamp | fromBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099      | D3            | 1G69             |
    Then berth '0099' in train describer 'D3' contains '' and is visible
    And berth '0095' in train describer 'D3' contains '1G69' and is visible

  Scenario: 40505-4 - cancellation for a berth that does not contain a train description
    Given berth '0099' in train describer 'D3' contains '' and is visible
    When the following berth cancel message is sent from LINX
      | timestamp | fromBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099      | D3            | 1G69             |
    Then berth '0099' in train describer 'D3' contains '' and is visible

  Scenario: 40505-5a - berth step
    #    Given berth A is displaying a train description
    #    And berth B is empty
    #    And A and B are not Q berths
    #    And A abd B berths exist on the map
    #    When a step message is published from LINX with from berth A and to Berth B
    #    Then no Train Description is displayed in the berth A
    #    And Train Description is displayed in the berth B
    Given berth '0099' in train describer 'D3' contains '' and is visible
    And berth '0115' in train describer 'D3' contains '' and is visible
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099    | D3            | 1G69             |
    Then berth '0099' in train describer 'D3' contains '1G69' and is visible
    And berth '0115' in train describer 'D3' contains '' and is visible
    When the following berth step message is sent from LINX
      | timestamp | fromBerth | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099      | 0115    | D3            | 1G69             |
    Then berth '0099' in train describer 'D3' contains '' and is visible
    And berth '0115' in train describer 'D3' contains '1G69' and is visible

  Scenario: 40505-5b - berth step via cancellation and interpose
    # Could get a cancellation at A and an interpose at B instead of a step - do not always get a step
    Given berth '0099' in train describer 'D3' contains '' and is visible
    And berth '0115' in train describer 'D3' contains '' and is visible
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099    | D3            | 1G69             |
    Then berth '0099' in train describer 'D3' contains '1G69' and is visible
    And berth '0115' in train describer 'D3' contains '' and is visible
    When the following berth cancel message is sent from LINX
      | timestamp | fromBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099      | D3            | 1G69             |
    And the following berth interpose message is sent from LINX
      | timestamp | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0115    | D3            | 1G69             |
    Then berth '0099' in train describer 'D3' contains '' and is visible
    And berth '0115' in train describer 'D3' contains '1G69' and is visible

  # Permutations - something in B, nothing in A - overriding what's in B
  Scenario: 40505-5c - berth step - train description already in second berth, so overridden
    Given berth '0099' in train describer 'D3' contains '' and is visible
    And berth '0115' in train describer 'D3' contains '' and is visible
    And the following berth interpose message is sent from LINX
      | timestamp | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0115    | D3            | 1G99             |
    Then berth '0099' in train describer 'D3' contains '' and is visible
    And berth '0115' in train describer 'D3' contains '1G99' and is visible
    When the following berth step message is sent from LINX
      | timestamp | fromBerth | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099      | 0115    | D3            | 1G69             |
    Then berth '0099' in train describer 'D3' contains '' and is visible
    And berth '0115' in train describer 'D3' contains '1G69' and is visible

  Scenario: 40505-5d - berth step - out of sequence
    Given berth '0099' in train describer 'D3' contains '' and is visible
    And berth '0115' in train describer 'D3' contains '' and is visible
    And berth '0129' in train describer 'D3' contains '' and is visible
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099    | D3            | 1G69             |
    Then berth '0099' in train describer 'D3' contains '1G69' and is visible
    And berth '0115' in train describer 'D3' contains '' and is visible
    And berth '0129' in train describer 'D3' contains '' and is visible
    When the following berth step message is sent from LINX
      | timestamp | fromBerth | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099      | 0129    | D3            | 1G69             |
    Then berth '0099' in train describer 'D3' contains '' and is visible
    And berth '0115' in train describer 'D3' contains '' and is visible
    And berth '0129' in train describer 'D3' contains '1G69' and is visible

  Scenario: 40505-5e - berth step - both berths not on the map
    Given berth '0099' in train describer 'D3' contains '' and is visible
    And berth '0115' in train describer 'D3' contains '' and is visible
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099    | D3            | 1G69             |
    Then berth '0099' in train describer 'D3' contains '1G69' and is visible
    And berth '0115' in train describer 'D3' contains '' and is visible
    When the following berth step message is sent from LINX
      | timestamp | fromBerth | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0000      | 9999    | D3            | 1G69             |
    Then berth '0099' in train describer 'D3' contains '1G69' and is visible
    And berth '0115' in train describer 'D3' contains '' and is visible

  Scenario: 40505-5f - berth step - only from berth is on the map - cancellation
    Given berth '0099' in train describer 'D3' contains '' and is visible
    And berth '0115' in train describer 'D3' contains '' and is visible
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099    | D3            | 1G69             |
    Then berth '0099' in train describer 'D3' contains '1G69' and is visible
    And berth '0115' in train describer 'D3' contains '' and is visible
    When the following berth step message is sent from LINX
      | timestamp | fromBerth | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099      | 9999    | D3            | 1G69             |
    Then berth '0099' in train describer 'D3' contains '' and is visible
    And berth '0115' in train describer 'D3' contains '' and is visible

  Scenario: 40505-5g - berth step - only to berth is on the map - interpose
    Given berth '0099' in train describer 'D3' contains '' and is visible
    And berth '0115' in train describer 'D3' contains '' and is visible
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099    | D3            | 1G69             |
    Then berth '0099' in train describer 'D3' contains '1G69' and is visible
    And berth '0115' in train describer 'D3' contains '' and is visible
    When the following berth step message is sent from LINX
      | timestamp | fromBerth | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0000      | 0115    | D3            | 1G69             |
    Then berth '0099' in train describer 'D3' contains '1G69' and is visible
    And berth '0115' in train describer 'D3' contains '1G69' and is visible
