# Manual scenario 12: the unfertilised hen still behaves as vanilla does. The manual scenario says the stall
# is vanilla's and that the mod adds nothing to it, and does not say what vanilla does, so this does not
# guess: it runs the same hen twice. One keeps the need. The other has it taken away, so the mod's factor is
# exactly 1 for it and it runs the game's own code and nothing else. Both start at the same egg progress
# with no rooster on the map.
#
# The hen with the need at full contentment must gain 140 percent of what the reference hen gains, give or
# take the drift of contentment during the hour, or nothing at all if vanilla holds the reference still.
# That covers a stall wherever vanilla puts it, and a progress that creeps when it should be held.
@review
Feature: Scenario 12 - the unfertilised hen still behaves as vanilla

  Background:
    Given the save "test-colony" is loaded
    And I close all dialogs
    And Contented Livestock restores its default settings

  Scenario: a hen with no rooster gains 140 percent of what a vanilla hen gains, or holds still when it does
    Given Contented Livestock the map holds no male "Chicken"
    And Contented Livestock spawns the player animal "ScenarioTwelveHen" as "Chicken"
    And Contented Livestock spawns the player animal "ScenarioTwelveVanilla" as "Chicken"
    When Contented Livestock takes the contentment need away from "ScenarioTwelveVanilla"
    And Contented Livestock sets "ScenarioTwelveHen" to 100 percent contentment
    And Contented Livestock sets the egg progress of "ScenarioTwelveHen" to 10 percent
    And Contented Livestock sets the egg progress of "ScenarioTwelveVanilla" to 10 percent
    And Contented Livestock waits one game hour
    Then Contented Livestock egg progress gained by "ScenarioTwelveHen" is 140 percent of that gained by "ScenarioTwelveVanilla", give or take 15 points
    And Contented Livestock the map holds no fertilised egg of "ScenarioTwelveHen"
    When Contented Livestock selects animal "ScenarioTwelveHen" for visual evidence
    Then I take a screenshot "scenario 12 - the hen with the need, after one game hour"
    When Contented Livestock selects animal "ScenarioTwelveVanilla" for visual evidence
    Then I take a screenshot "scenario 12 - the reference hen without the need, after the same hour"
    And no errors were logged
