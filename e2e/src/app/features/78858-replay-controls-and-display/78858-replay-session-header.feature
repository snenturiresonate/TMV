@TMVPhase2 @P2.S1
@newSession
Feature: 78858 - TMV Replay Controls & Display - Replay Session Header
  As a TMV User
  I want to the replay controls and view updated
  So that it is closer to CCF which I am familiar with

  Scenario Outline: 78872-1 Replay Session Header
    # Given the user has started a replay session
    # When the user is viewing the header information
    # Then the session header is displayed as "Replay Session:" + replay session number + "(Start Date:" + Replay session start date + "Start Time:" + Replay start time + ")"
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name '<mapGroup>'
    When I select the map '<map>'
    And I wait for the buffer to fill
    Then the replay session header is correctly formatted

    Examples:
      | mapGroup               | map                   |
      | Wales & Western        | HDGW01paddington.v    |
      | Wales & Western        | GW22heartofwales.v    |
      | North West and Central | MD01euston.v          |
      | North West and Central | NW22mpsccsig.v        |
      | Southern               | SO01charingcross.v    |
      | Southern               | HS1Shighspeed1south.v |
