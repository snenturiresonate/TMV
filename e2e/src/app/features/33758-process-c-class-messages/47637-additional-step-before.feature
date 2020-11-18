Feature: 47637 - Process C Class Messages - Additional Step Before scenarios

As a TMV User
I want the berth state messages to be processed
So that I can record berth stepping for use by the system

  @tdd
  Scenario: 33758-1 Additional Step Before
    # values taken from addstep.dat in S3
    Given I am viewing the map HDGW01paddington.v
    When the following berth step message is sent from LINX
      | timestamp | fromBerth | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0101      | 0119    | D3            | 1G69             |
    And the maximum amount of time is allowed for end to end transmission
    #Old From
    Then berth '0101' in train describer 'D3' does not contain '1G69'
    #New From
    And berth '0101' in train describer 'D3' does not contain '1G69'
    #Old To
    And berth '0119' in train describer 'D3' contains '1G69' and is visible
    #New To
    And berth 'LSNP' in train describer 'D3' contains '1G69' and is visible

