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

  Scenario: 33806 -37 Trains List Config (TRUST IDs Applied)
  #Given the user has made changes to the TRUST ID settings
  #When the user views the trains list
  #Then the view is updated to reflect the user's TRUST ID changes
    Given the access plan located in CIF file 'access-plan/trains_list_test.cif' is amended so that all services start within the next hour and then received from LINX
    And the access plan located in CIF file 'access-plan/1D46_PADTON_OXFD.cif' is amended so that all services start within the next hour and then received from LINX
    And the access plan located in CIF file 'access-plan/1S42_PADTON_DIDCOTP.cif' is amended so that all services start within the next hour and then received from LINX
    And the following VSTP update messages are sent from LINX
      | asXml                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | <?xml version="1.0"?> <VSTPCIFMsgV1 xmlns="http://xml.networkrail.co.uk/ns/2008/Train" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:eai="http://xml.networkrail.co.uk/ns/2008/EAI" classification="industry" timestamp="2020-02-24T12:10:09-00:00" owner="Network Rail" originMsgId="2020-02-24T12:10:09-00:00@vstp.networkrail.co.uk"> <eai:Sender organisation="Network Rail" application="TSIA" component="TSIA" userID="#QBP0058" sessionID="FX06000"/> <schedule schedule_id="" transaction_type="Create" schedule_start_date="20200225" schedule_end_date="20220225" schedule_days_runs="1111111" applicable_timetable="Y" CIF_bank_holiday_running="" CIF_train_uid="V95541" train_status="1" CIF_stp_indicator="N"> <schedule_segment signalling_id="1B25" uic_code="" atoc_code="" CIF_train_category="EE" CIF_headcode="" CIF_course_indicator="" CIF_train_service_code="22216001" CIF_business_sector="" CIF_power_type="EMU" CIF_timing_load="" CIF_speed="" CIF_operating_characteristics="" CIF_train_class="" CIF_sleepers="" CIF_reservations="" CIF_connection_indicator="" CIF_catering_code="" CIF_service_branding="" CIF_traction_class=""> <schedule_location scheduled_arrival_time=" " scheduled_departure_time="234500" scheduled_pass_time=" " public_arrival_time=" " public_departure_time=" " CIF_platform="" CIF_line="" CIF_path=" " CIF_activity="TB" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""> <location> <tiploc tiploc_id="WCROYDN"/> </location> </schedule_location> <schedule_location scheduled_arrival_time="234630" scheduled_departure_time="235200" scheduled_pass_time=" " public_arrival_time=" " public_departure_time=" " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""> <location> <tiploc tiploc_id="WCROYTB"/> </location> </schedule_location> <schedule_location scheduled_arrival_time="235330" scheduled_departure_time="235600" scheduled_pass_time=" " public_arrival_time=" " public_departure_time=" " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""> <location> <tiploc tiploc_id="WCROYDN"/> </location> </schedule_location> <schedule_location scheduled_arrival_time=" " scheduled_departure_time=" " scheduled_pass_time="235830" public_arrival_time=" " public_departure_time=" " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="1" CIF_performance_allowance=""> <location> <tiploc tiploc_id="SELHGRJ"/> </location> </schedule_location> <schedule_location scheduled_arrival_time=" " scheduled_departure_time=" " scheduled_pass_time="000130" public_arrival_time=" " public_departure_time=" " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""> <location> <tiploc tiploc_id="NORWDJ"/> </location> </schedule_location> <schedule_location scheduled_arrival_time=" " scheduled_departure_time=" " scheduled_pass_time="000430" public_arrival_time=" " public_departure_time=" " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="2H" CIF_performance_allowance=""> <location> <tiploc tiploc_id="SYDENHM"/> </location> </schedule_location> <schedule_location scheduled_arrival_time=" " scheduled_departure_time=" " scheduled_pass_time="001100" public_arrival_time=" " public_departure_time=" " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="1" CIF_performance_allowance=""> <location> <tiploc tiploc_id="NEWXGTE"/> </location> </schedule_location> <schedule_location scheduled_arrival_time=" " scheduled_departure_time=" " scheduled_pass_time="001400" public_arrival_time=" " public_departure_time=" " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="1" CIF_performance_allowance=""> <location> <tiploc tiploc_id="CANALJ"/> </location> </schedule_location> <schedule_location scheduled_arrival_time=" " scheduled_departure_time=" " scheduled_pass_time="001600" public_arrival_time=" " public_departure_time=" " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="1" CIF_performance_allowance=""> <location> <tiploc tiploc_id="SURRQSJ"/> </location> </schedule_location> <schedule_location scheduled_arrival_time=" " scheduled_departure_time=" " scheduled_pass_time="001800" public_arrival_time=" " public_departure_time=" " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="2" CIF_performance_allowance=""> <location> <tiploc tiploc_id="CNDAW"/> </location> </schedule_location> <schedule_location scheduled_arrival_time=" " scheduled_departure_time=" " scheduled_pass_time="002200" public_arrival_time=" " public_departure_time=" " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="7" CIF_performance_allowance=""> <location> <tiploc tiploc_id="SHADWEL"/> </location> </schedule_location> <schedule_location scheduled_arrival_time=" " scheduled_departure_time=" " scheduled_pass_time="003300" public_arrival_time=" " public_departure_time=" " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""> <location> <tiploc tiploc_id="HAGGERS"/> </location> </schedule_location> <schedule_location scheduled_arrival_time="003400" scheduled_departure_time="004000" scheduled_pass_time=" " public_arrival_time=" " public_departure_time=" " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""> <location> <tiploc tiploc_id="DALS"/> </location> </schedule_location> <schedule_location scheduled_arrival_time=" " scheduled_departure_time=" " scheduled_pass_time="004700" public_arrival_time=" " public_departure_time=" " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""> <location> <tiploc tiploc_id="HAGGERS"/> </location> </schedule_location> <schedule_location scheduled_arrival_time=" " scheduled_departure_time=" " scheduled_pass_time="005400" public_arrival_time=" " public_departure_time=" " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""> <location> <tiploc tiploc_id="SHADWEL"/> </location> </schedule_location> <schedule_location scheduled_arrival_time=" " scheduled_departure_time=" " scheduled_pass_time="005800" public_arrival_time=" " public_departure_time=" " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""> <location> <tiploc tiploc_id="CNDAW"/> </location> </schedule_location> <schedule_location scheduled_arrival_time=" " scheduled_departure_time=" " scheduled_pass_time="010000" public_arrival_time=" " public_departure_time=" " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""> <location> <tiploc tiploc_id="SURRQSJ"/> </location> </schedule_location> <schedule_location scheduled_arrival_time=" " scheduled_departure_time=" " scheduled_pass_time="010200" public_arrival_time=" " public_departure_time=" " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""> <location> <tiploc tiploc_id="CANALJ"/> </location> </schedule_location> <schedule_location scheduled_arrival_time="010700" scheduled_departure_time=" " scheduled_pass_time=" " public_arrival_time=" " public_departure_time=" " CIF_platform="" CIF_line=" " CIF_path="" CIF_activity="TF" CIF_engineering_allowance=" " CIF_pathing_allowance=" " CIF_performance_allowance=" "> <location> <tiploc tiploc_id="NEWXCSD"/> </location> </schedule_location> </schedule_segment> </schedule> </VSTPCIFMsgV1> |
    When the following train running information message is sent from LINX
      | trainUID | trainNumber | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType           |
      | V95541   | 1B25        | today              | 15220               | WCROYDN                | Departure from Origin |
    And I click the clear all button for TRUST Service Filter
    And I input '1B25V95541' in the TRUST input field
    And I click the add button for TRUST Service Filter
    And I save the service filter changes for Trust Id
    And I open 'trains list' page in a new tab
    Then I should see the trains list table to only display train description 'IB25'

