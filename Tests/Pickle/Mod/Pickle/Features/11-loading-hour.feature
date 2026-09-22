@review @film
Feature: Contented Livestock remains healthy through the first game hour

  Scenario: a milkable animal advances without patch or def errors
    Given the save "test-colony" is loaded
    And I close all dialogs
    And Contented Livestock spawns the player animal "FirstHour" as "Cow"
    When Contented Livestock records the milk fullness of "FirstHour"
    And Contented Livestock selects animal "FirstHour" for visual evidence
    Then I take a screenshot "scenario 00 - milkable cow before first game hour"
    When Contented Livestock waits one game hour
    Then Contented Livestock milk fullness of "FirstHour" has increased
    When Contented Livestock selects animal "FirstHour" for visual evidence
    Then I take a screenshot "scenario 00 - milkable cow after first game hour"
    And no errors were logged
