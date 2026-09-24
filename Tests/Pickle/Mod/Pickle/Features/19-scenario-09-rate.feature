# Manual scenario 9: the rate really changes, which is what the mod exists for. Three cows of the same
# kind and age, at three contentment levels: the tip of each states its rate, and one game hour of milk
# shows it. "Vanilla" here is what the def gives with no mod, computed from the cow's own comp.
#
# Contentment is set, not earned, so the scenario is staged in its starting state. The rates and the
# milk are real. Just above the floor is 26 percent, which the curve puts at 42 percent of the usual rate
# where the manual scenario says about 40. Contentment drifts a little toward its target during the hour,
# so the gains are checked against the vanilla amount with room, never for an exact ratio.
@review
Feature: Scenario 9 - the rate really changes

  Background:
    Given the save "test-colony" is loaded
    And I close all dialogs
    And Contented Livestock restores its default settings

  Scenario: full contentment fills faster than vanilla, the plateau at the vanilla rate, just above the floor slower
    Given Contented Livestock spawns the player animal "ScenarioNineWell" as "Cow"
    And Contented Livestock spawns the player animal "ScenarioNinePlateau" as "Cow"
    And Contented Livestock spawns the player animal "ScenarioNineNeglected" as "Cow"
    When Contented Livestock sets "ScenarioNineWell" to 100 percent contentment
    And Contented Livestock sets "ScenarioNinePlateau" to 60 percent contentment
    And Contented Livestock sets "ScenarioNineNeglected" to 26 percent contentment
    Then Contented Livestock production factor for "ScenarioNineWell" is 140 percent
    And Contented Livestock production factor for "ScenarioNinePlateau" is 100 percent
    And Contented Livestock production factor for "ScenarioNineNeglected" is 42 percent
    When Contented Livestock selects animal "ScenarioNineWell" for visual evidence
    And Contented Livestock opens the live contentment tip for "ScenarioNineWell" at the top left
    Then I take a screenshot "scenario 09 - full contentment, 140 percent of the usual rate"
    When I close all dialogs
    And Contented Livestock selects animal "ScenarioNinePlateau" for visual evidence
    And Contented Livestock opens the live contentment tip for "ScenarioNinePlateau" at the top left
    Then I take a screenshot "scenario 09 - at the plateau, 100 percent of the usual rate"
    When I close all dialogs
    And Contented Livestock selects animal "ScenarioNineNeglected" for visual evidence
    And Contented Livestock opens the live contentment tip for "ScenarioNineNeglected" at the top left
    Then I take a screenshot "scenario 09 - just above the floor, about 40 percent of the usual rate"
    When I close all dialogs
    And Contented Livestock records the milk fullness of "ScenarioNineWell"
    And Contented Livestock records the milk fullness of "ScenarioNinePlateau"
    And Contented Livestock records the milk fullness of "ScenarioNineNeglected"
    And Contented Livestock waits one game hour
    Then Contented Livestock milk gained by "ScenarioNineWell" in one game hour is above the vanilla amount
    And Contented Livestock milk gained by "ScenarioNinePlateau" in one game hour is within 15 percent of the vanilla amount
    And Contented Livestock milk gained by "ScenarioNineNeglected" in one game hour is below the vanilla amount
    And Contented Livestock milk gained by "ScenarioNineWell" exceeds the milk gained by "ScenarioNineNeglected"
    When Contented Livestock selects animal "ScenarioNineWell" for visual evidence
    Then I take a screenshot "scenario 09 - the well kept cow after one game hour"
    When Contented Livestock selects animal "ScenarioNineNeglected" for visual evidence
    Then I take a screenshot "scenario 09 - the neglected cow after the same hour"
    And no errors were logged
