Feature: Contentment belongs to the right live animals

  Background:
    Given the save "test-colony" is loaded
    And I close all dialogs

  Scenario: a producing colony animal receives the need at the configured starting level
    Given Contented Livestock spawns the player animal "Bessie" as "Cow"
    Then Contented Livestock animal "Bessie" has the contentment need
    And Contented Livestock animal "Bessie" starts at 50 percent contentment
    And Contented Livestock production factor for "Bessie" is 83 percent
    And no errors were logged

  Scenario: producers-only adds and removes the need from a non-producer when settings close
    Given Contented Livestock spawns the player animal "Scout" as "Husky"
    Then Contented Livestock animal "Scout" has no contentment need
    When Contented Livestock sets producers-only to false and applies settings
    Then Contented Livestock animal "Scout" has the contentment need
    When Contented Livestock sets producers-only to true and applies settings
    Then Contented Livestock animal "Scout" has no contentment need
    And no errors were logged

  Scenario: taming and leaving the colony update the need immediately
    Given Contented Livestock spawns the wild animal "Muff" as "Muffalo"
    Then Contented Livestock animal "Muff" has no contentment need
    When Contented Livestock gives "Muff" to the player faction
    Then Contented Livestock animal "Muff" has the contentment need
    When Contented Livestock removes "Muff" from every faction
    Then Contented Livestock animal "Muff" has no contentment need
    And no errors were logged

  Scenario: the live production factor stops below the floor and reaches the configured maximum
    Given Contented Livestock spawns the player animal "Daisy" as "Cow"
    When Contented Livestock sets "Daisy" to 20 percent contentment
    Then Contented Livestock production factor for "Daisy" is 0 percent
    When Contented Livestock sets "Daisy" to 100 percent contentment
    Then Contented Livestock production factor for "Daisy" is 140 percent
    And no errors were logged
