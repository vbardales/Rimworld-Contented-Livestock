@review
Feature: Scenario 01 assigns Contentment only to eligible colony producers

  Background:
    Given the save "test-colony" is loaded
    And I close all dialogs

  Scenario: cow and hen have the need while husky colonist and wild animal do not
    Given Contented Livestock spawns the player animal "ScenarioOneCow" as "Cow"
    And Contented Livestock spawns the player animal "ScenarioOneHen" as "Chicken"
    And Contented Livestock spawns the player animal "ScenarioOneHusky" as "Husky"
    And Contented Livestock spawns the player pawn "ScenarioOneColonist" as "Colonist"
    And Contented Livestock spawns the wild animal "ScenarioOneWild" as "Squirrel"
    Then Contented Livestock animal "ScenarioOneCow" has the contentment need
    And Contented Livestock animal "ScenarioOneHen" has the contentment need
    And Contented Livestock animal "ScenarioOneHusky" has no contentment need
    And Contented Livestock animal "ScenarioOneColonist" has no contentment need
    And Contented Livestock animal "ScenarioOneWild" has no contentment need
    When Contented Livestock selects animal "ScenarioOneCow" for visual evidence
    Then I take a screenshot "scenario 01 - cow has contentment"
    When Contented Livestock selects animal "ScenarioOneHen" for visual evidence
    Then I take a screenshot "scenario 01 - hen has contentment"
    When Contented Livestock selects animal "ScenarioOneHusky" for visual evidence
    Then I take a screenshot "scenario 01 - husky has no contentment"
    When Contented Livestock selects animal "ScenarioOneColonist" for visual evidence
    Then I take a screenshot "scenario 01 - colonist has no contentment"
    When Contented Livestock selects animal "ScenarioOneWild" for visual evidence
    Then I take a screenshot "scenario 01 - wild animal has no contentment"
    And no errors were logged
