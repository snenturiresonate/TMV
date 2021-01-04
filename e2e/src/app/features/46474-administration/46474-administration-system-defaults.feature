Feature: 46474 - Administration System Defaults - full end to end testing

  As a tester
  I want to verify the administration page - login message
  So, that I can identify if the build meets the end to end requirements

  #33767-3 Navigating to Systems Defaults view
  #Given that I have the admin screen open on a tab other than the Systems Defaults view
  #When I select the System Defaults option
  #Then the Systems Default view tab is highlighted
  #And the Systems Default Setting are displayed (Replay background colour, Max maps per replay session, Max number of Replay sessions, Max number of maps, Max number of trains lists)

  #33767-7 Read Only Systems Defaults (TDD)
  #Given that I have the admin screen open on the Systems Defaults view
  #When when I attempt to change Max maps per replay session, Max number of Replay sessions, Max number of maps, Max number of trains lists
  #Then no edit option is available

  Background:
    Given I am on the admin page
    And I navigate to the 'System Defaults' admin tab

  Scenario: Replay system settings
    Then the following can be seen on the system default settings
      | replayEntry                                       |
      | Replay Background Colour                          |
      | Maximum Number of Replays                         |
      | Maximum Number of Schematic Map Display Instances |
      | Maximum Number of Trains List View Instances      |

  Scenario: Replay system setting values display
    Then I should see the system default settings as
      | ReplayBackgroundColour | MaxNoOfMapsPerReplay | MaxNoofReplays | MaxNoofSchematicMapDisplayInstances | MaxNoofTrainsListViewInstances |
      | #2b78e4                | 10                    | 10             | 4                                   | 8                              |

  Scenario: Replay system setting values update and save
    When I update the system default settings as
      | ReplayBackgroundColour | MaxNoOfMapsPerReplay | MaxNoofReplays | MaxNoofSchematicMapDisplayInstances | MaxNoofTrainsListViewInstances |
      | #637                   | 5                    | 15             | 5                                   | 9                              |
    And I save the system default settings
    And I navigate to the 'Login Message' admin tab
    And I navigate to the 'System Defaults' admin tab
    Then I should see the system default settings as
      | ReplayBackgroundColour | MaxNoOfMapsPerReplay | MaxNoofReplays | MaxNoofSchematicMapDisplayInstances | MaxNoofTrainsListViewInstances |
      | #663377                | 5                    | 15             | 5                                   | 9                              |

    @bug @bug_51595
  Scenario: Replay system setting values reset
    When I update the system default settings as
      | ReplayBackgroundColour | MaxNoOfMapsPerReplay | MaxNoofReplays | MaxNoofSchematicMapDisplayInstances | MaxNoofTrainsListViewInstances |
      | #638                   | 8                    | 9             | 6                                   | 10                              |
    And I save the system default settings
    And I update the system default settings as
      | ReplayBackgroundColour | MaxNoOfMapsPerReplay | MaxNoofReplays | MaxNoofSchematicMapDisplayInstances | MaxNoofTrainsListViewInstances |
      | #637                   | 2                    | 3             | 5                                   | 15                              |
    And I reset the system default settings
    Then I should see the system default settings as
      | ReplayBackgroundColour | MaxNoOfMapsPerReplay | MaxNoofReplays | MaxNoofSchematicMapDisplayInstances | MaxNoofTrainsListViewInstances |
      | #638                   | 8                    | 9             | 6                                   | 10                              |

      @tdd
      Scenario: User can edit only replay background colour of Replay system setting values
      Then I should not be able to edit 'Maximum Number of Maps Per Replay Session'
        And I should not be able to edit 'Maximum Number of Replays'
        And I should not be able to edit 'Maximum Number of Schematic Map Display Instances'
        And I should not be able to edit 'Maximum Number of Trains List View Instances'
