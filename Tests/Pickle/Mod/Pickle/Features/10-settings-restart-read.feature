@review
Feature: Settings return after a separate-process restart

  Scenario: read every distinctive setting in the next launch and clean up
    Given the save "test-colony" is loaded
    And I close all dialogs
    Then Contented Livestock setting "floorLevel" reads "0.11"
    And Contented Livestock setting "plateauLevel" reads "0.72"
    And Contented Livestock setting "minRateFactor" reads "0.55"
    And Contented Livestock setting "maxRateFactor" reads "1.65"
    And Contented Livestock setting "adjustSpeed" reads "2.35"
    And Contented Livestock setting "feedMatters" reads "False"
    And Contented Livestock setting "penMatters" reads "False"
    And Contented Livestock setting "temperatureMatters" reads "False"
    And Contented Livestock setting "healthMatters" reads "False"
    And Contented Livestock setting "companyMatters" reads "False"
    And Contented Livestock setting "producersOnly" reads "False"
    When I open the Contented Livestock settings dialog
    Then Contented Livestock sees its own settings dialog open
    When Nelim's Pickle Tools: screenshot mode is enabled around the open windows
    And I take a screenshot "scenario 13 - distinctive settings after process restart"
    And Nelim's Pickle Tools: screenshot mode is disabled
    And no errors were logged
