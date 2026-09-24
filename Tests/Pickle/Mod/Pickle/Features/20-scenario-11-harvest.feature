# Manual scenario 11: harvesting and laying still reset cleanly, and the yield is the game's own.
#
# Gathering goes through the game's own Gathered method, called for a colonist, not through the job a
# colonist would take to walk there: it proves the reset and the size of the yield, not the job. The
# game can waste a yield by chance, so each gathering is repeated until something comes out. The
# question asked of the amount is that it is the same at 100 and at 30 percent contentment: this mod
# scales the clock and never the amount. A hen lays through the game's own method for the same reason.
@review
Feature: Scenario 11 - harvesting and laying reset cleanly

  Background:
    Given the save "test-colony" is loaded
    And I close all dialogs
    And Contented Livestock restores its default settings

  Scenario: milking a full cow empties it and gives the same amount at any contentment
    Given Contented Livestock spawns the player animal "ScenarioElevenCow" as "Cow"
    When Contented Livestock sets "ScenarioElevenCow" to 100 percent contentment
    And Contented Livestock colonist "Jet" gathers from the full "ScenarioElevenCow"
    Then Contented Livestock the yield of "ScenarioElevenCow" is what the game says a full one gives
    When Contented Livestock selects animal "ScenarioElevenCow" for visual evidence
    Then I take a screenshot "scenario 11 - cow milked, fullness back at zero"
    When Contented Livestock sets "ScenarioElevenCow" to 30 percent contentment
    And Contented Livestock colonist "Jet" gathers from the full "ScenarioElevenCow"
    Then Contented Livestock the yield of "ScenarioElevenCow" is what the game says a full one gives
    And Contented Livestock the last two yields of "ScenarioElevenCow" are equal
    And no errors were logged

  Scenario: shearing a full sheep empties it and gives the same amount at any contentment
    Given Contented Livestock spawns the player animal "ScenarioElevenSheep" as "Sheep"
    When Contented Livestock sets "ScenarioElevenSheep" to 100 percent contentment
    And Contented Livestock colonist "Jet" gathers from the full "ScenarioElevenSheep"
    Then Contented Livestock the yield of "ScenarioElevenSheep" is what the game says a full one gives
    When Contented Livestock selects animal "ScenarioElevenSheep" for visual evidence
    Then I take a screenshot "scenario 11 - sheep shorn, fullness back at zero"
    When Contented Livestock sets "ScenarioElevenSheep" to 30 percent contentment
    And Contented Livestock colonist "Jet" gathers from the full "ScenarioElevenSheep"
    Then Contented Livestock the last two yields of "ScenarioElevenSheep" are equal
    And no errors were logged

  Scenario: a hen that lays starts again from zero and fills slowly from there
    Given Contented Livestock the map holds no male "Chicken"
    And Contented Livestock spawns the player animal "ScenarioElevenHen" as "Chicken"
    When Contented Livestock sets "ScenarioElevenHen" to 100 percent contentment
    And Contented Livestock makes "ScenarioElevenHen" lay an egg now
    Then Contented Livestock "ScenarioElevenHen" has laid an egg and starts again from zero
    When Contented Livestock selects animal "ScenarioElevenHen" for visual evidence
    Then I take a screenshot "scenario 11 - hen just after laying, egg progress at zero"
    When Contented Livestock waits one game hour
    Then Contented Livestock the egg progress of "ScenarioElevenHen" has risen but not by much
    And no errors were logged
