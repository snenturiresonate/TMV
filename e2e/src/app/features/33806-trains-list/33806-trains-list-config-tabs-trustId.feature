Feature: 33806 - TMV User Preferences - full end to end testing

  As a tester
  I want to verify the train list config tab - trustId
  So, that I can identify if the build meets the end to end requirements

  Background:
    * I remove all trains from the trains list
    * I am on the home page
    * I restore to default train list config
    * I am on the trains list Config page
    * I have navigated to the 'Trains Class & MISC' configuration tab
    * I set 'Include unmatched' to be 'off'
    * I save the trains list config
    * I have navigated to the 'TRUST IDs' configuration tab

  #33806 - 33 Trains List Config (TRUST IDs View)
    #Given the user is viewing the trains list config
    #When the user selects the TRUST IDs view
    #Then the user is presented with the TRUST IDs settings view

  Scenario: 33806 -33 Trust ID config header and table display
    Then the trustId tab header is displayed as 'TRUST IDs'
    And I should see the trustId table with header as 'Selected TRUST IDs'

  #33806 -34 Trains List Config (Add TRUST IDs)
    #Given the user is viewing the trains list config
    #And the user is viewing the TRUST IDs view
    #When the user enters a TRUST ID (text input)
    #And the user selects the add button
    #Then the TRUST ID text is added to the TRUST IDs list

  Scenario: 33806 -34 Trains List Config (Add TRUST IDs)
    When I input '1T99' in the TRUST input field
    And I click the add button for TRUST Service Filter
    Then The TRUST ID table contains the following results
      | trustId |
      | 1T99    |

  #33806 -35 Trains List Config (Remove TRUST IDs)
    #Given the user is viewing the trains list config
    #And the user is viewing the TRUST IDs view
    #And there are TRUST IDs in the TRUST ID list
    #When the user opts to remove a TRUST ID entry
    #And the user selects the cross button aligned to the TRUST ID
    #Then the TRUST ID is removed from the TRUST IDs list

  Scenario: 33806 -35 Trains List Config (Remove TRUST IDs)
    When I input '1T00' in the TRUST input field
    And I click the add button for TRUST Service Filter
    And I remove the trust '1T00' from the selected trusts
    Then The TRUST ID table does not contain the following results
      | trustId |
      | 1T00    |

  #33806 - 36 Trains List Config (Remove All TRUST IDs)
    #Given the user is viewing the trains list config
    #And the user is viewing the TRUST IDs view
    #And there are TRUST IDs in the TRUST ID list
    #When the user opts to remove all TRUST ID entries
    #And the user selects the remove all button
    #Then all TRUST IDs are removed from the TRUST IDs list

  Scenario: 33806 -36 Trains List Config (Remove All TRUST IDs)
    When I input '1T01' in the TRUST input field
    And I click the add button for TRUST Service Filter
    And I input '1T02' in the TRUST input field
    And I click the add button for TRUST Service Filter
    And I click the clear all button for TRUST Service Filter
    Then I see the selected trusts table to not have any items

  Scenario Outline: 33806 -37 Trains List Config (TRUST IDs Applied)
    #Given the user has made changes to the TRUST ID settings
    #When the user views the trains list
    #Then the view is updated to reflect the user's TRUST ID changes
    * I remove today's train '<trainUid>' from the Redis trainlist
    Given I delete '<trainUid>:today' from hash 'schedule-modifications'
    When the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And the following live berth interpose message is sent from LINX
      | toBerth | trainDescriber | trainDescription   |
      | A001    | D3             | <trainDescription> |
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <trainUid> | <trainDescription> | now                    | 73000               | PADTON                 | today         | now                 |
    And I am on the trains list page
    Then train '<trainDescription>' with schedule id '<trainUid>' for today is visible on the trains list
    When I am on the trains list Config page
    And I have navigated to the 'TRUST IDs' configuration tab
    When I input '<nonExistentTrustId>' in the TRUST input field
    And I click the add button for TRUST Service Filter
    Then The TRUST ID table contains the following results
      | trustId              |
      | <nonExistentTrustId> |
    And I save the service filter changes for Trust Id
    And I refresh the browser
    And I am on the trains list page
    Then train description '<trainDescription>' with schedule type 'LTP' disappears from the trains list
    When I am on the trains list Config page
    And I have navigated to the 'TRUST IDs' configuration tab
    When I input '<existentTrustId>' in the TRUST input field
    And I click the add button for TRUST Service Filter
    Then The TRUST ID table contains the following results
      | trustId           |
      | <existentTrustId> |
    And I save the service filter changes for Trust Id
    And I refresh the browser
    And I am on the trains list page
    Then train '<trainDescription>' with schedule id '<trainUid>' for today is visible on the trains list

    Examples:
      | trainUid | trainDescription | nonExistentTrustId | existentTrustId |
      | H62991   | 5B62             | 5B62H62990         | 5B62H62991      |

  Scenario: 33806 AC2 - Limit of 50 TRUST IDs - frontend and backend validation
    Given I am on the trains list Config page
    And I have navigated to the 'TRUST IDs' configuration tab
    Then the trust ID input box is not disabled
    When I add 50 TRUST IDs to the filter list
    Then the TRUST ID table contains 50 IDs
    And the trust ID input box is disabled
