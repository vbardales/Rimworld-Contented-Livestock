# Manual scenario 4: feed moves the target, and the kind of feed matters.
#
# What is real and what is arranged. Each animal eats a real thing through the game's own Thing.Ingested,
# the funnel the mod patches: a rooted grass plant, a stack of hay, a stack of kibble. So the patch and the
# test that tells grazing from hay are what is exercised, not the need's memory set by hand.
#
# Time is arranged twice, because the manual scenario waits days. A game day of the level moving is 400
# need intervals, run in a loop: at the default speed that is one full swing, enough for each cow to reach
# its own target. And the fading of the memory over two days is done by moving the recorded time of the
# meal back, in hours, since waiting two game days would take over half an hour of real time; what is tested
# is the fading formula, not the clock. Because of that, the two are separate scenarios: in the first the
# memory is fresh for the whole simulated day.
@review
Feature: Scenario 4 - feed moves the target, and the kind of feed matters

  Background:
    Given the save "test-colony" is loaded
    And I close all dialogs
    And Contented Livestock restores its default settings

  Scenario: grazing gives the most, hay gives nothing, kibble takes away, and the three cows settle in that order
    Given Contented Livestock spawns the player animal "ScenarioFourGrazer" as "Cow"
    And Contented Livestock spawns the player animal "ScenarioFourHay" as "Cow"
    And Contented Livestock spawns the player animal "ScenarioFourKibble" as "Cow"
    When Contented Livestock lets "ScenarioFourGrazer" eat grass
    And Contented Livestock lets "ScenarioFourHay" eat hay
    And Contented Livestock lets "ScenarioFourKibble" eat kibble
    Then Contented Livestock the feed contribution to "ScenarioFourGrazer" is positive
    And Contented Livestock the feed contribution to "ScenarioFourHay" is zero
    And Contented Livestock the feed contribution to "ScenarioFourKibble" is negative
    And Contented Livestock the tip of "ScenarioFourGrazer" has a feed line
    And Contented Livestock the tip of "ScenarioFourHay" has no feed line
    And Contented Livestock the tip of "ScenarioFourKibble" has a feed line
    And Contented Livestock the contentment target of "ScenarioFourGrazer" is above that of "ScenarioFourHay"
    And Contented Livestock the contentment target of "ScenarioFourHay" is above that of "ScenarioFourKibble"
    When Contented Livestock selects animal "ScenarioFourGrazer" for visual evidence
    And Contented Livestock opens the live contentment tip for "ScenarioFourGrazer" at the top left
    Then I take a screenshot "scenario 04 - the cow that grazed, a positive Feed line"
    When I close all dialogs
    And Contented Livestock selects animal "ScenarioFourHay" for visual evidence
    And Contented Livestock opens the live contentment tip for "ScenarioFourHay" at the top left
    Then I take a screenshot "scenario 04 - the cow that ate hay, no Feed line"
    When I close all dialogs
    And Contented Livestock selects animal "ScenarioFourKibble" for visual evidence
    And Contented Livestock opens the live contentment tip for "ScenarioFourKibble" at the top left
    Then I take a screenshot "scenario 04 - the cow that ate kibble, a negative Feed line"
    When I close all dialogs
    And Contented Livestock lets "ScenarioFourGrazer" live 400 need intervals
    And Contented Livestock lets "ScenarioFourHay" live 400 need intervals
    And Contented Livestock lets "ScenarioFourKibble" live 400 need intervals
    Then Contented Livestock contentment of "ScenarioFourGrazer" is above that of "ScenarioFourHay"
    And Contented Livestock contentment of "ScenarioFourHay" is above that of "ScenarioFourKibble"
    When Contented Livestock selects animal "ScenarioFourGrazer" for visual evidence
    Then I take a screenshot "scenario 04 - after a game day of intervals, the grazer's bar"
    When Contented Livestock selects animal "ScenarioFourKibble" for visual evidence
    Then I take a screenshot "scenario 04 - after the same, the kibble cow's bar"
    And no errors were logged

  Scenario: the memory of a meal fades to nothing over two days
    Given Contented Livestock spawns the player animal "ScenarioFourFade" as "Cow"
    When Contented Livestock lets "ScenarioFourFade" eat grass
    Then Contented Livestock the feed contribution to "ScenarioFourFade" is positive
    When Contented Livestock selects animal "ScenarioFourFade" for visual evidence
    And Contented Livestock opens the live contentment tip for "ScenarioFourFade" at the top left
    Then I take a screenshot "scenario 04 - just eaten, the Feed line at its largest"
    When I close all dialogs
    And Contented Livestock moves the last meal of "ScenarioFourFade" back by 12 game hours
    Then Contented Livestock the feed contribution to "ScenarioFourFade" is positive
    When Contented Livestock opens the live contentment tip for "ScenarioFourFade" at the top left
    Then I take a screenshot "scenario 04 - twelve hours later, the Feed line has shrunk"
    When I close all dialogs
    And Contented Livestock moves the last meal of "ScenarioFourFade" back by 24 game hours
    Then Contented Livestock the feed contribution to "ScenarioFourFade" is positive
    When Contented Livestock opens the live contentment tip for "ScenarioFourFade" at the top left
    Then I take a screenshot "scenario 04 - a day and a half later, almost gone"
    When I close all dialogs
    And Contented Livestock moves the last meal of "ScenarioFourFade" back by 12 game hours
    Then Contented Livestock the feed contribution to "ScenarioFourFade" is zero
    And Contented Livestock the tip of "ScenarioFourFade" has no feed line
    When Contented Livestock opens the live contentment tip for "ScenarioFourFade" at the top left
    Then I take a screenshot "scenario 04 - two days later, the Feed line is gone"
    And no errors were logged
