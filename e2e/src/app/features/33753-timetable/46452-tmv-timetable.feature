@bug @bug_54441
Feature: 33753 - TMV Timetable

  As a TMV dev team member
  I want end to end tests to be created for the Timetable functionality
  So that there is confidence that it continues to work as expected as more of the system is developed

  Scenario Outline: 33753-1 -Open Timetable (Trains List)
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
  Scenario Outline: 33753-2 -Open Timetable (Map)
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

  Scenario Outline: 33753-3 Open Timetable (Search Result - Train, Timetable & Manual Match Search Results)
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

  @tdd @replaySetup
  Scenario: 33753-4 - View Timetable (Schedule Matched)
    #Given the user is authenticated to use TMV
    #And the user has opened a timetable
    #And the train is schedule matched
    #When the user is viewing the timetable
    #Then the train's schedule is displayed with any predicted and live running information and header information
      Given the access plan located in CIF file 'access-plan/1D46_PADTON_OXFD.cif' is amended so that all services start within the next hour and then received from LINX
      And the following live berth step message is sent from LINX
        | fromBerth | toBerth | trainDescriber | trainDescription |
        | 1668      | 1664    | D1             | 1D46             |
      And I am on the trains list page
      And The trains list table is visible
      When I invoke the context menu from train '1D46' on the trains list
      And I wait for the context menu to display
      And I open timetable from the context menu
      And I switch to the new tab
      And The values for the header properties are as follows
        | schedType | lastSignal | lastReport                  | trainUid | trustId       | lastTJM  |
        | VAR       |            |                             | L77777   |               |          |
      And the navbar punctuality indicator is displayed as 'green'
      And the punctuality is displayed as 'On Time'
      Then a matched service is visible
      And The timetable entries contains the following data
        | location               | workingArrivalTime | workingDeptTime   | publicArrivalTime  | publicDeptTime | originalAssetCode   | originalPathCode    | originalLineCode   | allowances | activities | arrivalDateTime | deptDateTime | assetCode | pathCode | lineCode | punctuality |
        |PADTON		               |                    |23:33:00	          |	                   |23:33:00	      |4                    |		                  |1                   |            |            |                 |              |           |          |          |             |
        |ROYAOJN		             |                    |23:34:00	          |00:00:00	           |00:00:00			  |                     |                     |1                   |            |            |                 |              |           |          |          |             |
        |PRTOBJP		             |                    |23:35:00	          |00:00:00	           |00:00:00			  |                     |                     |1                   |            |            |                 |              |           |          |          |             |
        |LDBRKJ		               |                    |23:35:30	          |00:00:00	           |00:00:00		    |                     |1	                  |ML                  |            |            |                 |              |           |          |          |             |
        |ACTONW Change-en-Route  |                    |23:38:00	          |00:00:00	           |00:00:00		    |                     |ML	                  |ML                  |            |            |                 |              |           |          |          |             |
        |STHALL		               |                    |23:40:00	          |00:00:00	           |00:00:00	      |1		                |                     |ML                  |            |            |                 |              |           |          |          |             |
        |HTRWAJN		             |                    |23:41:00	          |00:00:00	           |00:00:00			  |                     |                     |ML	                 |(2)         |            |                 |              |           |          |          |             |
        |SLOUGH	                 |23:47:00	          |23:48:30	          |23:47:00	           |23:48:00	      |2		                |                     |ML	                 |(0.5)       |            |                 |              |           |          |          |             |
        |MDNHEAD	               |23:53:30	          |23:55:30	          |23:54:00	           |23:55:00	      |1		                |                     |ML	                 |(0.5)       |            |                 |              |           |          |          |             |
        |TWYFORD		             |                    |00:01:00	          |00:00:00	           |00:00:00	      |1		                |                     |ML	                 |[1] (1)     |            |                 |              |           |          |          |             |
        |RDNGKBJ		             |                    |00:05:00	          |00:00:00	           |00:00:00			  |                     |                     |DML	               |(0.5)       |            |                 |              |           |          |          |             |
        |RDNGSTN	               |00:06:30	          |00:10:00	          |00:07:00	           |00:10:00	      |9		                |                     |ML                  |            |            |                 |              |           |          |          |             |
        |RDNGHLJ		             |                    |00:11:00       	  |00:00:00	           |00:00:00        |			                |                     |ML                  |            |            |                 |              |           |          |          |             |
        |GORASTR		             |                    |00:16:30	          |00:00:00	           |00:00:00        |		                  |	                    |ML	                 |[1] (1)     |            |                 |              |           |          |          |             |
        |DIDCTEJ		             |                    |00:23:00	          |00:00:00	           |00:00:00        |			                |                     |RL                  |            |            |                 |              |           |          |          |             |
        |DIDCOTP Change-en-Route |00:24:00	          |00:26:00	          |00:24:00	           |00:26:00        |3		                |                     |DOX                 |            |            |                 |              |           |          |          |             |
        |DIDCTNJ		             |                    |00:28:00	          |00:00:00	           |00:00:00        |                     |                     |                    |            |            |                 |              |           |          |          |             |
        |RDLEY	                 |00:32:30	          |00:34:00	          |00:33:00	           |00:34:00        |1                    |                     |                    |            |            |                 |              |           |          |          |             |
        |KNNGTNJ		             |                    |00:37:30	          |00:00:00	           |00:00:00        |                     |                     |                    |            |            |                 |              |           |          |          |             |
        |OXFDUDP		             |                    |00:40:00	          |00:00:00	           |00:00:00        |				              |                     |                    |[1]         |            |                 |              |           |          |          |             |
        |OXFD	                   |00:43:00		        |                   |00:43:00		         |                |3                    |                     |                    |            |            |                 |              |           |          |          |             |
      And I toggle the inserted locations on
      And The timetable entries contains the following data
        | location               | workingArrivalTime | workingDeptTime   | publicArrivalTime  | publicDeptTime | originalAssetCode   | originalPathCode    | originalLineCode   | allowances | activities | arrivalDateTime | deptDateTime | assetCode | pathCode | lineCode | punctuality |
        |PADTON		               |                    |23:33:00	          |	                   |23:33:00	      |4                    |		                  |1                   |            |            |                 |              |           |          |          |             |
        |ROYAOJN		             |                    |23:34:00	          |00:00:00	           |00:00:00			  |                     |                     |1                   |            |            |                 |              |           |          |          |             |
        |PRTOBJP		             |                    |23:35:00	          |00:00:00	           |00:00:00			  |                     |                     |1                   |            |            |                 |              |           |          |          |             |
        |LDBRKJ		               |                    |23:35:30	          |00:00:00	           |00:00:00		    |                     |1	                  |ML                  |            |            |                 |              |           |          |          |             |
        |[ACTONML]               |                    |23:37:22	          |                    |                |                     |                     |                    |            |            |                 |              |           |          |          |             |
        |ACTONW Change-en-Route  |                    |23:38:00	          |00:00:00	           |00:00:00		    |                     |ML	                  |ML                  |            |            |                 |              |           |          |          |             |
        |[EALINGB]               |                    |23:38:13	          |                    |                |                     |                     |                    |            |            |                 |              |           |          |          |             |
        |[WEALING]               |                    |23:38:43	          |                    |                |                     |                     |                    |            |            |                 |              |           |          |          |             |
        |[HANWELL]               |                    |23:39:07	          |                    |                |                     |                     |                    |            |            |                 |              |           |          |          |             |
        |[STHALEJ]               |                    |23:39:49	          |                    |                |                     |                     |                    |            |            |                 |              |           |          |          |             |
        |STHALL		               |                    |23:40:55	          |00:00:00	           |00:00:00	      |1		                |                     |ML                  |            |            |                 |              |           |          |          |             |
        |[STHALWJ]               |                    |23:41:00	          |                    |                |                     |                     |                    |            |            |                 |              |           |          |          |             |
        |[HANWELL]               |                    |23:39:07	          |                    |                |                     |                     |                    |            |            |                 |              |           |          |          |             |
        |HTRWAJN		             |                    |23:41:00	          |00:00:00	           |00:00:00			  |                     |                     |ML	                 |(2)         |            |                 |              |           |          |          |             |
        |SLOUGH	                 |23:47:00	          |23:48:30	          |23:47:00	           |23:48:00	      |2		                |                     |ML	                 |(0.5)       |            |                 |              |           |          |          |             |
        |MDNHEAD	               |23:53:30	          |23:55:30	          |23:54:00	           |23:55:00	      |1		                |                     |ML	                 |(0.5)       |            |                 |              |           |          |          |             |
        |TWYFORD		             |                    |00:01:00	          |00:00:00	           |00:00:00	      |1		                |                     |ML	                 |[1] (1)     |            |                 |              |           |          |          |             |
        |RDNGKBJ		             |                    |00:05:00	          |00:00:00	           |00:00:00			  |                     |                     |DML	               |(0.5)       |            |                 |              |           |          |          |             |
        |RDNGSTN	               |00:06:30	          |00:10:00	          |00:07:00	           |00:10:00	      |9		                |                     |ML                  |            |            |                 |              |           |          |          |             |
        |RDNGHLJ		             |                    |00:11:00       	  |00:00:00	           |00:00:00        |			                |                     |ML                  |            |            |                 |              |           |          |          |             |
        |GORASTR		             |                    |00:16:30	          |00:00:00	           |00:00:00        |		                  |	                    |ML	                 |[1] (1)     |            |                 |              |           |          |          |             |
        |DIDCTEJ		             |                    |00:23:00	          |00:00:00	           |00:00:00        |			                |                     |RL                  |            |            |                 |              |           |          |          |             |
        |DIDCOTP Change-en-Route |00:24:00	          |00:26:00	          |00:24:00	           |00:26:00        |3		                |                     |DOX                 |            |            |                 |              |           |          |          |             |
        |DIDCTNJ		             |                    |00:28:00	          |00:00:00	           |00:00:00        |                     |                     |                    |            |            |                 |              |           |          |          |             |
        |RDLEY	                 |00:32:30	          |00:34:00	          |00:33:00	           |00:34:00        |1                    |                     |                    |            |            |                 |              |           |          |          |             |
        |KNNGTNJ		             |                    |00:37:30	          |00:00:00	           |00:00:00        |                     |                     |                    |            |            |                 |              |           |          |          |             |
        |OXFDUDP		             |                    |00:40:00	          |00:00:00	           |00:00:00        |				              |                     |                    |[1]         |            |                 |              |           |          |          |             |
        |OXFD	                   |00:43:00		        |                   |00:43:00		         |                |3                    |                     |                    |            |            |                 |              |           |          |          |             |
  @tdd
  Scenario: 33753-5 - View Timetable (Schedule Not Matched)
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
    And I open timetable from the context menu
    And I switch to the new tab
    Then the tab title is 'TMV Schedule Matching 5N68'
    And the punctuality is displayed as 'Unmatched'
    And no matched service is visible
    And The timetable entries contains the following data
      | location   | workingArrivalTime | workingDeptTime  | publicArrivalTime | publicDeptTime | originalAssetCode | originalPathCode | originalLineCode   | allowances | activities | arrivalDateTime | deptDateTime | assetCode | pathCode | lineCode | punctuality |

  @tdd
  Scenario: 33753-7 - View Timetable (Schedule Matched)
    #Given the user is authenticated to use TMV
    #And the user has opened a timetable
    #And the train is schedule matched
    #When the user selects the details tab of the timetable
    #Then the train's CIF information and header information with any TJM, Association and Change-en-route is displayed
    Given the access plan located in CIF file 'access-plan/1D46_PADTON_OXFD.cif' is amended so that all services start within the next hour and then received from LINX
    And the following live berth step message is sent from LINX
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 1668      | 1664    | D1             | 1D46             |
    And I am on the trains list page
    And The trains list table is visible
    When I invoke the context menu from train '1D46' on the trains list
    And I wait for the context menu to display
    And I open timetable from the context menu
    And I switch to the new tab
    And the navbar punctuality indicator is displayed as 'green'
    And the punctuality is displayed as 'On Time'
    Then a matched service is visible
    When I switch to the timetable details tab
    Then The timetable details tab is visible
    And The timetable details table contains the following data in each row
      | daysRun                 | runs                                      | bankHoliday | berthId | operator | trainServiceCode  | trainStatusCode  | trainCategory | direction | cateringCode| class    | seatingClass| reservations | timingLoad | powerType | speed           | portionId | trainLength | trainOperatingCharacteristcs | serviceBranding |
      | 04/01/2021 to 31/01/2020| Monday,Tuesday,Wednesday,Thursday & Friday|             |         | GW       | 25507005          | P                | XX            |           |  ,,         | 1        | B,B         | A,A          | D1 , D2    | DMU , AMU | 125mph , 144mph |  ,,       | m,m         | D , D                        |                |
    And The entry of the change en route table contains the following data
      | columnName  |
      | ACTONW      |
      | DMU         |
      | 811         |
      | 144mph      |
      | D           |


  @tdd
  Scenario: 33753-8 - View Timetable Detail (Not Schedule Matched)
    #Given the user is authenticated to use TMV
    #And the user has opened a timetable
    #And the train is not schedule matched
    #When the user selects the details tab of the timetable
    #Then the train's basic header information is displayed
    Given the following live berth interpose message is sent from LINX
      | toBerth | trainDescriber | trainDescription |
      | 0535    | 5N68           | D6               |
    And I am on the trains list page
    And The trains list table is visible
    When I invoke the context menu from train '5N68' on the trains list
    And I wait for the context menu to display
    And I open timetable from the context menu
    And I switch to the new tab
    And the punctuality is displayed as 'Unmatched'
    And no matched service is visible
    When I switch to the timetable details tab
    Then The timetable details tab is visible
    And The timetable entries contains the following data
      | location   | workingArrivalTime | workingDeptTime  | publicArrivalTime | publicDeptTime | originalAssetCode | originalPathCode | originalLineCode   | allowances | activities | arrivalDateTime | deptDateTime | assetCode | pathCode | lineCode | punctuality |
