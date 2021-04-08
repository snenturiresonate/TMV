Feature: 46482 - TMV Key - select key
  As a TMV User
  I want to view a symbol key
  So that I can understand what the schematic objects mean

  Scenario: 34085-1a The TMV Key modal window is launched when a map is displayed
    Given I am viewing the map GW01paddington.v
    When I click on the Help icon
    And I select the TMV Key option
    Then a modal displays with title 'Key'
    And the modal contains a 'Close' button
    And the following tabs can be seen on the modal
      | tabName         |
      | Colour          |
      | Symbol          |
      | Train Describer |
    And the active tab is 'Colour'

  @bug @bug_56581 @newSession
  Scenario: 34085-1b The TMV Key modal window is launched when a map is displayed in the replay view
    Given I am on the replay page as existing user
    And I select Next
    And I expand the replay group of maps with name 'Eastern'
    And I select the map 'ea01liverpoolst.v'
    When I click on the Help icon
    And I select the TMV Key option
    Then a modal displays with title 'Key'
    And the modal contains a 'Close' button
    And the following tabs can be seen on the modal
      | tabName         |
      | Colour          |
      | Symbol          |
      | Train Describer |
    And the active tab is 'Colour'

  Scenario: 34085-1c The TMV Key modal window is not displayed in the help menu for the home page
    Given I am on the home page
    When I click on the Help icon
    Then the TMV Key option should not be visible

  Scenario: 34085-1d The TMV Key modal window is not displayed in the help menu for the trains list
    Given I am on the trains list page
    When I click on the Help icon
    Then the TMV Key option should not be visible

  Scenario: 34085-1e The TMV Key modal window is not displayed in the help menu for the log viewer page
    Given I am on the log viewer page
    When I click on the Help icon
    Then the TMV Key option should not be visible

  Scenario: 34085-1f The TMV Key modal window is not displayed in the help menu for the admin page
    Given I am on the admin page
    When I click on the Help icon
    Then the TMV Key option should not be visible

  Scenario: 34085-1g Verify still possible to interact with map whilst the TMV Modal Key window is open
    Given I am viewing the map GW01paddington.v
    And I click on the Help icon
    And I select the TMV Key option
    And a modal displays with title 'Key'
    When I click on the layers icon in the nav bar
    And I toggle the 'Platform' toggle 'on'
    Then the platform layer is shown
    And a modal displays with title 'Key'

  Scenario: 34085-1h Verify the map still updates whilst the TMV Modal Key is open
    Given I am viewing the map GW01paddington.v
    When I click on the Help icon
    And I select the TMV Key option
    And I click on the layers icon in the nav bar
    And I toggle the 'Berth' toggle 'on'
    And the following berth interpose message is sent from LINX (to indicate train is present)
      | timestamp | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099    | D3            | 1G69             |
    And the following berth interpose message is sent from LINX (to indicate train is present)
      | timestamp | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0092    | D3            | 1G70             |
    Then berth '0099' in train describer 'D3' does not contain '1G69'
    And berth '0092' in train describer 'D3' does not contain '1G70'
    And I toggle the 'Berth' toggle 'off'
    Then berth '0099' in train describer 'D3' contains '1G69' and is visible
    And berth '0092' in train describer 'D3' contains '1G70' and is visible
    And a modal displays with title 'Key'

  Scenario: 34085-1i The TMV Key modal window can only be opened one key at a time
    Given I am viewing the map GW01paddington.v
    And I click on the Help icon
    And I select the TMV Key option
    Then a modal displays with title 'Key'
    When I click on the Help icon
    And I select the TMV Key option
    Then there should only be one key model window open
