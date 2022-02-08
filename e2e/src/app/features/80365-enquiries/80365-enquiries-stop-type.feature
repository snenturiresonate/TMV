@TMVPhase2 @P2.S3
Feature: 80365 - TMV Enquiries
  As a TMV User
  I want the ability update the enquires selection criteria
  So that I can filter the enquires trains to my business needs

  # Given the user is authenticated to use TMV
  # When the user has submitted the enquries criteria
  # And is viewing the enquires result page
  # Then the user's enquires selection criteria is displayed

  Background:
    * I have not already authenticated
    * I have cleared out all headcodes
    * I generate a new train description
    * I generate a new trainUID


  Scenario Outline: 81201-1 - TMV Enquiries Criteria Display - all stop types with start/end times that should show the Paddington train
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '1' minute, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    * I wait until today's train '<planningUid>' has loaded
    And I am on the enquiries page
    And I type 'PADTON' into the enquiries location search box
    And I select the location at position 1 in the enquiries location auto suggest search results list
    When I click the enquiries view button
    And I primary click for todays train '<trainDescription>' schedule uid '<planningUid>' from the enquiries page
    And the number of tabs open is 2
    And I switch to the new tab
    Then the tab title is '<trainDescription> TMV Timetable'
    And I give the timetable a settling time of 2 seconds to update
    Then The values for the header properties are as follows
      | schedType | lastSignal | lastReport                       | trainUid      | trustId                         | lastTJM | headCode           |
      | LTP       |            |                                  | <planningUid> |                                 |         | <trainDescription> |

    Examples:
      | trainDescription          | planningUid       |
      | generatedTrainDescription | generatedTrainUId |

  Scenario Outline: 81201-2 - TMV Enquiries Criteria Display - all stop types with start/end times *after* the Paddington train - no results expected
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '1' minute, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    * I wait until today's train '<planningUid>' has loaded
    And I am on the enquiries page
    And I type 'PADTON' into the enquiries location search box
    And I select the location at position 1 in the enquiries location auto suggest search results list
    And I have set the start and end time to a period after the train finishes
    When I click the enquiries view button
    Then train '<trainDescription>' with schedule id '<planningUid>' for today is not visible on the enquiries page

    Examples:
      | trainDescription          | planningUid       |
      | generatedTrainDescription | generatedTrainUId |

  @Mat
  Scenario Outline: 81201-3 - TMV Enquiries Criteria Display - all stop types with start/end times *before* the Paddington train - no results expected
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '1' minute, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    * I wait until today's train '<planningUid>' has loaded
    And I am on the enquiries page
    And I type 'PADTON' into the enquiries location search box
    And I select the location at position 1 in the enquiries location auto suggest search results list
    And I have set the start and end time to a period before the train begins
    When I click the enquiries view button
    Then train '<trainDescription>' with schedule id '<planningUid>' for today is not visible on the enquiries page

    Examples:
      | trainDescription          | planningUid       |
      | generatedTrainDescription | generatedTrainUId |

  Scenario Outline: 81201-4 - TMV Enquiries Criteria Display - Originate stop type - only Originate selected, should show Paddington train
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '1' minute, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    * I wait until today's train '<planningUid>' has loaded
    And I am on the enquiries page
    And I type 'PADTON' into the enquiries location search box
    And I select the location at position 1 in the enquiries location auto suggest search results list
    And I uncheck the enquiries Stop checkbox for 'PADTON'
    And I uncheck the enquiries Pass checkbox for 'PADTON'
    And I uncheck the enquiries Terminate checkbox for 'PADTON'
    When I click the enquiries view button
    And I primary click for todays train '<trainDescription>' schedule uid '<planningUid>' from the enquiries page
    And the number of tabs open is 2
    And I switch to the new tab
    Then the tab title is '<trainDescription> TMV Timetable'
    And I give the timetable a settling time of 2 seconds to update
    Then The values for the header properties are as follows
      | schedType | lastSignal | lastReport                       | trainUid      | trustId                         | lastTJM | headCode           |
      | LTP       |            |                                  | <planningUid> |                                 |         | <trainDescription> |

    Examples:
      | trainDescription          | planningUid       |
      | generatedTrainDescription | generatedTrainUId |

  Scenario Outline: 81201-5 - TMV Enquiries Criteria Display - Originate stop type - only Originate selected but with a location that should not show Paddington train
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '1' minute, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    * I wait until today's train '<planningUid>' has loaded
    And I am on the enquiries page
    And I type 'OXFD' into the enquiries location search box
    And I select the location at position 1 in the enquiries location auto suggest search results list
    And I uncheck the enquiries Stop checkbox for 'OXFD'
    And I uncheck the enquiries Pass checkbox for 'OXFD'
    And I uncheck the enquiries Terminate checkbox for 'OXFD'
    When I click the enquiries view button
    Then train '<trainDescription>' with schedule id '<planningUid>' for today is not visible on the enquiries page

    Examples:
      | trainDescription          | planningUid       |
      | generatedTrainDescription | generatedTrainUId |

  Scenario Outline: 81201-6 - TMV Enquiries Criteria Display - Originate stop type - Originate not selected, should not show the Paddington train
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '1' minute, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    * I wait until today's train '<planningUid>' has loaded
    And I am on the enquiries page
    And I type 'PADTON' into the enquiries location search box
    And I select the location at position 1 in the enquiries location auto suggest search results list
    And I uncheck the enquiries Originate checkbox for 'PADTON'
    When I click the enquiries view button
    Then train '<trainDescription>' with schedule id '<planningUid>' for today is not visible on the enquiries page

    Examples:
      | trainDescription          | planningUid       |
      | generatedTrainDescription | generatedTrainUId |

  Scenario Outline: 81201-7 - TMV Enquiries Criteria Display - Terminate stop type - only Terminate selected, should show the Paddington train
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '1' minute, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    * I wait until today's train '<planningUid>' has loaded
    And I am on the enquiries page
    And I type 'OXFD' into the enquiries location search box
    And I select the location at position 1 in the enquiries location auto suggest search results list
    And I uncheck the enquiries Originate checkbox for 'OXFD'
    And I uncheck the enquiries Stop checkbox for 'OXFD'
    And I uncheck the enquiries Pass checkbox for 'OXFD'
    When I click the enquiries view button
    And I primary click for todays train '<trainDescription>' schedule uid '<planningUid>' from the enquiries page
    And the number of tabs open is 2
    And I switch to the new tab
    Then the tab title is '<trainDescription> TMV Timetable'
    And I give the timetable a settling time of 2 seconds to update
    Then The values for the header properties are as follows
      | schedType | lastSignal | lastReport                       | trainUid      | trustId                         | lastTJM | headCode           |
      | LTP       |            |                                  | <planningUid> |                                 |         | <trainDescription> |
    Examples:
      | trainDescription          | planningUid       |
      | generatedTrainDescription | generatedTrainUId |

  Scenario Outline: 81201-8 - TMV Enquiries Criteria Display - Terminate stop type - only Terminate selected, should not show the Paddington train
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '1' minute, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    * I wait until today's train '<planningUid>' has loaded
    And I am on the enquiries page
    And I type 'RDNGSTN' into the enquiries location search box
    And I select the location at position 1 in the enquiries location auto suggest search results list
    And I uncheck the enquiries Originate checkbox for 'RDNGSTN'
    And I uncheck the enquiries Stop checkbox for 'RDNGSTN'
    And I uncheck the enquiries Pass checkbox for 'RDNGSTN'
    When I click the enquiries view button
    Then train '<trainDescription>' with schedule id '<planningUid>' for today is not visible on the enquiries page

    Examples:
      | trainDescription          | planningUid       |
      | generatedTrainDescription | generatedTrainUId |

  Scenario Outline: 81201-9 - TMV Enquiries Criteria Display - Terminate stop type - valid location but Terminate not selected, should not show the Paddington train
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '1' minute, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    * I wait until today's train '<planningUid>' has loaded
    And I am on the enquiries page
    And I type 'OXFD' into the enquiries location search box
    And I select the location at position 1 in the enquiries location auto suggest search results list
    And I uncheck the enquiries Terminate checkbox for 'OXFD'
    When I click the enquiries view button
    Then train '<trainDescription>' with schedule id '<planningUid>' for today is not visible on the enquiries page

    Examples:
      | trainDescription          | planningUid       |
      | generatedTrainDescription | generatedTrainUId |

  Scenario Outline: 81201-10 - TMV Enquiries Criteria Display - Stop stop-type - only Stop selected, should show the Paddington train
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '1' minute, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    * I wait until today's train '<planningUid>' has loaded
    And I am on the enquiries page
    And I type 'SLOUGH' into the enquiries location search box
    And I select the location at position 1 in the enquiries location auto suggest search results list
    And I uncheck the enquiries Originate checkbox for 'SLOUGH'
    And I uncheck the enquiries Pass checkbox for 'SLOUGH'
    And I uncheck the enquiries Terminate checkbox for 'SLOUGH'
    When I click the enquiries view button
    And I primary click for todays train '<trainDescription>' schedule uid '<planningUid>' from the enquiries page
    And the number of tabs open is 2
    And I switch to the new tab
    Then the tab title is '<trainDescription> TMV Timetable'
    And I give the timetable a settling time of 2 seconds to update
    Then The values for the header properties are as follows
      | schedType | lastSignal | lastReport                       | trainUid      | trustId                         | lastTJM | headCode           |
      | LTP       |            |                                  | <planningUid> |                                 |         | <trainDescription> |
    Examples:
      | trainDescription          | planningUid       |
      | generatedTrainDescription | generatedTrainUId |

  Scenario Outline: 81201-11 - TMV Enquiries Criteria Display - Stop stop-type - only Stop selected but with a location that should not show the Paddington train
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '1' minute, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    * I wait until today's train '<planningUid>' has loaded
    And I am on the enquiries page
    And I type 'STHALL' into the enquiries location search box
    And I select the location at position 1 in the enquiries location auto suggest search results list
    And I uncheck the enquiries Originate checkbox for 'STHALL'
    And I uncheck the enquiries Pass checkbox for 'STHALL'
    And I uncheck the enquiries Terminate checkbox for 'STHALL'
    When I click the enquiries view button
    Then train '<trainDescription>' with schedule id '<planningUid>' for today is not visible on the enquiries page

    Examples:
      | trainDescription          | planningUid       |
      | generatedTrainDescription | generatedTrainUId |

   Scenario Outline: 81201-12 - TMV Enquiries Criteria Display - Stop stop-type - valid location but Stop not selected, should not show the Paddington train
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '1' minute, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    * I wait until today's train '<planningUid>' has loaded
    And I am on the enquiries page
    And I type 'OXFD' into the enquiries location search box
    And I select the location at position 1 in the enquiries location auto suggest search results list
    And I uncheck the enquiries Stop checkbox for 'OXFD'
    And I uncheck the enquiries Terminate checkbox for 'OXFD'
    When I click the enquiries view button
    Then train '<trainDescription>' with schedule id '<planningUid>' for today is not visible on the enquiries page

    Examples:
      | trainDescription          | planningUid       |
      | generatedTrainDescription | generatedTrainUId |

  Scenario Outline: 81201-13 - TMV Enquiries Criteria Display - Pass stop-type - only Pass selected, should show the Paddington train
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '1' minute, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    * I wait until today's train '<planningUid>' has loaded
    And I am on the enquiries page
    And I type 'LDBRKJ' into the enquiries location search box
    And I select the location at position 1 in the enquiries location auto suggest search results list
    And I uncheck the enquiries Originate checkbox for 'LDBRKJ'
    And I uncheck the enquiries Stop checkbox for 'LDBRKJ'
    And I uncheck the enquiries Terminate checkbox for 'LDBRKJ'
    When I click the enquiries view button
    And I primary click for todays train '<trainDescription>' schedule uid '<planningUid>' from the enquiries page
    And the number of tabs open is 2
    And I switch to the new tab
    Then the tab title is '<trainDescription> TMV Timetable'
    And I give the timetable a settling time of 2 seconds to update
    Then The values for the header properties are as follows
      | schedType | lastSignal | lastReport                       | trainUid      | trustId                         | lastTJM | headCode           |
      | LTP       |            |                                  | <planningUid> |                                 |         | <trainDescription> |

    Examples:
      | trainDescription          | planningUid       |
      | generatedTrainDescription | generatedTrainUId |

  Scenario Outline: 81201-14 - TMV Enquiries Criteria Display - Pass stop-type - only Pass selected but with a location that should not show the Paddington train
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '1' minute, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    * I wait until today's train '<planningUid>' has loaded
    And I am on the enquiries page
    And I type 'OXFD' into the enquiries location search box
    And I select the location at position 1 in the enquiries location auto suggest search results list
    And I uncheck the enquiries Originate checkbox for 'OXFD'
    And I uncheck the enquiries Stop checkbox for 'OXFD'
    And I uncheck the enquiries Terminate checkbox for 'OXFD'
    When I click the enquiries view button
    Then train '<trainDescription>' with schedule id '<planningUid>' for today is not visible on the enquiries page

    Examples:
      | trainDescription          | planningUid       |
      | generatedTrainDescription | generatedTrainUId |

  Scenario Outline: 81201-15 - TMV Enquiries Criteria Display - Pass stop-type - valid location but Pass not selected, should not show the Paddington train
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '1' minute, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    * I wait until today's train '<planningUid>' has loaded
    And I am on the enquiries page
    And I type 'LDBRKJ' into the enquiries location search box
    And I select the location at position 1 in the enquiries location auto suggest search results list
    And I uncheck the enquiries Pass checkbox for 'LDBRKJ'
    When I click the enquiries view button
    Then train '<trainDescription>' with schedule id '<planningUid>' for today is not visible on the enquiries page

    Examples:
      | trainDescription          | planningUid       |
      | generatedTrainDescription | generatedTrainUId |
