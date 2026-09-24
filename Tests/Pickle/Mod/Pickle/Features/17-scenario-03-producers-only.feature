# Manual scenario 3: the producers-only switch. Written to give a person something to look at, not only
# assertions: six captures, each a stable state, so no film is needed (nothing here depends on time).
#
# The switch is set in code and applied the way closing the settings window applies it. The caravan
# variant of the manual scenario, a husky coming back from a caravan, has no step and is not covered.
@review
Feature: Scenario 3 - the producers-only switch

  Background:
    Given the save "test-colony" is loaded
    And I close all dialogs
    And Contented Livestock restores its default settings

  Scenario: producers-only off gives a husky the need, on takes it away, and a cow keeps its level through both
    Given Contented Livestock spawns the player animal "ScenarioThreeCow" as "Cow"
    And Contented Livestock spawns the player animal "ScenarioThreeHusky" as "Husky"
    When Contented Livestock sets "ScenarioThreeCow" to 72 percent contentment
    Then Contented Livestock animal "ScenarioThreeHusky" has no contentment need
    When Contented Livestock selects animal "ScenarioThreeHusky" for visual evidence
    Then I take a screenshot "scenario 03 - husky before the switch, no contentment bar"
    When Contented Livestock sets producers-only to false and applies settings
    Then Contented Livestock animal "ScenarioThreeHusky" has the contentment need
    And Contented Livestock animal "ScenarioThreeCow" is at 72 percent contentment
    When Contented Livestock selects animal "ScenarioThreeHusky" for visual evidence
    Then I take a screenshot "scenario 03 - husky with the bar once producers-only is off"
    When Contented Livestock selects animal "ScenarioThreeCow" for visual evidence
    Then I take a screenshot "scenario 03 - cow at 72 percent while producers-only is off"
    When Contented Livestock sets producers-only to true and applies settings
    Then Contented Livestock animal "ScenarioThreeHusky" has no contentment need
    And Contented Livestock animal "ScenarioThreeCow" is at 72 percent contentment
    When Contented Livestock selects animal "ScenarioThreeHusky" for visual evidence
    Then I take a screenshot "scenario 03 - husky loses the bar when producers-only is on again"
    When Contented Livestock selects animal "ScenarioThreeCow" for visual evidence
    Then I take a screenshot "scenario 03 - cow still at 72 percent after both switches"
    And no errors were logged
