Feature: 78858 - TMV Replay Controls & Display - PreReplay Search Box Removal
  As a TMV User
  I want to the replay controls and view updated
  So that it is closer to CCF which I am familiar with

  Scenario Outline: 78873-1 - PreReplay Search Box Removal
    #  Given the user has selected the replay option from the homepage
    #  When user is viewing the replay selection criteria window
    #  Then the national search is not displayed
    #  Notes:
    #    * Replay national search is displayed when the replay session is initiaised
    Given I am on the home page
    Then the train search box is visible
    When I am on the replay page
    Then the train search box is not visible
    When I select Next
    Then the train search box is not visible
    When I expand the replay group of maps with name '<mapGroup>'
    And I select the map '<map>'
    And I wait for the buffer to fill
    Then the train search box is visible
    And I click Play button
    Then the train search box is visible

    Examples:
      | mapGroup               | map                   |
      | Wales & Western        | HDGW01paddington.v    |
      | Wales & Western        | GW22heartofwales.v    |
      | North West and Central | MD01euston.v          |
      | North West and Central | NW22mpsccsig.v        |
      | Southern               | SO01charingcross.v    |
      | Southern               | HS1Shighspeed1south.v |
