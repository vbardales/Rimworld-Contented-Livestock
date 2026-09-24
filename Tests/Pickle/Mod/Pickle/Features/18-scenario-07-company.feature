# Manual scenario 7: company. A herd animal alone is penalised, its own kind within twelve cells removes
# the penalty, and a bond with a colonist adds to it independently.
#
# The manual scenario waits a game day. That wait is for the *level* to move. The company offset itself is
# cached for 2500 ticks, so each step here forces the refresh and reads the offset at once; the tip in each
# capture is opened after that refresh, so it shows the line, or its absence, as a player would see it.
# The tip is the game's own text for the need, in a message box moved out of the animal's way.
@review
Feature: Scenario 7 - company

  Background:
    Given the save "test-colony" is loaded
    And I close all dialogs
    And Contented Livestock restores its default settings

  Scenario: a lone muffalo is penalised, two of its kind beside it remove the penalty, and a bond adds to it
    Given Contented Livestock spawns the player animal "ScenarioSevenMother" as "Muffalo"
    When Contented Livestock refreshes the surroundings of "ScenarioSevenMother"
    Then Contented Livestock company for "ScenarioSevenMother" is a penalty of 10 percent
    When Contented Livestock selects animal "ScenarioSevenMother" for visual evidence
    And Contented Livestock opens the live contentment tip for "ScenarioSevenMother" at the top left
    Then I take a screenshot "scenario 07 - muffalo alone, company is a penalty"
    When I close all dialogs
    And Contented Livestock spawns the player animal "ScenarioSevenAunt" as "Muffalo" beside "ScenarioSevenMother"
    And Contented Livestock spawns the player animal "ScenarioSevenCousin" as "Muffalo" beside "ScenarioSevenMother"
    And Contented Livestock refreshes the surroundings of "ScenarioSevenMother"
    Then Contented Livestock company for "ScenarioSevenMother" is zero
    When Contented Livestock selects animal "ScenarioSevenMother" for visual evidence
    And Contented Livestock opens the live contentment tip for "ScenarioSevenMother" at the top left
    Then I take a screenshot "scenario 07 - two of its kind beside it, no company line"
    When I close all dialogs
    And Contented Livestock bonds "ScenarioSevenMother" to the colonist "Jet"
    And Contented Livestock refreshes the surroundings of "ScenarioSevenMother"
    Then Contented Livestock company for "ScenarioSevenMother" is a bonus of 10 percent
    When Contented Livestock selects animal "ScenarioSevenMother" for visual evidence
    And Contented Livestock opens the live contentment tip for "ScenarioSevenMother" at the top left
    Then I take a screenshot "scenario 07 - bonded to a colonist with kin beside it, company is a bonus"
    And no errors were logged
