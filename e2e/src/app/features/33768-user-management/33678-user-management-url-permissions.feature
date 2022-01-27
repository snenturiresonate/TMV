Feature: 33768-1: TMV User Management - Direct URL permissions
  As a TMV user
  I want to be able to log into the TMV application
  so that I can access functionality that the is appropriate for my role

  Background:
    Given I have not already authenticated

  Scenario Outline: 33768 -17a Prevent direct navigation for user without Standard Role - Admin Only User
      #Given I have signed in
      #And I have a valid TMV role of <Role Type>
      #When I navigate to the <Location> URL
      #Then the page is not displayed
      #Examples:
      #  | Role Type |
      #  | Admin|
      #  | Restrictions |
      #  | Schedule Matching|
      #Examples:
      #  | Location |
      #  | Trains List|
      #  | Timetable |
      #  | Maps |
      #  | Logs |
      #  | Replay |
      #  | Train enquiries |
    When I navigate to <page> page as adminOnly user
    Then I am re-directed to home page
    Examples:
      | page       |
      | TrainsList |
      | LogViewer  |
      | Replay     |
      | Enquiries  |

  Scenario: 33768 -17b Prevent direct navigation for user without Standard Role - Admin Only User to the timetable page
    Given the access plan located in CIF file 'access-plan/1S42_PADTON_DIDCOTP.cif' is amended so that all services start within the next hour and then received from LINX
    When I navigate to the timetable page of train UID L55285 and date today as adminOnly user
    Then I am re-directed to home page

  Scenario: 33768 -17c Prevent direct navigation for user without Standard Role - Admin Only User to the maps page
    When I view the map gw15cambrian.v as adminOnly user
    Then I am re-directed to home page


  Scenario Outline: 33768 -18 Prevent direct navigation for user without Admin Role
    #Given I have signed in
    #And I have a valid TMV role of <Role Type>
    #When I navigate to a admin by URL
    #Then the admin is not displayed
    #Examples:
    #  | Role Type |
    #  | Standard |
    #  | Restrictions |
    #  | Schedule Matching|
    When I navigate to Admin page as <testUser> user
    Then I am re-directed to home page
    Examples:
      | testUser         |
      | Standard         |
      | restriction      |
      | ScheduleMatching |

  Scenario Outline: 33768 -19a Prevent direct navigation for user without Schedule matching
    #Given I have signed in
    #And I have a valid TMV role of <Role Type>
    #When I navigate to a schedule match for a service by URL
    #Then the manual  match page is not displayed
    #Examples:
      #| Role Type |
      #| Admin|
      #| Restrictions |
      #| Standard |
    * I remove today's train 'C46096' from the Redis trainlist
    Given the access plan located in CIF file 'access-plan/1B69_PADTON_SWANSEA.cif' is amended so that all services start within the next hour and then received from LINX
    When I access the homepage as <user>
    And I wait until today's train 'C46096' has loaded
    And I navigate to the schedule matching page for the following train
      | trainUID | trainDesc | scheduleDate |
      | C46096   | 1B69      | today        |
    Then I am re-directed to home page
    Examples:
      | user        |
      | Standard    |
      | restriction |

  Scenario: 33768 -19b Prevent direct navigation for user without Schedule matching - AdminOnly user
    #Given I have signed in
    #And I have a valid TMV role of <Role Type>
    #When I navigate to a schedule match for a service by URL
    #Then the manual  match page is not displayed
    #Examples:
      #| Role Type |
      #| Admin|
      #| Restrictions |
      #| Standard |
    Given the access plan located in CIF file 'access-plan/1B69_PADTON_SWANSEA.cif' is amended so that all services start within the next hour and then received from LINX
    When I access the homepage as adminOnly
    And I navigate to the schedule matching page for the following train
      | trainUID | trainDesc | scheduleDate |
      | C46096   | 1B69      | today        |
    Then I am re-directed to home page

  @tdd @tdd:54546
  Scenario Outline: 33768 -20 Prevent direct navigation for user without Restrictions Role - <user>
    #Given I have signed in
    #And I have a valid TMV role of <Role Type>
    #When I navigate to restrictions by URL
    #Then the restrictions management page is not displayed
    #Examples:
    #  | Role Type |
    #  | Admin|
    #  | Standard |
    #  | Schedule Matching|
    When I access the homepage as <user>
    And I navigate to the restrictions page for track id 'LSLS1S'
    Then I am re-directed to home page
    Examples:
      | user             |
      | adminOnly        |
      | standardOnly     |
      | scheduleMatching |

  Scenario Outline: 33768 -21a Allow direct navigation for user Standard Role
    ##Given I have signed in
    #And I have a valid TMV role of Standard
    #When I navigate to the <Location> URL
    #Then the page is displayed
    #Examples:
    #  | Location |
    #  | Trains List|
    #  | Timetable |
    #  | Maps |
    #  | Logs |
    #  | Replay |
    #  | Train enquiries |
    When I navigate to <page> page as Standard user
    Then I am not re-directed to home page
  Examples:
    | page       |
    | TrainsList |
    | LogViewer  |
    | Replay     |
    | Enquiries  |

  Scenario: 33768 -21b Allow direct navigation for user Standard Role - Timetable
    Given the access plan located in CIF file 'access-plan/1B69_PADTON_SWANSEA.cif' is amended so that all services start within the next hour and then received from LINX
    When I navigate to the timetable page of train UID C46096 and date today as Standard user
    Then I am not re-directed to home page

  Scenario: 33768 -21c Allow direct navigation for user Standard Role - Maps page
    When I view the map gw15cambrian.v as Standard user
    Then I am not re-directed to home page

  Scenario Outline: 33768 -22a Prevent direct navigation for user that has not signed in
    #Given I have not signed in
    #When I navigate to the <Location> URL
    #Then the page is not displayed
    #And I am directed to the sign in screen
    #Examples:
    #  | Location |
    #  | Trains List|
    #  | Timetable |
    #  | Maps |
    #  | Logs |
    #  | Replay |
    #  | Train enquiries |
    #  | Admin |
    When I navigate to <page> page without prior authentication
    Then I am presented with the sign in screen
    Examples:
      | page       |
      | TrainsList |
      | LogViewer  |
      | Replay     |
      | Enquiries  |

  Scenario: 33768 -22b Prevent direct navigation for user that has not signed in - Timetable
    Given the access plan located in CIF file 'access-plan/1B69_PADTON_SWANSEA.cif' is amended so that all services start within the next hour and then received from LINX
    When I navigate to the timetable page of train UID C46096 and date today without prior authentication
    Then I am presented with the sign in screen

  Scenario: 33768 -22c Prevent direct navigation for user that has not signed in - maps screen
    When I view the map gw15cambrian.v without prior authentication
    Then I am presented with the sign in screen
