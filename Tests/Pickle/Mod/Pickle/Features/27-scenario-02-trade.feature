# Manual scenario M3 (TESTING.md): a muffalo bought from a trader through the real trade dialog arrives with
# its Contentment need. Complements scenario 02, which sets the faction in code. The row to buy is chosen in
# code (the dialog's rows have no name Pickle can click); the purchase itself is the game's own TradeDeal.
@review
Feature: Scenario 02 (trade) - a muffalo bought from a trader arrives with its contentment need

  Background:
    Given the save "test-colony" is loaded
    And I close all dialogs

  Scenario: the colony buys a muffalo through the trade dialog
    Given Contented Livestock has a trader "TradeScenarioTrader" who sells a muffalo "TradeScenarioMuffalo"
    Then Contented Livestock animal "TradeScenarioMuffalo" has no contentment need
    When Contented Livestock opens the trade dialog with "TradeScenarioTrader"
    Then Contented Livestock sees the trade dialog list the muffalo "TradeScenarioMuffalo"
    And I take a screenshot "scenario 02 trade - the muffalo offered in the trade dialog"
    When Contented Livestock buys the muffalo "TradeScenarioMuffalo" in the trade dialog
    And I close all dialogs
    Then Contented Livestock animal "TradeScenarioMuffalo" now belongs to the player
    And Contented Livestock animal "TradeScenarioMuffalo" has the contentment need
    When Contented Livestock selects animal "TradeScenarioMuffalo" for visual evidence
    Then I take a screenshot "scenario 02 trade - the bought muffalo with its contentment bar"
    And no errors were logged
