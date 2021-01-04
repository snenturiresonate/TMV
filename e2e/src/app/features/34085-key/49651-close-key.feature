Feature: 46482 - TMV Key - close key
  As a TMV User
  I want to view a symbol key
  So that I can understand what the schematic objects mean

  Scenario: 34085-5a The TMV Key modal can be closed via the close button
    Given I am viewing the map GW01paddington.v
    When I click on the Help icon
    And I select the TMV Key option
    And a modal displays with title 'Key'
    When I close the TMV key
    Then The TMV Key is no longer displayed

  Scenario: 34085-5b The TMV Key modal can be closed via the X button
    Given I am viewing the map GW01paddington.v
    When I click on the Help icon
    And I select the TMV Key option
    And a modal displays with title 'Key'
    When I close the TMV key via clicking X
    Then The TMV Key is no longer displayed
