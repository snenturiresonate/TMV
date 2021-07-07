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

  # Story 53035 specifies that the replay key should not contain the train describer tab
  Scenario: 34085-1b The TMV Key modal window is launched when a map is displayed in the replay view
    Given I am on the home page
    And I navigate to Replay page
    When I select time period 'Last 15 minutes' from the quick dropdown
    And I select Next
    And I expand the replay group of maps with name 'Eastern'
    And I select the map 'EA01liverpoolst.v'
    When I click on the Help icon
    And I select the TMV Key option
    Then a modal displays with title 'Key'
    And the modal contains a 'Close' button
    And the following tabs can be seen on the modal
      | tabName         |
      | Colour          |
      | Symbol          |
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
    Given I am viewing the map HDGW01paddington.v
    And I have cleared out all headcodes
    Then berth '0099' in train describer 'D3' does not contain '1K56'
    When I click on the Help icon
    And I select the TMV Key option
    Then a modal displays with title 'Key'
    When the following live berth interpose message is sent from LINX (to indicate train is present)
      | toBerth | trainDescriber| trainDescription |
      | 0099    | D3            | 1K56             |
    Then berth '0099' in train describer 'D3' contains '1K56' and is visible

  Scenario: 34085-1i The TMV Key modal window can only be opened one key at a time
    Given I am viewing the map GW01paddington.v
    And I click on the Help icon
    And I select the TMV Key option
    Then a modal displays with title 'Key'
    When I click on the Help icon
    And I select the TMV Key option
    Then there should only be one key model window open
