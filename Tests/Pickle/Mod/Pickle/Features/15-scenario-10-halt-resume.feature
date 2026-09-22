@review @requires:nelim.pickletools.filmticks
Feature: Scenario 10 production halts below the floor and resumes without loss

  Background:
    Given the save "test-colony" is loaded
    And I close all dialogs

  Scenario: a cow keeps its progress while halted and resumes from it
    Given Contented Livestock spawns the player animal "ScenarioTenCow" as "Cow"
    When Contented Livestock waits one game hour
    And Nelim's Pickle Tools: I film every 30 ticks as "scenario 10 halt and resume"
    And Contented Livestock sets "ScenarioTenCow" to 10 percent contentment
    Then Contented Livestock production factor for "ScenarioTenCow" is 0 percent
    When Contented Livestock selects animal "ScenarioTenCow" for visual evidence
    And Contented Livestock opens the live contentment tip for "ScenarioTenCow"
    Then I take a screenshot "scenario 10 - milk progress before halted hour"
    When I close all dialogs
    And Contented Livestock records the milk fullness of "ScenarioTenCow"
    And Contented Livestock waits one game hour
    Then Contented Livestock milk fullness of "ScenarioTenCow" has not changed
    When Contented Livestock selects animal "ScenarioTenCow" for visual evidence
    And Contented Livestock opens the live contentment tip for "ScenarioTenCow"
    Then I take a screenshot "scenario 10 - milk progress unchanged after halted hour"
    When I close all dialogs
    And Contented Livestock sets "ScenarioTenCow" to 100 percent contentment
    And Contented Livestock waits one game hour
    Then Contented Livestock milk fullness of "ScenarioTenCow" has increased
    When Contented Livestock selects animal "ScenarioTenCow" for visual evidence
    Then I take a screenshot "scenario 10 - milk progress resumes from prior amount"
    When Nelim's Pickle Tools: I stop filming
    And no errors were logged
