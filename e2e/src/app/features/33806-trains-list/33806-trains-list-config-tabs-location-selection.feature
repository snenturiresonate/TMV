Feature: 33806 - TMV User Preferences - full end to end testing - TL config - location selection

  As a tester
  I want to verify the train list config tab - Locations
  So, that I can identify if the build meets the end to end requirements

  Background:
    * I remove all trains from the trains list
    * I am on the trains list page 1
    * I restore to default train list config '1'
    * I refresh the browser
    * I have navigated to the 'Locations' configuration tab


  Scenario: Trains list TOC/FOC config header
    Then the locations tab header is displayed as 'Locations'

  Scenario: Trains list location filter match dropdown
    And I click on the location filter
    Then the following values can be seen on the locations filter
      | locationFilter               |
      | At least one location        |
      | All locations                |
      | All locations, order applied |

  Scenario: Trains list location stop types
    When I type 'ABDARE' into the location search box
    And I click the first suggested location
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
  Scenario: 33806 -15 Trains list location search auto suggest list
    When I type 'ABDARE' into the location search box
    And I click the first suggested location
    Then the following can be seen on the location order type table
      | locationNameValue | Originate | Stop       | Pass    | Terminate |
      | Aberdare (ABDARE) | Checked   | un-Checked | checked | unchecked |
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
  Scenario: 33806 -17 Trains location list ability to remove location and move the location elements to desired order
  #Below scenario covers both 33806 -16 & 33806 -17. They have been made as single scenario to avoid any data related false failures due to removing locations in different scenarios
    When I choose the location filter as 'All locations, order applied'
    And I have only the following locations and stop types selected
      | locationNameValue | Originate  | Stop       | Pass       | Terminate  |
      | PADTON            | Checked    | un-checked | un-checked | un-checked |
      | SLOUGH            | Checked    | un-Checked | checked    | unchecked  |
      | RDGLNJ            | un-checked | checked    | checked    | un-checked |
      | SDON              | un-checked | Checked    | un-checked | un-checked |
      | PBRO              | un-checked | checked    | unchecked  | checked    |
      | OXFD              | checked    | checked    | checked    | checked    |
    And I move 'up' the location 'Slough'
    And I move 'down' the location 'Reading Lane Jn'
    And I remove the location 'Oxford'
    Then the following can be seen on the location order type table
      | locationNameValue          | Originate  | Stop       | Pass       | Terminate  |
      | Slough (SLOUGH)            | Checked    | un-Checked | checked    | unchecked  |
      | London Paddington (PADTON) | Checked    | un-checked | un-checked | un-checked |
      | Swindon (SDON)             | un-checked | Checked    | un-checked | un-checked |
      | Reading Lane Jn (RDGLNJ)   | un-checked | checked    | checked    | un-checked |
      | Peterborough (PBRO)        | un-checked | checked    | unchecked  | checked    |

#33806 -18 Trains List Config (Location Applied)
  #Given the user has made changes to the trains list Location selection
  #When the user views the trains list
  #Then the view is updated to reflect the user's Location selection
  Scenario: 33806 -18 Trains list config for location types - Location applied while navigating away
    And I have only the following locations and stop types selected
      | locationNameValue | Originate | Stop       | Pass       | Terminate  |
      | PADTON            | Checked   | un-checked | un-checked | un-checked |
    And I have navigated to the 'Columns' configuration tab
    And I have navigated to the 'Locations' configuration tab
    Then the following can be seen on the location order type table
      | locationNameValue   | Originate | Stop       | Pass       | Terminate  |
      | Paddington (PADTON) | Checked   | un-checked | un-checked | un-checked |


  Scenario Outline: 33806 -18 Trains list config for location types - <testType> test - Stop type '<stopType>'
    #    Given the user has made changes to the trains list Location selection
    #    When the user views the trains list
    #    Then the view is updated to reflect the user's Location selection
    * I delete '<trainUid>:today' from hash 'schedule-modifications'
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>     | <location>  | <timingType>  | <trainDescription>  | <trainUid>         |
    And I wait until today's train '<trainUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <trainUid> | <trainDescription> | now                    | 99999               | <location>             | today         | now                 |
    # Baseline
    And I am on the trains list page 1
    And I save the trains list config
    And The trains list table is visible
    Then train '<trainDescription>' with schedule id '<trainUid>' for today is visible on the trains list
    # Positive/Negative Test
    And I navigate to train list configuration
    And I have navigated to the 'Locations' configuration tab
    And I have only the following locations and stop types selected
      | locationNameValue | Originate   | Stop   | Pass   | Terminate   |
      | <location>        | <originate> | <stop> | <pass> | <terminate> |
    And I save the trains list config
    Then train '<trainDescription>' with schedule id '<trainUid>' for today <visibility> visible on the trains list
    * I restore to default train list config '1'

    Examples:
    | trainUid | trainDescription | cif                                 | location | timingType | originate  | stop       | pass       | terminate  | visibility | testType | stopType  |
    | V33806   | 5G06             | access-plan/1D46_PADTON_OXFD.cif    | PADTON   | WTT_dep    | checked    | un-checked | un-checked | un-checked | is         | positive | originate |
    | V33807   | 5G07             | access-plan/1D46_PADTON_OXFD.cif    | PADTON   | WTT_dep    | un-checked | checked    | un-checked | un-checked | is not     | negative | originate |
    | V33808   | 5G08             | access-plan/2P77_RDNGSTN_PADTON.cif | PADTON   | WTT_arr    | un-checked | un-checked | un-checked | checked    | is         | positive | terminate |
    | V33809   | 5G09             | access-plan/2P77_RDNGSTN_PADTON.cif | PADTON   | WTT_arr    | checked    | un-checked | un-checked | un-checked | is not     | negative | terminate |
    | V33810   | 5G10             | access-plan/1D46_PADTON_OXFD.cif    | STHALL   | WTT_dep    | un-checked | un-checked | checked    | un-checked | is         | positive | pass      |
    | V33811   | 5G11             | access-plan/1D46_PADTON_OXFD.cif    | STHALL   | WTT_dep    | un-checked | checked    | un-checked | un-checked | is not     | negative | pass      |
    | V33812   | 5G12             | access-plan/1D46_PADTON_OXFD.cif    | SLOUGH   | WTT_dep    | un-checked | checked    | un-checked | un-checked | is         | positive | stop      |
    | V33813   | 5G13             | access-plan/1D46_PADTON_OXFD.cif    | SLOUGH   | WTT_dep    | un-checked | un-checked | checked    | un-checked | is not     | negative | stop      |
