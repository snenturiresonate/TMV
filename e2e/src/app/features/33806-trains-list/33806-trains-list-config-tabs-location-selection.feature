Feature: 33806 - TMV User Preferences - full end to end testing

  As a tester
  I want to verify the train list config tab - Locations
  So, that I can identify if the build meets the end to end requirements

  Background:
    Given I am on the trains list Config page
    And I have navigated to the 'Locations' configuration tab


  Scenario: Trains list TOC/FOC config header
    Then the locations tab header is displayed as 'Locations'

  Scenario: Trains list location filter match dropdown
    And I click on the location filter
    Then the following values can be seen on the locations filter
      | locationFilter               |
      | At least one location        |
      | All locations                |
      | All locations, order applied |
@tdd
  Scenario: Trains list location stop types
    Then I should see the following stop types in the given order within each location
      | stopTypes |
      | Originate |
      | Stop      |
      | Pass      |
      | Terminate |

      #33806 -14 Trains List Config (Location Search)
    #Given the user is viewing the trains list config
    #And the user is viewing the Location config tab
    #And the user selects the type of location order they desire
    #When the user enters characters in the location search text box
    #Then the user is presented with a list of locations

  Scenario: Trains list location search auto suggest list
    When I type 'AB' into the location search box
    Then the location auto-suggest list is not hidden
    And the location auto-suggest list has atleast 5 entries

    #33806 -15 Trains List Config (Location Search Selection)
  #Given the user is viewing the trains list config
  #And the user is viewing the Location config tab
  #And the user has performed a location search
  #When the user selects the location from the results
  #Then the location is added to the list of configured locations
  @tdd
  Scenario: Trains list location search auto suggest list
    When I type 'ABDARE' into the location search box
    And I click the first suggested location
    Then the following can be seen on the location order type table
      | locationNameValue              | Originate  | Stop       | Pass       | Terminate  |
      |Aberdare (ABDARE)               | Checked    | un-Checked | checked    | unchecked  |
      | Slough (SLOUGH)                | Checked    | un-Checked | checked    | unchecked  |
      | Paddington (PADTON)            | Checked    | un-checked | un-checked | un-checked |
      | Swindon (SDON)                 | un-checked | Checked    | un-checked | un-checked |
      | Reading Lane Junction (RDGLNJ) | un-checked | checked    | checked    | un-checked |
      | Peterborough (PBRO)            | un-checked | checked    | unchecked  | checked    |
      | Reading (RDNGSTN)              | un-checked | un-checked | checked    | un-checked |
      | Leeds (LEEDS)                  | un-checked | un-checked | checked    | checked    |
    And I should see the following stop types in the given order within each location
      | stopTypes |
      | Originate |
      | Stop      |
      | Pass      |
      | Terminate |

@tdd
Scenario: Trains location list ability to remove location and move the location elements to desired order
  When I choose the location filter as 'All locations, order applied'
  And I move 'up' the location 'Slough'
  And I move 'down' the location 'Reading Lane Junction'
  And I remove the location 'Oxford'
  Then the following can be seen on the location order type table
    | locationNameValue              | Originate  | Stop       | Pass       | Terminate  |
    | Slough (SLOUGH)                | Checked    | un-Checked | checked    | unchecked  |
    | Paddington (PADTON)            | Checked    | un-checked | un-checked | un-checked |
    | Swindon (SDON)                 | un-checked | Checked    | un-checked | un-checked |
    | Reading Lane Junction (RDGLNJ) | un-checked | checked    | checked    | un-checked |
    | Peterborough (PBRO)            | un-checked | checked    | unchecked  | checked    |
    | Reading (RDNGSTN)              | un-checked | un-checked | checked    | un-checked |
    | Leeds (LEEDS)                  | un-checked | un-checked | checked    | checked    |



