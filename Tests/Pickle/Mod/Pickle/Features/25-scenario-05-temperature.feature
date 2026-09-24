# Manual scenario 5: temperature is measured against the animal's own range.
#
# The manual scenario puts a husky and a hen in an unheated room in winter, then heats the room. This uses
# a cold snap outdoors and its end instead: what is under test is that the band belongs to the animal, not
# where the cold comes from, and a room would need walls, a roof and a heater built in code. The cold snap
# is set from the hen's own cold limit (six degrees below it), so the fixture's weather does not decide the
# result. The hen must be penalised and must be penalised more than the husky. The scenario does not assume
# the husky is spared altogether: if its band turned out to share the hen's lower end the comparison would
# fail and say so. Lifting the cold snap stands for heating: the hen's line comes back positive.
@review
Feature: Scenario 5 - temperature is measured against the animal's own range

  Background:
    Given the save "test-colony" is loaded
    And I close all dialogs
    And Contented Livestock restores its default settings

  Scenario: a cold snap penalises the hen more than the husky, and lifting it turns the hen's line positive
    Given Contented Livestock spawns the player animal "ScenarioFiveHen" as "Chicken"
    And Contented Livestock spawns the player animal "ScenarioFiveHusky" as "Husky"
    When Contented Livestock sets producers-only to false and applies settings
    Then Contented Livestock the temperature contribution to "ScenarioFiveHen" is positive
    And Contented Livestock the temperature contribution to "ScenarioFiveHusky" is positive
    When Contented Livestock starts a cold snap that puts the outdoors 6 degrees below the cold limit of "ScenarioFiveHen"
    And Contented Livestock lets the game run 300 ticks
    Then Contented Livestock the temperature contribution to "ScenarioFiveHen" is negative
    And Contented Livestock the temperature contribution to "ScenarioFiveHen" is lower than the one to "ScenarioFiveHusky"
    When Contented Livestock selects animal "ScenarioFiveHen" for visual evidence
    And Contented Livestock opens the live contentment tip for "ScenarioFiveHen" at the top left
    Then I take a screenshot "scenario 05 - the hen in the cold snap, a negative Temperature line"
    When I close all dialogs
    And Contented Livestock selects animal "ScenarioFiveHusky" for visual evidence
    And Contented Livestock opens the live contentment tip for "ScenarioFiveHusky" at the top left
    Then I take a screenshot "scenario 05 - the husky in the same cold snap"
    When I close all dialogs
    And Contented Livestock ends the cold snap
    And Contented Livestock lets the game run 400 ticks
    Then Contented Livestock the temperature contribution to "ScenarioFiveHen" is positive
    When Contented Livestock selects animal "ScenarioFiveHen" for visual evidence
    And Contented Livestock opens the live contentment tip for "ScenarioFiveHen" at the top left
    Then I take a screenshot "scenario 05 - the hen after the cold snap, a slightly positive Temperature line"
    And no errors were logged
