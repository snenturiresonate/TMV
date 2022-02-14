@TMVPhase2 @P2.S2
Feature: 80071 - TMV Signalling Log Viewer - Signalling Search

  As a TMV User
  I want to view, filter and search the Signalling Logs
  So that I can analysis the signalling data for operational needs.

  Background:
    Given I clear the logged-berth-states Elastic Search index
    And I clear the logged-signal-states Elastic Search index
    And I clear the logged-latch-states Elastic Search index
    And I clear the logged-s-class Elastic Search index
    And I clear the logged-agreed-schedules Elastic Search index

    #    Given the user is authenticated to use TMV
    #    And the user is viewing the Signalling Log
    #    When the user performs a search
    #    And passes validation
    #    Then the system will display a list of results based on the search criteria

    #  The following data items are searchable:
    #     Train describer
    #     Type (Signal, Route, Latch) - multi-select
    #     Signalling ID (minimum 2 char)

  Scenario: 80303 - 1 - Signalling Search - Valid Searches
    Given the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D1             | 31      | 00   | 17:45:00  |
      | D1             | 31      | FF   | 17:46:00  |
      | D3             | 50      | 04   | 17:47:00  |
      | D3             | 50      | 00   | 17:48:00  |
    When I am on the log viewer page
    * I navigate to the Signalling log tab
    * I search for Signalling logs with
      | log-type-signal-state | log-type-latch-state  | log-type-route  | trainDescriber | signallingId |
      | checked               | unchecked             | unchecked       |                |              |
    Then the first signalling log results are
      | trainDescriber | signallingFunctionName | type   | signallingId | state   | dateTime       |
      | D1             | S784                   | Signal | T784         | On      | today 17:45:00 |
      | D1             | S786                   | Signal | T786         | On      | today 17:45:00 |
      | D1             | S792                   | Signal | T792         | On      | today 17:45:00 |
      | D1             | S793                   | Signal | T793         | On      | today 17:45:00 |
      | D1             | S784                   | Signal | T784         | Off     | today 17:46:00 |
      | D1             | S786                   | Signal | T786         | Off     | today 17:46:00 |
      | D1             | S792                   | Signal | T792         | Off     | today 17:46:00 |
      | D1             | S793                   | Signal | T793         | Off     | today 17:46:00 |
    When I am on the log viewer page
    * I navigate to the Signalling log tab
    * I search for Signalling logs with
      | log-type-signal-state | log-type-latch-state  | log-type-route  | trainDescriber | signallingId |
      | checked               | unchecked             | unchecked       | d1             | 79           |
    Then the first signalling log results are
      | trainDescriber | signallingFunctionName | type   | signallingId | state   | dateTime       |
      | D1             | S792                   | Signal | T792         | On      | today 17:45:00 |
      | D1             | S793                   | Signal | T793         | On      | today 17:45:00 |
      | D1             | S792                   | Signal | T792         | Off     | today 17:46:00 |
      | D1             | S793                   | Signal | T793         | Off     | today 17:46:00 |
    When I am on the log viewer page
    * I navigate to the Signalling log tab
    * I search for Signalling logs with
      | log-type-signal-state | log-type-latch-state  | log-type-route  | trainDescriber | signallingId |
      | unchecked             | checked               | unchecked       | d3             | SN5          |
    Then the first signalling log results are
      | D3             | LPLT3TRS               | Latch  | SN5          | Set     | today 17:47:00 |
      | D3             | LPLT3TRS               | Latch  | SN5          | Not Set | today 17:48:00 |
    When I am on the log viewer page
    * I navigate to the Signalling log tab
    * I search for Signalling logs with
      | log-type-signal-state | log-type-latch-state  | log-type-route  | trainDescriber | signallingId |
      | unchecked             | unchecked             | checked         | d1             | 65           |
    And the first signalling log results are
      | D1             | R1646B                 | Route  | D11646       |         | today 17:45:00 |
      | D1             | R1655                  | Route  | D11655       |         | today 17:45:00 |
      | D1             | R1646B                 | Route  | D11646       | UM      | today 17:46:00 |
      | D1             | R1655                  | Route  | D11655       | *       | today 17:46:00 |
    When I am on the log viewer page
    * I navigate to the Signalling log tab
    * I search for Signalling logs with
      | log-type-signal-state | log-type-latch-state  | log-type-route  | trainDescriber | signallingId |
      | checked               | checked               | checked         | d1             |              |
    Then the first signalling log results are
      | trainDescriber | signallingFunctionName | type   | signallingId | state   | dateTime       |
      | D1             | R1646B                 | Route  | D11646       |         | today 17:45:00 |
      | D1             | R1655                  | Route  | D11655       |         | today 17:45:00 |
      | D1             | S784                   | Signal | T784         | On      | today 17:45:00 |
      | D1             | S786                   | Signal | T786         | On      | today 17:45:00 |
      | D1             | S792                   | Signal | T792         | On      | today 17:45:00 |
      | D1             | S793                   | Signal | T793         | On      | today 17:45:00 |
      | D1             | R1646B                 | Route  | D11646       | UM      | today 17:46:00 |
      | D1             | R1655                  | Route  | D11655       | *       | today 17:46:00 |
      | D1             | S784                   | Signal | T784         | Off     | today 17:46:00 |
      | D1             | S786                   | Signal | T786         | Off     | today 17:46:00 |
      | D1             | S792                   | Signal | T792         | Off     | today 17:46:00 |
      | D1             | S793                   | Signal | T793         | Off     | today 17:46:00 |
    When I am on the log viewer page
    * I navigate to the Signalling log tab
    * I search for Signalling logs with
      | log-type-signal-state | log-type-latch-state  | log-type-route  | signalling-logs-timeframe | startTime | endTime   |
      | checked               | checked               | checked         | checked                   | 17:46:00  | 17:47:00  |
    Then the first signalling log results are
      | trainDescriber | signallingFunctionName | type   | signallingId | state   | dateTime       |
      | D1             | R1646B                 | Route  | D11646       | UM      | today 17:46:00 |
      | D1             | R1655                  | Route  | D11655       | *       | today 17:46:00 |
      | D1             | S784                   | Signal | T784         | Off     | today 17:46:00 |
      | D1             | S786                   | Signal | T786         | Off     | today 17:46:00 |
      | D1             | S792                   | Signal | T792         | Off     | today 17:46:00 |
      | D1             | S793                   | Signal | T793         | Off     | today 17:46:00 |
      | D3             | LPLT3TRS               | Latch  | SN5          | Set     | today 17:47:00 |

    #  The following data items are searchable:
    #     Train describer
    #     Type (Signal, Route, Latch) - multi-select
    #     Signalling ID (minimum 2 char)

  Scenario:  80303 - 2 - Signalling Search - Invalid searches
    Given I am on the log viewer page
    * I navigate to the Signalling log tab
    * I search for Signalling logs with
      | signallingId |
      | 1            |
    Then the movement logs signalling tab search error message is shown * The Signalling ID must contain at least 2 characters
