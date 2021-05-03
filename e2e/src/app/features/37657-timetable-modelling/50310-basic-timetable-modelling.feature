Feature: 37657 - Basic Timetable Modelling

  As a TMV user
  I want the schedules received in a CIF format to be transformed and loaded into TMV as agreed and current timetables
  So that the data is available for the system to use schedule match and display purposes

  Scenario Outline: 37657-1 Old Schedules are not displayed
    # Given a schedule has been received with <STP indicator> which has a 'Date Runs To' before the current time period
    # When a user searches for that timetable
    # Then no results are returned with that planning UID and schedule date
    Given I am on the home page
    And there is a Schedule for '<trainDescription>'
    And the schedule has a basic timetable
    And the schedule has schedule identifier characteristics
      | trainUid   | stpIndicator   | dateRunsFrom   |
      | <trainUid> | <stpIndicator> | <dateRunsFrom> |
    And the schedule has a Date Run to of '<dateRunsTo>'
    And the schedule is received from LINX
    When I search Train for '<trainDescription>'
    Then no results are returned with that planning UID '<trainUid>'

    Examples:
      | trainDescription | trainUid | dateRunsFrom | dateRunsTo | stpIndicator | displayType |
      | 4F01             | A137657  | 2020-01-01   | yesterday  | P            | LTP         |
      | 4F02             | A237657  | 2020-01-01   | yesterday  | N            | STP         |

  Scenario Outline: 37657-2 Future Schedules are not displayed
    # Given a schedule has been received with <STP indicator>which has a 'Date Runs From' after the current time period
    # When a user searches for that timetable
    # Then no results are returned with that planning UID and schedule date
    Given I am on the home page
    And there is a Schedule for '<trainDescription>'
    And the schedule has a basic timetable
    And the schedule has schedule identifier characteristics
      | trainUid   | stpIndicator   | dateRunsFrom   |
      | <trainUid> | <stpIndicator> | <dateRunsFrom> |
    And the schedule is received from LINX
    When I search Train for '<trainDescription>'
    Then no results are returned with that planning UID '<trainUid>'

    Examples:
      | trainDescription | trainUid | dateRunsFrom | stpIndicator | displayType |
      | 4F03             | A337657  | tomorrow     | P            | LTP         |
      | 4F04             | A437657  | tomorrow     | N            | STP         |

  Scenario Outline: 37657-3 Days run outside current time period are not displayed
    # Given a schedule has been received with <STP indicator> where the 'Days Runs' is not in the current time period
    # When a user searches for that timetable
    # Then no results are returned with that planning UID and schedule date
    Given I am on the home page
    And there is a Schedule for '<trainDescription>'
    And the schedule has a basic timetable
    And the schedule has schedule identifier characteristics
      | trainUid   | stpIndicator   | dateRunsFrom   |
      | <trainUid> | <stpIndicator> | <dateRunsFrom> |
    And the schedule does not run on a day that is today
    And the schedule is received from LINX
    When I search Train for '<trainDescription>'
    Then no results are returned with that planning UID '<trainUid>'

    Examples:
      | trainDescription | trainUid | dateRunsFrom | dateRunsTo | stpIndicator | displayType |
      | 4F05             | A537657  | 2020-01-01   | 2050-12-01 | P            | LTP         |
      | 4F06             | A637657  | 2020-01-01   | 2050-12-01 | N            | STP         |

  @tdd
  Scenario Outline: 37657-4 Base Schedule is displayed
    # Given schedule(s) has been received with <STP indicator> that applies to the current time period (Date Runs To, Date Runs From and Days Run don't exclude it)
    # And no other STPs have been received for that service
    # When a user searches for that timetable
    # Then one timetable with the planning UID and schedule date is returned and the type is <DisplayType>
    Given I am on the home page
    And there is a Schedule for '<trainDescription>'
    And the schedule has schedule identifier characteristics
      | trainUid   | stpIndicator   | dateRunsFrom   |
      | <trainUid> | <stpIndicator> | <dateRunsFrom> |
    And the schedule has a Date Run to of '<dateRunsTo>'
    And the schedule has a Days Run of all Days
    And the schedule is received from LINX
    When I search Timetable for '<trainUid>'
    Then results are returned with that planning UID '<trainUid>'

    Examples:
      | trainDescription | trainUid | dateRunsFrom | dateRunsTo | stpIndicator | displayType |DaytoRun|
      | 4F07             | A12345   | 2020-01-01   | 2050-01-01 | P            | LTP         |1111111|
      | 4F08             | A22345   | 2020-01-01   | 2050-01-01 | N            | STP         |1111111|

  @tdd
  Scenario Outline: 37657-5 Schedule Cancellation is displayed
    # Given schedule(s) has been received with <STP indicator> that applies to the current time period (Date Runs To, Date Runs From and Days Run don't exclude it)
    # When a user searches for that timetable
    # Then one timetable with the planning UID and schedule date is returned and the type is <DisplayType>
    Given I am on the home page
    And the access plan located in CIF file '<fileName>' is received from LINX
    When I search Timetable for '<trainUid>'
    Then results are returned with that planning UID '<trainUid>'
    Examples:
      | fileName                                          | trainUid | dateRunsFrom | dateRunsTo | daysToRun| stpIndicator | displayType |
      | access-plan/schedules_BS_type_C.cif               | A32345   | 2020-01-01   | 2050-01-01 | 1111111  | C            | LTP         |
      | access-plan/schedules_BS_type_P_C.cif             | A42345   | 2020-01-01   | 2050-01-01 | 1111111  | P,C          | LTP         |
      | access-plan/schedules_BS_type_P_O_C.cif           | A52345   | 2020-01-01   | 2050-01-01 | 1111111  | P,O,C        | LTP         |
      | access-plan/schedules_BS_type_N_C.cif             | A62345   | 2020-01-01   | 2050-01-01 | 1111111  | N,C          | LTP         |
      | access-plan/schedules_BS_type_N_O_C.cif           | A72345   | 2020-01-01   | 2050-01-01 | 1111111  | N,O,C        | LTP         |

  @tdd
  Scenario Outline: 37657-6 Schedule Overlay is displayed
    # Given multiple schedules has been received with <STP indicator> that applies to the current time period (Date Runs To, Date Runs From and Days Run don't exclude it)
    # When a user searches for that timetable
    # Then one timetable with the planning UID and schedule date is returned and the type is <DisplayType>
    Given I am on the home page
    And the access plan located in CIF file '<fileName>' is received from LINX
    When I search Timetable for '<trainUid>'
    Then results are returned with that planning UID '<trainUid>'
    Examples:
      | fileName                                          | trainUid | dateRunsFrom | dateRunsTo | daysToRun| stpIndicator | displayType |
      | access-plan/schedules_BS_type_O.cif               | A82345   | 2020-01-01   | 2050-01-01 | 1111111  | O            | LTP         |
      | access-plan/schedules_BS_type_P_O.cif             | A92345   | 2020-01-01   | 2050-01-01 | 1111111  | P,O          | LTP         |
      | access-plan/schedules_BS_type_N_O.cif             | A13345   | 2020-01-01   | 2050-01-01 | 1111111  | N,O          | LTP         |

  @tdd
  Scenario Outline: 37657-7 Multiple schedules with the same precedence
    # Given schedule(s) has been received with <STP indicator> that applies to the current time period (Date Runs To, Date Runs From and Days Run don't exclude it)
    # When a user searches for that timetable
    # Then newest version of the timetable with the planning UID and schedule date is returned and the type is <DisplayType>
    Given I am on the home page
    And the access plan located in CIF file '<fileName>' is received from LINX
    When I search Timetable for '<trainUid>'
    Then results are returned with planning UID '<trainUid>' and schedule type '<scheduleType>'
    Examples:
      | fileName                                          | trainUid |  scheduleType  |
      | access-plan/schedules_BS_type_P_P.cif             | A14345   |  LTP           |
      | access-plan/schedules_BS_type_O_O.cif             | A15345   |  VAR           |
      | access-plan/schedules_BS_type_C_C.cif             | A16345   |  CAN           |

  @tdd
  Scenario Outline: 37657-8 Schedule details content are displayed
    # Given schedule(s) has been received with <STP indicator> that applies to the current time period (Date Runs To, Date Runs From and Days Run don't exclude it)
    # When a user views  that timetable
    # Then the timetable is displayed with the type is <DisplayType>
    # And the Train UID from the schedule
    # And the headcode from the schedule
    # And Details displayed match those provided in the CIF
    # ***********Headcode need to be add for validation *************
    Given the access plan located in CIF file '<fileName>' is received from LINX
    And I am on the trains list page
    And The trains list table is visible
    And I invoke the context menu from train '<trainUid>' on the trains list
    And I wait for the context menu to display
    When I open timetable from the context menu
    And I switch to the new tab
    Then The values for the header properties are as follows
      | schedType            | lastSignal | lastReport   | trainUid     | trustId       | lastTJM  |
      | <scheduleType>       |            |              | <trainUid>   |               |          |
    And the window title is displayed as '1L23'
    And I switch to the timetable details tab
    And The timetable details tab is visible
    And The timetable details table contains the following data in each row
      | daysRun                 | runs                                      | bankHoliday | berthId | operator | trainServiceCode  | trainStatusCode  | trainCategory | direction | cateringCode| class    | seatingClass| reservations | timingLoad | powerType | speed           | portionId | trainLength | trainOperatingCharacteristcs | serviceBranding |
      |                         | Monday,Tuesday,Wednesday,Thursday & Friday|             |         | GW       | 25507005          |                  | XX            |           |             | 1        | B,B         | A,A          | D1 , D2    | DMU , AMU |                 |           | m,m         | D , D                        |                 |
    Examples:
      | fileName                                        | trainUid  |  scheduleType   |
      | access-plan/schedules_BS_type_P.cif             | A17345    |  LTP            |
      | access-plan/schedules_BS_type_N.cif             | A18345    |  STP            |
      | access-plan/schedules_BS_type_O.cif             | A19345    |  VAR            |

  @tdd
  Scenario Outline: 37657-9 Schedule locations are displayed
    # Given schedule(s) has been received with <STP indicator> that applies to the current time period (Date Runs To, Date Runs From and Days Run don't exclude it)
    # When a user views that timetable with inserted locations turned off
    # Then the locations displayed match those provided in the CIF
    Given the access plan located in CIF file '<fileName>' is received from LINX
    And I am on the trains list page
    And The trains list table is visible
    And I invoke the context menu from train '<trainUid>' on the trains list
    And I wait for the context menu to display
    When I open timetable from the context menu
    And I switch to the new tab
    Then The timetable entries contains the following data
      | location         | workingArrivalTime | workingDeptTime | publicArrivalTime  | publicDeptTime | originalAssetCode   | originalPathCode  | originalLineCode   | allowances | activities | arrivalDateTime | deptDateTime | assetCode | pathCode | lineCode | punctuality |
      | PADTON		       |       		          | 09:33:00	      |       	           | 	09:33:00      | 12	                | 	      		      | 4		               |       	    |   	TB     |       		       |      	      |      	    |          |	        |            	|
      | ROYAOJN		       |       		          | 09:34:00      	| 00:00:00           | 	00:00:00      | 		                | 	      		      | 4		               |       	    |   	       |       		       |      	      |      	    |          |	        |            	|
      | PRTOBJP		       |       		          | 09:35:00      	| 00:00:00           | 	00:00:00      | 		                | 	      		      | 4		               |       	    |   	       |       		       |      	      |      	    |          |	        |            	|
      | LDBRKJ		       |       		          | 09:36:00      	| 00:00:00           | 	00:00:00      |	                    | 	   4   		      | RL		             |       	    |   	       |       		       |      	      |      	    |          |	        |            	|
      | ACTONW		       |       		          | 09:39:30      	| 00:00:00           | 	00:00:00      | 		                | 	   RL  		      | RL		             |       	    |   	       |       		       |      	      |      	    |          |	        |            	|
      | EALINGB		       |	09:40:30          | 09:41:30    	  | 09:41:00           |	09:41:00      |	3     		          |		                | RL      	         |	(2.5)     | T	         |       		       |      	      |      	    |          |	        |            	|
      | STHALL		       |	09:48:30          | 09:49:30    	  | 09:49:00           |	09:49:00      |	3     		          |		                | RL      	         |		        | T	         |       		       |      	      |      	    |          |	        |            	|
      | HAYESAH		       |	09:52:30          | 09:53:30    	  | 09:53:00           |	09:53:00      |	3     		          |	   RL	            |		                 | T	        |	           |       		       |      	      |      	    |          |	        |            	|
      | HTRWAJN		       |		                | 09:54:00		    |	00:00:00           | 	00:00:00      |	      		          |      		          | RL		             |       	    |   	       |       		       |      	      |      	    |          |	        |            	|
      | WDRYTON		       |	09:56:30          | 09:57:00    	  |	09:57:00           |	09:57:00      |	3     		          |	   	              |		                 | T	        |	           |       		       |      	      |      	    |          |	        |            	|
      | IVER		         |	09:59:30          | 10:00:00	     	|	10:00:00           |	10:00:00      |	3     		          |	   	              |		                 | T	        |	           |       		       |      	      |      	    |          |	        |            	|
      | LANGLEY		       |	10:03:00          | 10:02:30	     	|	10:02:00           |	10:02:00      |	3     		          |	   	              |		                 | T	        |	           |       		       |      	      |      	    |          |	        |            	|
      | SLOUGH		       |	10:05:30          | 10:06:30	     	|	10:06:00           |	10:06:00      |	4     		          |	   RL	            |		                 | T	        |	           |       		       |      	      |      	    |          |	        |            	|
      | BNHAM		         |	10:09:30          | 10:10:00	     	|	10:10:00           |	10:10:00      |	1     		          |	   	              |		                 | T	        |	           |       		       |      	      |      	    |          |	        |            	|
      | TAPLOW		       |	10:12:30          | 10:13:00	     	|	10:13:00           |	10:13:00      |	3     		          |	   	              |		                 | T	        |	           |       		       |      	      |      	    |          |	        |            	|
      | MDNHEAD		       |	10:15:30          | 10:16:30	     	|	10:16:00           |	10:16:00      |	3     		          |	   RL	            |		                 | T	        |	           |       		       |      	      |      	    |          |	        |            	|
      | TWYFORD		       |	10:22:30          | 10:23:30	     	|	10:23:00           |	10:23:00      |	3     		          |	   RL	            | [1]		             | T	        |	           |       		       |      	      |      	    |          |	        |            	|
      | RDNGKBJ		       |		                | 10:28:30		    |	00:00:00           |  00:00:00      |	     		            |	   DRL	          | 		               | 		        |	           |       		       |      	      |      	    |          |	        |            	|
      | RDNGSTN		       |	10:31:00          |		              |	10:31:00           |  00:00:00      |	14    		          |	   	              | 		               | 		        |	 TF        |       		       |      	      |      	    |          |	        |            	|
    Examples:
      | fileName                                        | trainUid  |
      | access-plan/schedules_BS_type_P.cif             | A12145    |
      | access-plan/schedules_BS_type_N.cif             | A12245    |
      | access-plan/schedules_BS_type_O.cif             | A12345    |

  Scenario: 37657-10 Schedule associations are displayed
    # Given schedule(s) has been received with <STP indicator> that applies to the current time period (Date Runs To, Date Runs From and Days Run don't exclude it)
    # When a user views that timetable
    # Then the associations displayed match those provided in the CIF
    Given the access plan located in CIF file 'access-plan/schedules_BS_type_P.cif' is received from LINX
    And I am on the trains list page
    And The trains list table is visible
    And I invoke the context menu from train '1D46' on the trains list
    And I wait for the context menu to display
    And I open timetable from the context menu
    And I switch to the new tab
    When I switch to the timetable details tab
    Then The timetable details tab is visible
    Then The entry 1 of the timetable associations table contains the following data in each column
      | Location            | Type                 | TrainDescription   |
      | Paddington          | Previous Working     | 1D46               |

  @tdd
  Scenario: 37657-11 Schedule change en route are displayed
    # Given schedule(s) has been received with <STP indicator> that applies to the current time period (Date Runs To, Date Runs From and Days Run don't exclude it)
    # When a user views that timetable
    # Then the change en route displayed match those provided in the CIF
    Given the access plan located in CIF file 'access-plan/1D46_PADTON_OXFD.cif' is received from LINX
    And I am on the trains list page
    And The trains list table is visible
    And I invoke the context menu from train '1D46' on the trains list
    And I wait for the context menu to display
    And I open timetable from the context menu
    And I switch to the new tab
    When I switch to the timetable details tab
    Then The timetable details tab is visible
    And The entry of the change en route table contains the following data
      | columnName  |
      | ACTONW      |
      | DMU         |
      | 811         |
      | 144mph      |
      | D           |
