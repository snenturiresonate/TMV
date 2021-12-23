Feature: 78815 - TMV Map Interaction - Off plan TMV key
Given the user is authenticated to use TMV
And the user is viewing a live the map
When the user selects the TMV Key
Then the Off Plan indication is displayed

  Background:
    Given I have not already authenticated
    And I am viewing the map HDGW01paddington.v
    And The admin setting defaults are as originally shipped
    And I refresh the browser

  Scenario: 34085-2b The TMV Key berth table is displayed within the modal when the tmv icon is clicked
    When I click on the Help icon
    And I select the TMV Key option
    Then a modal displays with title 'Key'
    And The key berth table contains the following data
      | position | text                     | backgroundColour | colour  |
      | 0        | Off Plan                 | #0000ff          | #ffffff |
      | 1        | Left Behind              | #969696          | #000000 |
      | 2        | No Timetable             | #e1e1e1          | #000000 |
      | 3        | Last Berth               | #ffffff          | #000000 |
      | 4        | Unknown Delay            | #ffffff          | #000000 |
