@review @film
Feature: Scenario 06 health pulls Contentment down and recovers

  Background:
    Given the save "test-colony" is loaded
    And I close all dialogs
    # Stated rather than assumed: the health factor has an on/off switch, and a whole-companion
    # run reaches this feature with that switch left false by the restart pair.
    And Contented Livestock restores its default settings

  Scenario: pain and bleeding make a capped negative contribution that healing clears
    Given Contented Livestock spawns the player animal "ScenarioSixCow" as "Cow"
    When Contented Livestock wounds "ScenarioSixCow" with a bleeding cut
    Then Contented Livestock health offset for "ScenarioSixCow" is negative but capped
    When Contented Livestock selects animal "ScenarioSixCow" for visual evidence
    And Contented Livestock opens the live contentment tip for "ScenarioSixCow"
    Then I take a screenshot "scenario 06 - injured cow negative health contribution"
    When I close all dialogs
    And Contented Livestock heals every injury on "ScenarioSixCow"
    Then Contented Livestock health offset for "ScenarioSixCow" is zero
    When Contented Livestock selects animal "ScenarioSixCow" for visual evidence
    And Contented Livestock opens the live contentment tip for "ScenarioSixCow"
    Then I take a screenshot "scenario 06 - healed cow health contribution recovered"
    And no errors were logged
