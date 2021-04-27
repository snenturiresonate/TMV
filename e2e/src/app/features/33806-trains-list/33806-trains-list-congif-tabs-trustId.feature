Feature: 33806 - TMV User Preferences - full end to end testing

  As a tester
  I want to verify the train list config tab - trustId
  So, that I can identify if the build meets the end to end requirements

  Background:
    Given I am on the trains list Config page
    And I have navigated to the 'TRUST IDs' configuration tab

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
      | trustId               |
      | 1T99  |

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
      | trustId               |
      | 1T00  |

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
