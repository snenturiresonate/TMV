Feature: Example Scenarios
  Navigate to the homepage and recieve LINX messages

  Scenario: Example - Receive berth interpose message from LINX
    Given I am on the home page
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth | trainDescriber| trainDescription |
      | 10:02:06  | 0246    | D4            | 1G65             |
    Then I should see nothing

  Scenario: Example - Receive berth step message from LINX
    Given I am on the home page
    When the following berth step message is sent from LINX
      | fromBerth | timestamp | toBerth| trainDescriber | trainDescription |
      | S307      | 10:02:06  | S308   | D4             | 1G65             |
    Then I should see nothing

  Scenario: Example - Receive berth cancel message from LINX
    Given I am on the home page
    When the following berth cancel message is sent from LINX
      | fromBerth | timestamp | trainDescriber | trainDescription |
      | S308      | 10:02:06  | D4             | 1G65             |
    Then I should see nothing

  Scenario: Example - Receive heartbeat message from LINX
    Given I am on the home page
    When the following heartbeat message is sent from LINX
      | timestamp | trainDescriber | trainDescriberTimestamp |
      | 10:02:06  | D4             | 10:02:06                |
    Then I should see nothing

  Scenario: Example - Receive train journey modification message from LINX
    Given I am on the home page
    When the following train journey modification message is sent from LINX
      | asXml |
      | <?xml version="1.0" encoding="UTF-8"?><TrainJourneyModificationMessage xmlns="http://www.era.europa.eu/schemes/TAFTSI/5.3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:n1="http://www.era.europa.eu/schemes/TAFTSI/5.3" xsi:schemaLocation="http://www.era.europa.eu/schemes/TAFTSI/5.3 taf_cat_complete.xsd"><MessageHeader><MessageReference><MessageType>9004</MessageType><MessageTypeVersion>5.3.1.GB</MessageTypeVersion><MessageIdentifier>414d51204e52504230303920202020205e81b4b92f578dea</MessageIdentifier><MessageDateTime>2020-04-07T23:35:04-00:00</MessageDateTime></MessageReference><SenderReference>6M157-TV277J,4M157-TV277J</SenderReference><Sender n1:CI_InstanceNumber="01">0070</Sender><Recipient n1:CI_InstanceNumber="99">0070</Recipient></MessageHeader><MessageStatus>1</MessageStatus><TrainOperationalIdentification><TransportOperationalIdentifiers><ObjectType>TR</ObjectType><Company>0070</Company><Core>--176M15C308</Core><Variant>01</Variant><TimetableYear>2020</TimetableYear><StartDate>2020-04-08</StartDate></TransportOperationalIdentifiers></TrainOperationalIdentification><OperationalTrainNumberIdentifier><OperationalTrainNumber>4M15</OperationalTrainNumber></OperationalTrainNumberIdentifier><ReferenceOTN><OperationalTrainNumberIdentifier><OperationalTrainNumber>6M15</OperationalTrainNumber></OperationalTrainNumberIdentifier></ReferenceOTN><TrainJourneyModification><TrainJourneyModificationIndicator>07</TrainJourneyModificationIndicator><LocationModified><Location><CountryCodeISO>GB</CountryCodeISO><LocationPrimaryCode>99999</LocationPrimaryCode></Location><ModificationStatusIndicator>07</ModificationStatusIndicator></LocationModified></TrainJourneyModification><TrainJourneyModificationTime>2020-04-08T00:35:00-00:00</TrainJourneyModificationTime></TrainJourneyModificationMessage> |
    Then I should see nothing

  Scenario: Example - Receive train journey modification change of ID message from LINX
    Given I am on the home page
    When the following train journey modification change of id message is sent from LINX
      | asXml |
      | </exampleNeeded> |
    Then I should see nothing

  Scenario: Example - Receive train activation message from LINX
    Given I am on the home page
    When the following train activation message is sent from LINX
      | asXml |
      | </exampleNeeded> |
    Then I should see nothing

  Scenario: Example - Receive VSTP message from LINX
    Given I am on the home page
    When the following VSTP messages are sent from LINX
      | asXml |
      | <?xml version="1.0"?><VSTPCIFMsgV1 xmlns="http://xml.networkrail.co.uk/ns/2008/Train" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:eai="http://xml.networkrail.co.uk/ns/2008/EAI" classification="industry" timestamp="2020-04-08T02:01:19-00:00" owner="Network Rail" originMsgId="2020-04-08T02:01:19-00:00@vstp.networkrail.co.uk"><eai:Sender organisation="Network Rail" application="TSIA" component="TSIA" userID="#QDP0255" sessionID="CU75900"/><schedule schedule_id="" transaction_type="Create" schedule_start_date="20200408" schedule_end_date="20200408" schedule_days_runs="0010000" applicable_timetable="N" CIF_bank_holiday_running="" CIF_train_uid=" 11845" train_status="2" CIF_stp_indicator="N"><schedule_segment signalling_id="6A29" uic_code="" atoc_code="" CIF_train_category="B4" CIF_headcode="" CIF_course_indicator="" CIF_train_service_code="57622972" CIF_business_sector="" CIF_power_type="D" CIF_timing_load="" CIF_speed="" CIF_operating_characteristics="" CIF_train_class="" CIF_sleepers="" CIF_reservations="" CIF_connection_indicator="" CIF_catering_code="" CIF_service_branding="" CIF_traction_class=""><schedule_location scheduled_arrival_time=" " scheduled_departure_time="025100" scheduled_pass_time=" " public_arrival_time=" " public_departure_time="      " CIF_platform="" CIF_line="" CIF_path=" " CIF_activity="TB" CIF_engineering_allowance="" CIF_pathing_allowance="3" CIF_performance_allowance=""><location><tiploc tiploc_id="WHATFHH"/></location></schedule_location><schedule_location scheduled_arrival_time="      " scheduled_departure_time="      " scheduled_pass_time="031200" public_arrival_time="      " public_departure_time="      " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""><location><tiploc tiploc_id="FROMNSB"/></location></schedule_location><schedule_location scheduled_arrival_time="      " scheduled_departure_time="      " scheduled_pass_time="031500" public_arrival_time="      " public_departure_time="      " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="1" CIF_pathing_allowance="" CIF_performance_allowance=""><location><tiploc tiploc_id="CLNKRDJ"/></location></schedule_location><schedule_location scheduled_arrival_time="      " scheduled_departure_time="      " scheduled_pass_time="032100" public_arrival_time="      " public_departure_time="      " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="5" CIF_performance_allowance=""><location><tiploc tiploc_id="FRWDJN"/></location></schedule_location><schedule_location scheduled_arrival_time="033000" scheduled_departure_time="033200" scheduled_pass_time="      " public_arrival_time="      " public_departure_time="      " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""><location><tiploc tiploc_id="WSTBRYW"/></location></schedule_location><schedule_location scheduled_arrival_time="      " scheduled_departure_time="      " scheduled_pass_time="033530" public_arrival_time="      " public_departure_time="      " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""><location><tiploc tiploc_id="HWKRJN"/></location></schedule_location><schedule_location scheduled_arrival_time="      " scheduled_departure_time="      " scheduled_pass_time="034230" public_arrival_time="      " public_departure_time="      " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""><location><tiploc tiploc_id="BRDFDJN"/></location></schedule_location><schedule_location scheduled_arrival_time="      " scheduled_departure_time="      " scheduled_pass_time="040130" public_arrival_time="      " public_departure_time="      " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""><location><tiploc tiploc_id="THNGLYJ"/></location></schedule_location><schedule_location scheduled_arrival_time="      " scheduled_departure_time="      " scheduled_pass_time="040230" public_arrival_time="      " public_departure_time="      " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""><location><tiploc tiploc_id="THNGLEJ"/></location></schedule_location><schedule_location scheduled_arrival_time="      " scheduled_departure_time="      " scheduled_pass_time="040530" public_arrival_time="      " public_departure_time="      " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""><location><tiploc tiploc_id="CHIPNHM"/></location></schedule_location><schedule_location scheduled_arrival_time="      " scheduled_departure_time="      " scheduled_pass_time="042900" public_arrival_time="      " public_departure_time="      " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""><location><tiploc tiploc_id="WTNBSTJ"/></location></schedule_location><schedule_location scheduled_arrival_time="      " scheduled_departure_time="      " scheduled_pass_time="044100" public_arrival_time="      " public_departure_time="      " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""><location><tiploc tiploc_id="SDON"/></location></schedule_location><schedule_location scheduled_arrival_time="      " scheduled_departure_time="      " scheduled_pass_time="045400" public_arrival_time="      " public_departure_time="      " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""><location><tiploc tiploc_id="UFNGTN"/></location></schedule_location><schedule_location scheduled_arrival_time="      " scheduled_departure_time="      " scheduled_pass_time="045630" public_arrival_time="      " public_departure_time="      " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""><location><tiploc tiploc_id="CHALLOW"/></location></schedule_location><schedule_location scheduled_arrival_time="      " scheduled_departure_time="      " scheduled_pass_time="050130" public_arrival_time="      " public_departure_time="      " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""><location><tiploc tiploc_id="WANTRD"/></location></schedule_location><schedule_location scheduled_arrival_time="      " scheduled_departure_time="      " scheduled_pass_time="051200" public_arrival_time="      " public_departure_time="      " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""><location><tiploc tiploc_id="FOXHALJ"/></location></schedule_location><schedule_location scheduled_arrival_time="      " scheduled_departure_time="      " scheduled_pass_time="051300" public_arrival_time="      " public_departure_time="      " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""><location><tiploc tiploc_id="DIDCOTP"/></location></schedule_location><schedule_location scheduled_arrival_time="      " scheduled_departure_time="      " scheduled_pass_time="051400" public_arrival_time="      " public_departure_time="      " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""><location><tiploc tiploc_id="DIDCTEJ"/></location></schedule_location><schedule_location scheduled_arrival_time="      " scheduled_departure_time="      " scheduled_pass_time="052330" public_arrival_time="      " public_departure_time="      " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""><location><tiploc tiploc_id="GORASTR"/></location></schedule_location><schedule_location scheduled_arrival_time="      " scheduled_departure_time="      " scheduled_pass_time="053400" public_arrival_time="      " public_departure_time="      " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""><location><tiploc tiploc_id="REDGWJN"/></location></schedule_location><schedule_location scheduled_arrival_time="      " scheduled_departure_time="      " scheduled_pass_time="053600" public_arrival_time="      " public_departure_time="      " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""><location><tiploc tiploc_id="RDNGORJ"/></location></schedule_location><schedule_location scheduled_arrival_time="      " scheduled_departure_time="      " scheduled_pass_time="053900" public_arrival_time="      " public_departure_time="      " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""><location><tiploc tiploc_id="SCOTEJN"/></location></schedule_location><schedule_location scheduled_arrival_time="      " scheduled_departure_time="      " scheduled_pass_time="054500" public_arrival_time="      " public_departure_time="      " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""><location><tiploc tiploc_id="THEA831"/></location></schedule_location><schedule_location scheduled_arrival_time="054900" scheduled_departure_time="060900" scheduled_pass_time="      " public_arrival_time="      " public_departure_time="      " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""><location><tiploc tiploc_id="THEARCP"/></location></schedule_location><schedule_location scheduled_arrival_time="063900" scheduled_departure_time=" " scheduled_pass_time=" " public_arrival_time="      " public_departure_time=" " CIF_platform="" CIF_line=" " CIF_path="" CIF_activity="TF" CIF_engineering_allowance=" " CIF_pathing_allowance=" " CIF_performance_allowance=" "><location><tiploc tiploc_id="THEAARC"/></location></schedule_location></schedule_segment></schedule></VSTPCIFMsgV1> |
      | <?xml version="1.0"?><VSTPCIFMsgV1 xmlns="http://xml.networkrail.co.uk/ns/2008/Train" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:eai="http://xml.networkrail.co.uk/ns/2008/EAI" classification="industry" timestamp="2020-04-08T02:20:26-00:00" owner="Network Rail" originMsgId="2020-04-08T02:20:26-00:00@vstp.networkrail.co.uk"><eai:Sender organisation="Network Rail" application="TSIA" component="TSIA" userID="#QRP0009" sessionID="CC03700"/><schedule schedule_id="" transaction_type="Create" schedule_start_date="20200408" schedule_end_date="20200408" schedule_days_runs="0010000" applicable_timetable="N" CIF_bank_holiday_running="" CIF_train_uid=" 11846" train_status="2" CIF_stp_indicator="N"><schedule_segment signalling_id="6F09" uic_code="" atoc_code="" CIF_train_category="E0" CIF_headcode="" CIF_course_indicator="" CIF_train_service_code="56461882" CIF_business_sector="" CIF_power_type="D" CIF_timing_load="" CIF_speed="" CIF_operating_characteristics="" CIF_train_class="" CIF_sleepers="" CIF_reservations="" CIF_connection_indicator="" CIF_catering_code="" CIF_service_branding="" CIF_traction_class=""><schedule_location scheduled_arrival_time=" " scheduled_departure_time="061500" scheduled_pass_time=" " public_arrival_time=" " public_departure_time="      " CIF_platform="" CIF_line="" CIF_path=" " CIF_activity="TB" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""><location><tiploc tiploc_id="LVRPGBF"/></location></schedule_location><schedule_location scheduled_arrival_time="062500" scheduled_departure_time="062700" scheduled_pass_time="      " public_arrival_time="      " public_departure_time="      " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""><location><tiploc tiploc_id="RGNTSRX"/></location></schedule_location><schedule_location scheduled_arrival_time="      " scheduled_departure_time="      " scheduled_pass_time="063100" public_arrival_time="      " public_departure_time="      " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""><location><tiploc tiploc_id="BOOTLEJ"/></location></schedule_location><schedule_location scheduled_arrival_time="      " scheduled_departure_time="      " scheduled_pass_time="064600" public_arrival_time="      " public_departure_time="      " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""><location><tiploc tiploc_id="EDGELAJ"/></location></schedule_location><schedule_location scheduled_arrival_time="      " scheduled_departure_time="      " scheduled_pass_time="064800" public_arrival_time="      " public_departure_time="      " CIF_platform="" CIF_line="" CIF_path="" CIF_activity="" CIF_engineering_allowance="" CIF_pathing_allowance="" CIF_performance_allowance=""><location><tiploc tiploc_id="BOOTLBJ"/></location></schedule_location><schedule_location scheduled_arrival_time="065100" scheduled_departure_time=" " scheduled_pass_time=" " public_arrival_time="      " public_departure_time=" " CIF_platform="" CIF_line=" " CIF_path="" CIF_activity="TF" CIF_engineering_allowance=" " CIF_pathing_allowance=" " CIF_performance_allowance=" "><location><tiploc tiploc_id="TUEBGBF"/></location></schedule_location></schedule_segment></schedule></VSTPCIFMsgV1>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
    Then I should see nothing

  Scenario: Example - Receive train running information message from LINX
    Given I am on the home page
    When the following train running information message is sent from LINX
      | asXml |
      | <?xml version="1.0" encoding="UTF-8"?><TrainRunningInformationMessage xmlns="http://www.era.europa.eu/schemes/TAFTSI/5.3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:n1="http://www.era.europa.eu/schemes/TAFTSI/5.3" xsi:schemaLocation="http://www.era.europa.eu/schemes/TAFTSI/5.3 taf_cat_complete.xsd"><MessageHeader><MessageReference><MessageType>4005</MessageType><MessageTypeVersion>5.3.1.GB</MessageTypeVersion><MessageIdentifier>414d51204e52504230303920202020205e81b4b92f5227f2</MessageIdentifier><MessageDateTime>2020-04-07T23:00:03-00:00</MessageDateTime></MessageReference><SenderReference>9H74aA2cM67J</SenderReference><Sender n1:CI_InstanceNumber="01">0070</Sender><Recipient n1:CI_InstanceNumber="99">9999</Recipient></MessageHeader><MessageStatus>1</MessageStatus><TrainOperationalIdentification><TransportOperationalIdentifiers><ObjectType>TR</ObjectType><Company>0070</Company><Core>--879H741907</Core><Variant>01</Variant><TimetableYear>2020</TimetableYear><StartDate>2020-04-07</StartDate></TransportOperationalIdentifiers></TrainOperationalIdentification><OperationalTrainNumberIdentifier><OperationalTrainNumber>9H74</OperationalTrainNumber></OperationalTrainNumberIdentifier><ResponsibleRU>9930</ResponsibleRU><TrainLocationReport><Location><CountryCodeISO>GB</CountryCodeISO><LocationPrimaryCode>53013</LocationPrimaryCode><LocationSubsidiaryIdentification><LocationSubsidiaryCode n1:LocationSubsidiaryTypeCode="0">CFTNRJN</LocationSubsidiaryCode><AllocationCompany>0070</AllocationCompany></LocationSubsidiaryIdentification></Location><LocationDateTime>2020-04-08T00:00:00-00:00</LocationDateTime><TrainLocationStatus>04</TrainLocationStatus><BookedLocationDateTime>2020-04-07T23:59:30-00:00</BookedLocationDateTime><TrainDelay><AgainstBooked>+0001</AgainstBooked></TrainDelay></TrainLocationReport></TrainRunningInformationMessage> |
    Then I should see nothing

  Scenario: Example - Receive access plan from JSON file example
    Given I am on the home page
    When the access plan located in JSON file 'e2e/testdata/access-plan/one-schedule.json' is received from LINX
    Then I should see nothing

  Scenario: Example - Receive access plan from CIF file example
    Given I am on the home page
    When the access plan located in CIF file 'e2e/testdata/access-plan/one-schedule.cif' is received from LINX with name 'CFR1LXB.LCF'
    Then I should see nothing
