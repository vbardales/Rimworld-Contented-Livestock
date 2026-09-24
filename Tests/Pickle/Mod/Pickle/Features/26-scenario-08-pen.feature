# Manual scenario 8: the pen is judged on its food balance.
#
# The pen is built in code: a closed ring of fence around a small square of soil at the middle of the map,
# a pen marker inside, four cows. The pen's own two figures (nutrition grown and eaten per day) are read from
# the marker, and the pasture contribution must equal the mod's rule applied to them, computed in the step
# without the mod's code. The manual scenario says the line is "negative when the herd eats faster than
# the grass grows". The rule is a straight line from -20 percent (nothing grown) to +20 percent (grown at least
# what is eaten), so the line is negative only below one half of the balance, zero at one half and positive
# above it; a herd that eats a little more than the grass grows still reads positive. The scenario checks the
# rule, not that wording, and a person reading the captures should know the difference.
#
# Whether the game recognises the pen is the riskiest premise: a closed fence, a marker and regions that
# have had time to update. The step that finds the pen says which of these failed. The pen is small on
# purpose, so that four cows exceed it; if the run shows it sustains them, its size is what to change.
@review
Feature: Scenario 8 - the pen is judged on its food balance

  Background:
    Given the save "test-colony" is loaded
    And I close all dialogs
    And Contented Livestock restores its default settings

  Scenario: four cows in a pen that cannot feed them, then two cows, and the line follows the pen's own figures
    Given Contented Livestock builds a fenced pen 5 cells wide on soil at the middle of the map
    And Contented Livestock spawns the player animal "ScenarioEightA" as "Cow" inside the pen
    And Contented Livestock spawns the player animal "ScenarioEightB" as "Cow" inside the pen
    And Contented Livestock spawns the player animal "ScenarioEightC" as "Cow" inside the pen
    And Contented Livestock spawns the player animal "ScenarioEightD" as "Cow" inside the pen
    When Contented Livestock lets the game run 120 ticks
    And Contented Livestock refreshes the surroundings of "ScenarioEightA"
    Then Contented Livestock the pen holding "ScenarioEightA" grows less than its animals eat
    And Contented Livestock the pasture contribution to "ScenarioEightA" follows its pen's own figures
    When Contented Livestock selects the pen marker of the pen holding "ScenarioEightA"
    Then I take a screenshot "scenario 08 - the pen and its marker, four cows inside"
    When Contented Livestock selects animal "ScenarioEightA" for visual evidence
    And Contented Livestock opens the live contentment tip for "ScenarioEightA" at the top left
    Then I take a screenshot "scenario 08 - four cows, the Pasture line in a cow's tip"
    When I close all dialogs
    And Contented Livestock records the pasture contribution of "ScenarioEightA"
    And Contented Livestock removes the animal "ScenarioEightB" from the map
    And Contented Livestock removes the animal "ScenarioEightC" from the map
    And Contented Livestock lets the game run 120 ticks
    And Contented Livestock refreshes the surroundings of "ScenarioEightA"
    Then Contented Livestock the pasture contribution to "ScenarioEightA" follows its pen's own figures
    And Contented Livestock the pasture contribution to "ScenarioEightA" is above the recorded one
    When Contented Livestock selects animal "ScenarioEightA" for visual evidence
    And Contented Livestock opens the live contentment tip for "ScenarioEightA" at the top left
    Then I take a screenshot "scenario 08 - two cows left, the Pasture line has risen"
    And no errors were logged
