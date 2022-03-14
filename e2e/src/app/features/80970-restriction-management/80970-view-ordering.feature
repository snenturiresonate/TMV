@TMVPhase2 @P2.S4
Feature: 80970 - TMV Restrictions - View Ordering

  As a TMV User (with restrictions role)
  I want the ability manage restrictions
  So that I can ensure user are aware of future and current restrictions

#  Given the user is viewing a live schematic map
#  When the user selects a track section with the secondary click
#  And selects the option to view the restrictions tab
#  And there are restrictions
#  Then the user is presented with a list of restriction that are ordered in logical way
#  The ordering of the restrictions are as follows:
#

#       Order by operational start date & time (early first) and then operational end date & time (later first, but with blank highest)
#       If the end date is in the past then these are placed at the bottom of the list
#       If all dates are equal order by type of restriction (currently excluded from BDD because of bug: 87579)
#           BLOK (Line Blockage)
#           OOU (Out of Use)
#           POSS (Possession)
#           ESR (Emergency Speed Restriction)
#           TSR (Temporary Speed Restriction)
#           BTET (Blocked to Electric Traction)
#           CAU (Cautioning of Trains)
#
#       The restrictions to use are as follows:
#           Operational restriction with an end date in the future
#           Operational restriction with no end date
#           Non-operational restriction with a start date and end date in the future
#           Non-operational restriction with a start date in the future and no end date
#           Past restriction start and end date in the past

  Background:
    Given I have not already authenticated
    And I access the homepage as restriction user

  Scenario Outline: 87348 - View Ordering

    Given I remove all restrictions for track division <trackDivisionId>
    And I clear all restrictions events and snapshots for map <map>
    And I am viewing the map <map>
    And I right click on track with id '<trackDivisionId>'
    And I open restrictions screen from the map context menu
    And I switch to the new restriction tab
    And I add the following restrictions whilst preserving allocated dates
      | type              | start-date | end-date  | comment             |
      | POSS (Possession) | now - 30   |           | Operational - 1     |
      | POSS (Possession) | now - 60   | now + 60  | Operational - 2     |
      | POSS (Possession) | now - 60   | now + 65  | Operational - 3     |
      | POSS (Possession) | now - 60   | now + 70  | Operational - 4     |
      | POSS (Possession) | now - 60   |           | Operational - 5     |
      | POSS (Possession) | now - 100  | now + 120 | Operational - 6     |
      | POSS (Possession) | now - 120  | now - 20  | Past                |
      | POSS (Possession) | now + 30   | now + 60  | Non-operational - 1 |
      | POSS (Possession) | now + 30   |           | Non-operational - 2 |
      | POSS (Possession) | now - 840  | now - 720 | Expired             |
    And I click apply changes
    And I logout
    And I access the homepage as standard user
    And I am viewing the map <map>
    And I right click on track with id '<trackDivisionId>'
    And I open restrictions screen from the map context menu
    When I switch to the new restriction tab
    Then only the following restrictions are shown in order
      | type              | start-date | end-date  | comment             |
      | POSS (Possession) | now - 100  | now + 120 | Operational - 6     |
      | POSS (Possession) | now - 60   |           | Operational - 5     |
      | POSS (Possession) | now - 60   | now + 70  | Operational - 4     |
      | POSS (Possession) | now - 60   | now + 65  | Operational - 3     |
      | POSS (Possession) | now - 60   | now + 60  | Operational - 2     |
      | POSS (Possession) | now - 30   |           | Operational - 1     |
      | POSS (Possession) | now + 30   |           | Non-operational - 2 |
      | POSS (Possession) | now + 30   | now + 60  | Non-operational - 1 |
      | POSS (Possession) | now - 120  | now - 20  | Past                |

    Examples:
      | map                | trackDivisionId |
      | HDGW01paddington.v | PNPNDM          |

