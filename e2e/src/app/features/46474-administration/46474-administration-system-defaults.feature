Feature: 46474 - Administration System Defaults - full end to end testing

  As a tester
  I want to verify the administration page - login message
  So, that I can identify if the build meets the end to end requirements

  Background:
    Given I have not already authenticated
    And I am on the admin page
    And I navigate to the 'System Defaults' admin tab
    And The admin setting defaults are as originally shipped

  Scenario: Replay system settings
    Then the following can be seen on the system default settings
      | setting                                                |
      | Replay Background Colour                               |
      | Maximum Number of Replays                              |
      | Maximum Number of Live Schematic Map Display Instances |

  Scenario: Replay system setting values display
    Then I should see the system default settings as
      | ReplayBackgroundColour | MaxNoOfMapsPerReplay | MaxNoofReplays | MaxNoofSchematicMapDisplayInstances |
      | #016e01                | 16                   | 2              | 16                                  |

  Scenario: Replay system setting values update and save
    When I update the system default settings as
      | ReplayBackgroundColour | MaxNoOfMapsPerReplay | MaxNoofReplays | MaxNoofSchematicMapDisplayInstances |
      | #637                   | 16                   | 2              | 16                                  |
    And I save the system default settings
    And I navigate to the 'Login Message' admin tab
    And I navigate to the 'System Defaults' admin tab
    Then I should see the system default settings as
      | ReplayBackgroundColour | MaxNoOfMapsPerReplay | MaxNoofReplays | MaxNoofSchematicMapDisplayInstances |
      | #663377                | 16                   | 2              | 16                                  |
    And The admin setting defaults are as originally shipped

  Scenario: Replay system setting values reset
    When I update the system default settings as
      | ReplayBackgroundColour | MaxNoOfMapsPerReplay | MaxNoofReplays | MaxNoofSchematicMapDisplayInstances |
      | #638                   | 16                   | 2              | 16                                  |
    And I save the system default settings
    And I update the system default settings as
      | ReplayBackgroundColour | MaxNoOfMapsPerReplay | MaxNoofReplays | MaxNoofSchematicMapDisplayInstances |
      | #637                   | 16                   | 2              | 16                                  |
    And I reset the system default settings
    Then I should see the system default settings as
      | ReplayBackgroundColour | MaxNoOfMapsPerReplay | MaxNoofReplays | MaxNoofSchematicMapDisplayInstances |
      | #663388                | 16                   | 2              | 16                                  |
    And The admin setting defaults are as originally shipped
