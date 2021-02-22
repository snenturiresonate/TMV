@bug @bug_55994
Feature: 33806 - TMV User Preferences - full end to end testing

  As a tester
  I want to verify the train list config tab - TOC/FOC
  So, that I can identify if the build meets the end to end requirements

  Background:
    Given I am on the trains list Config page
    And I have navigated to the 'TOC/FOC' configuration tab

  #33806 -11 Trains List Config (TOC/FOC Selection)
    #Given the user is viewing the trains list config
    #And the user is viewing the TOC/FOC config tab
    #When the user selects a TOC/FOC from un-selected TOC/FOC list to add to the trains list view
    #Then the TOC/FOC item is moved to the selected TOC/FOC list

  Scenario: 33806 -11a Trains list TOC/FOC config header
    Then the railway undertaking tab header is displayed as 'TOC/FOC'

  Scenario: 33806 -11b Trains list column config column names
    Then the following header can be seen on the railway undertaking columns
      | configColumnName |
      | Available        |
      | Selected         |
@tdd
  Scenario: 33806 -11c Trains list railway undertaking config tab - default selected and unselected entries
    Then the following can be seen on the unselected railway undertaking config
      | unSelectedColumn                 | arrowType            |
      | Advenza Freight (PI)             | keyboard_arrow_right |
      | AMEY Fleet Services (RE)         | keyboard_arrow_right |
      | Arriva Trains Wales (HL)         | keyboard_arrow_right |
      | COLAS (RG)                       | keyboard_arrow_right |
      | Cross Country Trains (EH)        | keyboard_arrow_right |
      | Deven and Cornwall Railways (PO) | keyboard_arrow_right |
      | Great Western Railways (GW)      | keyboard_arrow_right |
      | Heathrow Express (HE)            | keyboard_arrow_right |
      | Cross country (CC)               | keyboard_arrow_right |
      | South Western Railways (SW)      | keyboard_arrow_right |
      | Tfl Rail (TR)                    | keyboard_arrow_right |
      | Others (OT)                      | keyboard_arrow_right |
      | East Midlands Trains (EM)        | keyboard_arrow_right |
      | Chiltern Railways (HO)           | keyboard_arrow_right |
      | C2C Rail (HT)                    | keyboard_arrow_right |
    Then the following appear in the selected railway undertaking config
      |selectedColumn                   |
      |                                 |

  Scenario: 33806 -11d Moving all unselected items to selected column
    When I click on all the unselected railway undertaking entries
    Then the following appear in the selected railway undertaking config
      |selectedColumn               |
      | Advenza Freight (PI)        |
      | AMEY Fleet Services (RE)    |
      | Arriva Trains Wales (HL)    |
      | COLAS (RG)                  |
      | Cross Country Trains (EH)   |
      | Deven and Cornwall Railways (PO) |
      | Great Western Railways (GW) |
      | Heathrow Express (HE)       |
      | Cross country (CC)          |
      | South Western Railways (SW) |
      | Tfl Rail (TR)               |
      | Others (OT)                 |
      |East Midlands Trains (EM)    |
      |Chiltern Railways (HO)       |
      |C2C Rail (HT)                |

  #33806 -12 Trains List Config (TOC/FOC De-Selection)
    #Given the user is viewing the trains list config
    #And the user is viewing the TOC/FOC config tab
    #When the user selects a TOC/FOC from selected TOC/FOC list to remove from the trains list view
    #Then the TOC/FOC item is moved to the un-selected TOC/FOC list

  Scenario: 33806 -12 Moving all selected items to Unselected column
    When I click on all the selected railway undertaking entries
    And the following can be seen on the unselected railway undertaking config
      | unSelectedColumn                 | arrowType            |
      | Advenza Freight (PI)             | keyboard_arrow_right |
      | AMEY Fleet Services (RE)         | keyboard_arrow_right |
      | Arriva Trains Wales (HL)         | keyboard_arrow_right |
      | COLAS (RG)                       | keyboard_arrow_right |
      | Cross Country Trains (EH)        | keyboard_arrow_right |
      | Deven and Cornwall Railways (PO) | keyboard_arrow_right |
      | Great Western Railways (GW)      | keyboard_arrow_right |
      | Heathrow Express (HE)            | keyboard_arrow_right |
      | Cross country (CC)               | keyboard_arrow_right |
      | South Western Railways (SW)      | keyboard_arrow_right |
      | Tfl Rail (TR)                    | keyboard_arrow_right |
      | Others (OT)                      | keyboard_arrow_right |
      | East Midlands Trains (EM)        | keyboard_arrow_right |
      | Chiltern Railways (HO)           | keyboard_arrow_right |
      | C2C Rail (HT)                    | keyboard_arrow_right |

  #33806 -13 Trains List Config (TOC/FOC Applied)
    #Given the user has made changes to the trains list TOC/FOC selection
    #When the user views the trains list
    #Then the view is updated to reflect the user's TOC/FOC selection
  @tdd
  Scenario Outline: 33806 -13 Selecting required columns and verifying if they are reflected in the trains list
    When I select only the following railway undertaking entries
      | items                    |
      | <columnToSelectInConfig> |
    And I open 'trains list' page in a new tab
    Then I should see the trains list column TOC has only the below values
      | expectedValues               |
      | <valuesToExpectInTrainsList> |
    Examples:
      | columnToSelectInConfig           | valuesToExpectInTrainsList |
      | Advenza Freight (PI)             | PI                         |
      | AMEY Fleet Services (RE)         | RE                         |
      | Arriva Trains Wales (HL)         | HL                         |
      | COLAS (RG)                       | RG                         |
      | Cross Country Trains (EH)        | EH                         |
      | Deven and Cornwall Railways (PO) | PO                         |
      | Great Western Railways (GW)      | GW                         |
      | Heathrow Express (HE)            | HE                         |
      | Cross country (CC)               | CC                         |
      | South Western Railways (SW)      | SW                         |
      | Tfl Rail (TR)                    | TR                         |
      | Others (OT)                      | OT                         |
      | East Midlands Trains (EM)        | EM                         |
      | Chiltern Railways (HO)           | HO                         |
      | C2C Rail (HT)                    | HT                         |
