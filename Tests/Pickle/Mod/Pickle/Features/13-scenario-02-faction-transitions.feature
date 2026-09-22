@review @film
Feature: Scenario 02 ownership changes refresh Contentment immediately

  Background:
    Given the save "test-colony" is loaded
    And I close all dialogs

  Scenario: a wild muffalo gains the need when tamed and loses it when transferred
    Given Contented Livestock spawns the wild animal "ScenarioTwoMuffalo" as "Muffalo"
    Then Contented Livestock animal "ScenarioTwoMuffalo" has no contentment need
    When Contented Livestock selects animal "ScenarioTwoMuffalo" for visual evidence
    Then I take a screenshot "scenario 02 - wild muffalo before taming"
    When Contented Livestock gives "ScenarioTwoMuffalo" to the player faction
    Then Contented Livestock animal "ScenarioTwoMuffalo" has the contentment need
    When Contented Livestock selects animal "ScenarioTwoMuffalo" for visual evidence
    Then I take a screenshot "scenario 02 - muffalo immediately after taming"
    When Contented Livestock transfers "ScenarioTwoMuffalo" to a neutral trader faction
    Then Contented Livestock animal "ScenarioTwoMuffalo" has no contentment need
    When Contented Livestock selects animal "ScenarioTwoMuffalo" for visual evidence
    Then I take a screenshot "scenario 02 - muffalo immediately after trader transfer"
    And no errors were logged
