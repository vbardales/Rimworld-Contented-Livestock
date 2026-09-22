@review @film
Feature: Contentment survives a save and reload

  Scenario: level and last-feed memory return with the animal
    Given the save "test-colony" is loaded
    And I close all dialogs
    And Contented Livestock spawns the player animal "Keeper" as "Cow"
    When Contented Livestock sets "Keeper" to 73 percent contentment
    And Contented Livestock records that "Keeper" ate "Kibble"
    Then Contented Livestock animal "Keeper" is at 73 percent contentment
    And Contented Livestock animal "Keeper" has feed offset -15 percent
    When Contented Livestock selects animal "Keeper" for visual evidence
    And I wait 30 ticks
    Then I take a screenshot "scenario 13 - contentment before save and reload"
    When I save and reload
    Then Contented Livestock animal "Keeper" is at 73 percent contentment
    And Contented Livestock animal "Keeper" has feed offset -15 percent
    When Contented Livestock selects animal "Keeper" for visual evidence
    And I wait 30 ticks
    Then I take a screenshot "scenario 13 - contentment after save and reload"
    And no errors were logged
