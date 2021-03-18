Feature: 33806 - TMV User Preferences - full end to end testing - TL config - location selection

  As a tester
  I want to verify the train list config tab - Locations
  So, that I can identify if the build meets the end to end requirements

  Background:
    Given the access plan located in CIF file 'access-plan/trains_list_test.cif' is amended so that all services start within the next hour and then received from LINX
    And I am on the trains list Config page
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
  #Needs a step to add all desired locations
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

  Scenario: 33806 -14 Trains list location search auto suggest list
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
    #Needs a step to add all desired locations
  Scenario: 33806 -15 Trains list location search auto suggest list
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

  #33806 -16 Trains List Config (Location Ordering Selection)
    #Given the user is viewing the trains list config
    #And the user is viewing the Location config tab
    #And the user has at least two location in the list
    #And the user has opted to enforce ordering
    #When the user selects the ordering up/down
    #Then the location moved up or down in the list

  Scenario Outline: 33806 -16 Ability to re-order location should be available only for All Locations, order applied
    When I choose the location filter as '<filters>'
    Then I should not see the location re-ordering arrows
    Examples:
      | filters               |
      | All locations         |
      | At least one location |

  #33806 -17 Trains List Config (Location Removed)
    #Given the user has locations in the list
    #When the user removes a location
    #Then the location is removed from the list
  @tdd
    #Needs a step to add all desired locations
Scenario: 33806 -17 Trains location list ability to remove location and move the location elements to desired order
  #Below scenario covers both 33806 -16 & 33806 -17. They have been made as single scenario to avoid any data related false failures due to removing locations in different scenarios
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

#33806 -18 Trains List Config (Location Applied)
  #Given the user has made changes to the trains list Location selection
  #When the user views the trains list
  #Then the view is updated to reflect the user's Location selection
@bug @bug_54025
  Scenario: 33806 -18 Trains list config for location types - Location applied while navigating away
    And I have only the following locations and stop types selected
      | locationNameValue | Originate | Stop       | Pass       | Terminate  |
      | PADTON            | Checked   | un-checked | un-checked | un-checked |
    And I have navigated to the 'Columns' configuration tab
    And I have navigated to the 'Locations' configuration tab
    Then the following can be seen on the location order type table
      | locationNameValue              | Originate  | Stop       | Pass       | Terminate  |
      | Paddington (PADTON)            | Checked    | un-checked | un-checked | un-checked |

  @tdd
  Scenario: 33806 -18 Trains list config for location types - Stop type 'Originate'
    And I have only the following locations and stop types selected
      | locationNameValue | Originate | Stop       | Pass       | Terminate  |
      | PADTON            | Checked   | un-checked | un-checked | un-checked |
    And I open 'trains list' page in a new tab
    #Services to be displayed might have to change based on data once the integration is done
    Then '1S42' are then displayed

  @tdd
  Scenario: 33806 -18 Trains list config for location types - Stop type 'Terminate'
    And I have only the following locations and stop types selected
      | locationNameValue | Originate  | Stop       | Pass       | Terminate |
      | DDIDCOTP          | un-checked | un-checked | un-checked | Checked   |
    And I open 'trains list' page in a new tab
    #Services to be displayed might have to change based on data once the integration is done
    Then '1S42' are then displayed

  @tdd
  Scenario: 33806 -18 Trains list config for location types - Stop type 'Pass'
    And I have only the following locations and stop types selected
      | locationNameValue | Originate  | Stop       | Pass    | Terminate  |
      | ACTONW            | un-checked | un-checked | Checked | un-checked |
    And I open 'trains list' page in a new tab
    #Services to be displayed might have to change based on data once the integration is done
    Then '1S42' are then displayed

  @tdd
  Scenario: 33806 -18 Trains list config for location types - Stop type 'Stop'
    And I have only the following locations and stop types selected
      | locationNameValue | Originate  | Stop    | Pass       | Terminate  |
      | EALINGB           | un-checked | checked | un-checked | un-checked |
    And I open 'trains list' page in a new tab
    #Services to be displayed might have to change based on data once the integration is done
    Then '1S42' are then displayed
