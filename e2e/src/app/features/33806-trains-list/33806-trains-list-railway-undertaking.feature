@newSession
Feature: 33806 - TMV User Preferences - full end to end testing - TL config - railway undertaking

  As a tester
  I want to verify the train list config tab - TOC/FOC
  So, that I can identify if the build meets the end to end requirements

  Background:
    * I remove all trains from the trains list
    * I am on the home page
    * I restore to default train list config '1'
    * I am on the trains list page 1
    * I have navigated to the 'TOC/FOC' configuration tab

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

  Scenario: 33806 -11c Trains list railway undertaking config tab - default selected and unselected entries
    Then the following can be seen on the unselected railway undertaking config
      | unSelectedColumn                    | arrowType            |
      | ARRIVA CROSSCOUNTRY TRAINS (EH)     | keyboard_arrow_right |
      | SOUTH WESTERN RAILWAY (HY)          | keyboard_arrow_right |
      | ON ROUTE LOGISTICS (UK) (PM)        | keyboard_arrow_right |
      | AMEY (RE)                           | keyboard_arrow_right |
      | SB (SWIETELSKY BABCOCK)RAIL (RD)    | keyboard_arrow_right |
      | FREIGHT EUROPE (PN)                 | keyboard_arrow_right |
      | DRS-DIRECT RAIL SVCS (XH)           | keyboard_arrow_right |
      | TRANSPENNINE EXPRESS (FTPE) (EA)    | keyboard_arrow_right |
      | EAST MIDLANDS RAILWAY (EM)          | keyboard_arrow_right |
      | LEGGE INFRASTRUCTURE SERVICES (LG)  | keyboard_arrow_right |
      | c2c RAIL (HT)                       | keyboard_arrow_right |
      | NETWORK RAIL OTM (LR)               | keyboard_arrow_right |
      | LORAM (LC)                          | keyboard_arrow_right |
      | EUROPORTE CHANNEL (PT)              | keyboard_arrow_right |
      | VINTAGE TRAINS (TY)                 | keyboard_arrow_right |
      | DB CARGO CHARTERS (WA)              | keyboard_arrow_right |
      | Govia Thameslink Railway (ET)       | keyboard_arrow_right |
      | FREIGHTLINER (DB)                   | keyboard_arrow_right |
      | LUL BAKERLOO (XC)                   | keyboard_arrow_right |
      | DEVON AND CORNWALL RAILWAYS (PO)    | keyboard_arrow_right |
      | SOUTH YORKSHIRE SUPERTRAM (SJ)      | keyboard_arrow_right |
      | LOCOMOTIVE SERVICES (LS)            | keyboard_arrow_right |
      | HEATHROW EXPRESS (HM)               | keyboard_arrow_right |
      | NETWORKRAIL VIRTUAL FREIGHT CO (QJ) | keyboard_arrow_right |
      | EUROSTAR INTL (GA)                  | keyboard_arrow_right |
      | GB RAILFREIGHT (PE)                 | keyboard_arrow_right |
      | Serco Caledonian Sleeper Ltd (ES)   | keyboard_arrow_right |
      | TfL RAIL (formerly Crossrail) (EX)  | keyboard_arrow_right |
      | SECO RAIL (RU)                      | keyboard_arrow_right |
      | TRANSPORT FOR WALES (HL)            | keyboard_arrow_right |
      | HEATHROW CONNECT (EE)               | keyboard_arrow_right |
      | CHILTERN RAILWAY (HO)               | keyboard_arrow_right |
      | COLAS RAIL (RG)                     | keyboard_arrow_right |
      | SNCF FREIGHT SERVICES (PS)          | keyboard_arrow_right |
      | SOUTHEASTERN (HU)                   | keyboard_arrow_right |
      | AVANTI WEST COAST (HF)              | keyboard_arrow_right |
      | LONDON NORTHEASTERN RAILWAY (HB)    | keyboard_arrow_right |
      | GRAND CENTRAL (EC)                  | keyboard_arrow_right |
      | Rail Operations Group (PH)          | keyboard_arrow_right |
      | LUL DISTRICT (WIMBLEDON) (XB)       | keyboard_arrow_right |
      | NORTHERN TRAINS LTD. (ED)           | keyboard_arrow_right |
      | SERCO Railtest (SD)                 | keyboard_arrow_right |
      | FFESTINIOG RAILWAY (XJ)             | keyboard_arrow_right |
      | Swanage Railway (SG)                | keyboard_arrow_right |
      | WEST COAST RAILWAY CO (PA)          | keyboard_arrow_right |
      | NORTH YORKSHIRE MOORS RAILWAY (PR)  | keyboard_arrow_right |
      | BALFOUR BEATTY RAIL PLANT (RZ)      | keyboard_arrow_right |
      | GREATER ANGLIA (ABELLIO GA) (EB)    | keyboard_arrow_right |
      | EAST COAST TRAINS LIMITED (LD)      | keyboard_arrow_right |
      | CARILLION RAIL CTRL PHASE 1 (RQ)    | keyboard_arrow_right |
      | PRE METRO OPERATIONS (PK)           | keyboard_arrow_right |
      | LUL DISTRICT (RICHMOND) (XE)        | keyboard_arrow_right |
      | ARRIVA RAIL LONDON (EK)             | keyboard_arrow_right |
      | CARILLON RAIL (FORMERLY GTRM) (RB)  | keyboard_arrow_right |
      | VOLKERRAIL (RH)                     | keyboard_arrow_right |
      | HULL TRAINS (PF)                    | keyboard_arrow_right |
      | JSD Research & Development Ltd (RR) | keyboard_arrow_right |
      | ISLAND LINES (HZ)                   | keyboard_arrow_right |
      | MERSEYRAIL ELECTRICS (HE)           | keyboard_arrow_right |
      | VICTA RAIL (PV)                     | keyboard_arrow_right |
      | HARSCO (RT)                         | keyboard_arrow_right |
      | NR RESERVED PATHINGS (NON QJ) (NR)  | keyboard_arrow_right |
      | TYNE AND WEAR METRO (PG)            | keyboard_arrow_right |
      | WEST MIDLANDS TRAINS (EJ)           | keyboard_arrow_right |
      | GREAT WESTERN RAILWAY (EF)          | keyboard_arrow_right |
      | SCOTRAIL (HA)                       | keyboard_arrow_right |
      | SLC OPERATIONS LIMITED (SO)         | keyboard_arrow_right |
      | GCNW (LN)                           | keyboard_arrow_right |
    Then the following appear in the selected railway undertaking config
      |selectedColumn                   |
      |                                 |

  Scenario: 33806 -11d Moving all unselected items to selected column
    When I click on all the unselected railway undertaking entries
    Then the following appear in the selected railway undertaking config
      | selectedColumn                      |
      | ARRIVA CROSSCOUNTRY TRAINS (EH)     |
      | SOUTH WESTERN RAILWAY (HY)          |
      | ON ROUTE LOGISTICS (UK) (PM)        |
      | AMEY (RE)                           |
      | SB (SWIETELSKY BABCOCK)RAIL (RD)    |
      | FREIGHT EUROPE (PN)                 |
      | DRS-DIRECT RAIL SVCS (XH)           |
      | TRANSPENNINE EXPRESS (FTPE) (EA)    |
      | EAST MIDLANDS RAILWAY (EM)          |
      | LEGGE INFRASTRUCTURE SERVICES (LG)  |
      | c2c RAIL (HT)                       |
      | NETWORK RAIL OTM (LR)               |
      | LORAM (LC)                          |
      | EUROPORTE CHANNEL (PT)              |
      | VINTAGE TRAINS (TY)                 |
      | DB CARGO CHARTERS (WA)              |
      | Govia Thameslink Railway (ET)       |
      | FREIGHTLINER (DB)                   |
      | LUL BAKERLOO (XC)                   |
      | DEVON AND CORNWALL RAILWAYS (PO)    |
      | SOUTH YORKSHIRE SUPERTRAM (SJ)      |
      | LOCOMOTIVE SERVICES (LS)            |
      | HEATHROW EXPRESS (HM)               |
      | NETWORKRAIL VIRTUAL FREIGHT CO (QJ) |
      | EUROSTAR INTL (GA)                  |
      | GB RAILFREIGHT (PE)                 |
      | Serco Caledonian Sleeper Ltd (ES)   |
      | TfL RAIL (formerly Crossrail) (EX)  |
      | SECO RAIL (RU)                      |
      | TRANSPORT FOR WALES (HL)            |
      | HEATHROW CONNECT (EE)               |
      | CHILTERN RAILWAY (HO)               |
      | COLAS RAIL (RG)                     |
      | SNCF FREIGHT SERVICES (PS)          |
      | SOUTHEASTERN (HU)                   |
      | AVANTI WEST COAST (HF)              |
      | LONDON NORTHEASTERN RAILWAY (HB)    |
      | GRAND CENTRAL (EC)                  |
      | Rail Operations Group (PH)          |
      | LUL DISTRICT (WIMBLEDON) (XB)       |
      | NORTHERN TRAINS LTD. (ED)           |
      | SERCO Railtest (SD)                 |
      | FFESTINIOG RAILWAY (XJ)             |
      | Swanage Railway (SG)                |
      | WEST COAST RAILWAY CO (PA)          |
      | NORTH YORKSHIRE MOORS RAILWAY (PR)  |
      | BALFOUR BEATTY RAIL PLANT (RZ)      |
      | GREATER ANGLIA (ABELLIO GA) (EB)    |
      | EAST COAST TRAINS LIMITED (LD)      |
      | CARILLION RAIL CTRL PHASE 1 (RQ)    |
      | PRE METRO OPERATIONS (PK)           |
      | LUL DISTRICT (RICHMOND) (XE)        |
      | ARRIVA RAIL LONDON (EK)             |
      | CARILLON RAIL (FORMERLY GTRM) (RB)  |
      | VOLKERRAIL (RH)                     |
      | HULL TRAINS (PF)                    |
      | JSD Research & Development Ltd (RR) |
      | ISLAND LINES (HZ)                   |
      | MERSEYRAIL ELECTRICS (HE)           |
      | VICTA RAIL (PV)                     |
      | HARSCO (RT)                         |
      | NR RESERVED PATHINGS (NON QJ) (NR)  |
      | TYNE AND WEAR METRO (PG)            |
      | WEST MIDLANDS TRAINS (EJ)           |
      | GREAT WESTERN RAILWAY (EF)          |
      | SCOTRAIL (HA)                       |
      | SLC OPERATIONS LIMITED (SO)         |
      | GCNW (LN)                           |

  #33806 -12 Trains List Config (TOC/FOC De-Selection)
    #Given the user is viewing the trains list config
    #And the user is viewing the TOC/FOC config tab
    #When the user selects a TOC/FOC from selected TOC/FOC list to remove from the trains list view
    #Then the TOC/FOC item is moved to the un-selected TOC/FOC list

  Scenario: 33806 -12 Moving all selected items to Unselected column
    When I click on all the selected railway undertaking entries
    And the following can be seen on the unselected railway undertaking config
      | unSelectedColumn                    | arrowType            |
      | ARRIVA CROSSCOUNTRY TRAINS (EH)     | keyboard_arrow_right |
      | SOUTH WESTERN RAILWAY (HY)          | keyboard_arrow_right |
      | ON ROUTE LOGISTICS (UK) (PM)        | keyboard_arrow_right |
      | AMEY (RE)                           | keyboard_arrow_right |
      | SB (SWIETELSKY BABCOCK)RAIL (RD)    | keyboard_arrow_right |
      | FREIGHT EUROPE (PN)                 | keyboard_arrow_right |
      | DRS-DIRECT RAIL SVCS (XH)           | keyboard_arrow_right |
      | TRANSPENNINE EXPRESS (FTPE) (EA)    | keyboard_arrow_right |
      | EAST MIDLANDS RAILWAY (EM)          | keyboard_arrow_right |
      | LEGGE INFRASTRUCTURE SERVICES (LG)  | keyboard_arrow_right |
      | c2c RAIL (HT)                       | keyboard_arrow_right |
      | NETWORK RAIL OTM (LR)               | keyboard_arrow_right |
      | LORAM (LC)                          | keyboard_arrow_right |
      | EUROPORTE CHANNEL (PT)              | keyboard_arrow_right |
      | VINTAGE TRAINS (TY)                 | keyboard_arrow_right |
      | DB CARGO CHARTERS (WA)              | keyboard_arrow_right |
      | Govia Thameslink Railway (ET)       | keyboard_arrow_right |
      | FREIGHTLINER (DB)                   | keyboard_arrow_right |
      | LUL BAKERLOO (XC)                   | keyboard_arrow_right |
      | DEVON AND CORNWALL RAILWAYS (PO)    | keyboard_arrow_right |
      | SOUTH YORKSHIRE SUPERTRAM (SJ)      | keyboard_arrow_right |
      | LOCOMOTIVE SERVICES (LS)            | keyboard_arrow_right |
      | HEATHROW EXPRESS (HM)               | keyboard_arrow_right |
      | NETWORKRAIL VIRTUAL FREIGHT CO (QJ) | keyboard_arrow_right |
      | EUROSTAR INTL (GA)                  | keyboard_arrow_right |
      | GB RAILFREIGHT (PE)                 | keyboard_arrow_right |
      | Serco Caledonian Sleeper Ltd (ES)   | keyboard_arrow_right |
      | TfL RAIL (formerly Crossrail) (EX)  | keyboard_arrow_right |
      | SECO RAIL (RU)                      | keyboard_arrow_right |
      | TRANSPORT FOR WALES (HL)            | keyboard_arrow_right |
      | HEATHROW CONNECT (EE)               | keyboard_arrow_right |
      | CHILTERN RAILWAY (HO)               | keyboard_arrow_right |
      | COLAS RAIL (RG)                     | keyboard_arrow_right |
      | SNCF FREIGHT SERVICES (PS)          | keyboard_arrow_right |
      | SOUTHEASTERN (HU)                   | keyboard_arrow_right |
      | AVANTI WEST COAST (HF)              | keyboard_arrow_right |
      | LONDON NORTHEASTERN RAILWAY (HB)    | keyboard_arrow_right |
      | GRAND CENTRAL (EC)                  | keyboard_arrow_right |
      | Rail Operations Group (PH)          | keyboard_arrow_right |
      | LUL DISTRICT (WIMBLEDON) (XB)       | keyboard_arrow_right |
      | NORTHERN TRAINS LTD. (ED)           | keyboard_arrow_right |
      | SERCO Railtest (SD)                 | keyboard_arrow_right |
      | FFESTINIOG RAILWAY (XJ)             | keyboard_arrow_right |
      | Swanage Railway (SG)                | keyboard_arrow_right |
      | WEST COAST RAILWAY CO (PA)          | keyboard_arrow_right |
      | NORTH YORKSHIRE MOORS RAILWAY (PR)  | keyboard_arrow_right |
      | BALFOUR BEATTY RAIL PLANT (RZ)      | keyboard_arrow_right |
      | GREATER ANGLIA (ABELLIO GA) (EB)    | keyboard_arrow_right |
      | EAST COAST TRAINS LIMITED (LD)      | keyboard_arrow_right |
      | CARILLION RAIL CTRL PHASE 1 (RQ)    | keyboard_arrow_right |
      | PRE METRO OPERATIONS (PK)           | keyboard_arrow_right |
      | LUL DISTRICT (RICHMOND) (XE)        | keyboard_arrow_right |
      | ARRIVA RAIL LONDON (EK)             | keyboard_arrow_right |
      | CARILLON RAIL (FORMERLY GTRM) (RB)  | keyboard_arrow_right |
      | VOLKERRAIL (RH)                     | keyboard_arrow_right |
      | HULL TRAINS (PF)                    | keyboard_arrow_right |
      | JSD Research & Development Ltd (RR) | keyboard_arrow_right |
      | ISLAND LINES (HZ)                   | keyboard_arrow_right |
      | MERSEYRAIL ELECTRICS (HE)           | keyboard_arrow_right |
      | VICTA RAIL (PV)                     | keyboard_arrow_right |
      | HARSCO (RT)                         | keyboard_arrow_right |
      | NR RESERVED PATHINGS (NON QJ) (NR)  | keyboard_arrow_right |
      | TYNE AND WEAR METRO (PG)            | keyboard_arrow_right |
      | WEST MIDLANDS TRAINS (EJ)           | keyboard_arrow_right |
      | GREAT WESTERN RAILWAY (EF)          | keyboard_arrow_right |
      | SCOTRAIL (HA)                       | keyboard_arrow_right |
      | SLC OPERATIONS LIMITED (SO)         | keyboard_arrow_right |
      | GCNW (LN)                           | keyboard_arrow_right |

  Scenario Outline: 33806 -13a Selecting required columns and verifying if they are reflected in the trains list - positive tests - <valuesToExpectInTrainsList>
    #    Given the user has made changes to the trains list TOC/FOC selection
    #    When the user views the trains list
    #    Then the view is updated to reflect the user's TOC/FOC selection
    * I generate a new trainUID
    * I delete '<trainUid>:today' from hash 'schedule-modifications'
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>    | <location>  | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    When the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <trainUid> | <trainDescription> | now                    | 99999               | RDNGSTN                | today         | now                 |
    When I select only the following railway undertaking entries
      | items                    |
      | <columnToSelectInConfig> |
    And I save the trains list config
    Then I should see the trains list column TOC has only the below values
      | expectedValues               |
      | <valuesToExpectInTrainsList> |
    * I restore to default train list config '1'

    Examples:
      | columnToSelectInConfig        | valuesToExpectInTrainsList | trainUid  | trainDescription | cif                                 | location |
      | GREAT WESTERN RAILWAY (EF)    | EF                         | generated | 2P33             | access-plan/2P77_RDNGSTN_PADTON.cif | RDNGSTN  |
      | WEST MIDLANDS TRAINS (EJ)     | EJ                         | generated | 2P34             | access-plan/1W06_EUSTON_BHAMNWS.cif | EUSTON   |

  Scenario Outline: 33806 -13b Selecting required columns and verifying if they are reflected in the trains list - negative tests
    #    Given the user has made changes to the trains list TOC/FOC selection
    #    When the user views the trains list
    #    Then the view is updated to reflect the user's TOC/FOC selection
    * I delete '<trainUid>:today' from hash 'schedule-modifications'
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>    | <location>  | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    When the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <trainUid> | <trainDescription> | now                    | 99999               | RDNGSTN                | today         | now                 |
    When I select only the following railway undertaking entries
      | items                    |
      | <columnToSelectInConfig> |
    And I save the trains list config
    Then the trains list column TOC FOC column is empty
    * I restore to default train list config '1'

    Examples:
      | columnToSelectInConfig        | trainUid | trainDescription | cif                                 | location |
      | WEST MIDLANDS TRAINS (EJ)     | B33808   | 2P35             | access-plan/2P77_RDNGSTN_PADTON.cif | RDNGSTN  |
      | GREAT WESTERN RAILWAY (EF)    | B33809   | 2P36             | access-plan/1W06_EUSTON_BHAMNWS.cif | EUSTON   |
