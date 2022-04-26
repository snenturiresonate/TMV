@TMVPhase2 @P2.S1
@newSession
Feature: 78858 - TMV Replay Controls & Display - Replay Date Time Size
  As a TMV User
  I want to the replay controls and view updated
  So that it is closer to CCF which I am familiar with

  Scenario Outline: 83319-1 - Replay Date & Time Size - Maximised Playback Control
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name '<mapGroup>'
    And I select the map '<map>'
    When I wait for the buffer to fill
    And I click Play button
    Then the replay date and time text size is 15px

    Examples:
      | mapGroup               | map                   |
      | Wales & Western        | HDGW01paddington.v    |

  Scenario Outline: 83319-2 - Replay Date & Time Size - Minimized Playback Control
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name '<mapGroup>'
    And I select the map '<map>'
    When I wait for the buffer to fill
    And I click Play button
    And I click minimise button
    And the replay play back control is 'collapsed'
    Then the replay date and time text size is 15px

    Examples:
      | mapGroup               | map                   |
      | Southern               | HS1Shighspeed1south.v |
