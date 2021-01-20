Feature: 33753 - TMV Timetable

  As a TMV dev team member
  I want end to end tests to be created for the Timetable functionality
  So that there is confidence that it continues to work as expected as more of the system is developed

  Scenario Outline: Scenario 1 -Open Timetable (Trains List)
     #Open Timetable (Trains List)
     #Given the user is authenticated to use TMV
     #And the user is viewing the trains list
     #When the user selects a train from the trains list using the secondary mouse click
     #And selects the "open timetable" option from the menu
     #Then the train's timetable is opened in a new browser tab
    Given I am on the trains list page
    And The trains list table is visible
    When I invoke the context menu from train <trainNum> on the trains list
    And I wait for the context menu to display
    And the trains list context menu is displayed
    And I open timetable from the context menu
    And I switch to the new tab
    And the tab title is 'TMV Timetable'
    Examples:
      | trainNum |
      | 1        |

  @tdd
  Scenario Outline: Scenario 2 -Open Timetable (Map)
    #Given the user is authenticated to use TMV
    #And the user is viewing a map
    #When the user selects a train (occupied berth) from the map using the secondary click
    #And selects the "open timetable" option from the menu
    #Then the train's timetable is opened in a new browser tab
    Given I am viewing the map HDGW01paddington.v
    And the following berth interpose message is sent from LINX
      | timestamp | toBerth | trainDescriber | trainDescription |
      | 09:59:00  | 0099    | D3             | <trainNum>       |
    When I invoke the context menu on the map for train <trainNum>
    And I open timetable from the map context menu
    And I switch to the new tab
    And the tab title is 'TMV Timetable'
    Examples:
      | trainNum |
      | 1G69     |

  Scenario Outline: Scenario - 3 Open Timetable (Search Result - Train, Timetable & Manual Match Search Results)
    #Given the user is authenticated to use TMV
    #And the user is viewing a search results list
    #When the user selects a train search result using the secondary click
    #And selects the "open timetable" option from the menu
    #Then the train's timetable is opened in a new browser tab
    Given I am on the home page
    When I click on the Train search
    When the user enter the value 'IT55'
    And I click on the Search icon
    Then the Train search table is shown
    And I invoke the context menu from trains <trainNum>
    And I wait for the train search context menu to display
    And the trains context menu is displayed
    And the train search context menu contains 'Open timetable' on line 1
    And the train search context menu contains 'Select maps' on line 2
    And I click on timetable link
    And I switch to the new tab
    And the tab title is 'TMV Timetable'
    Examples:
      | trainNum |
      | 1        |

  Scenario: Scenario 4 - View Timetable (Schedule Matched)
    #Given the user is authenticated to use TMV
    #And the user has opened a timetable
    #And the train is schedule matched
    #When the user is viewing the timetable
    #Then the train's schedule is displayed with any predicted and live running information and header information
    Given the access plan located in CIF file 'access-plan/2P77_RDNGSTN_PADTON.cif' is amended so that all services start within the next hour and then received from LINX
    And the following live berth step message is sent from LINX
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 1668      | 1664    | D1             | 2P77             |
    And I am on the trains list page
    And The trains list table is visible
    When I invoke the context menu from train '2P77' on the trains list
    And I wait for the context menu to display
    And the context menu contains 'Unmatch' on line 3
    And I click on Unmatch in the context menu
    And I switch to the new tab
    And the tab title is 'TMV Schedule Matching 2P77'
    #Then a matched service is visible
    And The timetable entries contains the following data
     | location   | workingArrivalTime | workingDeptTime  | publicArrivalTime | publicDeptTime | originalAssetCode | originalPathCode | originalLineCode   | allowances | activities | arrivalDateTime | deptDateTime | assetCode | pathCode | lineCode | punctuality |
     | RDNGSTN    |                    | 21:30:00	        |                   | 21:30:00	     | 15A               |                  | URL                |            |            |                 |              |           |          |          |             |
     | RDNGKBJ    |                    | 21:32:00	        | 00:00:00	        | 00:00:00	     |                   |                  | RL                 |            |            |                 |              |           |          |          |             |
     | TWYFORD    | 21:35:30	         | 21:36:30         | 21:36:00	        | 21:36:00	     | 4                 |                  | RL                 |            |            |                 |              |           |          |          |             |
     | MDNHEAD    | 21:43:30	         | 21:44:30	        | 21:44:00          | 21:44:00	     | 4                 |                  | RL                 |            |            |                 |              |           |          |          |             |
     | SLOUGH     | 21:51:00	         | 21:52:00	        | 21:51:00	        | 21:52:00	     | 5                 |                  | RL                 | (0.5)      |            |                 |              |           |          |          |             |
     | HTRWAJN    |                    | 21:59:30	        | 00:00:00	        | 00:00:00	     |                   |                  | RL                 |            |            |                 |              |           |          |          |             |
     | HAYESAH    | 22:00:30	         | 22:01:30	        | 22:01:00	        | 22:01:00	     | 4                 | RL               |                    | (1)        |            |                 |              |           |          |          |             |
     | STHALL     |                    | 22:05:00	        | 00:00:00	        | 00:00:00	     | 4                 |                  | RL                 | (1)        |            |                 |              |           |          |          |             |
     | WEALING    |                    | 22:08:00	        | 00:00:00	        | 00:00:00	     | 4                 |                  | RL                 | (1.5)      |            |                 |              |           |          |          |             |
     | EALINGB    | 22:11:00	         | 22:12:00         | 22:11:00	        | 22:12:00	     | 4                 |                  | RL                 |            |            |                 |              |           |          |          |             |
     | ACTONW     |                    | 22:13:30         | 00:00:00	        | 00:00:00	     |                   | RL               | RL                 | (1)        |            |                 |              |           |          |          |             |
     | LDBRKJ     |                    | 22:17:30	        | 00:00:00	        | 00:00:00	     |                   | RL               | 6                  |            |            |                 |              |           |          |          |             |
     | PRTOBJP    |                    | 22:18:30	        | 00:00:00	        | 00:00:00	     |                   |                  | 5                  | [1](0.5)   |            |                 |              |           |          |          |             |
     | ROYAOJN    |                    | 22:21:00	        | 00:00:00	        | 00:00:00	     |                   |                  |                    |            |            |                 |              |           |          |          |             |
     | PADTON     | 22:23:00           |                  | 22:23:00		      | 11:25          | 10                |                  |                    |            |            |                 |              |           |          |          |             |
    And I toggle the inserted locations on
    And The timetable entries contains the following data
      | location   | workingArrivalTime | workingDeptTime  | publicArrivalTime | publicDeptTime | originalAssetCode | originalPathCode | originalLineCode   | allowances | activities | arrivalDateTime | deptDateTime | assetCode | pathCode | lineCode | punctuality |
      | RDNGSTN    |                    | 21:30:00	       |                   | 21:30:00	      | 15A               |                  | URL                |            |            |                 |              |           |          |          |             |
      | RDNGKBJ    |                    | 21:32:00	       | 00:00:00	         | 00:00:00	      |                   |                  | RL                 |            |            |                 |              |           |          |          |             |
      | [TWYFDW]   |                    | 21:34:51         |                   |                |                   |                  |                    |            |            |                 |              |           |          |          |             |
      | TWYFORD    | 21:35:30	          | 21:36:30         | 21:36:00	         | 21:36:00	      | 4                 |                  | RL                 |            |            |                 |              |           |          |          |             |
      | [RUSCOMB]  |                    | 21:37:56	       |                   |                |                   |                  |                    |            |            |                 |              |           |          |          |             |
      | MDNHEAD    | 21:43:30	          | 21:44:30	       | 21:44:00          | 21:44:00	      | 4                 |                  | RL                 |            |            |                 |              |           |          |          |             |
      | [MDNHDE]	 |                    | 21:44:53         |                   |                |                   |                  |                    |            |            |                 |              |           |          |          |             |
      | [TAPLOW]   |                    | 21:46:29         |                   |                |                   |                  |                    |            |            |                 |              |           |          |          |             |
      | [BNHAM]    |                    | 21:48:10         |                   |                |                   |                  |                    |            |            |                 |              |           |          |          |             |
      | [SLOUGHW]  |                    | 21:50:06	       |                   |                |                   |                  |                    |            |            |                 |              |           |          |          |             |
      | SLOUGH     | 21:51:00	          | 21:52:00	       | 21:51:00	         | 21:52:00	      | 5                 |                  | RL                 | (0.5)      |            |                 |              |           |          |          |             |
      | [DOLPHNJ]	 |                    | 21:53:15         |                   |                |                   |                  |                    | (0.5)      |            |                 |              |           |          |          |             |
      | [LANGLEY]  |                    | 21:54:14         |                   |                |                   |                  |                    | (0.5)      |            |                 |              |           |          |          |             |
      | [IVER]     |                    | 21:55:48         |                   |                |                   |                  |                    | (0.5)      |            |                 |              |           |          |          |             |
      | [WDRYTON]  |                    | 21:57:28	       |                   |                |                   |                  |                    | (0.5)      |            |                 |              |           |          |          |             |
      | [STKYJN]   |                    | 21:58:51	       |                   |                |                   |                  |                    | (0.5)      |            |                 |              |           |          |          |             |
      | HTRWAJN    |                    | 21:59:30	       | 00:00:00	         | 00:00:00	      |                   |                  | RL                 |            |            |                 |              |           |          |          |             |
      | HAYESAH    | 22:00:30	          | 22:01:30	       | 22:01:00	         | 22:01:00	      | 4                 | RL               |                    | (1)        |            |                 |              |           |          |          |             |
      | [STHALWJ]  |                    | 22:03:12	       |                   |                |                   |                  |                    | (1)        |            |                 |              |           |          |          |             |
      | STHALL     |                    | 22:05:00	       | 00:00:00	         | 00:00:00	      | 4                 |                  | RL                 | (1)        |            |                 |              |           |          |          |             |
      | [STHALEJ]  |                    | 22:05:19	       |                   |                |                   |                  |                    | (1)        |            |                 |              |           |          |          |             |
      | [HANWELL]  |                    | 22:06:57	       |                   |                |                   |                  |                    | (1)        |            |                 |              |           |          |          |             |
      | WEALING    |                    | 22:08:00	       | 00:00:00	         | 00:00:00	      | 4                 |                  | RL                 | (1.5)      |            |                 |              |           |          |          |             |
      | EALINGB    | 22:11:00	          | 22:12:00         | 22:11:00	         | 22:12:00	      | 4                 |                  | RL                 |            |            |                 |              |           |          |          |             |
      | ACTONW     |                    | 22:13:30         | 00:00:00	         | 00:00:00	      |                   | RL               | RL                 | (1)        |            |                 |              |           |          |          |             |
      | [ACTONML]  |                    | 22:14:37	       |                   |                |                   |                  |                    | (1)        |            |                 |              |           |          |          |             |
      | LDBRKJ     |                    | 22:17:30	       | 00:00:00	         | 00:00:00	      |                   | RL               | 6                  |            |            |                 |              |           |          |          |             |
      | PRTOBJP    |                    | 22:18:30	       | 00:00:00	         | 00:00:00	      |                   |                  | 5                  | [1](0.5)   |            |                 |              |           |          |          |             |
      | ROYAOJN    |                    | 22:21:00	       | 00:00:00	         | 00:00:00	      |                   |                  |                    |            |            |                 |              |           |          |          |             |
      | PADTON     | 22:23:00           |                  | 22:23:00		       |                | 10                |                  |                    |            |            |                 |              |           |          |          |             |

  Scenario: Scenario 6 - View Timetable (Schedule Not Matched)
    #Given the user is authenticated to use TMV
    #And the user has opened a timetable
    #And the train is not schedule matched
    #When the user is viewing the timetable
    #Then the train's blank schedule is displayed with basic header information
    Given the following live berth interpose message is sent from LINX
      | toBerth | trainDescriber | trainDescription |
      | 0535    | 5N68           | D6               |
    And I am on the trains list page
    And The trains list table is visible
    When I invoke the context menu from train '5N68' on the trains list
    And I wait for the context menu to display
    Then the context menu contains '5N68' on line 1
    And the context menu contains 'Match' on line 3
    And the context menu contains 'D60535' on line 6
    And the context menu contains 'T535' on line 7
    And the context menu contains 'T6284' on line 7
    When I click on Match in the context menu
    And I switch to the new tab
    Then the tab title is 'TMV Schedule Matching 5N68'
    #And no matched service is visible
    And The timetable entries contains the following data
      | location   | workingArrivalTime | workingDeptTime  | publicArrivalTime | publicDeptTime | originalAssetCode | originalPathCode | originalLineCode   | allowances | activities | arrivalDateTime | deptDateTime | assetCode | pathCode | lineCode | punctuality |
