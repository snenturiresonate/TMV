@TMVPhase2 @P2.S2
# These tests fail on the build servers but they pass when ran manually (semi-automated), locally
@manual
Feature: 80071 - TMV Signalling Log Viewer - Signalling view export

  As a TMV User
  I want to view, filter and search the Signalling Logs
  So that I can analysis the signalling data for operational needs.

# Indexes need to be cleared to prevent other tests contaminating results
  Background:
    Given I clear the logged-berth-states Elastic Search index
    And I clear the logged-signal-states Elastic Search index
    And I clear the logged-latch-states Elastic Search index
    And I clear the logged-s-class Elastic Search index
    And I clear the logged-agreed-schedules Elastic Search index
    And the downloads folder is empty

  Scenario: 80304 - Signalling View Export
#    Given the user is authenticated to use TMV
#    And the user performed a search
#    And has returned results
#    When the user opts export the results
#    Then the export corresponds to the combined s-class & signalling data set
    Given the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D1             | 31      | 00   | 18:45:00  |
      | D1             | 31      | FF   | 18:46:00  |
      | D3             | 50      | 04   | 18:47:00  |
      | D3             | 50      | 00   | 18:48:00  |
    And I give the data 2 seconds to be written to elastic
    And I refresh the Elastic Search indices
    And I am on the log viewer page
    And I navigate to the Signalling log tab
    When I export for Signalling logs with
      | log-type-signal-state | log-type-latch-state | log-type-route | trainDescriber | signallingId |
      | checked               | checked              | checked        |                |              |
    And allow 1000 milliseconds to pass
    Then the zip, with the name of 'signalling-logs-<TODAY:yyyyMMdd>-0000-2359.zip' and a filename of 'signalling-<TODAY:yyyy-MM-dd>T00-00-00-<TODAY:yyyy-MM-dd>T23-59-59.csv', contains the following csv logs
      | Train Describer | Signalling Function Name | Type   | Signalling ID | State   | Date Time                   |
      | D1              | R1646B                   | ROUTE  | D11646        |         | <TODAY:yyyy-MM-dd>T18:45:00 |
      | D1              | R1655                    | ROUTE  | D11655        |         | <TODAY:yyyy-MM-dd>T18:45:00 |
      | D1              | S784                     | SIGNAL | T784          | On      | <TODAY:yyyy-MM-dd>T18:45:00 |
      | D1              | S786                     | SIGNAL | T786          | On      | <TODAY:yyyy-MM-dd>T18:45:00 |
      | D1              | S792                     | SIGNAL | T792          | On      | <TODAY:yyyy-MM-dd>T18:45:00 |
      | D1              | S793                     | SIGNAL | T793          | On      | <TODAY:yyyy-MM-dd>T18:45:00 |
      | D1              | R1646B                   | ROUTE  | D11646        | UM      | <TODAY:yyyy-MM-dd>T18:46:00 |
      | D1              | R1655                    | ROUTE  | D11655        | *       | <TODAY:yyyy-MM-dd>T18:46:00 |
      | D1              | S784                     | SIGNAL | T784          | Off     | <TODAY:yyyy-MM-dd>T18:46:00 |
      | D1              | S786                     | SIGNAL | T786          | Off     | <TODAY:yyyy-MM-dd>T18:46:00 |
      | D1              | S792                     | SIGNAL | T792          | Off     | <TODAY:yyyy-MM-dd>T18:46:00 |
      | D1              | S793                     | SIGNAL | T793          | Off     | <TODAY:yyyy-MM-dd>T18:46:00 |
      | D3              | LPLT3TRS                 | LATCH  | SN5           | Set     | <TODAY:yyyy-MM-dd>T18:47:00 |
      | D3              | LPLT3TRS                 | LATCH  | SN5           | Not Set | <TODAY:yyyy-MM-dd>T18:48:00 |

  Scenario: 80304 - Signalling View Export - signalling ID of SN5
#    Given the user is authenticated to use TMV
#    And the user performed a search
#    And has returned results
#    When the user opts export the results
#    Then the export corresponds to the combined s-class & signalling data set
    Given the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D1             | 31      | 00   | 18:45:00  |
      | D1             | 31      | FF   | 18:46:00  |
      | D3             | 50      | 04   | 18:47:00  |
      | D3             | 50      | 00   | 18:48:00  |
    And I give the data 2 seconds to be written to elastic
    And I refresh the Elastic Search indices
    And I am on the log viewer page
    And I navigate to the Signalling log tab
    When I export for Signalling logs with
      | log-type-signal-state | log-type-latch-state | log-type-route | trainDescriber | signallingId |
      | checked               | checked              | checked        |                | SN5          |
    And allow 1000 milliseconds to pass
    Then the zip, with the name of 'signalling-logs-<TODAY:yyyyMMdd>-0000-2359.zip' and a filename of 'signalling-<TODAY:yyyy-MM-dd>T00-00-00-<TODAY:yyyy-MM-dd>T23-59-59.csv', contains the following csv logs
      | Train Describer | Signalling Function Name | Type  | Signalling ID | State   | Date Time                   |
      | D3              | LPLT3TRS                 | LATCH | SN5           | Set     | <TODAY:yyyy-MM-dd>T18:47:00 |
      | D3              | LPLT3TRS                 | LATCH | SN5           | Not Set | <TODAY:yyyy-MM-dd>T18:48:00 |

  Scenario: 80304 - Signalling View Export - signalling ID of D11 (Partial Search)
#    Given the user is authenticated to use TMV
#    And the user performed a search
#    And has returned results
#    When the user opts export the results
#    Then the export corresponds to the combined s-class & signalling data set
    Given the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D1             | 31      | 00   | 18:45:00  |
      | D1             | 31      | FF   | 18:46:00  |
      | D3             | 50      | 04   | 18:47:00  |
      | D3             | 50      | 00   | 18:48:00  |
    And I give the data 2 seconds to be written to elastic
    And I refresh the Elastic Search indices
    And I am on the log viewer page
    And I navigate to the Signalling log tab
    When I export for Signalling logs with
      | log-type-signal-state | log-type-latch-state | log-type-route | trainDescriber | signallingId |
      | checked               | checked              | checked        |                | D11          |
    And allow 1000 milliseconds to pass
    Then the zip, with the name of 'signalling-logs-<TODAY:yyyyMMdd>-0000-2359.zip' and a filename of 'signalling-<TODAY:yyyy-MM-dd>T00-00-00-<TODAY:yyyy-MM-dd>T23-59-59.csv', contains the following csv logs
      | Train Describer | Signalling Function Name | Type  | Signalling ID | State | Date Time                   |
      | D1              | R1646B                   | ROUTE | D11646        |       | <TODAY:yyyy-MM-dd>T18:45:00 |
      | D1              | R1655                    | ROUTE | D11655        |       | <TODAY:yyyy-MM-dd>T18:45:00 |
      | D1              | R1646B                   | ROUTE | D11646        | UM    | <TODAY:yyyy-MM-dd>T18:46:00 |
      | D1              | R1655                    | ROUTE | D11655        | *     | <TODAY:yyyy-MM-dd>T18:46:00 |

  Scenario: 80304 - Signalling View Export - TD D3 only
#    Given the user is authenticated to use TMV
#    And the user performed a search
#    And has returned results
#    When the user opts export the results
#    Then the export corresponds to the combined s-class & signalling data set
    Given the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D1             | 31      | 00   | 18:45:00  |
      | D1             | 31      | FF   | 18:46:00  |
      | D3             | 50      | 04   | 18:47:00  |
      | D3             | 50      | 00   | 18:48:00  |
    And I give the data 2 seconds to be written to elastic
    And I refresh the Elastic Search indices
    And I am on the log viewer page
    And I navigate to the Signalling log tab
    When I export for Signalling logs with
      | log-type-signal-state | log-type-latch-state | log-type-route | trainDescriber | signallingId |
      | checked               | checked              | checked        | D3             |              |
    And allow 1000 milliseconds to pass
    Then the zip, with the name of 'signalling-logs-<TODAY:yyyyMMdd>-0000-2359.zip' and a filename of 'signalling-<TODAY:yyyy-MM-dd>T00-00-00-<TODAY:yyyy-MM-dd>T23-59-59.csv', contains the following csv logs
      | Train Describer | Signalling Function Name | Type  | Signalling ID | State   | Date Time                   |
      | D3              | LPLT3TRS                 | LATCH | SN5           | Set     | <TODAY:yyyy-MM-dd>T18:47:00 |
      | D3              | LPLT3TRS                 | LATCH | SN5           | Not Set | <TODAY:yyyy-MM-dd>T18:48:00 |

  Scenario: 80304 - Signalling View Export - route only
#    Given the user is authenticated to use TMV
#    And the user performed a search
#    And has returned results
#    When the user opts export the results
#    Then the export corresponds to the combined s-class & signalling data set
    Given the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D1             | 31      | 00   | 18:45:00  |
      | D1             | 31      | FF   | 18:46:00  |
      | D3             | 50      | 04   | 18:47:00  |
      | D3             | 50      | 00   | 18:48:00  |
    And I give the data 2 seconds to be written to elastic
    And I refresh the Elastic Search indices
    And I am on the log viewer page
    And I navigate to the Signalling log tab
    When I export for Signalling logs with
      | log-type-signal-state | log-type-latch-state | log-type-route | trainDescriber | signallingId |
      | unchecked             | unchecked            | checked        |                |              |
    And allow 1000 milliseconds to pass
    Then the zip, with the name of 'signalling-logs-<TODAY:yyyyMMdd>-0000-2359.zip' and a filename of 'signalling-<TODAY:yyyy-MM-dd>T00-00-00-<TODAY:yyyy-MM-dd>T23-59-59.csv', contains the following csv logs
      | Train Describer | Signalling Function Name | Type  | Signalling ID | State | Date Time                   |
      | D1              | R1646B                   | ROUTE | D11646        |       | <TODAY:yyyy-MM-dd>T18:45:00 |
      | D1              | R1655                    | ROUTE | D11655        |       | <TODAY:yyyy-MM-dd>T18:45:00 |
      | D1              | R1646B                   | ROUTE | D11646        | UM    | <TODAY:yyyy-MM-dd>T18:46:00 |
      | D1              | R1655                    | ROUTE | D11655        | *     | <TODAY:yyyy-MM-dd>T18:46:00 |

  Scenario: 80304 - Signalling View Export - latch only
#    Given the user is authenticated to use TMV
#    And the user performed a search
#    And has returned results
#    When the user opts export the results
#    Then the export corresponds to the combined s-class & signalling data set
    Given the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D1             | 31      | 00   | 18:45:00  |
      | D1             | 31      | FF   | 18:46:00  |
      | D3             | 50      | 04   | 18:47:00  |
      | D3             | 50      | 00   | 18:48:00  |
    And I give the data 2 seconds to be written to elastic
    And I refresh the Elastic Search indices
    And I am on the log viewer page
    And I navigate to the Signalling log tab
    When I export for Signalling logs with
      | log-type-signal-state | log-type-latch-state | log-type-route | trainDescriber | signallingId |
      | unchecked             | checked              | unchecked      |                |              |
    And allow 1000 milliseconds to pass
    Then the zip, with the name of 'signalling-logs-<TODAY:yyyyMMdd>-0000-2359.zip' and a filename of 'signalling-<TODAY:yyyy-MM-dd>T00-00-00-<TODAY:yyyy-MM-dd>T23-59-59.csv', contains the following csv logs
      | Train Describer | Signalling Function Name | Type  | Signalling ID | State   | Date Time                   |
      | D3              | LPLT3TRS                 | LATCH | SN5           | Set     | <TODAY:yyyy-MM-dd>T18:47:00 |
      | D3              | LPLT3TRS                 | LATCH | SN5           | Not Set | <TODAY:yyyy-MM-dd>T18:48:00 |

  Scenario: 80304 - Signalling View Export - signal only
#    Given the user is authenticated to use TMV
#    And the user performed a search
#    And has returned results
#    When the user opts export the results
#    Then the export corresponds to the combined s-class & signalling data set
    Given the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D1             | 31      | 00   | 18:45:00  |
      | D1             | 31      | FF   | 18:46:00  |
      | D3             | 50      | 04   | 18:47:00  |
      | D3             | 50      | 00   | 18:48:00  |
    And I give the data 2 seconds to be written to elastic
    And I refresh the Elastic Search indices
    And I am on the log viewer page
    And I navigate to the Signalling log tab
    When I export for Signalling logs with
      | log-type-signal-state | log-type-latch-state | log-type-route | trainDescriber | signallingId |
      | checked               | unchecked            | unchecked      |                |              |
    And allow 1000 milliseconds to pass
    Then the zip, with the name of 'signalling-logs-<TODAY:yyyyMMdd>-0000-2359.zip' and a filename of 'signalling-<TODAY:yyyy-MM-dd>T00-00-00-<TODAY:yyyy-MM-dd>T23-59-59.csv', contains the following csv logs
      | Train Describer | Signalling Function Name | Type   | Signalling ID | State | Date Time                   |
      | D1              | S784                     | SIGNAL | T784          | On    | <TODAY:yyyy-MM-dd>T18:45:00 |
      | D1              | S786                     | SIGNAL | T786          | On    | <TODAY:yyyy-MM-dd>T18:45:00 |
      | D1              | S792                     | SIGNAL | T792          | On    | <TODAY:yyyy-MM-dd>T18:45:00 |
      | D1              | S793                     | SIGNAL | T793          | On    | <TODAY:yyyy-MM-dd>T18:45:00 |
      | D1              | S784                     | SIGNAL | T784          | Off   | <TODAY:yyyy-MM-dd>T18:46:00 |
      | D1              | S786                     | SIGNAL | T786          | Off   | <TODAY:yyyy-MM-dd>T18:46:00 |
      | D1              | S792                     | SIGNAL | T792          | Off   | <TODAY:yyyy-MM-dd>T18:46:00 |
      | D1              | S793                     | SIGNAL | T793          | Off   | <TODAY:yyyy-MM-dd>T18:46:00 |

  Scenario: 80304 - Signalling View Export - route + signal only
#    Given the user is authenticated to use TMV
#    And the user performed a search
#    And has returned results
#    When the user opts export the results
#    Then the export corresponds to the combined s-class & signalling data set
    Given the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D1             | 31      | 00   | 18:45:00  |
      | D1             | 31      | FF   | 18:46:00  |
      | D3             | 50      | 04   | 18:47:00  |
      | D3             | 50      | 00   | 18:48:00  |
    And I give the data 2 seconds to be written to elastic
    And I refresh the Elastic Search indices
    And I am on the log viewer page
    And I navigate to the Signalling log tab
    When I export for Signalling logs with
      | log-type-signal-state | log-type-latch-state | log-type-route | trainDescriber | signallingId |
      | checked               | unchecked            | checked        |                |              |
    And allow 1000 milliseconds to pass
    Then the zip, with the name of 'signalling-logs-<TODAY:yyyyMMdd>-0000-2359.zip' and a filename of 'signalling-<TODAY:yyyy-MM-dd>T00-00-00-<TODAY:yyyy-MM-dd>T23-59-59.csv', contains the following csv logs
      | Train Describer | Signalling Function Name | Type   | Signalling ID | State | Date Time                   |
      | D1              | R1646B                   | ROUTE  | D11646        |       | <TODAY:yyyy-MM-dd>T18:45:00 |
      | D1              | R1655                    | ROUTE  | D11655        |       | <TODAY:yyyy-MM-dd>T18:45:00 |
      | D1              | S784                     | SIGNAL | T784          | On    | <TODAY:yyyy-MM-dd>T18:45:00 |
      | D1              | S786                     | SIGNAL | T786          | On    | <TODAY:yyyy-MM-dd>T18:45:00 |
      | D1              | S792                     | SIGNAL | T792          | On    | <TODAY:yyyy-MM-dd>T18:45:00 |
      | D1              | S793                     | SIGNAL | T793          | On    | <TODAY:yyyy-MM-dd>T18:45:00 |
      | D1              | R1646B                   | ROUTE  | D11646        | UM    | <TODAY:yyyy-MM-dd>T18:46:00 |
      | D1              | R1655                    | ROUTE  | D11655        | *     | <TODAY:yyyy-MM-dd>T18:46:00 |
      | D1              | S784                     | SIGNAL | T784          | Off   | <TODAY:yyyy-MM-dd>T18:46:00 |
      | D1              | S786                     | SIGNAL | T786          | Off   | <TODAY:yyyy-MM-dd>T18:46:00 |
      | D1              | S792                     | SIGNAL | T792          | Off   | <TODAY:yyyy-MM-dd>T18:46:00 |
      | D1              | S793                     | SIGNAL | T793          | Off   | <TODAY:yyyy-MM-dd>T18:46:00 |

  Scenario: 80304 - Signalling View Export - route + latch only
#    Given the user is authenticated to use TMV
#    And the user performed a search
#    And has returned results
#    When the user opts export the results
#    Then the export corresponds to the combined s-class & signalling data set
    Given the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D1             | 31      | 00   | 18:45:00  |
      | D1             | 31      | FF   | 18:46:00  |
      | D3             | 50      | 04   | 18:47:00  |
      | D3             | 50      | 00   | 18:48:00  |
    And I give the data 2 seconds to be written to elastic
    And I refresh the Elastic Search indices
    And I am on the log viewer page
    And I navigate to the Signalling log tab
    When I export for Signalling logs with
      | log-type-signal-state | log-type-latch-state | log-type-route | trainDescriber | signallingId |
      | unchecked             | checked              | checked        |                |              |
    And allow 1000 milliseconds to pass
    Then the zip, with the name of 'signalling-logs-<TODAY:yyyyMMdd>-0000-2359.zip' and a filename of 'signalling-<TODAY:yyyy-MM-dd>T00-00-00-<TODAY:yyyy-MM-dd>T23-59-59.csv', contains the following csv logs
      | Train Describer | Signalling Function Name | Type  | Signalling ID | State   | Date Time                   |
      | D1              | R1646B                   | ROUTE | D11646        |         | <TODAY:yyyy-MM-dd>T18:45:00 |
      | D1              | R1655                    | ROUTE | D11655        |         | <TODAY:yyyy-MM-dd>T18:45:00 |
      | D1              | R1646B                   | ROUTE | D11646        | UM      | <TODAY:yyyy-MM-dd>T18:46:00 |
      | D1              | R1655                    | ROUTE | D11655        | *       | <TODAY:yyyy-MM-dd>T18:46:00 |
      | D3              | LPLT3TRS                 | LATCH | SN5           | Set     | <TODAY:yyyy-MM-dd>T18:47:00 |
      | D3              | LPLT3TRS                 | LATCH | SN5           | Not Set | <TODAY:yyyy-MM-dd>T18:48:00 |

  Scenario: 80304 - Signalling View Export - signal + latch only
#    Given the user is authenticated to use TMV
#    And the user performed a search
#    And has returned results
#    When the user opts export the results
#    Then the export corresponds to the combined s-class & signalling data set
    Given the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D1             | 31      | 00   | 18:45:00  |
      | D1             | 31      | FF   | 18:46:00  |
      | D3             | 50      | 04   | 18:47:00  |
      | D3             | 50      | 00   | 18:48:00  |
    And I give the data 2 seconds to be written to elastic
    And I refresh the Elastic Search indices
    And I am on the log viewer page
    And I navigate to the Signalling log tab
    When I export for Signalling logs with
      | log-type-signal-state | log-type-latch-state | log-type-route | trainDescriber | signallingId |
      | checked               | checked              | unchecked      |                |              |
    And allow 1000 milliseconds to pass
    Then the zip, with the name of 'signalling-logs-<TODAY:yyyyMMdd>-0000-2359.zip' and a filename of 'signalling-<TODAY:yyyy-MM-dd>T00-00-00-<TODAY:yyyy-MM-dd>T23-59-59.csv', contains the following csv logs
      | Train Describer | Signalling Function Name | Type   | Signalling ID | State   | Date Time                   |
      | D1              | S784                     | SIGNAL | T784          | On      | <TODAY:yyyy-MM-dd>T18:45:00 |
      | D1              | S786                     | SIGNAL | T786          | On      | <TODAY:yyyy-MM-dd>T18:45:00 |
      | D1              | S792                     | SIGNAL | T792          | On      | <TODAY:yyyy-MM-dd>T18:45:00 |
      | D1              | S793                     | SIGNAL | T793          | On      | <TODAY:yyyy-MM-dd>T18:45:00 |
      | D1              | S784                     | SIGNAL | T784          | Off     | <TODAY:yyyy-MM-dd>T18:46:00 |
      | D1              | S786                     | SIGNAL | T786          | Off     | <TODAY:yyyy-MM-dd>T18:46:00 |
      | D1              | S792                     | SIGNAL | T792          | Off     | <TODAY:yyyy-MM-dd>T18:46:00 |
      | D1              | S793                     | SIGNAL | T793          | Off     | <TODAY:yyyy-MM-dd>T18:46:00 |
      | D3              | LPLT3TRS                 | LATCH  | SN5           | Set     | <TODAY:yyyy-MM-dd>T18:47:00 |
      | D3              | LPLT3TRS                 | LATCH  | SN5           | Not Set | <TODAY:yyyy-MM-dd>T18:48:00 |
